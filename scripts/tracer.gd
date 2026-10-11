extends Node2D

@onready var outer_glow: Line2D = $OuterGlow
@onready var core_trail: Line2D = $CoreTrail

const SPEED := 2200.0
const TRAIL_LENGTH := 40.0

var direction := Vector2.RIGHT
var target := Vector2.ZERO
var start_position := Vector2.ZERO

func setup(start: Vector2, end: Vector2) -> void:
	global_position = start
	start_position = start
	target = end
	direction = start.direction_to(end)

func _process(delta: float) -> void:
	global_position += direction * SPEED * delta
	
	var distance_traveled := global_position.distance_to(start_position)
	var visible_length : float = min(TRAIL_LENGTH, distance_traveled)
	
	var points := [
		-direction * visible_length,
		Vector2.ZERO
	]
	
	outer_glow.points = points
	core_trail.points = points
	
	if global_position.distance_to(target) < SPEED * delta:
		queue_free()
