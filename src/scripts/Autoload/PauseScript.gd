extends Node

func _ready() -> void:
	set_pause_mode(Node.PAUSE_MODE_PROCESS)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") :
		get_tree().paused = ! get_tree().paused
	elif event.is_action_pressed("ui_end") :
		get_tree().quit()
