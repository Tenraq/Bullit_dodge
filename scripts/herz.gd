extends Area3D


func _ready() -> void:
	await get_tree().create_timer(5).timeout
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.add_health(25)
		queue_free()
