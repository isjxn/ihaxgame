extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene
@onready var cam = $Camera2D
@onready var canvasLayer = $Camera2D/CanvasLayer


func _on_host_pressed():
	peer.create_server(123)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	cam.enabled = false
	canvasLayer.visible = false
	change_level.call_deferred(load("res://scenes/world/world.tscn"))


func _on_join_pressed():
	peer.create_client("127.0.0.1", 123)
	multiplayer.multiplayer_peer = peer
	cam.enabled = false
	canvasLayer.visible = false
	change_level.call_deferred(load("res://scenes/world/world.tscn"))

func add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)


func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)


func del_player(id):
	rpc("_del_player", id)


@rpc("any_peer", "call_local") func _del_player(id):
	get_node(str(id)).queue_free()


# Call this function deferred and only on the main authority (server).
func change_level(scene: PackedScene):
	# Remove old level if any.
	var level = $Level
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	# Add new level.
	level.add_child(scene.instantiate())
