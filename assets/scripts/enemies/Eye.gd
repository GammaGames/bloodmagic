extends 'res://assets/scripts/engine/Entity.gd'

var SPEED = 400

onready var player = $"/root/Game/Player"

func _ready():
    $Sprite.material.set_shader_param("shift_amount", randf())

func _physics_process(delta):
    global_rotation += get_angle_to(player.get_position())
