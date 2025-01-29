extends MarginContainer


var objects = {}
var player: CharacterBody3D

@export var _scale = 256 / 80


func _process(_delta: float) -> void:
	var rot = get_camera_rotation()
	position.x = 0
	position.y = DisplayServer.window_get_size().y - 256
	var player_pos = Vector2(player.position.x, player.position.z).rotated(deg_to_rad(rot))
	for o in objects.keys():
		var o_pos = Vector2(o.position.x, o.position.z).rotated(deg_to_rad(rot))
		if not is_instance_valid(o):
			remove_object(o)
			continue
		if (o_pos - player_pos).length() * _scale > size.x:
			objects[o].visible = false
		else:
			objects[o].visible = true
		var pos = (o_pos - player_pos) * _scale
		objects[o].position = pos + size / 2

# Called when the node enters the scene tree for the first time.
func add_object(o, icon):
	var sprite = Sprite2D.new()
	$Radar.add_child(sprite)
	sprite.texture = icon
	sprite.scale = Vector2(0.5, 0.5)
	objects[o] = sprite


func remove_object(o):
	objects[o].queue_free()
	objects.erase(o)


func get_camera_rotation() -> float:
	var rot = player.get_node("Cam_rig").rotation_degrees
	return rot.y
