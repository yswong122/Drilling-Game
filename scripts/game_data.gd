extends Node

var _original_score: int = 0
var _original_fuel: float = 100.0

var current_score: int
var current_fuel: float

var _game_started = false

var _drilling_fuel_rate: float = 1.0
var _idle_fuel_rate: float = 1.5


func reset() -> void:
	current_score = _original_score
	current_fuel = _original_fuel
	_game_started = false


func increase_score(amount: int) -> void:
	current_score += amount


func reduce_drilling_fuel() -> void:
	reduce_fuel_by_rate(_drilling_fuel_rate)


func reduce_idle_fuel(delta: float) -> void:
	reduce_fuel_by_rate(delta * _idle_fuel_rate)


func reduce_fuel_by_rate(rate: float) -> void:
	current_fuel -= rate
	if current_fuel < 0:
		current_fuel = 0

func is_game_started() -> bool:
	return _game_started


func game_start() -> void:
	if !_game_started:
		_game_started = true


func game_over() -> void:
	_game_started = false


func is_run_out_of_fuel() -> bool:
	return current_fuel == 0
