extends StaticBody2D

var damage = .5
var value = 1

func _ready():
    add_to_group("world")
    add_to_group("damage")

func use(player):
    value = value + damage
    print(value)
