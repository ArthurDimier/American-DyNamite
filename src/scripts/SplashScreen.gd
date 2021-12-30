extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Tutorial/RetourMenu.connect("pressed", self, "_on_RetourMenu_pressed")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Button_pressed() -> void:
	get_tree().change_scene_to(load("res://src/scenes/Game.tscn"))


func _on_TutorialButton_pressed() -> void:
	$Tutorial.show()


func _on_RetourMenu_pressed() -> void:
	$Tutorial.hide()
