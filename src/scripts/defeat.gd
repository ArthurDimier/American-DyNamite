extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Explanations.get_node("RetourMenu").connect("pressed", self, "_on_RetourMainMenu_pressed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_RetourMenu_pressed() -> void:
	$Explanations.show()

func _on_RetourMainMenu_pressed() -> void:
	get_tree().change_scene_to(load("res://src/scenes/SplashScreen.tscn"))
