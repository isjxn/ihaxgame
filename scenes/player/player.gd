extends CharacterBody2D

@onready var cam = $Camera2D
@onready var animatedSprite = $AnimatedSprite2D
@onready var usernameLabel = $UsernameLabel

var action = "idle"
var looking = "front"
var direction = "left"

const SPEED = 50.0

func _enter_tree():
	set_multiplayer_authority(name.to_int())


func _ready():
	cam.enabled = is_multiplayer_authority()
	animatedSprite.play("idle_front_left")


func _physics_process(_delta):
	if is_multiplayer_authority():
		velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED


func _process(_delta):
	if is_multiplayer_authority():
		move_and_slide()
		
		if velocity == Vector2(0, 0):
			action = "idle"
			looking = "front"
		else:
			action = "walk"
			if velocity.x > 0:
				direction = "right"
			elif velocity.x < 0:
				direction = "left"
			
			if velocity.y >= 0:
				looking = "front"
			elif velocity.y < 0:
				looking = "back"
		
		animatedSprite.play(action + "_" + looking + "_" + direction)


func setUsername(username):
	if username != "Anonymous":
		$UsernameLabel.text = username
