extends CharacterBody3D

@onready var footstep: AudioStreamPlayer3D = $footstep
@onready var herz: AudioStreamPlayer3D = $herz
@onready var pfeil: AudioStreamPlayer3D = $pfeil

@onready var cameraholder: Node3D = $cameraholder
@onready var camera_3d: Camera3D = $cameraholder/Camera3D
@onready var damageSFX: AudioStreamPlayer3D = $damage
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
var health = 100
const SPEED = 6.0
var JUMP_VELOCITY = 4.5
func _ready() -> void:
	footstep.playing = true
func _physics_process(delta: float) -> void:
	JUMP_VELOCITY = clamp(JUMP_VELOCITY,4.5,8.5)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		footstep.stream_paused = true
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		JUMP_VELOCITY = 4.5
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("A", "D", "W", "S")
	var direction = (cameraholder.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if is_on_floor():
			footstep.stream_paused = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if is_on_floor():
			footstep.stream_paused = true
		
	if position.y < -6:
		damage(100)
	move_and_slide()
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			cameraholder.rotate_y(-event.relative.x * 0.01)
			camera_3d.rotate_x(-event.relative.y * 0.01)

			camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-80),deg_to_rad(80))
func jump_boost(amount:int):
	JUMP_VELOCITY+=amount
	pfeil.play()

func add_health(amount:int):
	herz.play()
	health += amount
	health = clamp(health,0, 100)
	texture_progress_bar.value = health
func damage(amount:int):
	health -= amount
	health = clamp(health,0, 100)
	texture_progress_bar.value = health
	if health <= 0:
		get_parent().gameover()
	damageSFX.play()
