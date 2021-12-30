extends Wagon


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var win := randi() % 100
	if raycast.is_colliding() :
		if raycast.get_collider() is Node :
			var node : Node = raycast.get_collider() as Node
			if node.is_in_group("lesion"):
				if(win <= 40) : #40% chance of success for SOS Train
					node.emit_signal("dead")
					node.queue_free()
			raycast.add_exception(node)
