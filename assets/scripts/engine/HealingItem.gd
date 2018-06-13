extends Area2D

var amount = 0.2

func _ready():
    add_to_group("item")
    connect("body_shape_entered", self, "_on_body_shape_entered")

func _on_body_shape_entered(body_id, body, body_shape, self_shape):
    if body.name == "Player":
        body.heal(self)
        disconnect("body_shape_entered", self, "_on_body_shape_entered")
        call_deferred("free")
