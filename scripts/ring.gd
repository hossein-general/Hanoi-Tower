extends Node2D

# Constants
const size_mul: float = 0.32

var size: int			# the length of the rod (how big it is)

# mouse input control
var mouse_in: bool = false	# if the mouse is within the surrounding area of the ring
signal external_click()		# this helps extending the click area for the rod

# movement related variables
var destination
var top_of_rod
var in_arc_move = false
var stage1 = false
var stage2_left = false
var stage2_right = false
var stage3 = false
var velocity: Vector2 = Vector2(0,0)
var step_speed = 20
var decrease_speed = 40

func _ready() -> void:
	scale = Vector2(size_mul * (size-1) + 1, 1)		# Size adjustments
	$Polygon2D.color = Color(randf_range(0.2, 0.9),randf_range(0.2, 0.9),randf_range(0.2, 0.9),1)	# Random color


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Click") and mouse_in:		# handling clicks
		external_click.emit()
		
	if in_arc_move:
		if stage1:
			velocity += Vector2.UP * step_speed * delta
			position += velocity
			if position.y < top_of_rod:
				print(position.y)
				print(top_of_rod)
				print("oops!")
				position.y = top_of_rod
				stage1 = false
				if destination.y >= position.y:
					stage2_right = true
				else:
					stage2_left = true
					
		elif stage2_right:
			velocity += Vector2(1 * step_speed, 1 * step_speed) * delta
			position += velocity
			if position.x >= destination.x:
				position.x = destination.x
				stage2_right = false
				stage3 = true
				
		elif stage2_left:
			position -= Vector2.RIGHT * 300 * delta
			if position.x <= destination.x:
				position.x = destination.x
				stage2_left = false
				stage3 = true
				
		elif stage3:
			position += Vector2.DOWN * 300 * delta
			if position.y >= destination.y:
				position = destination
				stage3 = false
				in_arc_move = false
			


func set_size(new_size: int):
	size = new_size


# position updating functions
func instant_update_pos(pos: Vector2):
	position = pos


func move_in_arc(dest: Vector2, top: int):
	destination = dest
	top_of_rod = top - 32
	in_arc_move = true
	stage1 = true


# Signals
func _on_area_2d_mouse_entered() -> void:
	mouse_in = true


func _on_area_2d_mouse_exited() -> void:
	mouse_in = false
