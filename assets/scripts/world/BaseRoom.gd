extends Area2D

func _ready():
	connect("body_shape_entered", self, "_on_body_shape_entered")

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()
		var tile_pos = $TileMap.world_to_map(mouse_pos)
		var tile = $TileMap.get_cell(tile_pos.x, tile_pos.y)
		# print(str(tile_pos.x) + ',' + str(tile_pos.y) + '=' + str(tile))
		# if tile > -1:
			# $TileMap.set_cell(tile_pos.x, tile_pos.y, -1)
		# else:
		$TileMap.set_cell(tile_pos.x, tile_pos.y, 0)
		$TileMap.update_bitmask_area(tile_pos)

func _on_body_shape_entered(body_id, body, body_shape, self_shape):
	if body.name == "Player":
		body.call_deferred("transition_room", self)
