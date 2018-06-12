extends 'res://assets/scripts/engine/Entity.gd'

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
    speed = 500
    health = 3.5
    change_weapon(load("res://scenes/weapons/BaseWeapon.tscn").instance())
    update_gui()

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

func shoot_loop(delta):
    if target_dir.length() != 0:
        if weapon.shoot(target_dir.angle(), passive_items):
            health -= weapon.cost
            update_gui()

func heal(item):
    health += item.amount
    print(health)
    update_gui()

func anim_switch(anim):
    var new_anim = str(anim, "_", sprite_dir)
    match anim:
        "walk":
            if $AnimationPlayer.current_animation != new_anim:
                $AnimationPlayer.play(new_anim)
        "shoot":
            anim_switch("walk")
            $AnimationPlayer.seek(0, true)
        "idle":
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

func update_gui():
    $Gui.set_health(health)
