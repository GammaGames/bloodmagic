extends "res://assets/scripts/weapons/BaseWeapon.gd"


func init():
    cooldown = 1.5
    $Timer.wait_time = cooldown
    speed = 2000
    spread = 0
    spread = 30
    damage = 5
    life = 2
    cost = 0.25

func shoot(dir, items):
    if $Timer.time_left == 0:
        var bullet = $Bullet.duplicate()
        bullet.show()
        bullet.init(dir - rand_range(-spread, spread), speed * rand_range(0.9, 1), damage, life)
        bullet.init(dir, speed * rand_range(0.9, 1), damage, life)
        bullet.global_position = global_position
        $"/root".add_child(bullet)

        post_shoot(32, 16, dir)
        return true
    else:
        return false
