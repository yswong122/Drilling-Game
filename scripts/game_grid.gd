extends TileMapLayer
## Handle Logics of GameGrid 

const TILE_SIZE: int = 32
const COLUMNS: int = 3

# Column and Row number in GameGrid
var _starting_col: int = 1
var _starting_row: int = 3

var _visible_rows: int = 8
var _fade_out_distance: int = 4

var _latest_row: int

var middle_x_position: float = 80


func _generate_block(col: int, row: int) -> void:
## Set random block in GameGrid
	var block_coord = BlockManager.get_random_block_coord()
	set_cell(Vector2i(col, row), 0, block_coord)


func generate_initial_blocks() -> void:
## Generate initial rows of blocks
	clear()
	#Create blocks for visible rows
	for col in range(COLUMNS):
		for row in range(_visible_rows):
			_generate_block(col + _starting_col, row + _starting_row)

	# Set the latest row number to current visible rows
	_latest_row = _visible_rows


func add_new_row() -> void:
	## Create new rows of blocks
	_latest_row += 1
	# Create new blocks based on the latest row number
	for col in range(COLUMNS):
		_generate_block(col + _starting_col, _latest_row)


func _erase_block(block_coords: Vector2i) -> void:
	if get_cell_source_id(block_coords) != -1:
		erase_cell(block_coords)

		# TODO: Fade out blocks intead
		for col in range(_starting_col, _starting_col + COLUMNS):
			erase_cell(Vector2i(col, block_coords.y - _fade_out_distance))


func get_player_x_positions() -> Array[float]:
## Provide x positions for player to be when drilling left mid and right
	return [
		middle_x_position - TILE_SIZE,
		middle_x_position,
		middle_x_position + TILE_SIZE,
	]


func _get_block_data_by_coords(coords: Vector2i) -> Block:
## Get the block name from GameGrid then get related block data in block manager
	var tile_data: TileData = get_cell_tile_data(coords)
	var block_name: String
	if tile_data:
		block_name= tile_data.get_custom_data("Type")
	return BlockManager._get_block_data(block_name)


func _get_block_value_by_coords(coords: Vector2i) -> int:
	var tile_data: TileData = get_cell_tile_data(coords)

	var block_name: String
	if tile_data:
		block_name= tile_data.get_custom_data("Type")
	return BlockManager.get_block_value(block_name)


func drill_position(position_to_drill: Vector2) -> int:
## Translate local drilling position to map position in GameGrid,
## erase block and return the base value (score) of the drilled block

	# Get coords in tileset for the position drilled
	var block_coords: Vector2i = local_to_map(position_to_drill)
	var block_value = _get_block_value_by_coords(block_coords)
	_erase_block(block_coords)

	# Get data of the drilled block
	return block_value


func get_block_coords(position_to_drill: Vector2) -> Vector2i:
	return local_to_map(position_to_drill)
