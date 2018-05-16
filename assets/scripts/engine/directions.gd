extends Node

const center = Vector2(0, 0)
const up = Vector2(0, -1)
const up_right = Vector2(1, -1)
const right = Vector2(1, 0)
const down_right = Vector2(1, 1)
const down = Vector2(0, 1)
const down_left = Vector2(-1, 1)
const left = Vector2(-1, 0)
const up_left = Vector2(-1, -1)

func rand():
    var d = rand() % 8
    match d:
        0:
            return up
        1:
            return up_right
        2:
            return right
        3:
            return down_right
        4:
            return down
        5:
            return down_left
        6:
            return left
        7:
            return up_left
