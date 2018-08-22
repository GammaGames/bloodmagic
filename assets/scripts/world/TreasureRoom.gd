extends "res://assets/scripts/world/BaseRoom.gd"

func set_item(item):
	var old = $Items/Pedestal/Item
	var pos = old.global_position
	old.queue_free()
	$Items/Pedestal.add_child(item)
	item.global_position = pos
