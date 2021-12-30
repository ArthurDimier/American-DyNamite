extends Node

# Cell clock state machine
enum CycleState { G1, S, G2, MITOSIS }
var state : int = CycleState.G1

#defeat
var defeat_range := 0
var score := 0

# Preload scenes
var loco := preload("res://src/scenes/Locomotive.tscn")
var packed_all_wagons := [preload("res://src/scenes/wagons/WagonMutL_MutH.tscn"),
							preload("res://src/scenes/wagons/WagonADNLigase.tscn"),
							preload("res://src/scenes/wagons/WagonADNPolymérase.tscn"),
							preload("res://src/scenes/wagons/WagonEndonucléase.tscn"),
							preload("res://src/scenes/wagons/WagonHélicase.tscn"),
							preload("res://src/scenes/wagons/WagonMutS.tscn"),
							preload("res://src/scenes/wagons/WagonADNGlycosylase.tscn"),
							]
var packed_lesion := [preload("res://src/scenes/Lesions/MMRLesion.tscn"), 
						preload("res://src/scenes/Lesions/NERLesion.tscn"),
						preload("res://src/scenes/Lesions/BERLesion.tscn"),
						preload("res://src/scenes/Lesions/RapideLesion.tscn"),]
var packed_wagon_fast := preload("res://src/scenes/wagons/WagonFast.tscn")
var packed_wagon_SCAN := preload("res://src/scenes/wagons/WagonSCAN.tscn")
var packed_wagon_SOS := preload("res://src/scenes/wagons/WagonSOS.tscn")

# debug
onready var label := get_node("CanvasLayer/GUI/Label")
onready var label_data := get_node("CanvasLayer/GUI/Label2")
onready var label_score := get_node("CanvasLayer/GUI/Label3")

# Called at load
func _ready():
	randomize()
	var horloge := get_node("CanvasLayer/GUI/horloge")
# warning-ignore:return_value_discarded
	horloge.connect("G1", self, "_on_horloge_G1")
# warning-ignore:return_value_discarded
	horloge.connect("G2", self, "_on_horloge_G2")
# warning-ignore:return_value_discarded
	horloge.connect("S", self, "_on_horloge_S")
# warning-ignore:return_value_discarded
	horloge.connect("Mitosis", self, "_on_horloge_Mitosis")

# Loop
func _on_Loco_Change_Tracks(locomotive : Locomotive) -> void :
	if locomotive.scale.x > 0 :
		locomotive.hide()
		#$Path2D.remove_child(locomotive)
		$Path2D.call_deferred("remove_child", locomotive)
		locomotive.scale.x *= -1
		locomotive.unit_offset = 0.0
		locomotive.h_offset = 0.0
		#$Path2DReturn.add_child(locomotive)
		$Path2DReturn.call_deferred("add_child", locomotive)
		yield(get_tree(), "idle_frame")
		locomotive.show()
		locomotive.launch()
	else :
		locomotive.queue_free()

#StatesSwitcher
func _on_horloge_S() -> void:
	state = CycleState.S
	label.text = "S"


func _on_horloge_G2() -> void:
	state = CycleState.G2
	label.text = "G2"


func _on_horloge_Mitosis() -> void:
	state = CycleState.MITOSIS
	label.text = "Mitose"


func _on_horloge_G1() -> void:
	#defeat test
	if randi()%100 < defeat_range :
		get_tree().change_scene_to(load("res://src/scenes/defeat.tscn"))
	defeat_range += get_tree().get_nodes_in_group("lesion").size()
	label_data.text = String(defeat_range) + "%"
	#update score
	score+=1
	label_score.text = "Score : " + String(score)
	#wincon
	if score >= 10 :
		get_tree().change_scene_to(load("res://src/scenes/Victory.tscn"))
	#change state
	state = CycleState.G1
	label.text = "G1"


export var count := 5; #QUE POUR DEBUG ET PLAYTEST
const tabY := [510, 922]
#spawns lesions
func spawn_lesion() -> void:
	if count <= 0 :
		$Timer.start(rand_range(3, 10.0))
		return
	count -= 1; #QUE POUR DEBUG ET PLAYTEST
	var p_lesion := packed_lesion[randi() % packed_lesion.size()] as PackedScene
	var lesion := p_lesion.instance()
	lesion.connect("dead", self, "_on_lesion_death")
	lesion.position = Vector2(rand_range(100.0, 2000.0), tabY[randi() % tabY.size()]) #position des lésions à changer en Y
	add_child(lesion)
	$Timer.start(rand_range(3, 10.0))
	
#spawns wagons
func spawn_wagons() -> void:
	var p_wagon := packed_all_wagons[randi() % packed_all_wagons.size()] as PackedScene
	
	
	if(state == CycleState.S) :
		packed_all_wagons.push_back(packed_wagon_SOS)
	else :
		packed_all_wagons.erase(packed_wagon_SOS)
	$PathWagon/PathFollowWagon.offset = randi()
	var wagon = p_wagon.instance()
	wagon.position = $PathWagon/PathFollowWagon.global_position
	wagon.connect("picked", $Station, "_select")
	wagon.connect("picked", $Poubelle, "_select")
	wagon.connect("letgo", $Station, "_deselect")
	wagon.connect("letgo", $Poubelle, "_deselect")
	add_child(wagon)
	
	$TimerWagon.start(rand_range(0.1, 10.0))


func _on_TimerWagon_timeout():
	spawn_wagons()


func _on_Station_launch_train(wag_array) -> void:
	var locomotive = loco.instance()
	for wagon in wag_array :
		remove_child(wagon)
		locomotive.add_wagon(wagon)
	$Path2D.add_child(locomotive)
	locomotive.connect("changetracks", self, "_on_Loco_Change_Tracks")


#Fast Lesions Trains
func _on_TimerFastTrain_timeout_spawn() -> void:
	_on_Station_launch_train([packed_wagon_fast.instance()])
	$TimerFastTrain.start()


#SCAN trains
func _on_SCANButton_pressed() -> void:
	_on_Station_launch_train([packed_wagon_SCAN.instance()])

#lesion death
func _on_lesion_death() -> void :
	count+=1
