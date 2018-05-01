extends Area2D

var direction
var speed
var life
var damage

func _ready():
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
            queue_free()

        var velocity = Vector2()

        velocity.x = cos(direction) * speed
        velocity.y = sin(direction) * speed

        if velocity.length() > 0:
            velocity = velocity.normalized() * speed

        position += velocity * delta
