extends Node

var slowTween
var slowTime = 0

func _ready():
    slowTween = Tween.new()
    add_child(slowTween)

func slow_motion(time):
    slowTime = time
    slowTween.connect("tween_completed", self, "end_tween")
    slowTween.interpolate_property(Engine, "time_scale", 1, 0.3, slowTime * 2/6, Tween.TRANS_QUART, Tween.EASE_OUT)
    slowTween.start()

func end_tween(object, key):
    slowTween.disconnect("tween_completed", self, "end_tween")
    slowTween.interpolate_property(Engine, "time_scale", 0.3, 1, slowTime * 1/6, Tween.TRANS_QUART, Tween.EASE_IN)
    slowTween.start()
