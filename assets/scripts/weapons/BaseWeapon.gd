extends Area2D

var cooldown = 0.2
var speed = 1000
var spread = 5
var damage = 1
var life = 1
onready var Bullet = preload("res://scenes/Bullet.tscn")

func _ready():
    connect("area_shape_entered", self, "_on_area_shape_entered")
    init()

func init():
    $Timer.wait_time = cooldown
    print(cooldown)
    pass

func shoot(dir):
    if $Timer.time_left == 0:
        var bullet = Bullet.instance()
        bullet.init(dir - rand_range(-spread, spread), speed * rand_range(0.9, 1), damage, life)
        bullet.init(dir, speed * rand_range(0.9, 1), damage, life)
        bullet.global_position = global_position
        $"/root".add_child(bullet)

        $Timer.start()
        $"../Camera2D".shake(0.2, 32, 4)

func _on_area_shape_entered(area_id, area, area_shape, self_shape):
    if area.name == "Player":
        area.call_deferred("change_weapon", self)
        disconnect("area_shape_entered", self, "_on_area_shape_entered")
        hide()
