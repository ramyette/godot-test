extends CanvasLayer

func _ready() -> void:
	$CenterContainer/Replay.pressed.connect(replay)

func replay() -> void:
	get_tree().reload_current_scene()
