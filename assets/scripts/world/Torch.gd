extends StaticBody2D

func _process(delta):
	$Light2D.texture_scale = 1 + abs(sin(OS.get_ticks_msec() / 10)) * 0.1
