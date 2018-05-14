extends KinematicBody2D

export(int) var SPEED = 600
export(float, 0, 5) var health = 3
var target_dir = Vector2(0, 0)
var sprite_dir = "down"
var weapon
var passive_items = []
var active_item
var cooldown_item

enum STATES {
    IDLE,
    MOVE,
    SHOOT
}

var state = STATES.IDLE

func _ready():
    change_weapon(load("res://scenes/weapons/BaseWeapon.tscn").instance())
    # change_weapon(load("res://scenes/weapons/Shotty.tscn").instance())

func _physics_process(delta):
    controls_loop(delta)

    match state:
        STATES.IDLE:
            idle_loop(delta)
            pass
        STATES.MOVE:
            movement_loop(delta)
        STATES.SHOOT:
            shoot_loop(delta)

    anim_loop(delta)

func controls_loop(delta):
    var LEFT = Input.is_action_pressed("ui_left")
    var RIGHT = Input.is_action_pressed("ui_right")
    var UP = Input.is_action_pressed("ui_up")
    var DOWN = Input.is_action_pressed("ui_down")
    var SHOOT = Input.is_action_pressed("key_use")

    target_dir.x = -int(LEFT) + int(RIGHT)
    target_dir.y = -int(UP) + int(DOWN)

    if SHOOT:
        state = STATES.SHOOT
        # TODO add shoot animations
        anim_switch("shoot")
    elif target_dir.length() != 0:
        state = STATES.MOVE
        anim_switch("walk")
    else:
        anim_switch("idle")
        state = STATES.IDLE

func idle_loop(delta):
    pass

func movement_loop(delta):
    var motion = target_dir.normalized() * SPEED
    move_and_slide(motion, Vector2(0, 0))
    # position += motion

func shoot_loop(delta):
    if target_dir.length() != 0:
        if weapon.shoot(target_dir.angle(), passive_items):
            health -= weapon.cost
            print(health)

func anim_loop(delta):
    match target_dir:
        Vector2(0, -1):
            sprite_dir = "up"
        Vector2(0, 1):
            sprite_dir = "down"
        Vector2(-1, 0):
            sprite_dir = "right"
        Vector2(1, 0):
            sprite_dir = "right"
        Vector2(-1, 1):
            sprite_dir = "down_right"
        Vector2(1, 1):
            sprite_dir = "down_right"
        Vector2(-1, -1):
            sprite_dir = "up_right"
        Vector2(1, -1):
            sprite_dir = "up_right"

func anim_switch(anim):
    if anim == "walk":
        var new_anim = str(anim, "_", sprite_dir)
        if $AnimationPlayer.current_animation != new_anim:
            $AnimationPlayer.play(new_anim)
            if target_dir.x != 0:
                $Sprite.flip_h = target_dir.x < 0
    elif anim == "shoot":
        anim_switch("walk")
        $AnimationPlayer.seek(0, true)
    elif anim == "idle":
        $AnimationPlayer.stop()

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
