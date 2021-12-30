extends Area2D

enum DamageColors {RED, PURPLE, GREEN, YELLOW, BLUE, PINK, ORANGE, FAST, NONE}

signal damaged
signal dead

export var gradient : StreamTexture
export (Array, DamageColors) var life_layers : Array
var life_layers_copy : Array

func _ready() -> void:
	life_layers_copy = life_layers.duplicate(true)

func damage(color : int) -> void :
	if color == life_layers_copy.front():
		life_layers_copy.pop_front()
		emit_signal("damaged")
		$AnimationPlayer.play("Damage")
		if life_layers_copy.empty() :
			emit_signal("dead")
			queue_free()

func reveal_lesion() -> void :
	$Sprite.texture = gradient
