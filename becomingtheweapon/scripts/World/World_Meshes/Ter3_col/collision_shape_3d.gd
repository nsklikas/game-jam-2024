extends CollisionShape3D

@onready var collision_shape = $CollisionShape3D 
@onready var terrain_mesh = $MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var heightmap_texture = preload("res://scenes/World Meshes/Heightmap_Out.exr")
	var heightmap_shape = HeightMapShape3D.new()
	heightmap_shape.heightmap = heightmap_texture
	heightmap_shape.width = terrain_mesh.scale.x
	heightmap_shape.depth = terrain_mesh.sclae.z
	collision_shape.shape = heightmap_shape


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
