extends Node

onready var weapons = [
	"PeaShooter",
	"Rail",
	"Shotty",
	"Stream"
]

func get_weapon(weapon):
	var new = weapons[randi() % weapons.size()]
	while new == weapon:
		new = weapons[randi() % weapons.size()]
	return load_weapon(new)

func load_weapon(weapon):
	return load("res://scenes/weapons/" + str(weapon) + ".tscn").instance()
