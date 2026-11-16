extends Node3D


@onready var mesh: MeshInstance3D = $mesh
@onready var broken: GPUParticles3D = $broken

var speed = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.z += speed * delta
	if position.z > 10:
		queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	
	if body.is_in_group("player"):
		self.queue_free()
		speed = 0
		mesh.hide()
		broken.emitting = true
		body.damage(25)
		await get_tree().create_timer(1).timeout
		
		#body.get_parent().gameover()
