extends Area2D

var cooldown = 0.2
var speed = 800
var spread = 5
var damage = 2
var life = 1
var cost = 0.08
var player

func _ready():
    connect("body_shape_entered", self, "_on_body_shape_entered")
    init()

func init():
    $Timer.wait_time = cooldown

func shoot(dir, items):
    if $Timer.time_left == 0:
        var bullet = $Bullet.duplicate()
        bullet.show()
        bullet.init(dir - rand_range(-spread, spread), speed * rand_range(0.9, 1), damage, life)
        bullet.init(dir, speed * rand_range(0.9, 1), damage, life)
        bullet.global_position = global_position
        $"/root".add_child(bullet)
        post_shoot(32, 4, dir)
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
