extends Area2D

@export var speed := 100.0
@export var stopping_distance := 24.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if player == null:
		return
	
	sprite.flip_h = player.global_position.x < global_position.x
	
	var distance_to_player := global_position.distance_to(player.global_position)
	
	if distance_to_player > stopping_distance:
		global_position = global_position.move_toward(
			player.global_position,
			speed * delta
		)

func die() -> void:
	queue_free()
