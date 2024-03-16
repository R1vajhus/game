extends Node3D


@onready var menu = $MENU/MENU
@onready var address_entry = $MENU/MENU/MarginContainer/VBoxContainer/AddressEntry

const Player = preload("res://player.tscn")
const port = 9999
var enet_peer = ENetMultiplayerPeer.new()


func _unhandled_input(event):
	pass

func _on_host_button_pressed():
	menu.hide()
	
	enet_peer.create_server(port)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())
	
func _on_join_button_pressed():
	menu.hide()
	
	enet_peer.create_client("localhost", port)
	multiplayer.multiplayer_peer = enet_peer
	
	
func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)
