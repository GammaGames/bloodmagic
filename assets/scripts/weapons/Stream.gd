extends "res://assets/scripts/engine/BaseWeapon.gd"


func _init():
    cooldown = 0.1
    speed = 0
    spread = 0
    damage = 2
    penetration = 10
    life = 0.09
    cost = 0.01

func shoot(dir, items):
    if $Timer.time_left == 0:
        var bullet = $Bullet.duplicate()
        var spread_angle = deg2rad(spread)
        bullet.shoot(dir - rand_range(-spread_angle, spread_angle), speed * rand_range(0.9, 1), damage, life, penetration)
        bullet.global_position = global_position
        $"/root".add_child(bullet)

        post_shoot(24, 8, dir)
        return true
    else:
        return false
