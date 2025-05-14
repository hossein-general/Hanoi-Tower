extends Node2D

# Constants
const size_mul: float = 0.32

var size: int	# the length of the rod (how big it is)

func _ready() -> void:
	scale = Vector2(size_mul * (size-1) + 1, 1)		# Size adjustments
	$Polygon2D.color = Color(randf_range(0.2, 0.9),randf_range(0.2, 0.9),randf_range(0.2, 0.9),1)	# Random color

func instant_update_pos(pos: Vector2):
	position = pos
	

func set_size(new_size: int):
	size = new_size
