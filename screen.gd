extends Node2D

onready var score_label = get_node("score")
onready var bottom_label = get_node("bottom")
onready var top_label = get_node("top")
onready var snake = get_node("snake")
onready var ghost = get_node("ghost")
onready var food = get_node("food")
onready var overlay = get_node("overlay")

export(NodePath) var mirror
export var color_1 = Color(0.23, 0.49, 0.35)
export var color_2 = Color(0.19, 0.41, 0.31)

var body = []
var head = Vector2(0, 0)
var food_pos = Vector2(0, 0)
var limits = Vector2(7, 5)
var active = true
var eating = false
var inputs = []
var score = 0
var mirror_node

func reset():
	snake.color_1 = color_1
	snake.color_2 = color_2
	active = true
	eating = false
	score = 0
	food_pos = Vector2(0, 0)
	food.set_pos(food_pos * 10)
	food.show()
	inputs.clear()
	body.clear()
	for x in range(3, -5, -1):
		body.push_back(Vector2(x, 3))
	head = body[0]
	snake.sync_data(body)
	overlay.hide()
	mirror_node = null
	if mirror and has_node(mirror):
		var bg = get_color()
		bg.a = 0.7
		mirror_node = get_node(mirror).ghost
		mirror_node.color_1 = color_1.blend(bg)
		mirror_node.color_2 = color_2.blend(bg)
		mirror_node.sync_data(body)
	tween(0.0)
	update_score()

func push_input(dir):
	if active:
		inputs.push_back(dir)

func set_food_pos(pos):
	food_pos = pos
	food.set_pos(food_pos * 10)

func update_score():
	score_label.set_text(tr("Score: {}").replace("{}", str(score)))

func show_wins(val):
	bottom_label.set_text(tr("Wins: {}").replace("{}", str(val)))

func show_highscore(val):
	bottom_label.set_text(tr("Highscore: {}").replace("{}", str(val)))

func set_top(text):
	top_label.set_text(text)

func step():
	if not active:
		eating = false
		return
	if not eating:
		body.pop_back()
	eating = false
	if head == food_pos:
		eating = true
		score += 1
		update_score()
	head = body[0] * 2 - body[1]
	while inputs.size() > 0:
		var next = body[0] + inputs[0]
		inputs.pop_front()
		if next != body[1]:
			head = next
			break
	if abs(head.x) > limits.x or abs(head.y) > limits.y:
		active = false
	for pos in body:
		if head == pos:
			active = false
			break
	if not active:
		overlay.show()
	body.push_front(head)
	snake.sync_data(body)
	if mirror_node:
		mirror_node.sync_data(body)

func tween(tween):
	if not active:
		tween = 0
	snake.tween(tween, eating)
	if mirror_node:
		mirror_node.tween(tween, eating)
