extends Node

const _UpgradablesRegistry = preload("uid://caqup8tg708b4")

var upgradables: Dictionary = {}


func _ready() -> void:
	# get information in blocks.tres and store in _block_types
	for upgradable in _UpgradablesRegistry.upgradables:
		print(upgradable.name)
		upgradables[upgradable.name] = upgradable


func get_cost(upgrade_name: String) -> int:
	if upgradables.has(upgrade_name):
		return upgradables[upgrade_name].get_current_cost()
	else:
		return 0


func get_value(upgrade_name: String) -> int:
	print(upgradables)
	if upgradables.has(upgrade_name):
		return upgradables[upgrade_name].get_total_value()
	else:
		return 0


func upgrade(upgrade_name: String) -> void:
	if upgradables.has(upgrade_name):
		upgradables[upgrade_name].upgrade()


func reset() -> void:
	for upgradable in _UpgradablesRegistry.upgradables:
		upgradable.reset()
