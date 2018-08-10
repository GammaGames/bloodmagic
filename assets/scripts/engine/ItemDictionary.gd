extends Node

onready var weapons = $Weapons.get_children()

func get_weapon():
	var index = randi() % weapons.size()
	return $Weapons.get_child(index).duplicate()
