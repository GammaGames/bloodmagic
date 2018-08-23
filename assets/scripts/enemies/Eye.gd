extends 'res://assets/scripts/engine/Entity.gd'

onready var player = $"/root/Game/World/Player"
var health_drop_chance = 0.05
var damage = 0.5

func _init():
    speed = 50
    health = 0.3

func _ready():
    add_to_group("enemy")
    add_to_group("damage")
    $Die.connect("timeout", self, "queue_free")
    var mat = $Sprite.get_material().duplicate()
    mat.set_shader_param("shift_amount", randf())
    $Sprite.set_material(mat)
    $Flash.interpolate_property($Sprite, "modulate", Color(10, 10, 10, 10), Color(1, 1, 1, 1), .4,  Tween.TRANS_QUART, Tween.EASE_OUT)
    $Hitstun.connect("tween_started", self, "start_knockback")
    $Hitstun.connect("tween_completed", self, "end_knockback")

func _physics_process(delta):
    if health > 0:
        global_rotation += get_angle_to(player.get_position())
        target_dir = Vector2(cos(global_rotation), sin(global_rotation))
        movement_loop(delta)

func hurt(item):
    health = health - item.damage
    $HurtParticles.restart()
    $Flash.seek(0)
    $Flash.start()
    knock_dir = global_position - item.global_position
    $Hitstun.interpolate_property(self, "knock_speed", 200, 0, 0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
    $Hitstun.start()

    if randf() < health_drop_chance:
        var count = randi() % 3
        for i in range(0, count):
            var index = randi() % 3 + 1
            var chunk = load("res://scenes/items/Chunk" + str(index) + ".tscn").instance()
            chunk.global_position = global_position
            $"/root/Game/World".add_child(chunk)
    if health <= 0:
        $"/root/Game/Camera2D".shake(0.3, 15, 5)
        die()
    else:
        $"/root/Game/Camera2D".shake(0.2, 24, 1)

func damage(player):
    return damage

func die():
    $Sprite.hide()
    $CollisionShape2D.disabled = true
    $Shadow.visible = false
    $Die.start()

func start_knockback(object, key):
    hitstun = true

func end_knockback(object, key):
    knock_speed = 0
    hitstun = false
