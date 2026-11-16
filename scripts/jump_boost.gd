extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(5).timeout
	queue_free() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous fram
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.jump_boost(4)
		queue_free()
