extends "res://assets/scripts/world/BaseRoom.gd"

func _ready():
	$Area.connect("body_shape_entered", self, "_on_body_shape_entered")
	print("BOSS")

func set_boss(boss):
	pass

func donate(amount):
	pass

func spawn_boss():
	pass
