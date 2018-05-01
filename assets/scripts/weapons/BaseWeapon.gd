extends Area2D

var cooldown = 0.2
var speed = 800
var spread = 5
var damage = 1
var life = 1
var player

func _ready():
    connect("area_shape_entered", self, "_on_area_shape_entered")
    init()

func init():
    $Timer.wait_time = cooldown

func shoot(dir):
    if $Timer.time_left == 0:
        var bullet = $Bullet.duplicate()
        bullet.show()
        bullet.init(dir - rand_range(-spread, spread), speed * rand_range(0.9, 1), damage, life)
        bullet.init(dir, speed * rand_range(0.9, 1), damage, life)
        bullet.global_position = global_position
        $"/root".add_child(bullet)
        post_shoot(32, 4, dir)

func post_shoot(duration, amplitude, dir):
    $Timer.start()
    player.post_shoot(duration, amplitude, dir)

func _on_area_shape_entered(area_id, area, area_shape, self_shape):
    if area.name == "Player":
        player = area
        area.call_deferred("change_weapon", self)
        disconnect("area_shape_entered", self, "_on_area_shape_entered")
        hide()
