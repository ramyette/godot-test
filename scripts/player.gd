extends CharacterBody2D

const MAX_HEALTH := 100.0
const HEAL_DELAY := 5.0
const HEAL_RATE := 12.0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FIRE_DELAY := 0.12

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gun_pivot: Node2D = $GunPivot
@onready var gun_sprite: Sprite2D = $GunPivot/Sprite
@onready var muzzle: Marker2D = $GunPivot/Muzzle
@onready var shoot_ray: RayCast2D = $GunPivot/Muzzle/ShootRay
@onready var health_bar: ProgressBar = $HealthBar


@export var tracer_scene: PackedScene

var health := MAX_HEALTH
var time_since_damage := 0.0
var is_dead := false
var jumping = false
var fire_cooldown := 0.0

func _ready() -> void:
	sprite.animation = "default"
	
	health_bar.max_value = MAX_HEALTH
	health_bar.value = health
	health_bar.hide()

func _physics_process(delta: float) -> void:
	if not is_dead and health < MAX_HEALTH:
		time_since_damage += delta
		
		if time_since_damage >= HEAL_DELAY:
			health = minf(health + HEAL_RATE * delta, MAX_HEALTH)
			health_bar.value = health
		
			if health >= MAX_HEALTH:
				health_bar.hide()
	
	fire_cooldown = maxf(fire_cooldown - delta, 0.0)
	
	if Input.is_action_just_pressed("jump"):
		jumping = true
	if Input.is_action_pressed("shoot") and fire_cooldown <= 0.0:
		shoot()
		fire_cooldown = FIRE_DELAY
	
	var aim_direction := (get_global_mouse_position() - global_position).normalized()
	gun_pivot.rotation = aim_direction.angle()
	gun_sprite.flip_v = aim_direction.x < 0
	
	var x_direction := Input.get_axis("move_left", "move_right")
	var y_direction := Input.get_axis("move_up", "move_down")
	if x_direction:
		velocity.x = x_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if y_direction:
		velocity.y = y_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	var moving = (velocity != Vector2.ZERO)
	if jumping:
		sprite.play("jump")
		await get_tree().create_timer(0.5).timeout
		jumping = false
	elif moving:
		sprite.play("walk")
	else:
		sprite.play("default")
	
	move_and_slide()

func take_damage(amount: int) -> void:
	if is_dead:
		return
	
	health = maxf(health - amount, 0.0)
	health_bar.value = health
	health_bar.show()
	
	time_since_damage = 0.0
	
	if health <= 0:
		die()

func die() -> void:
	is_dead = true
	set_physics_process(false)
	
	$AnimatedSprite2D.hide()
	$GunPivot.hide()
	
	$"../DeathScreen".show()

func shoot() -> void:
	shoot_ray.force_raycast_update()
	
	var end_position := muzzle.global_position + muzzle.global_transform.x * 1000.0
	
	if shoot_ray.is_colliding():
		end_position = shoot_ray.get_collision_point()
	
		var hit_object = shoot_ray.get_collider()
		if hit_object.has_method("die"):
			hit_object.die()
	
	var tracer = tracer_scene.instantiate()
	get_tree().current_scene.add_child(tracer)
	tracer.setup(muzzle.global_position, end_position)
