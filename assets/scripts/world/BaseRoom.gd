extends Area2D

func _ready():
	connect("body_shape_entered", self, "_on_body_shape_entered")

func _on_body_shape_entered(body_id, body, body_shape, self_shape):
	if body.name == "Player":
		body.call_deferred("transition_room", self)
