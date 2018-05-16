extends Timer

func _ready():
    connect("timeout", $"../..", "stop_particles")
