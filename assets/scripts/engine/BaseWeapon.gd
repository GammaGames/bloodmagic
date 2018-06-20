extends Area2D

var cooldown = 0.2
var speed = 800
var spread = 5
var damage = 2
var penetration = 0
var life = 1
var cost = 0.02
var player

func _ready():
    add_to_group("item")
    connect("body_shape_entered", self, "_on_body_shape_entered")
    $Bullet.disable()
    $Timer.wait_time = cooldown

func shoot(dir, items):
    if $Timer.time_left == 0:
        var bullet = $Bullet.duplicate()
        var spread_angle = deg2rad(spread)
        bullet.shoot(dir - rand_range(-spread_angle, spread_angle), speed * rand_range(0.9, 1), damage, life, penetration)
        bullet.global_position = global_position
        $"/root".add_child(bullet)
        post_shoot(32, 8, dir)
        return true
    else:
        return false

func post_shoot(duration, amplitude, dir):
    $Timer.start()
    player.post_shoot(duration, amplitude, dir)

func _on_body_shape_entered(body_id, body, body_shape, self_shape):
    if body.name == "Player":
        player = body
        body.call_deferred("change_weapon", self)
        disconnect("body_shape_entered", self, "_on_body_shape_entered")
        hide()
