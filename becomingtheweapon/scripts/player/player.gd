extends CharacterBody3D


const SPEED = 3
const JUMP_VELOCITY = 2
const SPEED_BOOST = 2
const JUMP_BOOST = 5
var canThrow = true
var last_thrown = null
var thrown_now = null

@export var marker: Node3D
@export var throw_strength: float = 500.0
@export var player: Node3D

@onready var animation_player: AnimationPlayer = $visuals/player/AnimationPlayer
@onready var visuals: Node3D = $visuals

var walking = false


func _ready():
	#GameManager.set_player(self)
#	blend the animation for smoother results
#	for left to right by the set value
	animation_player.set_blend_time("idle","walk",0.3)
	animation_player.set_blend_time("walk","idle",0.3)
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var speed = SPEED
	var jump_velocity = JUMP_VELOCITY
	if Input.is_action_pressed("slow_run"):
		speed = speed * SPEED_BOOST
		jump_velocity = jump_velocity * JUMP_BOOST

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward") 
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		visuals.look_at(direction + position)

		if !walking:
			walking = true
			animation_player.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

		if walking:
			walking = false
			animation_player.play("idle")

	move_and_slide()
	
