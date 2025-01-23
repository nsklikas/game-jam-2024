extends Node3D

var yaw: float = 0.0 

@export var target: Node3D
@export var pivot_node: Node3D



func ready():
	yaw = pivot_node.rotation_degrees.y
	update_camera_position()

#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#rotate_from_vector(event.screen_relative * 0.30)

#func rotate_from_vector(v: Vector2):
	#if v.length() == 0: return
	#yaw -= v.x
	#pivot_node.rotation_degrees.y = yaw
	#update_camera_position()

#func update_camera_position():
	#if target:
		#pivot_node.position = target.position
		#
		#pivot_node.look_at(target.position, Vector3.UP)
func _process(_delta: float) -> void:
	# Check if Q or E is being held down and rotate accordingly
	if Input.is_action_pressed("rotate_came_left"):
		rotate_from_vector(Vector2(-1, 0))  # Rotate left (counter-clockwise)
	elif Input.is_action_pressed("rotate_cam_right"):
		rotate_from_vector(Vector2(1, 0))   # Rotate right (clockwise)

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
