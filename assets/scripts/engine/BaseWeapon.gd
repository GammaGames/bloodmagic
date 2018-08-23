extends Area2D

var cooldown = 0.2
var speed = 200
var spread = 5
var damage = .1
# var penetration = 0
var life = 1
var cost = 0.02
var player
var minCount = 1
var maxCount = 1

func _ready():
    add_to_group("item")
    connect("body_shape_entered", self, "_on_body_shape_entered")
    $Bullet.disable()
    $Timer.wait_time = cooldown

func shoot(dir, items):
    if $Timer.time_left == 0:
        var count = 1
        if minCount != 1 and maxCount != 1:
            count = randi() % minCount + (maxCount - minCount)
        var spread_angle = deg2rad(spread / count)
        for i in range(0, count):
            var bullet = $Bullet.duplicate()
            bullet.shoot(dir - (count / 2 - i) * spread_angle, speed * rand_range(0.9, 1), damage, life)
            bullet.global_position = global_position
            $"/root".add_child(bullet)

        post_shoot(24, 6, dir)
        return true
    else:
        return false

func post_shoot(frequency, amplitude, dir):
    $Timer.start()
    player.post_shoot(frequency, amplitude, dir)

func _on_body_shape_entered(body_id, body, body_shape, self_shape):
    if body.is_in_group("player"):
        player = body
        body.call_deferred("change_weapon", self)
        disconnect("body_shape_entered", self, "_on_body_shape_entered")
        hide()
