extends Control

@onready var fuel_label: Label = $TopBar/FuelLabel
@onready var score_label: Label = $TopBar/ScoreLabel

func update_fuel_label() -> void:
	fuel_label.text = "Fuel: " + str(int(GameData.current_fuel))

func update_score_label() -> void:
	score_label.text = "Score: " + str(int(GameData.current_score))
