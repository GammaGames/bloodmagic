extends Control

func _ready():
	# pause()
	$Boxes/Center/Buttons/Play.connect("pressed", self, "play")
	$Boxes/Center/Buttons/Quit.connect("pressed", self, "quit")

func play():
	get_tree().paused = false
	visible = false

func pause():
    get_tree().paused = true
    visible = true

func quit():
	get_tree().quit()
