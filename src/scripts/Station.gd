extends Sprite

var wagon_list := []
export var wagon_max := 5
signal launch_train(wag_array)

func _select()-> void:
	material.set_shader_param("speed", 15.0)
	material.set_shader_param("scale", 0.8)
	#scale = Vector2(0.08, 0.08)

func _deselect()->void:
	material.set_shader_param("speed", 0.0)
	material.set_shader_param("scale", 1.0)
	#scale = Vector2(0.06, 0.06)

func _on_Wagon_Sent(wagon : Wagon) :
	if wagon_list.size() >= wagon_max :
		print((global_position - wagon.global_position).normalized() * 10000)
		wagon.move_and_slide((global_position - wagon.global_position).normalized() * 10000)
		return
	wagon.global_position = Vector2(-1000, -1000)
	if wagon_list.empty() :
		$Control/Button.visible = true
	wagon_list.append(wagon)
	
	var newSquare : ColorRect = ColorRect.new()
	newSquare.rect_min_size = Vector2(20,20)
	match wagon.wagon_damage :
		Wagon.DamageColors.BLUE :
			newSquare.color = Color.blue
		Wagon.DamageColors.RED :
			newSquare.color = Color.red
		Wagon.DamageColors.GREEN :
			newSquare.color = Color.limegreen
		Wagon.DamageColors.ORANGE :
			newSquare.color = Color.orangered
		Wagon.DamageColors.PINK :
			newSquare.color = Color.pink
		Wagon.DamageColors.PURPLE :
			newSquare.color = Color.purple
		Wagon.DamageColors.YELLOW :
			newSquare.color = Color.gold
	$Control/HBoxContainer.add_child(newSquare)
	$Control/HBoxContainer.move_child(newSquare, 0)


func _on_Button_pressed() -> void:
	emit_signal("launch_train", wagon_list)
	for child in $Control/HBoxContainer.get_children() :
		child.queue_free()
	$Control/Button.visible = false
	wagon_list.clear()
