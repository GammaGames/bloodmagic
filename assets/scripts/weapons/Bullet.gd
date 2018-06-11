extends Area2D

var direction
var penetration
var speed
var life
var damage

func _ready():
    z_index = -1

func shoot(dir, speed, damage, life, penetration):
    self.direction = dir
    self.rotation = dir
    self.damage = damage
    self.speed = speed
    self.life = life
    self.penetration = penetration
    enable()
    show()

func _process(delta):
    if life != null:
        life -= delta
        if life < 0:
            call_deferred("free")

        var velocity = Vector2()
        velocity.x = cos(direction) * speed
        velocity.y = sin(direction) * speed

        if velocity.length() > 0:
            velocity = velocity.normalized() * speed
        position += velocity * delta

    if penetration != null and penetration < 0:
        disable()
        call_deferred("free")

func _on_body_shape_entered(body_id, body, body_shape, self_shape):
    if body.has_method("hurt"):
        body.hurt(damage)
        penetration -= 1

func disable():
    disconnect("body_shape_entered", self, "_on_body_shape_entered")

func enable():
    connect("body_shape_entered", self, "_on_body_shape_entered")
