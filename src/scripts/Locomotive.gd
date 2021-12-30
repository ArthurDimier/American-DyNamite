extends PathFollow2D

class_name Locomotive

var last_wagon : Wagon
signal changetracks

var gettingout := false
var speed := 35

func _ready() -> void:
	unit_offset = 0.2436
	launch()
	if $Wagons.get_child_count() > 1 :
		last_wagon = $Wagons.get_children().back()
		last_wagon.get_node("VisibilityNotifier2D").connect("screen_exited", self, "_screen_exited")

func _process(delta: float) -> void:
	if gettingout :
		h_offset += scale.x * speed * delta

func launch() -> void :
	$Tween.interpolate_property(self, "unit_offset", unit_offset, 1.0, 15.0,Tween.TRANS_LINEAR)
	$Tween.start()

func add_wagon(wagon : Wagon) -> void :
	$Wagons.add_child(wagon)
	wagon.enable_ray()
	wagon.get_node("CollisionShape2D").disabled = true
	wagon.scale = Vector2(1,1)
	wagon.connect("hit_lesion", self, "_pause")
	if $Wagons.get_child_count() < 2 :
		wagon.set_attach($Attach.position)
		last_wagon = wagon
		last_wagon.get_node("VisibilityNotifier2D").connect("screen_exited", self, "_screen_exited")
	else :
		wagon.set_attach(last_wagon.get_attach())
		last_wagon.get_node("VisibilityNotifier2D").disconnect("screen_exited", self, "_screen_exited")
		last_wagon = wagon
		last_wagon.get_node("VisibilityNotifier2D").connect("screen_exited", self, "_screen_exited")


func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	gettingout = true
	#emit_signal("changetracks", self)
	#unit_offset = 0.0

func _pause(body : Node) -> void:
	if gettingout :
		gettingout = false
		yield(get_tree().create_timer(0.5), "timeout")
		gettingout = true
		return
	$Tween.stop(self, "unit_offset")
	yield(get_tree().create_timer(0.5), "timeout")
	$Tween.resume(self, "unit_offset")

func _screen_exited() -> void:
	gettingout = false
	emit_signal("changetracks", self)
	pass
