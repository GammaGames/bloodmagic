extends "res://assets/scripts/weapons/BaseWeapon.gd"

func init():
    cooldown = 0.5
    $Timer.wait_time = cooldown
    speed = 1000
    spread = 30
    spread = 30
    damage = 1
    life = 0.5

func shoot(dir):
    if $Timer.time_left == 0:
        var count = randi() % 5 + 10
        var spread_angle = deg2rad(spread / count)
        for i in range(0, count):
            var bullet = Bullet.instance()
            bullet.init(dir - (count / 2 - i) * spread_angle, speed * rand_range(0.9, 1), damage, life)
            bullet.global_position = global_position
            $"/root".add_child(bullet)

        $Timer.start()
        $"../Camera2D".shake(0.3, 32, 8)
