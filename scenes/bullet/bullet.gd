extends Area2D
var damge = 10
var speed = 1020
var t = true

func _sound():
	if t:
		$"shootsound".play()

# Called when the node enters the scene tree for the first time.
func _ready():
	_sound()  # Play the sound when the bullet is added to the scene.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	print("hit")
	if body.is_in_group("player") or body.is_in_group("enemy"):
		body.on_Hit(damge)
		print("hit")
		queue_free()
