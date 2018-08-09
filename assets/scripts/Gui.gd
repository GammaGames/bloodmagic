extends CanvasLayer

func set_health(health):
    var base = floor(health)
    var extra = fmod(health, 1)
    var grid = $Control/Margin/HBox/Grid
    var progress = $Control/Margin/HBox/Progress
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
    for node in $Minimap.get_children():
        node.queue_free()
    $Minimap.columns = map[0].size()
    for y in range(0, map.size()):
        for x in range(0, map[y].size()):
            if map[y][x] == 1:
                $Minimap.add_child($Rooms/BaseRoom.duplicate())
            else:
                $Minimap.add_child($Rooms/EmptyRoom.duplicate())
