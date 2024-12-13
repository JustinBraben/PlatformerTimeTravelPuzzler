extends Entity

class_name FallingObstacle

@export var rewind_component: RewindComponent
@onready var collision_shape_2d := $CollisionShape2D

func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	move(delta)
	
	# Player should always be move_and_slide ing
	move_and_slide()

## Probably shouldn't use this in the editor
func move(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	# Do not let the player move via input while rewinding
	if rewind_component:
		if rewind_component.rewinding:
			return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 2.0
