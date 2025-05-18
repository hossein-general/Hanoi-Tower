extends Node2D

var rod_scene = preload("res://scenes/rod.tscn")
var ring_scene = preload("res://scenes/ring.tscn")

# Constants
const min_ring_len: int = 74
const ring_len_dif: int = 16
const view_len: int = 576
const table_y_pos: int = 264

var main_rod_generated: bool = false	# main rod contains rings

# ring moving related variables
var first_rod = null


# Getting the number of Rods and Rings from the Game Creator menue (which is not implemented yet)
func _on_game_creator_rod_ring_count(rod_count:int, ring_count:int) -> void:	#maximum ring count and the number of rods avalable
	var rod_x_poses: Array[int] = calc_x_pos(ring_count, rod_count)		#calculate appropriate rod positions

	for x_pos in rod_x_poses:
		create_rod(x_pos, ring_count)	#creating each rod in each position


# Creating rods, instantiating, and adding as a child to RodPoses scene
func create_rod(pos, ring_count):
	var rod = rod_scene.instantiate()
	
	# if its the first rod generated, the level will generate all rings for it to hold
	if not main_rod_generated:
		var rings: Array = create_rings(ring_count)
		rod.ring_stack = rings
		main_rod_generated = true
	
	rod.position = Vector2(pos, table_y_pos)	# setting position
	rod.max_ring_count = ring_count			# setting maximum ring count avalable in game
	$RodPoses.add_child(rod)		# adding rods as childs of the RodPoses node (for further organization)
	
	# Connecting signals
	rod.click.connect(_on_rod_click)


# Creating rods, instantiating, and adding as a child to RodPoses scene and returns them
func create_rings(ring_count):
	var rings_created: Array = []	# the created rings
	
	for size in range(ring_count, 0, -1):
		var ring = ring_scene.instantiate()
		ring.set_size(size)
		$Rings.add_child(ring)
		rings_created.push_back(ring)
	
	return rings_created


# calculating the x positions in which the rods should be spawned and returns them
func calc_x_pos(ring_count, rod_count):
	var node_len = min_ring_len + ring_len_dif * ring_count
	var total_len = node_len * rod_count
	
	if total_len > view_len:		# if the number of rods or the length of each resaulted by ring count exited camera frame
		print("UN SUPPORTED NUMBER OF RODS/RINGS (OUT OF VIEW)")	# no exception raised
	
	var margin: int = (view_len - total_len) / 2
	var rod_x_poses: Array[int]		# an array containing x-posision of rods
	
	rod_x_poses.push_back(margin + node_len/2)		# the first rods x-pos should be calculated seperately 
	for i in range(1, rod_count):		# calculating other rods positions and storing them
		rod_x_poses.push_back(margin + node_len/2 + i * node_len)	# appending each new value

	return rod_x_poses
	
	
func move_ring(rod1, rod2):
	var the_ring = rod1.top_ring()
	if not (the_ring == null):
		if rod2.add_ring(the_ring):
			rod1.remove_top()
		else:
			printerr("the size doesnt match (this should have not happened)")
	else:
		printerr("the first rod is empty (this should have not happened)")
	


# Signals
func _on_rod_click(rod) -> void:
	# getting the first selection from rods
	if first_rod == null:
		if rod.has_rings():
			first_rod = rod
			print("rod \"", first_rod, "\" stored")
		else:
			print("this rod is empty")
			
	# handling clicking the same rod again
	elif rod == first_rod:
		first_rod = null
		print("duplicate")
		
	# if the ring moving request sounds sufficiant
	else:
		var the_ring = first_rod.top_ring()
		
		# concidering the rules of the game
		if (not rod.has_rings()) or first_rod.top_ring().size < rod.top_ring().size:
			move_ring(first_rod, rod)
		else:
			print("the rules of the game does not allow bigger rings on top of smaller ones")
		print("ring moved!")
		first_rod = null
		
		

	
