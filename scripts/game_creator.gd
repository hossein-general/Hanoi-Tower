extends Node2D

signal rod_ring_count(rod_count: int, ring_count: int)

var rod_count: int = 3
var ring_count: int = 5

func _ready():
	hide()
	rod_ring_count.emit(rod_count, ring_count)
