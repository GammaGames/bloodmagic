extends Area2D

export(int) var SPEED = 400
export(float, 0, 5) var health = 3
var weapon

func _ready():
    change_weapon(load("res://scenes/weapons/BaseWeapon.tscn").instance())
    # change_weapon(load("res://scenes/weapons/Shotty.tscn").instance())

func _process(delta):
    var velocity = Vector2()
    if Input.is_action_pressed("ui_right"):
        velocity.x += 1
    if Input.is_action_pressed("ui_left"):
        velocity.x -= 1
    if Input.is_action_pressed("ui_down"):
        velocity.y += 1
    if Input.is_action_pressed("ui_up"):
        velocity.y -= 1

    if Input.is_action_pressed("key_use"):
        if velocity.length() > 0:
            weapon.shoot(velocity.angle())
        $AnimatedSprite.stop()
    else:
        if velocity.length() > 0:
            velocity = velocity.normalized() * SPEED
        else:
            $AnimatedSprite.stop()

        position += velocity * delta

    if velocity.y < 0 && velocity.x == 0:
        if $AnimationPlayer.assigned_animation != "up" or !$AnimationPlayer.is_playing():
            $AnimationPlayer.play("up")
    elif velocity.y > 0 && velocity.x == 0:
        if $AnimationPlayer.assigned_animation != "down" or !$AnimationPlayer.is_playing():
            $AnimationPlayer.play("down")
    if velocity.y < 0 && velocity.x != 0:
        if $AnimationPlayer.assigned_animation != "up_right" or !$AnimationPlayer.is_playing():
            $AnimationPlayer.play("up_right")
    elif velocity.y > 0 && velocity.x != 0:
        if $AnimationPlayer.assigned_animation != "down_right" or !$AnimationPlayer.is_playing():
            $AnimationPlayer.play("down_right")
    elif velocity.x != 0:
        if $AnimationPlayer.assigned_animation != "right" or !$AnimationPlayer.is_playing():
            $AnimationPlayer.play("right")
    elif velocity.x == 0 && velocity.y == 0:
        $AnimationPlayer.stop()

    if velocity.x != 0:
        $Sprite.flip_h = velocity.x < 0

func change_weapon(new_weapon):
    if weapon != null:
        remove_child(weapon)
    if new_weapon.get_parent() != null:
        new_weapon.get_parent().remove_child(new_weapon)
    weapon = new_weapon
    add_child(weapon)
    new_weapon.position = Vector2(0, 0)

func post_shoot(duration, amplitude, dir):
    $Particles2D.rotation = dir
    $Particles2D.emitting = true
    $Particles2D/Timer.start()

    $Camera2D.shake(0.2, duration, amplitude)

func stop_particles():
    $Particles2D.emitting = false
