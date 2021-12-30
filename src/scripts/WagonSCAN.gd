extends Wagon


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if raycast.is_colliding() :
		if raycast.get_collider() is Node :
			var node : Node = raycast.get_collider() as Node
			if node.is_in_group("lesion"):
				node.reveal_lesion()
			raycast.add_exception(node)
