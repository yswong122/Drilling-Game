extends CharacterBody2D

@export var middle_x_position: float

signal drilled_block_at_position(position_to_drill: Vector2)

const TILE_SIZE: int = 32
var new_x_position: float

func _ready() -> void:
	position.x = middle_x_position

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		match event.keycode:
			KEY_LEFT, KEY_A:
				new_x_position = middle_x_position - TILE_SIZE
			KEY_RIGHT, KEY_D:
				new_x_position = middle_x_position + TILE_SIZE
			KEY_DOWN, KEY_W:
				new_x_position = middle_x_position
			_:
				return

		_attempt_move(new_x_position)

func _attempt_move(move_x_position: float) -> void:
	var drill_position = position + Vector2(0, TILE_SIZE)
	drill_position.x = move_x_position

	emit_signal("drilled_block_at_position", drill_position)

	_update_position(drill_position)

func _update_position(drill_position: Vector2i) -> void:
	position = drill_position
