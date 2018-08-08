extends Node2D

var width = 5
var height = 5

var tilemap_width = 13
var tilemap_height = 8

var base_room = load("res://scenes/world/BaseRoom.tscn")

func _ready():
	randomize()
	generate()

func generate():
	var level = fill_level(width, height)
	while !check_level(level, 0.4):
		level = fill_level(width, height)

	print(get_level_string(level))
	create_rooms(level)

func fill_level(width, height):
	var level = []
	for y in range(height):
		var row = []
		for x in range(width):
			row.append(0)
		level.append(row)

	var x = floor(width / 2) - 1
	var y = floor(width / 2) - 1

	for i in range(width * height):
		level[y][x] = 1
		var dir = deg2rad((randi() % 4) * 90)
		x += cos(dir)
		y += sin(dir)
		x = clamp(x, 0, width - 1)
		y = clamp(y, 0, height - 1)

	return level

func check_level(level, percent):
	var count = 0
	for row in level:
		for ch in row:
			if ch != 0:
				count += 1
	return float(count) / (width * height) > percent

func get_level_string(level):
	var m = ""
	for row in level:
		for ch in row:
			m += str(ch)
		m += "\n"
	return m

func create_rooms(level):
	for y in range(0, level.size()):
		for x in range(0, level[y].size()):
			if level[y][x] == 1:
				var room = base_room.instance()
				room.global_position = Vector2(x * 208, y * 128)

				create_room_walls(level, x, y)
				create_room_doors(room, level, x, y)

				$"../Overworld".add_child(room)
	$TileMap.update_bitmask_region(Vector2(-1, -1), Vector2(width * tilemap_width + 1, height * tilemap_height + 1))

func create_room_walls(level, x, y):
	var offset_x = x * tilemap_width - 1
	var offset_y = y * tilemap_height - 1

	for yy in range(tilemap_height):
		$TileMap.set_cell(offset_x, offset_y + yy, 0)
		$TileMap.set_cell(offset_x + tilemap_width, offset_y + yy, 0)
	for xx in range(tilemap_width):
		$TileMap.set_cell(offset_x + xx, offset_y, 0)
		$TileMap.set_cell(offset_x + xx, offset_y + tilemap_height - 1, 0)

func create_room_doors(room, level, x, y):
	var north = check_pos(x, y - 1) && level[y - 1][x] == 1
	var east = check_pos(x + 1, y) && level[y][x + 1] == 1
	var south = check_pos(x, y + 1) && level[y + 1][x] == 1
	var west = check_pos(x - 1, y) && level[y][x - 1] == 1

	var offset_x = x * tilemap_width - 1
	var offset_y = y * tilemap_height - 1

	if north:
		room.get_node('TopDoor').hide()
		room.get_node('TopDoor/CollisionShape2D').disabled = true
		$TileMap.set_cell(offset_x + 6, offset_y, -1)
		$TileMap.set_cell(offset_x + 7, offset_y, -1)
	if east:
		room.get_node('RightDoor').hide()
		room.get_node('RightDoor/CollisionShape2D').disabled = true
		$TileMap.set_cell(offset_x + tilemap_width, offset_y + 3, -1)
	if south:
		room.get_node('BottomDoor').hide()
		room.get_node('BottomDoor/CollisionShape2D').disabled = true
		$TileMap.set_cell(offset_x + 6, offset_y + tilemap_height - 1, -1)
		$TileMap.set_cell(offset_x + 7, offset_y + tilemap_height - 1, -1)
	if west:
		room.get_node('LeftDoor').hide()
		room.get_node('LeftDoor/CollisionShape2D').disabled = true
		$TileMap.set_cell(offset_x, offset_y + 3, -1)

func check_pos(x, y):
	return x >= 0 and x < width and y >= 0 and y < height
