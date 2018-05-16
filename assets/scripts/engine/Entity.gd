extends KinematicBody2D

const SPEED = 0
var target_dir = Vector2(0, 0)
var sprite_dir = 'down'

func movement_loop(delta):
    var motion = target_dir.normalized() * SPEED
    move_and_slide(motion, Vector2(0, 0))

func anim_loop(delta):
    match target_dir:
        dir.up:
            sprite_dir = "up"
        dir.down:
            sprite_dir = "down"
        dir.left:
            sprite_dir = "left"
        dir.right:
            sprite_dir = "right"
        dir.down_left:
            sprite_dir = "down_left"
        dir.down_right:
            sprite_dir = "down_right"
        dir.up_left:
            sprite_dir = "up_left"
        dir.up_right:
            sprite_dir = "up_right"

func anim_switch(anim):
    var new_anim = str(anim, "_", sprite_dir)
    match anim:
        "walk":
            if $AnimationPlayer.current_animation != new_anim:
                $AnimationPlayer.play(new_anim)
        "shoot":
            if $AnimationPlayer.current_animation != new_anim:
                $AnimationPlayer.play(new_anim)
            $AnimationPlayer.seek(0, true)
        "idle":
            $AnimationPlayer.stop()
