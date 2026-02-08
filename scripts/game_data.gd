extends Node

var _starting_score: int = 0
var _starting_fuel: float = 10.0

var current_score: int
var current_fuel: float

## Start of the game
var game_started = false
## Start of the level
var level_started = false

var _drilling_fuel_rate: float = 1.0
var _idle_fuel_rate: float = 1.5

var _starting_level_up_score_threshold: int = 1
var _level_up_score_threshold: int
var current_level: int = 0


func init() -> void:
##	initialise the entire game from start
	game_start()

	current_score = _starting_score
	current_fuel = _starting_fuel
	_level_up_score_threshold = _starting_level_up_score_threshold


## Game and Level functions


func game_start() -> void:
	if game_started == false:
		game_started = true


func level_start() -> void:
	if level_started == false:
		level_started = true


func game_over() -> void:
	level_over()
	game_started = false


func level_over() -> void:
	level_started = false


func reset() -> void:
	game_over()


func set_fuel() -> void:
##	reset the fuel
	current_fuel = UpgradeManager.get_value("Fuel")


func is_run_out_of_fuel() -> bool:
	return current_fuel <= 0


## Score and score thresholds


func increase_score(amount: int) -> void:
	current_score += amount


func is_over_threshold() -> bool:
	return current_score >= _level_up_score_threshold * pow(1.8, current_level)


## Fuel reduce functions


func reduce_drilling_fuel() -> void:
	reduce_fuel_by_rate(_drilling_fuel_rate)


func reduce_idle_fuel(delta: float) -> void:
	reduce_fuel_by_rate(delta * _idle_fuel_rate)


func reduce_fuel_by_rate(rate: float) -> void:
	current_fuel -= rate
	if current_fuel < 0:
		current_fuel = 0


## Upgrade functions

func enough_money(cost: int) -> bool:
	return current_score >= cost
