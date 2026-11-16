extends Node3D
@onready var label: Label = $Control/Label
var score :float = 0.0
var score_anzeiger = true
var timer = 2
var power_up: int
var power_up_timer= 4
@onready var control: Control = $Control

@onready var button: Button = $Control/Button

@export var herz:PackedScene
@export var jump:PackedScene
@export var bullit:PackedScene
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if score_anzeiger == true:
		score += delta
		label.text = "Score: " + str(round(score))
	timer -= delta
	if timer < 0:
		var bullit_inst = bullit.instantiate()
		bullit_inst.position = Vector3(randf_range(5.4, -5.4), 1, -8)
		add_child(bullit_inst)
		timer = 0.1
	power_up_timer -= delta
	if power_up_timer < 0:
		power_up = randi_range(1,2)
		if power_up == 1:
			var herz_inst = herz.instantiate()
			herz_inst.position = Vector3(randf_range(-4,5),0.5,randf_range(-3, 6.2))
			add_child(herz_inst)
			power_up_timer=8
		elif power_up == 2:
			var jump_inst = jump.instantiate()
			jump_inst.position = Vector3(randf_range(-4,5),0.5,randf_range(-3, 6.2))
			add_child(jump_inst) 
			power_up_timer=8
func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
func gameover():
	get_tree().paused = true
	control.mouse_filter = Control.MOUSE_FILTER_PASS
	button.show()
	score_anzeiger = false
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
