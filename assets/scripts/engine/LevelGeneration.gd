extends Node

export(int) var width = 4
export(int) var height = 4

func _ready():
	randomize()
	generate()

func generate():
	var level = fill_level(width, height)
	while !check_level(level, 0.3):
		level = fill_level(width, height)

	print(get_level_string(level))

func fill_level(width, height):
	var level = []
	for y in range(height):
		var row = []
		for x in range(width):
			row.append(0)
		level.append(row)

	var x = floor(width / 2)
	var y = floor(width / 2)

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
