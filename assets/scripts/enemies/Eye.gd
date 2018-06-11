extends 'res://assets/scripts/engine/Entity.gd'

onready var player = $"/root/Game/Player"

func _init():
    speed = 300

func _ready():
    var mat = $Sprite.get_material().duplicate()
    mat.set_shader_param("shift_amount", randf())
    $Sprite.set_material(mat)

func _process(delta):
    if health <= 0:
        die()

func _physics_process(delta):
    global_rotation += get_angle_to(player.get_position())
    target_dir = Vector2(cos(global_rotation), sin(global_rotation))
    movement_loop(delta)

    # var motion = target_dir.normalized() * SPEED
    # move_and_slide(motion, Vector2(0, 0))

func hurt(damage):
    health = health - damage
    print(health)

func die():
    call_deferred("free")
