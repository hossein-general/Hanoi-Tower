extends Node2D


var rod_scene = preload("res://scenes/rod.tscn")

# Constants
const min_ring_len: int = 74
const ring_len_dif: int = 16
const view_len: int = 576
const table_y_pos: int = 264

var main_rod_generated: bool = false


func _on_game_creator_rod_ring_count(rod_count:int, ring_count:int) -> void:
	pass # Replace with function body.

	var rod_x_poses: Array[int] = calc_x_pos(ring_count, rod_count)

	for x_pos in rod_x_poses:
		create_rod(x_pos, ring_count)


func create_rod(pos, ring_count):
	print("rod_created")
	var rod = rod_scene.instantiate()
	rod.position = Vector2(pos, table_y_pos)
	rod.ring_count = ring_count
	$RodPoses.add_child(rod)


# calculating the x positions in which the rods should be spawned
func calc_x_pos(ring_count, rod_count):
	var node_len = min_ring_len + ring_len_dif * ring_count
	var total_len = node_len * rod_count
	
	if total_len > view_len:
		print("UN SUPPORTED NUMBER OF RODS/RINGS (OUT OF VIEW)")
		
	var margin: int = (view_len - total_len) / 2
	var rod_x_poses: Array[int]
	
	rod_x_poses.push_back(margin + node_len/2)
	for i in range(1, rod_count):
		rod_x_poses.push_back(margin + node_len/2 + i * node_len)

	return rod_x_poses
