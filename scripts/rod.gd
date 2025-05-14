extends Node2D

var ring_stack: Array = []
var mouse_in: bool = false
var ring_count: int

func _ready() -> void:
	scale *= Vector2(1, ring_count)


func  _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Click") and mouse_in:
		print("on-click")


func _on_area_2d_mouse_entered() -> void:
	mouse_in = true


func _on_area_2d_mouse_exited() -> void:
	mouse_in = false
