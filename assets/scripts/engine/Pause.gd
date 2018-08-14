extends Control

func _ready():
	$Buttons/Resume.connect("pressed", self, "toggle_pause")
	$Buttons/Quit.connect("pressed", self, "quit")

func _input(event):
    if event.is_action_pressed("ui_cancel"):
        toggle_pause()

func toggle_pause():
    if get_tree().paused:
        unpause();
    else:
        pause()

func pause():
    get_tree().paused = true
    visible = true

func unpause():
    get_tree().paused = false
    visible = false

func quit():
	get_tree().quit()
