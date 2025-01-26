class_name ShieldNextPass extends Shield

@export var base_expansion:float = 0.05
var expansion:float = 0


func _process(delta: float) -> void:
	var decayed_points:Array[Vector4] = _points.decay_points(delta, SHIELD_IMPACT_DECAY_SPEED)
	shield_appearance.material_override.next_pass.set("shader_parameter/impact_points", decayed_points)
	
	expansion = lerpf(expansion, base_expansion, delta)
	shield_appearance.material_override.next_pass.set("shader_parameter/extend_distance", expansion)


func _on_body_entered(body: Node3D) -> void:
	super._on_body_entered(body)
	expansion += base_expansion * 0.5
