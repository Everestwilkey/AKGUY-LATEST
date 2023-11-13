extends CharacterBody2D
@onready var end_of_gun = $end_of_gun
@onready var walking_sound = $WalkingSound  # Get the AudioStreamPlayer2D node reference
const BULLETPATH = preload("res://scenes/bullet/bullet.tscn")
const SPEED = 400
var canShoot = true
var bullet_direction;
var MAX_HP = 100
var current_Hp 

func _ready():
	current_Hp = MAX_HP
	
func _process(delta):
	look_at(get_global_mouse_position())
	velocity = get_input()
	move_and_slide()

func get_input() -> Vector2:
	var x_movement = Input.get_action_strength("up") - Input.get_action_strength("down")
	var y_movement = Input.get_action_strength("Right") - Input.get_action_strength("left")
	var input_vec = Vector2(x_movement, y_movement).normalized()
	var relative_movement = transform.x * input_vec.x + transform.y * input_vec.y
	return relative_movement * SPEED

func _unhandled_input(event) -> void:
	if event.is_action_pressed("Fire"):
		shoot()

func shoot():
	if canShoot:
		canShoot = false
		$ShootTimer.start()
		var bullet = BULLETPATH.instantiate()
		get_parent().add_child(bullet)
		bullet.transform = $end_of_gun.global_transform
func wait():
	canShoot = true
	


func _on_shoot_timer_timeout():
	canShoot = true

func on_Hit(damage):
	current_Hp -= damage
	if current_Hp <= 0:
		on_Death()
func on_Death():
	self.queue_free()
	
func handle_walking_sound(velocity: Vector2):
	if velocity.length() > 0 and not walking_sound.playing:  # If the character is moving and sound isn't already playing
		walking_sound.play()
	elif velocity.length() == 0:  # If character stops moving
		walking_sound.stop()
