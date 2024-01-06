extends Node2D

var peer = ENetMultiplayerPeer.new()
var scene = preload("res://scenes/world/world.tscn").instantiate()
@onready var cam = $Camera2D
@onready var canvasLayer = $Camera2D/CanvasLayer
@onready var ip = $Camera2D/CanvasLayer/CenterContainer/VBoxContainer/IP

func _ready():
	if DisplayServer.get_name() == "headless":
		print("Started in headless mode.")
		create_server()

func _on_host_pressed():
	create_server()
	add_player()
	hideUi()


func _on_join_pressed():
	get_tree().get_root().call_deferred("add_child", scene)
	peer.create_client(ip.text, 123)
	multiplayer.multiplayer_peer = peer
	hideUi()

func create_server():
	get_tree().get_root().call_deferred("add_child", scene)
	peer.create_server(123)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)
	print("Server created")

func add_player(id = 1):
	scene.spawn_player(id)
	print("Added player: " + str(id))


func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)


func del_player(id):
	rpc("_del_player", id)


@rpc("any_peer", "call_local") func _del_player(id):
	scene.get_node(str(id)).queue_free()


func hideUi():
	cam.enabled = false
	canvasLayer.visible = false
