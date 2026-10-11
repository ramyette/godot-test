extends Node2D

@export var enemy_scene: PackedScene

@onready var spawn_timer: Timer = $SpawnTimer

const MAX_ENEMIES := 8

func _ready() -> void:
	spawn_timer.timeout.connect(spawn_enemy)
	spawn_timer.start()

func spawn_enemy() -> void:
	if get_tree().get_nodes_in_group("enemies").size() >= MAX_ENEMIES:
		return

	var spawn_points := get_tree().get_nodes_in_group("enemy_spawn")
	var spawn_point: Marker2D = spawn_points.pick_random()

	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = spawn_point.global_position
