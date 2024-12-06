extends Entity

class_name Player

@export var rewind_component: RewindComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = lerp(velocity.x, direction * speed, accel * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
	
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	elif velocity.x < 0:
		$Sprite2D.flip_h = true
