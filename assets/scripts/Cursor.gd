extends Node2D

func _ready():
	$Tween.connect("tween_completed", self, "_end_tween")
	$Timer.connect("timeout", self, "tween")
	hide()

func _process(delta):
	if visible:
		global_position = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseMotion:
		show()
		$Underfire.emitting = true
		$Overfire.emitting = true
		modulate = Color(1, 1, 1, 1)
		global_position = get_global_mouse_position()
		$Timer.start()

func tween():
	$Tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, Tween.TRANS_QUART, Tween.EASE_OUT)
	$Tween.start()

func _end_tween():
	$Underfire.emitting = false
	$Overfire.emitting = false
