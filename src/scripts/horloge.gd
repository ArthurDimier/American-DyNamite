extends Sprite

export var time_cycle := 60.0

signal G1
signal S
signal G2
signal Mitosis

func _ready() -> void:
	$AnimationPlayer.playback_speed = 1/time_cycle
	$AnimationPlayer.play("TimeCell")


func G1_to_S() -> void:
	emit_signal("S")
	pass
	
func S_to_G2() -> void:
	emit_signal("G2")
	pass

func G2_to_Mitose() -> void:
	emit_signal("Mitosis")
	pass

func Mitose_to_G1() -> void:
	emit_signal("G1")
	pass


# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	print("loop")
	Mitose_to_G1()
