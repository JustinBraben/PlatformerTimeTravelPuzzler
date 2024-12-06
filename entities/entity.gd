extends CharacterBody2D

class_name Entity

# ATTRIBUTES
@export_enum("PLAYER", "OBSTACLE", "GOAL") var TYPE: String = "OBSTACLE"
@export var speed: float = 300.0
@export var accel: float = 10.0
@export var friction: float = 10.0

# MOVEMENT
@export var direction: Vector2 = Vector2(0,0)
@export var jump_velocity = -800.0

@onready var anim = $AnimationPlayer
var hitbox: Area2D
var center: Area2D

signal killed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
