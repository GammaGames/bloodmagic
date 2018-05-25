extends Area2D

var direction
var speed
var life
var damage

func _ready():
    connect("body_shape_entered", self, "_on_body_shape_entered")
    z_index = -1

func init(dir, speed, damage, life):
    self.direction = dir
    self.rotation = dir
    self.damage = damage
    self.speed = speed
    self.life = life

func _process(delta):
    if life != null:
        life -= delta
        if life < 0:
            # queue_free()
            call_deferred("free")

        var velocity = Vector2()

        velocity.x = cos(direction) * speed
        velocity.y = sin(direction) * speed

        if velocity.length() > 0:
            velocity = velocity.normalized() * speed

        position += velocity * delta

func _on_body_shape_entered(body_id, body, body_shape, self_shape):
    if body.has_method("hurt"):
        print(damage)
        body.hurt(damage)
