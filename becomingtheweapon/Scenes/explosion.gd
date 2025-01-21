extends Node3D

@onready var debris = $Debris
@onready var fire = $Fire

func explode():
	debris.emitting = true
	fire.emitting = true
	await get_tree().create_timer(2.0).timeout
	queue_free()
