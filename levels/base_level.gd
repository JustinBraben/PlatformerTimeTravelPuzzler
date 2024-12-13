extends CanvasLayer
class_name BaseLevel

signal restart_level
signal time_expired
signal level_changed(level_name: String)
signal player_reached_goal(level_name: String)

@export var level_name: String = "level"
@export var total_level_time: float = 60.0  # 1 minute
@onready var player_spawn := $PlayerSpawn
@onready var kill_zone := $KillZone
@onready var goal := $Goal
@onready var stopwatch := $Stopwatch
var player_scene = preload("res://entities/player/player.tscn")
var current_time: float = 0.0
var rewinding: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_player()
	reset_timer()
	$Stopwatch.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	
	if event.is_action_pressed("restart_level"):
		emit_signal("restart_level")

func reset_timer() -> void:
	stopwatch.get_node("Shader").material.set_shader_parameter("time_remaining", total_level_time)

func spawn_player() -> void:
	# queue free of any current players in the scene to be safe
	
	# create player at player_spawn
	var new_player = player_scene.instantiate()
	new_player.position = player_spawn.position
	new_player.add_to_group("player")
	if (new_player.get_node_or_null("RewindComponent") != null):
		new_player.get_node("RewindComponent").connect("rewind_started", handle_rewind_started)
		new_player.get_node("RewindComponent").connect("rewind_stopped", handle_rewind_ended)
	add_child(new_player)

func handle_rewind_started() -> void:
	print("Player started rewind!")
	rewinding = true;

func handle_rewind_ended() -> void:
	print("Player ended rewind!")
	rewinding = false;

func _on_stopwatch_timeout() -> void:
	update_time_remaining()
	update_rewind_remaining()

func update_time_remaining() -> void:
	var time_remaining = stopwatch.get_node("Shader").material.get_shader_parameter("time_remaining")
	
	if (rewinding):
		time_remaining += $Stopwatch.wait_time
	elif (!rewinding):
		time_remaining -= $Stopwatch.wait_time
	
	stopwatch.get_node("Shader").material.set_shader_parameter("time_remaining", time_remaining)
	
	if time_remaining > 0.0:
		$Stopwatch.start()
	else:
		emit_signal("time_expired")

func update_rewind_remaining() -> void:
	var rewind_remaining = stopwatch.get_node("Shader").material.get_shader_parameter("rewind_duration")
	if (rewinding):
		rewind_remaining -= $Stopwatch.wait_time
	elif (!rewinding):
		rewind_remaining += $Stopwatch.wait_time
		rewind_remaining = clamp(rewind_remaining, 0.0, 3.0)
			
	stopwatch.get_node("Shader").material.set_shader_parameter("rewind_duration", rewind_remaining)
