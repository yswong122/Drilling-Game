extends Node


const _BLOCK_REGISTRY: BlockRegistry = preload("uid://4c3eavh4wjx1")
var _block_types: Dictionary = {}


func _ready() -> void:
	for block in _BLOCK_REGISTRY.blocks:
		_block_types[block.name] = block


func get_random_block_coord() -> Vector2i:
	# get the random block and return the tile_coordinates of the block
	var random_number = randf()
	var cumulative_chance = 0.0

	if _block_types.is_empty():
		return Vector2i.ZERO

	for block in _block_types.values():
		cumulative_chance += block.drop_chance
		if random_number <= cumulative_chance:
			return block.tile_coords

	return _block_types.values()[0].tile_coords


func _get_block_data(block_name: String) -> Block:
	if _block_types.get(block_name):
			return _block_types[block_name]
	return _block_types.values()[0]
