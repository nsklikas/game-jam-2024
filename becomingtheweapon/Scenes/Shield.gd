class_name Shield extends Area3D

const SHIELD_IMPACT_DECAY_SPEED: float = 1

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

@export var shield_appearance: MeshInstance3D
@export var active: bool = true

# note that the size of the buffer created here must match the impacts_tracked const in the shader
# this can be freely changed however if you want to support more than 16 simultaneous impacts
var _points: PointBuffer = PointBuffer.new(16)


func _ready() -> void:
	# i do this here so that shield nodes that share this material dont all react to impacts on one shield
	# unfortunately I can't define instance uniform arrays in the Godot shader language
	shield_appearance.material_override = shield_appearance.material_override.duplicate()


func _process(delta: float) -> void:
	var decayed_points:Array[Vector4] = _points.decay_points(delta, SHIELD_IMPACT_DECAY_SPEED)
	shield_appearance.material_override.set("shader_parameter/impact_points", decayed_points)


func _on_body_entered(body: Node3D) -> void:
	var space = get_world_3d().direct_space_state
	var ray_params = PhysicsRayQueryParameters3D.create(global_transform.origin, body.global_transform.origin)
	var collision = space.intersect_ray(ray_params)
	if collision.collider:
		_points.push(to_local(collision.position))
	

func hit(from: Node3D):
	var space = get_world_3d().direct_space_state
	var ray_params = PhysicsRayQueryParameters3D.create(global_transform.origin, from.global_transform.origin)
	var collision = space.intersect_ray(ray_params)
	if collision.collider:
		_points.push(to_local(collision.position))
	

	
# the below is just a data structure to make handling impacts simpler
# it automatically removes the oldest impact information when new impacts are added
# and cleanly handles the decay of all tracked impacts when decay_points is called

class PointBuffer:
	var _buffer_index:int = 0
	var _points:Array[Vector4]
	
	func _init(buffer_size:int) -> void:
		_points.resize(buffer_size)
	
	func push(point:Vector3) -> void:
		_points[_buffer_index] = Vector4(point.x, point.y, point.z, 1.0)
		_buffer_index += 1
		if _buffer_index >= _points.size():
			_buffer_index = 0

	func decay_points(delta:float, decay_speed:float) -> Array[Vector4]:
		var new_points:Array[Vector4]
		for point in _points:
			new_points.append(Vector4(point.x, point.y, point.z, clamp(point.w - decay_speed * delta, 0, 1)))
		_points = new_points
		
		return _points
