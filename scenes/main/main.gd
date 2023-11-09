extends Node3D


@onready var player: CharacterBody3D = $player
@onready var inventory_interface: Control = $UI/InventoryInterface

func _ready() -> void:
	inventory_interface.visible = false
	player.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	
	# 43:10
	for node in get_tree().get_nodes_in_group("external_inventory"):		
		print("node ", node)
		node.toggle_inventory.connect(toggle_inventory_interface)

func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_interface.visible = not inventory_interface.visible

	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	# 44:10
	if external_inventory_owner:
		inventory_interface.set_external_inventory(external_inventory_owner)
