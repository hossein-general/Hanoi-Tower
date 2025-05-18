extends Node2D

signal rod_ring_count(rod_count: int, ring_count: int)

var rod_count: int = 3
var ring_count: int = randi_range(3, 6)

func _ready():
	hide()
	rod_ring_count.emit(rod_count, ring_count)
	# rod_ring_count.emit(3, 3)
