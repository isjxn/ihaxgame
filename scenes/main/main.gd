extends Node2D

var peer = ENetMultiplayerPeer.new()
var scene = preload("res://scenes/world/world.tscn").instantiate()
@onready var cam = $Camera2D
@onready var canvasLayer = $Camera2D/CanvasLayer

func _on_host_pressed():
	get_tree().root.add_child(scene)
	peer.create_server(123)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	hideUi()


func _on_join_pressed():
	get_tree().root.add_child(scene)
	peer.create_client("127.0.0.1", 123)
	multiplayer.multiplayer_peer = peer
	hideUi()


func add_player(id = 1):
		scene.spawn_player(id)


func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)


func del_player(id):
	rpc("_del_player", id)


@rpc("any_peer", "call_local") func _del_player(id):
	get_node(str(id)).queue_free()


func hideUi():
	cam.enabled = false
	canvasLayer.visible = false
