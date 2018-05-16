extends 'res://assets/scripts/engine/Entity.gd'

export(int) var SPEED = 400

func _ready():
    print($Sprite.material.get_shader_param("replacement_color"))
