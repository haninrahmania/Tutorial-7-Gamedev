extends StaticBody3D

@onready var lamp_light: OmniLight3D = find_child("OmniLight3D", true, false)

var is_on: bool = false

func interact(_player):
	is_on = !is_on
	lamp_light.visible = is_on
	print("Lampu menyala!" if is_on else "Lampu mati!")
