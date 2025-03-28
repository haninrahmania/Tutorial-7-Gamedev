extends StaticBody3D

@export var item_name: String = "Item"

func interact(player):
	player.add_to_inventory(item_name)
	print("Item diambil: ", item_name)
	queue_free()
