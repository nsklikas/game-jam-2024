extends CharacterBody3D


const SPEED = 2
const JUMP_VELOCITY = 2
const SPEED_BOOST = 2
const JUMP_BOOST = 5


@export var throw_strength: float = 20.0
@export var player: Node3D

@export var left_equipment: Node3D
@export var object_to_spawn: PackedScene

@onready var animation_player: AnimationPlayer = $ANIMS/AnimationPlayer
@onready var cam: Node3D = $Cam_rig
@onready var body: Node3D = $ANIMS
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var shield_sphere: Shield = $ShieldSphere

var state_machine: AnimationNodeStateMachinePlayback
var applied_force = null
var health = 800


func _ready():
	state_machine = animation_tree["parameters/playback"]


func _physics_process(delta: float) -> void:
	var walk: bool
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var speed = SPEED
	var jump_velocity = JUMP_VELOCITY
	var run = Input.is_action_pressed("run")
	if run:
		speed = speed * SPEED_BOOST
		jump_velocity = jump_velocity * JUMP_BOOST

	# Handle jump.
	var jump = Input.is_action_just_pressed("ui_accept") and is_on_floor()
	if jump:
		velocity.y = jump_velocity
		state_machine.travel("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward") 
	var direction := (cam.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if is_on_floor():
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			body.look_at(direction + position)
			if not run:
				state_machine.travel("Slow_walk")
				animation_tree.set("parameters/TimeScale/scale", SPEED)
				walk = true
			else:
				state_machine.travel("Run")
				animation_tree.set("parameters/TimeScale/scale", SPEED_BOOST)
		else:
			velocity.x = direction.x * speed * 0.1
			velocity.z = direction.z * speed * 0.1
	else:
		if is_on_floor() && not jump:
			velocity.x = 0
			velocity.z = 0
			state_machine.travel("Idle")

	if Input.is_action_pressed("right_skill"):
		if walk:
			state_machine.travel("Walk aim right")
		elif run:
			state_machine.travel("Run_aim_right")
		else:
			state_machine.travel("Aim_idlle_right")

	if Input.is_action_just_released("right_skill"):
		right_hand_skill()

	apply_external_forces()
	move_and_slide()


func right_hand_skill():
	var g: RigidBody3D = object_to_spawn.instantiate()
	var skeleton: Skeleton3D = body.get_node("Idle/Skeleton3D")
	var bone = skeleton.find_bone("mixamorig_RightHand")
	var hand_pos: Vector3 = skeleton.to_global(skeleton.get_bone_global_pose(bone).origin)
	g.position = hand_pos
	get_parent().add_child(g)

	var force = 18
	var upDirection = 3.5

	var player_rotation = -body.transform.basis.z.normalized()

	g.apply_central_impulse(player_rotation * force + Vector3(0, upDirection, 0))


func hit(damage: int):
	cam.apply_shade()
	health = health - damage
	if health <= 0:
		queue_free()


func apply_force(velocity):
	applied_force = [velocity, 5]


func apply_external_forces():
	if applied_force:
		velocity = velocity + applied_force[0]
		applied_force[1] = applied_force[1] - 1
		if applied_force[1] <= 0:
			applied_force = null
