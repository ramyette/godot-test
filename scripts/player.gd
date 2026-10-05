extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var jumping = false

func _ready() -> void:
	sprite.animation = "default"

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		jumping = true

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
