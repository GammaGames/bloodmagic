extends 'res://assets/scripts/engine/HealingItem.gd'

func _init():
    amount = 0.2
    speed = 200

func _ready():
    $Sprite.rotation = deg2rad(randf() * 80 - 40)
    var dir = randf() * 360
    target_dir = Vector2(cos(dir), sin(dir))

    $Tween.interpolate_property(self, "speed", speed, 0, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $Tween.start()

func _on_body_shape_entered(body_id, body, body_shape, self_shape):
    if body.name == "Player":
        body.heal(self)
        disconnect("body_shape_entered", self, "_on_body_shape_entered")
        queue_free()
