extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gun_pivot: Node2D = $GunPivot
@onready var gun_sprite: Sprite2D = $GunPivot/Sprite
@onready var muzzle: Marker2D = $GunPivot/Muzzle

@export var tracer_scene: PackedScene

var jumping = false

func _ready() -> void:
	sprite.animation = "default"

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		jumping = true
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
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

func shoot() -> void:
	var tracer = tracer_scene.instantiate()
	get_tree().current_scene.add_child(tracer)

	var shoot_direction := muzzle.global_position.direction_to(get_global_mouse_position())
	var max_range := 1000.0
	var end_position := muzzle.global_position + shoot_direction * max_range

	tracer.setup(muzzle.global_position, end_position)
