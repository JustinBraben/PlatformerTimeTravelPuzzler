extends Node

var next_level = null

@onready var current_level := $Level1
@onready var current_level_file_path: String
@onready var anim := $AnimationPlayer

var scenes: Array[PackedScene] = [
	preload("res://levels/intro/Level1.tscn"), 
	preload("res://levels/intro/Level2.tscn"), 
	preload("res://levels/intro/Level3.tscn"), 
	preload("res://levels/intro/Level4.tscn"), 
	preload("res://levels/intro/Level5.tscn"), 
	]
var scene_index: int = 0

func _ready() -> void:
	setup_level_connections(current_level)
	current_level_file_path = current_level.scene_file_path

func handle_level_changed(current_level_name: String) -> void:
	print("level should change! ", current_level_name)
	call_deferred("start_next_level", current_level_name)

func start_next_level(current_level_name: String) -> void:
	var next_level_name: String
	
	match current_level_name:
		"1":
			next_level_name = "2"
		"2":
			next_level_name = "3"
		"3":
			next_level_name = "4"
		"4":
			next_level_name = "5"
		"5":
			next_level_name = "6"
		"6":
			next_level_name = "1"
		_:
			print("Dont recognize this level...")
	
	next_level = load("res://levels/intro/Level" + next_level_name + ".tscn").instantiate()
	next_level.layer = -1
	anim.play("fade_in")
	
	print("current level file path: ", current_level_file_path)

func setup_level_connections(level: Node) -> void:
	level.connect("restart_level", handle_restart_level)
	level.kill_zone.connect("killed", handle_restart_level)
	level.goal.connect("player_reached_goal", handle_level_changed)

func handle_restart_level() -> void:
	print("level should restart! ", current_level_file_path)
	
	call_deferred("restart_current_level")

func restart_current_level() -> void:
	var next_level = load(current_level_file_path).instantiate()
	add_child(next_level)
	setup_level_connections(next_level)
	current_level.queue_free()
	current_level = next_level
	current_level_file_path = next_level.scene_file_path


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"fade_in":
			current_level.queue_free()
			current_level = next_level
			current_level_file_path = current_level.scene_file_path
			current_level.layer = 1
			next_level = null
			anim.play("fade_out")
			add_child(current_level)
		"fade_out":
			setup_level_connections(current_level)
