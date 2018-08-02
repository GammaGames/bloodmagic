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
onready var camera = $"/root/Game/Camera2D"

func _ready():
    add_to_group("player")
    speed = 150
    health = 3.5
    change_weapon(load("res://scenes/weapons/BaseWeapon.tscn").instance())
    update_gui()
    $ShootParticles/Timer.connect("timeout", self, "stop_particles")
    $Hitstun.connect("tween_started", self, "start_knockback")
    $Hitstun.connect("tween_completed", self, "end_knockback")

func _physics_process(delta):
    controls_loop(delta)

    match state:
        STATES.IDLE:
            idle_loop(delta)
        STATES.MOVE:
            movement_loop(delta)
        STATES.SHOOT:
            shoot_loop(delta)

    idle_health_loop(delta)
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
    elif target_dir.length() != 0 or hitstun:
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

func idle_health_loop(delta):
    if !hitstun and health < 5:
        # health += 0.01
        update_gui()

func heal(item):
    health += item.amount
    update_gui()

func hurt(item):
    if !hitstun:
        knock_dir = transform.origin - item.transform.origin
        knock_speed = 250
        $HurtParticles.rotation = knock_dir.angle() - PI
        $HurtParticles.restart()

        $Hitstun.interpolate_property(self, "knock_speed", knock_speed, 200, 0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
        $Hitstun.start()

        health -= item.damage
        if health < 1.5:
            Time.slow_motion(0.3)

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

func post_shoot(frequency, amplitude, dir):
    $ShootParticles.rotation = dir
    $ShootParticles.emitting = true
    $ShootParticles/Timer.start()

func stop_particles():
    $ShootParticles.emitting = false

func update_gui():
    $"/root/Game/Gui".set_health(health)

func start_knockback(object, key):
    hitstun = true

func end_knockback(object, key):
    knock_speed = 0
    hitstun = false

func transition_room(room):
    $"/root/Game/Camera2D".global_position = room.global_position + Vector2(104, 56)
