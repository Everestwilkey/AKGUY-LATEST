extends CharacterBody2D

# Variables
var speed = 200
var agro = false
var target = null
const BULLETPATH = preload("res://scenes/bullet/bullet.tscn")
var canShoot = true
const MAX_HP = 50
var current_Hp;
var move_dir = Vector2()  # The direction the enemy will move in
# Initialization
func _ready():
	current_Hp = MAX_HP
	randomize()
	on_Wander()  # Start wandering when the game starts

# Main Loop
func _process(delta):
	velocity = move_dir * speed  # Update the velocity
	if agro:
		move_dir = (target.position - position).normalized()
		look_at(target.position)
		if canShoot:
			shoot()
	else:
		# Make the enemy look in the direction it's moving
		rotation = move_dir.angle()

	move_character()  # Move in the set direction

# Movement
func move_character():
	# Using move_and_slide without arguments now
	move_and_slide()

# Detection
func _on_detection_body_entered(body):
	if body.is_in_group("player"):
		print("is this a player")
		agro = true
		target = body

# Shooting
func shoot():
	canShoot = false
	$"shootsound".play()
	$"Shoot _timer".start()
	var bullet = BULLETPATH.instantiate()
	get_parent().add_child(bullet)
	bullet.transform = $end_of_gun.global_transform

func _on_shoot_timer_timeout():
	canShoot = true

# Damage and Death
func on_Hit(damage):
	current_Hp -= damage
	if current_Hp <= 0:
		on_Death()

func on_Death():
	self.queue_free()

# Wandering
func random_pos() -> Vector2:
	var random_x = randi_range(-200, 200)
	var random_y = randi_range(-200, 200)
	return position + Vector2(random_x, random_y)

func on_Wander():
	if not agro:
		var mob_random_time = randi_range(1, 3)
		$"Wander_timer".set_wait_time(mob_random_time)
		$"Wander_timer".start()
		move_dir = (random_pos() - position).normalized()

func _on_wander_timer_timeout():
	on_Wander()  # Pick a new direction to wander in when the timer times out
