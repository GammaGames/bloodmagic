extends "res://assets/scripts/engine/BaseWeapon.gd"

func _init():
    cooldown = 0.5
    speed = 900
    spread = 30
    damage = 1
    life = 0.5
    cost = 0.1

func shoot(dir, items):
    if $Timer.time_left == 0:
        var count = randi() % 5 + 10
        var spread_angle = deg2rad(spread / count)
        for i in range(0, count):
            var bullet = $Bullet.duplicate()
            bullet.shoot(dir - (count / 2 - i) * spread_angle, speed * rand_range(0.9, 1), damage, life, penetration)
            bullet.global_position = global_position
            $"/root".add_child(bullet)

        post_shoot(32, 16, dir)
        return true
    else:
        return false
