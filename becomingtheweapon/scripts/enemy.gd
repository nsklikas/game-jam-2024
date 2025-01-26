extends CharacterBody3D


const SPEED = 4
const DAMAGE = 25
var health = 200
var attack: bool = false
var jump_back: int = 0

@onready var target: CharacterBody3D
@onready var detection_area: Area3D = $DetectionArea
@onready var animation_player: AnimationPlayer = $"Rock_claw/Crab /Skeleton3D/AnimationPlayer"


func _ready() -> void:
	animation_player.set_blend_time("walk", "CLAW", 0.3)
	animation_player.set_blend_time("CLAW", "walk", 0.3)

func _physics_process(_delta: float) -> void:
	if target && not attack && not jump_back:
		var direction = (target.position - position).normalized()
		look_at(target.global_position)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		animation_player.play("walk")
	elif target && jump_back:
		var direction = (target.position + position).normalized()
		look_at(target.global_position)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		animation_player.play("walk")
		jump_back = jump_back - 1

	move_and_slide()


func enemy_hit(damage):
	health -= damage
	if health <= 0:
		queue_free()


func _on_detection_area_body_entered(body: Node3D) -> void:
	var space = get_world_3d().direct_space_state
	# Check if there are any obstacles between the enemy and the target
	var ray_params = PhysicsRayQueryParameters3D.create(global_transform.origin, body.global_transform.origin, detection_area.collision_mask)
	var collision = space.intersect_ray(ray_params)
	if collision:
		target = collision.collider


func _on_detection_area_body_exited(_body: Node3D) -> void:
	target = null


func _on_attack_area_body_entered(body: Node3D) -> void:
	animation_player.set_blend_time("walk", "CLAW", 0.3)
	animation_player.play("CLAW")
	animation_player.set_speed_scale(0.8)
	attack = true


func _on_attack_area_body_exited(_body: Node3D) -> void:
	animation_player.set_blend_time("CLAW", "walk", 0.3)
	attack = false
	jump_back = 5


func _on_right_arm_area_body_entered(body: CharacterBody3D) -> void:
	body.hit(DAMAGE)


func _on_left_arm_area_body_entered(body: CharacterBody3D) -> void:
	body.hit(DAMAGE)
