extends Node2D

# Constants
const size_mul: float = 0.32

var parent_rod = null	# the rod that holds this ring
var size: int			# the length of the rod (how big it is)

# mouse input control
var mouse_in: bool = false	# if the mouse is within the surrounding area of the ring
signal external_click()		# this helps extending the click area for the rod


func _ready() -> void:
	scale = Vector2(size_mul * (size-1) + 1, 1)		# Size adjustments
	$Polygon2D.color = Color(randf_range(0.2, 0.9),randf_range(0.2, 0.9),randf_range(0.2, 0.9),1)	# Random color


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Click") and mouse_in:		# handling clicks
		external_click.emit()


func update_parent(rod):
	parent_rod = rod

# position updating functions
func instant_update_pos(pos: Vector2):
	position = pos
	

func set_size(new_size: int):
	size = new_size


func _on_area_2d_mouse_entered() -> void:
	mouse_in = true


func _on_area_2d_mouse_exited() -> void:
	mouse_in = false
