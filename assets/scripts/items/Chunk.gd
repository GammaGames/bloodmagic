extends 'res://assets/scripts/engine/HealingItem.gd'

onready var dir = randf() * 360
var speed = randf() * 100 + 100

func _init():
    amount = 0.2

func _ready():
    $Sprite.rotation = deg2rad(randf() * 80 - 40)
    tween()
    connect("area_entered", self, "_on_area_entered")

func tween():
    $Tween.interpolate_property(self, "speed", speed, 0, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $Tween.start()

func _physics_process(delta):
    if speed != 0:
        var angle = deg2rad(dir)
        var motion_x = cos(angle) * speed * delta
        var motion_y = sin(angle) * speed * delta
        global_position += Vector2(motion_x, motion_y)

func _on_area_entered(body):
    if body.is_in_group("bullet") and speed < 20:
        dir = rad2deg(body.direction + (randf() * 0.5 - 0.25))
        speed = clamp(body.damage * 100, 100, 300)
        tween()
