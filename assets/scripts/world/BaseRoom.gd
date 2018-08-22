extends Node2D

func _ready():
	$Area.connect("body_shape_entered", self, "_on_body_shape_entered")

func _on_body_shape_entered(body_id, body, body_shape, self_shape):
	if body.is_in_group("player"):
		$"/root/Game/Camera2D".global_position = global_position + Vector2(104, 64)

func get_items():
	return $Items.get_children()
