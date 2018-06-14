extends KinematicBody2D

var amount = 0.2
var speed = 0
var target_dir = Vector2(0, 0)

func _ready():
    add_to_group("item")
    connect("body_shape_entered", self, "_on_body_shape_entered")
    # get_node("Area").connect("area_enter", self, "_on_collision")

func _physics_process(delta):
    if speed != 0:
        var motion = target_dir * speed
        move_and_slide(motion, Vector2(0, 0))

func _on_body_shape_entered(body_id, body, body_shape, self_shape):
    print("foo")
    if body.name == "Player":
        body.heal(self)
        disconnect("body_shape_entered", self, "_on_body_shape_entered")
        queue_free()
