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
            pass
        elif base < hearts.size():
            var to_remove = hearts.back()
            grid.remove_child(to_remove)
            if hearts.size() > 1:
                to_remove.queue_free()

    grid.minimum_size_changed()

    progress.value = extra
