extends CharacterBody2D

class_name Player

#movement
@export var gravity := 2500.0
@export var wall_slide := 300.0
@export var run_accel: Curve
@export var max_run_speed := 500.0
@export var friction := 10000.0
@export var air_friction := 1000.0
@export var jump_vel: Curve

@export var coyote_time := 0.05
@export var jump_grace_time := 0.1
@export var wall_kickoff: Curve
@export var walljump_strength := 400.0
@export var controllability: Curve

var cur_friction

#Movement Variables
var leftMove := false
var rightMove := false
var isMoving := false
var jumpMove := false

#Timer
@onready var coy_timer: Timer = get_node("CoyoteTimer")
@onready var jump_grace_timer: Timer = get_node("JumpGraceTimer")
@onready var jump_timer: Timer = get_node("JumpTimer")
var kickoff_timer: Timer = Timer.new()
var kickoff_right: bool = false

func _ready() -> void:
	coy_timer.wait_time = coyote_time
	jump_grace_timer.wait_time = jump_grace_time
	jump_timer.wait_time = jump_vel.max_domain
	
	kickoff_timer.wait_time = wall_kickoff.max_domain
	kickoff_timer.one_shot =true
	add_child(kickoff_timer)

func _input(event: InputEvent) -> void:
	if event.is_action("move_left"):
		if event.is_pressed():
			leftMove = true
		elif event.is_released():
			leftMove = false
		return
	
	if event.is_action("move_right"):
		if event.is_pressed():
			rightMove = true
		elif event.is_released():
			rightMove = false
		return
	
	if event.is_action("jump"):
		if Input.is_action_just_pressed("jump"):
			jumpMove = true
		elif Input.is_action_just_released("jump"):
			jump_timer.stop()
			jumpMove = false
		return 
	

func process_jump() -> void:
	# jump
	if is_on_floor() || !coy_timer.is_stopped():
		jump_timer.start()
		coy_timer.stop()
		jump_grace_timer.stop()
		return
	
	# walljump
	if is_on_wall_only():
		velocity = Vector2.ZERO
		coy_timer.stop()
		
		kickoff_right = get_wall_normal().x > 0
		kickoff_timer.start()
		jump_grace_timer.stop()
		return


func process_movement(delta) -> void:
	isMoving = leftMove != rightMove
	var adjusted_accel = run_accel.sample(abs(velocity.x)) * delta * controllability.sample(kickoff_timer.time_left)
	if isMoving:
		if rightMove && velocity.x < max_run_speed:
			velocity.x = min(adjusted_accel+velocity.x , max_run_speed)
		if leftMove && velocity.x > -max_run_speed:
			velocity.x = max(-adjusted_accel+velocity.x, -max_run_speed)
	
	if jumpMove:
		jump_grace_timer.start()
		jumpMove=false  
	
	if jump_grace_timer.time_left > 0 && !jump_grace_timer.is_stopped():
		process_jump()
	

func calc_friction(delta) -> float:
	if !isMoving or abs(velocity.x)>max_run_speed:
		if is_on_floor():
			return friction * delta
		return air_friction * delta
	return 0


func velocity_decay() -> void:
	if velocity.x < 0:
		velocity.x = min(0, velocity.x+cur_friction)
	else:
		velocity.x = max(0, velocity.x-cur_friction)

func jump_decay(delta) -> void:
	if jump_timer.time_left > 0 && !jump_timer.is_stopped():
		var time = jump_vel.max_domain - jump_timer.time_left
		velocity.y -= jump_vel.sample(time)*delta
		if is_on_ceiling():
			jump_timer.stop()


func kickoff_decay(delta) -> void:
	if kickoff_timer.time_left > 0 && !kickoff_timer.is_stopped():
		var time = wall_kickoff.max_domain - kickoff_timer.time_left
		if kickoff_right:
			velocity.x += wall_kickoff.sample(time) * delta
		else:
			velocity.x -= wall_kickoff.sample(time) * delta
		velocity.y -= wall_kickoff.sample(time) * delta



func _physics_process(delta) -> void:
	process_movement(delta)
	
	if is_on_floor():
		coy_timer.start()
	
	jump_decay(delta)
	kickoff_decay(delta)
	
	#wall glide
	if is_on_wall_only() && velocity.y>0:
		velocity.y = wall_slide
	else:
		velocity.y += gravity * delta
		
	cur_friction = calc_friction(delta)
	velocity_decay()
	
	move_and_slide()
