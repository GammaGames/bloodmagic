extends Node

export(int) var width = 33
export(int) var height = 18
export(float) var rand_chance = 0.4

var space = ' '
var wall = '#'
var f = '.'

func generate():
	var map = fill_map(width, height)
	var valid = false
	while !valid:
		for i in 4:
			iterate_empty(map)
		for i in 3:
			iterate(map)
		var m = flood_map(map)
		valid = check_map(m, f, 0.45)

	close_map(map)
	set_tilemap($"../Underworld/CaveTilemap", map)

func fill_map(width, height):
	var map = []
	for y in range(height):
		var row = []
		row.resize(width)
		map.append(row)

	for y in range(map.size()):
		for x in range(map[y].size()):
			if randf() > rand_chance:
				map[y][x] = wall
			else:
				map[y][x] = space
	return map

func iterate(map):
	var m = clone_map(map)
	for y in range(map.size()):
		for x in range(map[y].size()):
			if check_surrounding(x, y, wall, m):
				map[y][x] = space
			else:
				map[y][x] = wall

func iterate_empty(map):
	var m = clone_map(map)
	for y in range(map.size()):
		for x in range(map[y].size()):
			if check_surrounding_or_empty(x, y, wall, m):
				map[y][x] = space
			else:
				map[y][x] = wall

func set_tilemap(tilemap, map):
	print(tilemap)
	tilemap.clear()
	for y in range(map.size()):
		for x in range(map[y].size()):
			if map[y][x] == wall:
				tilemap.set_cell(x, y, 0)
	tilemap.update_bitmask_region(Vector2(0, 0), Vector2(map[0].size(), map.size()))

func check_surrounding(x, y, ch, map):
	var count = 0
	for yy in range(-1, 2):
		for xx in range(-1, 2):
			var X = x + xx
			var Y = y + yy
			if 0 < X and X < map[0].size() and 0 < Y and Y < map.size():
				if map[Y][X] == ch:
					count += 1
	return count >= 5

func check_surrounding_or_empty(x, y, ch, map):
	var count = 0
	for yy in range(-1, 2):
		for xx in range(-1, 2):
			var X = x + xx
			var Y = y + yy
			if 0 < X and X < map[0].size() and 0 < Y and Y < map.size():
				if map[Y][X] == ch:
					count += 1
	return count >= 5 or count == 0

func clone_map(map):
	var m = []
	for row in map:
		m.append(duplicate_array(row))
	return m

func flood_map(map):
	var m = clone_map(map)
	var valid = false
	var x
	var y
	while !valid:
		x = randi() % map[0].size()
		y = randi() % map.size()
		valid = m[y][x] == space
	m[y][x] = f
	flood(m, x, y)
	return m

func flood(map, x, y):
	map[y][x] = f
	if x - 1 >= 0 and map[y][x - 1] == space:
		flood(map, x - 1, y)
	if x + 1 < map[0].size() and map[y][x + 1] == space:
		flood(map, x + 1, y)
	if y - 1 >= 0 and map[y - 1][x] == space:
		flood(map, x, y - 1)
	if y + 1 < map.size() and map[y + 1][x] == space:
		flood(map, x, y + 1)
	pass

func check_map(map, ch, percent):
	var count = 0
	for row in map:
		for c in row:
			if c == ch:
				count += 1
	return float(count) / (map.size() * map[0].size()) >= percent

func close_map(map):
	for y in range(map.size()):
		map[y][0] = wall
		map[y][map[0].size() - 1] = wall
	for x in range(map[0].size()):
		map[0][x] = wall
		map[map.size() - 1][x] = wall

func duplicate_array(arr):
	return [] + arr

func get_map_string(map):
	var m = ""
	for row in map:
		for ch in row:
			m += str(ch)
		m += "\n"
	return m
