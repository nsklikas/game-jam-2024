extends Node3D

var yaw: float = 0.0 

@export var target: Node3D
@export var pivot_node: Node3D
@export var random_strength: float = 0.2

@onready var camera: Camera3D = $"Camera3D"

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0


func ready():
	yaw = pivot_node.rotation_degrees.y
	update_camera_position()


func _process(_delta: float) -> void:
	# Check if Q or E is being held down and rotate accordingly
	if Input.is_action_pressed("rotate_came_left"):
		rotate_from_vector(Vector2(-1, 0))  # Rotate left (counter-clockwise)
	elif Input.is_action_pressed("rotate_cam_right"):
		rotate_from_vector(Vector2(1, 0))   # Rotate right (clockwise)

	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, 0.2)
		var offset = random_offset()
		camera.h_offset = offset[0]
		camera.v_offset = offset[1]
	update_camera_position()


func rotate_from_vector(v: Vector2):
	if v.length() == 0: 
		return
	yaw -= v.x
	rotation_degrees.y = yaw
	update_camera_position()


func update_camera_position():
	if target:
		pivot_node.position = lerp(pivot_node.position, target.position, 0.6)
		#pivot_node.look_at(target.position, Vector3.UP)


func apply_shade():
	shake_strength = random_strength


func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
