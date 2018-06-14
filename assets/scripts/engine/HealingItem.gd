extends Area2D

var amount = 0.2

func _ready():
    add_to_group("item")
    connect("body_shape_entered", self, "_on_body_shape_entered")
    # get_node("Area").connect("area_enter", self, "_on_collision")

func _on_body_shape_entered(body_id, body, body_shape, self_shape):
    if body.is_in_group("player"):
        body.heal(self)
        disconnect("body_shape_entered", self, "_on_body_shape_entered")
        queue_free()
