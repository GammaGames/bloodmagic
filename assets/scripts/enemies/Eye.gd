extends 'res://assets/scripts/engine/Entity.gd'

onready var player = $"/root/Game/World/Player"
var health_drop_chance = 0.05
var damage = 0.3

func _init():
    speed = 75

func _ready():
    add_to_group("enemy")
    $Hitbox.connect("body_shape_entered", self, "_on_body_shape_entered")
    $Die.connect("timeout", self, "queue_free")
    var mat = $Sprite.get_material().duplicate()
    mat.set_shader_param("shift_amount", randf())
    $Sprite.set_material(mat)
    $Flash.interpolate_property($Sprite, "modulate", Color(10, 10, 10, 10), Color(1, 1, 1, 1), .4,  Tween.TRANS_QUART, Tween.EASE_OUT)

func _physics_process(delta):
    if health > 0:
        global_rotation += get_angle_to(player.get_position())
        target_dir = Vector2(cos(global_rotation), sin(global_rotation))
        movement_loop(delta)

func hurt(damage):
    health = health - damage
    $HurtParticles.restart()
    $Flash.seek(0)
    $Flash.start()
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

func _on_body_shape_entered(body_id, body, body_shape, area_shape):
    if body.is_in_group("player"):
        body.hurt(self)

func die():
    $Sprite.hide()
    $CollisionShape2D.disabled = true
    $Hitbox.monitorable = false
    $Hitbox.monitoring = false
    $Shadow.visible = false
    $Die.start()
