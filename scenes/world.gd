extends Node2D

@export var columns: int = 3
@export var visible_rows: int = 8
@export var starting_col: int
@export var starting_row: int
@export var block_types: Array[Block]

const TILE_SIZE: int = 32
var latest_row: int


func _ready():
	_generate_initial_map()
	latest_row = visible_rows


func _generate_initial_map() -> void:
	%GameGrid.clear()

	#Create blocks for visible rows
	for col in range(columns):
		for row in range(visible_rows):
			_generate_blocks(col + starting_col, row + starting_row)


func _generate_blocks(col: int, row: int) -> void:
	var block_coord = _get_random_block_coord()
	%GameGrid.set_cell(Vector2i(col, row), 0, block_coord)


func _add_new_row() -> void:
	latest_row += 1
	# Create new blocks based on the latest row number
	for col in range(columns):
		_generate_blocks(col + starting_col, latest_row)


func _on_player_drilled_block_at_position(position_to_drill: Vector2) -> void:
	# Get coords in tileset for the position drilled
	var block_coords = %GameGrid.local_to_map(position_to_drill)

	# Get value of the drilled block
	var drilled_block_data = _get_block_data_by_coords(block_coords)

	# Erase block
	if %GameGrid.get_cell_source_id(block_coords) != -1:
		%GameGrid.erase_cell(block_coords)
		#for col in range(starting_col, starting_col + columns):
			#%GameGrid.erase_cell(Vector2i(col, block_coords.y))

	# Create new row to make it infinite
	_add_new_row()


func _get_random_block_coord() -> Vector2i:
	var random_number = randf() # Returns a random float between 0.0 and 1.0
	
	var cumulative_chance = 0.0
	for block in block_types:
		cumulative_chance += block.drop_chance
		if random_number <= cumulative_chance:
			return block.tile_coords
			
	return block_types.front().tile_coords # Fallback


func _get_block_data_by_coords(coords: Vector2i) -> Block:
	var tile_data: TileData = %GameGrid.get_cell_tile_data(coords)
	if tile_data:
		var block_type: String = tile_data.get_custom_data("Type")
		for block in block_types:
			if block.name == block_type:
				return block
	return block_types.front()
