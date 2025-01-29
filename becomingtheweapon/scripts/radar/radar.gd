extends Area3D

var item_icon = preload("res://icon.svg")


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Item"):
		$CanvasLayer/RadarUI.add_object(body, item_icon)
	elif body.is_in_group("Player"):
		$CanvasLayer/RadarUI.add_object(body, item_icon)
	elif body.is_in_group("Enemy"):
		$CanvasLayer/RadarUI.add_object(body, item_icon)


func _on_body_exited(body: Node3D) -> void:
	$CanvasLayer/RadarUI.remove_object(body)
