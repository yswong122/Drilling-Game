extends Control

@onready var fuel_label: Label = $TopBar/FuelLabel
@onready var score_label: Label = $TopBar/ScoreLabel


func _update_fuel_label() -> void:
	fuel_label.text = "Fuel: " + str(int(GameData.current_fuel))


func _update_score_label() -> void:
	score_label.text = "Score: " + str(GameData.current_score)


func update_labels() -> void:
	_update_fuel_label()
	_update_score_label()
