extends Node2D

# Constants
const rod_ring_height: int = 32

# signals
signal click(rod)	# passing "self"

# ring managementa
var ring_stack: Array = []		# the stack wich holds the rings
var ring_count: int				# number of the rings contained within this rod
var max_ring_count: int			# number of rings within the game
var ring_pos_map: Dictionary	# a map dictionary which shoes logically appropriate position for each level of rings

# for handling mouse input
var mouse_in: bool = false
var click_done: bool = false


# Default processes
func _ready() -> void:
	# for test
	if max_ring_count <= 0:
		max_ring_count = 3
		
	scale *= Vector2(1, max_ring_count)
	for num in range(max_ring_count):
		ring_pos_map[num] = Vector2(global_position.x, global_position.y - num * rod_ring_height - (rod_ring_height/2))
		
	update_ring_count()
	init_rings()


func  _process(_delta: float) -> void:
	click_done = false
	if Input.is_action_just_pressed("Click") and mouse_in and (not click_done):		# handling clicks (the click_done part is for multithreat)
		print("-----------------")
		click.emit(self)
		click_done = true


# Custom functions
func update_ring_count():
	ring_count = ring_stack.size()


func init_rings():
	for i in range(ring_count):
		var the_ring = ring_stack[i]
		the_ring.instant_update_pos(ring_pos_map[i])
		the_ring.external_click.connect(_on_ring_external_click)


# adding a new ring and requesting that ring to move to required position
func add_ring(new_ring) -> bool:
	if has_rings() and new_ring.size > ring_stack[ring_count - 1].size:	# to check if the new one is not larger than the top one
		return false				# process un-successful
		
	ring_stack.push_back(new_ring)	# add the new ring to the stack
	new_ring.external_click.connect(_on_ring_external_click)
	update_ring_count()				# updating number of rings
	new_ring.instant_update_pos(ring_pos_map[ring_count - 1])	# moving the new ring to correct position
	return true		# process successful


# remove the last ring, update ring count
func remove_top():
	var the_ring = ring_stack.pop_back()
	the_ring.external_click.disconnect(_on_ring_external_click)
	update_ring_count()


func top_ring():
	if ring_count > 0:
		return ring_stack[ring_count - 1]
	else:
		return null


func has_rings() -> bool:
	if ring_count > 0:
		return true
	else:
		return false

# Signals
func _on_area_2d_mouse_entered() -> void:
	mouse_in = true


func _on_area_2d_mouse_exited() -> void:
	mouse_in = false


func _on_ring_external_click() -> void:
	if not click_done:
		click.emit(self)
		click_done = true
