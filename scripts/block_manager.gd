extends Node
## Link between BlockRegistry and Game_tile_set

## Preset storage of blocks
const _BLOCK_REGISTRY: BlockRegistry = preload("uid://4c3eavh4wjx1")
## Block storage on the run
var _block_types: Dictionary = {}


func _ready() -> void:
	# get information in blocks.tres and store in _block_types
	for block in _BLOCK_REGISTRY.blocks:
		_block_types[block.name] = block


func get_random_block_coord() -> Vector2i:
## get the random block in _block_types and return the tile_coordinates of the block in tile set

	var random_number = randf()
	var cumulative_chance = 0.0

	if _block_types.is_empty():
		return Vector2i.ZERO

	## chance of blocks in _block_types must be in descending order
	for block in _block_types.values():
		cumulative_chance += block.drop_chance
		if random_number <= cumulative_chance:
			return block.tile_coords

	return _block_types.values()[0].tile_coords


func get_block_data(block_name: String) -> Block:
	return _block_types.get(block_name)


func get_block_value(block_name: String) -> int:
	var block = _block_types.get(block_name)
	if block:
		return block.value
	push_error("Block not found")
	return 0
