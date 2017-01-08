extends Camera2D

export(Vector2) var size

func _ready():
	get_viewport().connect("size_changed", self, "_on_resize")
	_on_resize()

func _on_resize():
	var screen = size
	if screen == null:
		if not get_parent() extends Control:
			return
		screen = get_parent().get_rect().size
		set_global_pos(get_parent().get_global_rect().pos + screen / 2)
	var scale = screen / get_viewport_rect().size
	if scale.x > scale.y:
		scale.y = scale.x
	else:
		scale.x = scale.y
	set_zoom(scale)
