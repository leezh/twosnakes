extends Control

export var active = false

onready var players = [get_node("left"), get_node("right")]
onready var countdown = get_node("countdown/anim")

var wins = {}
var limits = Vector2(7, 5)
var timer = 0.0
var speed = 5.0

func _ready():
	set_process(true)
	set_process_input(true)
	for player in players:
		wins[player] = 0
		player.show_wins(0)
	reset()

func _process(delta):
	if active:
		timer += delta
		var tick = 1.0 / speed
		while timer >= tick and active:
			timer -= tick
			step()
		for player in players:
			player.tween(timer * speed)

func _input(event):
	if active:
		if event.is_action_pressed("ui_up_0"):
			players[0].push_input(Vector2(0, -1))
		elif event.is_action_pressed("ui_down_0"):
			players[0].push_input(Vector2(0, 1))
		elif event.is_action_pressed("ui_left_0"):
			players[0].push_input(Vector2(-1, 0))
		elif event.is_action_pressed("ui_right_0"):
			players[0].push_input(Vector2(1, 0))

		if event.is_action_pressed("ui_up_1"):
			players[1].push_input(Vector2(0, -1))
		elif event.is_action_pressed("ui_down_1"):
			players[1].push_input(Vector2(0, 1))
		elif event.is_action_pressed("ui_left_1"):
			players[1].push_input(Vector2(-1, 0))
		elif event.is_action_pressed("ui_right_1"):
			players[1].push_input(Vector2(1, 0))
	elif event.is_action_pressed("ui_accept"):
		if not countdown.is_playing():
			reset()
			countdown.play("start")

func reset():
	timer = 0.0
	speed = 5.0
	for player in players:
		player.reset()
		player.set_top("")

func update_wins():
	for player in players:
		player.show_wins(wins[player])

func step():
	var deaths = 0
	var highscore = 0
	var winner = -1
	for p in range(players.size()):
		var player = players[p]
		player.step()
		if player.score > highscore:
			highscore = player.score
			winner = p
		elif player.score == highscore:
			winner = -1
		if not player.active:
			deaths += 1
	if deaths == 2:
		active = false
		timer = 0.0
		if winner != -1:
			var player = players[winner]
			wins[player] += 1
			player.set_top(tr("Winner!"))
			update_wins()
	elif deaths == 1 and winner != -1 and players[winner].active:
		var player = players[winner]
		wins[player] += 1
		player.set_top(tr("Winner!"))
		active = false
		timer = 0.0
		update_wins()
	elif players[0].eating or players[1].eating:
		var positions = []
		for x in range(-limits.x, limits.x + 1):
			for y in range(-limits.y, limits.y + 1):
				positions.push_back(Vector2(x, y))
		for player in players:
			for pos in player.body:
				if positions.has(pos):
					positions.erase(pos)
		if positions.size() > 0:
			var food_pos = positions[randi() % positions.size()]
			for player in players:
				player.set_food_pos(food_pos)
		speed += 0.1
	speed += 0.01
