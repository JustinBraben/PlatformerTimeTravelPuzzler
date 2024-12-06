extends Area2D
class_name Goal

signal player_reached_goal(level_name: String)

@export var level_name: String = "level"
@export var goal_disabled: bool = false

func _on_body_entered(body: Node2D) -> void:
	#if collision_shape_2d.disabled:
		#return
		
	if body.is_in_group("player"):
		#print("player entered goal!")
		emit_signal("player_reached_goal", level_name)
