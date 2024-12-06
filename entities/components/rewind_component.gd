extends Node2D
class_name RewindComponent

signal rewind_started
signal rewind_stopped

@export var replay_duration: float = 3.0
var rewinding: bool = false
var rewind_values = {
	"position": [],
	"velocity": [],
}
var parent: Entity = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	var found_parent = get_parent()
	if found_parent is not Entity:
		printerr("Parent is not descendant of Entity, rewind will not work on: ", parent)
	else:
		parent = found_parent

func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	
	if event.is_action_pressed("rewind_player"):
		if !rewinding:
			start_rewind()
		else:
			end_rewind()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if !rewinding:
		update_rewind_values()
	else:
		compute_rewind(delta)

## Should only run when not rewinding
func update_rewind_values() -> void:
	if Engine.is_editor_hint():
		return
	
	# Guard just in case
	if !rewinding:
		
		if (parent.velocity == Vector2.ZERO):
			return
		
		if replay_duration * Engine.physics_ticks_per_second == rewind_values["position"].size():
			# Remove oldest value, to make room for new one
			for key in rewind_values.keys():
				rewind_values[key].pop_front()
		
		rewind_values["position"].append(parent.global_position)
		rewind_values["velocity"].append(parent.velocity)

func compute_rewind(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	var pos = rewind_values["position"].pop_back()
	if rewind_values["position"].is_empty():
		if parent != null:
			parent.global_position = pos
			# parent.velocity = rewind_values["velocity"][0]
			parent.velocity = Vector2(0, 0)
			end_rewind()
			return
	
	parent.global_position = pos
	parent.velocity = Vector2(0, 0)

func start_rewind() -> void:
	if Engine.is_editor_hint():
		return
	
	rewinding = true
	parent.get_node("CollisionShape2D").set_deferred("disabled", true)
	emit_signal("rewind_started")

func end_rewind() -> void:
	parent.get_node("CollisionShape2D").set_deferred("disabled", false)
	rewinding = false
	emit_signal("rewind_stopped")

func clear_rewind_values() -> void:
	rewind_values["position"].clear()
	rewind_values["velocity"].clear()
