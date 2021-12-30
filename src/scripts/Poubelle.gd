extends Node2D

func _on_Wagon_Sent(wagon : Wagon) :
	wagon.queue_free()

func _select()-> void:
	$Sprite.material.set_shader_param("speed", 15.0)
	scale *= 1.2
	#scale = Vector2(0.08, 0.08)

func _deselect()->void:
	$Sprite.material.set_shader_param("speed", 0.0)
	scale = Vector2(1,1)
	#scale = Vector2(0.06, 0.06)
