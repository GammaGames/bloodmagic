extends 'res://assets/scripts/engine/Entity.gd'

const SPEED = 300

onready var player = $"/root/Game/Player"

func _ready():
    $Sprite.material.set_shader_param("shift_amount", randf())

func _physics_process(delta):
    global_rotation += get_angle_to(player.get_position())
    target_dir = Vector2(cos(global_rotation), sin(global_rotation))
    movement_loop(delta)

    # var motion = target_dir.normalized() * SPEED
    # move_and_slide(motion, Vector2(0, 0))
