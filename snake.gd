extends Node2D

var Tile = load("res://tile.tscn")

var body = []
var color_1 = Color(0.23, 0.49, 0.35)
var color_2 = Color(0.19, 0.41, 0.31)

func push_front(pos):
	var prev_pos
	if body.size() > 0:
		var prev = body.front()
		prev_pos = prev.pos
		prev.set_next(pos)
	var tile = Tile.instance()
	body.push_front(tile)
	add_child(tile)
	tile.reset(pos, prev_pos)
	tile.set_color(color_1, color_2)

func pop_back():
	body.back().free()
	body.pop_back()

func sync_data(data):
	for tile in body:
		tile.free()
	body.clear()
	for i in range(data.size() - 1, -1, -1):
		push_front(data[i])

func tween(tween, growing):
	for i in range(body.size()):
		body[i].update_tile(tween, i, body.size(), growing)
