extends Area2D

signal killed

func _on_body_entered(body: Node2D) -> void:
	print("You died...")
	emit_signal("killed")
