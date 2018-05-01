extends Timer

func _ready():
    print($"../..".name)
    connect("timeout", $"../..", "stop_particles")
