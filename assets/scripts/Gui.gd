extends Control

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func set_health(health):
    var base = floor(health)
    var extra = fmod(health, 1)
    var grid = $Player/Health/Margin/HBox/Grid
    var progress = $Player/Health/Margin/HBox/Progress
    while grid.get_children().size() != base:
        var hearts = grid.get_children()
        if base > hearts.size():
            grid.add_child($Hearts/Heart.duplicate())
        elif base < hearts.size():
            var to_remove = hearts.back()
            grid.remove_child(to_remove)
            if hearts.size() > 1:
                to_remove.queue_free()

    grid.minimum_size_changed()

    progress.value = extra

func set_minimap(map):
    var minimap = $Player/Minimap
    for node in minimap.get_children():
        node.queue_free()
    minimap.columns = map[0].size()
    for y in range(0, map.size()):
        for x in range(0, map[y].size()):
            if map[y][x] == 1:
                minimap.add_child($Rooms/BaseRoom.duplicate())
            else:
                minimap.add_child($Rooms/EmptyRoom.duplicate())
