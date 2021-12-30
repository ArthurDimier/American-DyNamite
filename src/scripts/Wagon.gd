extends KinematicBody2D

class_name Wagon
signal hit_lesion(body)
signal sent(wagon)
signal picked
signal letgo

enum DamageColors {RED, PURPLE, GREEN, YELLOW, BLUE, PINK, ORANGE, FAST, SOS}

var picked := false
var attached := false
export var anim := true
onready var drop_points := get_tree().get_nodes_in_group("zone")

export (DamageColors) var wagon_damage : int

onready var raycast := $RayCast2D


func _ready() -> void:
	if anim :
		$Tween.interpolate_method(self, "move_and_slide", Vector2.ZERO, Vector2(0,230), 3.0, Tween.TRANS_LINEAR,Tween.EASE_OUT)
		$Tween.start()
	$Sprite.set_material($Sprite.get_material().duplicate())

func set_attach(attach : Vector2) -> void :
	position = Vector2.ZERO
	position = attach - $FrontAttach.position
	attached = true

func get_attach() -> Vector2 :
	return $BackAttach.position + position

# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if raycast.is_colliding() :
		if raycast.get_collider() is Node :
			var node : Node = raycast.get_collider() as Node
			if node.is_in_group("lesion") :
# warning-ignore:return_value_discarded
				self.connect("hit_lesion", node, "damage")
				emit_signal("hit_lesion", wagon_damage)
				self.disconnect("hit_lesion", node, "damage")
			raycast.add_exception(node)

func _physics_process(delta: float) -> void:
	if picked and not attached:
		#global_position = lerp(global_position, get_global_mouse_position(), 25*delta)
		#move_and_slide((get_global_mouse_position() - global_position) * 25, Vector2.UP)
		var collision = move_and_collide((get_global_mouse_position() - global_position) * 25 * delta)
		if collision:
			collision.collider.move_and_collide((get_global_mouse_position() - global_position) * 25 * delta)

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Wagon_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click") :
		picked  = true
		emit_signal("picked")
		#$Sprite.material.set_shader_param("speed", 10)
		$Sprite.material.set_shader_param("scale", 0.8)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton :
		if event.button_index == BUTTON_LEFT and not event.pressed :
			if picked : 
				scale =Vector2(5,5)
				drop_points.sort_custom(self, "sort_Loc_Distances")
				var target := drop_points.front() as Node2D
				if target.global_position.distance_to(global_position) < 100 :
# warning-ignore:return_value_discarded
					connect("sent", target, "_on_Wagon_Sent")
					emit_signal("sent", self)
					disconnect("sent", target, "_on_Wagon_Sent")
			#$Sprite.material.set_shader_param("speed", 0)
			$Sprite.material.set_shader_param("scale", 1)
			picked = false
			emit_signal("letgo")

func sort_Loc_Distances(a : Node2D, b : Node2D) -> bool:
	return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position)

func enable_ray() :
	$RayCast2D.enabled = true
