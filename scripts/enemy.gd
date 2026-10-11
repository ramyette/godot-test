extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var speed := 35.0
@export var stopping_distance := 24.0

const CONTACT_DAMAGE := 10
const DAMAGE_DELAY := 1.0

var player: Node2D
var player_in_contact: Node2D
var damage_cooldown := 0.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _physics_process(delta: float) -> void:
	if player != null:
		sprite.flip_h = player.global_position.x < global_position.x
	
		var distance_to_player := global_position.distance_to(player.global_position)
	
		if distance_to_player > stopping_distance:
			global_position = global_position.move_toward(
				player.global_position,
				speed * delta
			)
	
	if player_in_contact != null:
		damage_cooldown -= delta

		if damage_cooldown <= 0.0:
			player_in_contact.take_damage(CONTACT_DAMAGE)
			damage_cooldown = DAMAGE_DELAY

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_contact = body
		
		player_in_contact.take_damage(CONTACT_DAMAGE)
		damage_cooldown = DAMAGE_DELAY

func _on_body_exited(body: Node2D) -> void:
	if body == player_in_contact:
		player_in_contact = null

func die() -> void:
	queue_free()
