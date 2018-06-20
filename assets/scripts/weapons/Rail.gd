extends "res://assets/scripts/engine/BaseWeapon.gd"

func _init():
    cooldown = 1.5
    speed = 2000
    spread = 0
    spread = 3
    damage = 5
    penetration = 3
    life = 2
    cost = 0.12

func shoot(dir, items):
    if $Timer.time_left == 0:
        var bullet = $Bullet.duplicate()
        var spread_angle = deg2rad(spread)
        bullet.shoot(dir - rand_range(-spread_angle, spread_angle), speed * rand_range(0.9, 1), damage, life, penetration)
        bullet.global_position = global_position
        $"/root".add_child(bullet)

        post_shoot(32, 24, dir)
        return true
    else:
        return false
