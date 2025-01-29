extends MarginContainer


var objects = {}
var player: CharacterBody3D

@export var _scale = 256 / 80


func _process(_delta: float) -> void:
	var player_pos = Vector2(player.global_position.x, player.global_position.z)
	for o in objects.keys():
		var o_pos = Vector2(o.global_position.x, o.global_position.z)
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
