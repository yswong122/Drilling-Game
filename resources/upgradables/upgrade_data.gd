extends Resource
class_name UpgradeData

@export var name: String = "Upgrade"
@export var base_cost: int = 100
@export var cost_multiplier: float = 1.5
@export var base_value: float = 50.0
@export var value_increment: float = 10.0

var current_level: int = 0


func get_current_cost() -> int:
	return int(base_cost * pow(cost_multiplier, current_level))


func get_total_value() -> float:
	return base_value + (current_level * value_increment)


func upgrade() -> void:
	current_level += 1


func reset() -> void:
	current_level = 1
