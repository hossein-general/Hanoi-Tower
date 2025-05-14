extends Node2D

# Constants
const rod_ring_height: int = 32

# ring managementa
var ring_stack: Array = []		# the stack wich holds the rings
var ring_count: int				# number of the rings contained within this rod
var max_ring_count: int			# number of rings within the game
var ring_pos_map: Dictionary	# a map dictionary which shoes logically appropriate position for each level of rings

# for handling mouse input
var mouse_in: bool = false


func _ready() -> void:
	scale *= Vector2(1, max_ring_count)
	
	for num in range(max_ring_count):
		ring_pos_map[num] = Vector2(global_position.x, global_position.y - num * rod_ring_height - (rod_ring_height/2))
		
	update_ring_count()
	init_rings()
	
	print(ring_pos_map)
	print(ring_stack)
	for ring in ring_stack:
		print(ring, ring.size)
	print(ring_count)


func  _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Click") and mouse_in:		# handling clicks
		print("on-click")


func update_ring_count():
	ring_count = ring_stack.size()


func init_rings():
	for i in range(ring_count):
		ring_stack[i].instant_update_pos(ring_pos_map[i])

# Signals
func _on_area_2d_mouse_entered() -> void:
	mouse_in = true


func _on_area_2d_mouse_exited() -> void:
	mouse_in = false
