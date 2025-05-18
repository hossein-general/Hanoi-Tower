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
var step_speed: int = 20
var decrease_speed: int
var raising_height: int

func _ready() -> void:
	scale = Vector2(size_mul * (size-1) + 1, 1)		# Size adjustments
	$Polygon2D.color = Color(randf_range(0.2, 0.9),randf_range(0.2, 0.9),randf_range(0.2, 0.9),1)	# Random color


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Click") and mouse_in:		# handling clicks
		external_click.emit()
		
	if in_arc_move:
		if stage1:
			# velocity += Vector2.UP * step_speed * delta
			velocity = Vector2(0, -step_speed)
			position += velocity
			if position.y < top_of_rod:
				position.y = top_of_rod
				stage1 = false
				decrease_speed = velocity.y / ( abs(position.x - destination.x)/step_speed)
				raising_height = position.y - 32
				print(destination.x - position.x)
				print(decrease_speed)
				velocity = Vector2(0, 0)
				if destination.x >= position.x:
					stage2_right = true
				else:
					stage2_left = true
					
		elif stage2_right:
			# print(velocity)
			# velocity += Vector2(1 * step_speed, (position.y - raising_height) * 100 * decrease_speed) * delta
			# velocity += Vector2(1 * step_speed, (position.y - raising_height) * 100 * decrease_speed) * delta
			velocity = Vector2(step_speed, 0)
			position += velocity
			if position.x >= destination.x:
				print("stage2_done")
				position.x = destination.x
				stage2_right = false
				stage3 = true
				
		elif stage2_left:
			# print(velocity)
			# velocity -= Vector2(1 * step_speed, 1 * decrease_speed) * delta
			velocity = Vector2(-step_speed, 0)
			position += velocity
			# position -= Vector2.RIGHT * 300 * delta
			if position.x <= destination.x:
				print("stage2_done")
				position.x = destination.x
				stage2_left = false
				stage3 = true
				
		elif stage3:
			# position += Vector2.DOWN * 300 * delta
			velocity = Vector2(0, step_speed)
			position += velocity
			
			if position.y >= destination.y:
				position = destination
				stage3 = false
				in_arc_move = false
				velocity = Vector2(0,0)
			


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
