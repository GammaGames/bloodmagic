extends 'res://assets/scripts/engine/Entity.gd'

onready var player = $"/root/Game/World/Player"
var health_drop_change = 0.7

func _init():
    speed = 250

func _ready():
    add_to_group("enemy")
    var mat = $Sprite.get_material().duplicate()
    mat.set_shader_param("shift_amount", randf())
    $Sprite.set_material(mat)

func _physics_process(delta):
    if health > 0:
        global_rotation += get_angle_to(player.get_position())
        target_dir = Vector2(cos(global_rotation), sin(global_rotation))
        movement_loop(delta)

func hurt(damage):
    health = health - damage
    $Particles2D.restart()
    if randf() < health_drop_change:
        var count = randi() % 3
        for i in range(0, count):
            var index = randi() % 3 + 1
            var chunk = load("res://scenes/items/Chunk" + str(index) + ".tscn").instance()
            chunk.global_position = global_position
            $"/root/Game/World".add_child(chunk)
    if health <= 0:
        die()

func die():
    $Sprite.hide()
    $CollisionShape2D.disabled = true
    $Timer.connect("timeout", self, "queue_free")
    $Timer.start()
