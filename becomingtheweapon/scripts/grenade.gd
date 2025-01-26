extends RigidBody3D

@export var stop_threshold: float = 0.1
@export var explosion_scene: PackedScene

@onready var blast_radius = $BlastRadius
@onready var timer = $Timer

var triggered: bool = false
const damage = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	explode()


func explode():
	var bodies = blast_radius.get_overlapping_bodies()
	for b in bodies:
		if b.is_in_group("Enemy"):
			var space = get_world_3d().direct_space_state
			var ray_params = PhysicsRayQueryParameters3D.create(global_transform.origin, b.global_transform.origin)
			var collision = space.intersect_ray(ray_params)
			if collision and collision.collider.is_in_group("Enemy"):
				b.enemy_hit(damage)
	
	var explosion = explosion_scene.instantiate()
	explosion.position = global_position
	get_parent().add_child(explosion)
	explosion.explode()

	queue_free()


func _on_blast_radius_body_entered(_body: Node3D) -> void:
	if not triggered:
		timer.start()
		explode()
		triggered = true
