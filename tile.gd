extends Node2D

onready var center = get_node("center")
onready var edges_in = [get_node("in_x"), get_node("in_y")]
onready var edges_out = [get_node("out_x"), get_node("out_y")]

const EDGE_X = 0
const EDGE_Y = 1

var edge_in = EDGE_X
var edge_out = EDGE_X
var pos
var scale

func reset(pos, prev):
	self.pos = pos
	set_pos(pos * 10)
	scale = Vector2(1, 1)
	if prev != null:
		var dir = pos - prev
		if dir.x == 0:
			edge_in = EDGE_Y
			scale.y = dir.y
		else:
			edge_in = EDGE_X
			scale.x = dir.x
	edges_in[edge_in].show()
	edges_in[(edge_in + 1) % 2].hide()
	edges_out[0].hide()
	edges_out[1].hide()
	set_scale(scale)

func set_color(color_1, color_2):
	center.set_color(color_1)
	for edge in edges_in:
		edge.set_color(color_2)
	for edge in edges_out:
		edge.set_color(color_2)

func set_next(next):
	var dir = next - pos
	if dir.x == 0:
		edge_out = EDGE_Y
		scale.y = dir.y
	else:
		edge_out = EDGE_X
		scale.x = dir.x
	edges_out[edge_out].show()
	edges_out[(edge_out + 1) % 2].hide()
	set_scale(scale)

func update_tile(tween, index, length, growing=true):
	var reverse = false
	var scale_center = Vector2(1, 1)
	var scale_in = Vector2(1, 1)
	var scale_out = Vector2(1, 1)
	if index == 0:
		scale_center[edge_in] = clamp((tween - 0.2) / 0.8, 0, 1)
		scale_in[edge_in] = clamp((tween - 0.1) * 10, 0, 1)
		scale_out[edge_out] = 0
	elif index == 1:
		scale_out[edge_out] = clamp(tween * 10, 0, 1)
	elif not growing and index == length - 2:
		scale_in[edge_in] = clamp((1 - tween) * 10, 0, 1)
		reverse = true
	elif not growing and index == length - 1:
		scale_center[edge_out] = 1.0 - clamp(tween / 0.8, 0, 1)
		scale_out[edge_out] = clamp((0.9 - tween) * 10, 0, 1)
		scale_in[edge_in] = 0
		reverse = true
	elif growing and index == length - 1:
		scale_in[edge_in] = 0
		reverse = true
	center.set_scale(scale_center)
	if not reverse:
		edges_in[edge_in].set_scale(scale_in)
		edges_out[edge_out].set_scale(scale_out)
	else:
		edges_in[edge_out].show()
		edges_in[edge_out].set_scale(scale_out)
		edges_in[(edge_out + 1) % 2].hide()
		edges_out[edge_in].show()
		edges_out[edge_in].set_scale(scale_in)
		edges_out[(edge_in + 1) % 2].hide()
		set_scale(scale * -1)
