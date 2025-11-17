extends CharacterBody2D

signal drill_block_at_position(position_to_drill: Vector2)

var x_positions: Array[float]

func _ready() -> void:
	x_positions = %GameGrid.get_player_x_positions()
	position.x = x_positions[1]


func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and not event.is_echo():
		if event.is_action_pressed("move_left"):
			_attempt_move("left")
		if event.is_action_pressed("move_right"):
			_attempt_move("right")
		if event.is_action_pressed("move_down"):
			_attempt_move("down")


func _attempt_move(direction: String) -> void:
	var attempt_drill_position: Vector2

	# Identify drill position 
	if direction == "left":
		attempt_drill_position.x = x_positions[0]
	if direction == "right":
		attempt_drill_position.x = x_positions[2]
	if direction == "down":
		attempt_drill_position.x = x_positions[1]

	attempt_drill_position.y = position.y + %GameGrid.TILE_SIZE

	emit_signal("drill_block_at_position", attempt_drill_position)


func update_position(drill_position: Vector2) -> void:
	position = drill_position
