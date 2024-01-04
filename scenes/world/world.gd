extends Node2D

@export var player_scene : PackedScene

@onready var spawnPoint = $SpawnPoint

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_child_entered_tree(node):
	if node.is_in_group("players"):
		node.position = spawnPoint.position


func spawn_player(id):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
