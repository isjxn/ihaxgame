extends CharacterBody2D

@onready var cam = $Camera2D

const SPEED = 300.0

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _ready():
	cam.enabled = is_multiplayer_authority()

func _physics_process(delta):
	if is_multiplayer_authority():
		velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED
	move_and_slide()
