extends CharacterBody2D


@export var speed := 300.0
@export var acceleration := 1.0
@export var deceleration := 1.0

var curr_speed := 0.0


func _physics_process(delta: float) -> void:
	if Global.state == Global.State.PAUSED:
		return
	# Get the input direction and handle the accesleration/deceleration.
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = lerp(velocity, direction * speed, delta * acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, delta * deceleration)
		
	if velocity.length() > speed:
		velocity = velocity.normalized() * speed

	move_and_slide()
