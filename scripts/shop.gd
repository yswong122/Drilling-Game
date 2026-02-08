extends Node2D

@onready var _currency_label: Label = $Control/VBoxContainer/CurrencyLabel
@onready var _fuel_upgrade_button: Button = $Control/VBoxContainer/UpgradeContainer/FuelUpgradeButton
@onready var _restart_button: Button = $Control/VBoxContainer/UpgradeContainer/RestartButton


func _ready():
	_update_ui()
	# Connect signals from the buttons
	_fuel_upgrade_button.pressed.connect(_on_fuel_upgrade_button_pressed)
	_restart_button.pressed.connect(_on_restart_button_pressed)


func _update_ui():	
	var max_fuel_upgrade_cost = UpgradeManager.get_cost("Fuel")

	_currency_label.text = "Currency (Score): " + str(GameData.current_score)

	_fuel_upgrade_button.text = "Max Fuel: " + str(UpgradeManager.get_value("Fuel")) + \
							   " (Cost: " + str(max_fuel_upgrade_cost) + ")"

	_fuel_upgrade_button.disabled = GameData.current_score < max_fuel_upgrade_cost


func _on_fuel_upgrade_button_pressed():
	var upgrade_cost = UpgradeManager.get_cost("Fuel")
	if GameData.enough_money(upgrade_cost):
		UpgradeManager.upgrade("Fuel")
		_update_ui()
	pass


func _on_restart_button_pressed():
	GameData.current_level += 1
	get_tree().change_scene_to_file("res://scenes/world.tscn")
