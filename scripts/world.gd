extends Node2D


@export var columns: int = 3
@export var visible_rows: int = 8

@export var block_types: Array[Block]
@export var max_fuel: float
@export var fuel_rate: float
@export var idle_fuel_rate: float

const TILE_SIZE: int = 32
var latest_row: int
var game_started = false
var starting_col: int = 1
var starting_row: int = 3

@onready var hud: Control = $UILayer/HUD
const DRILL_PARTICLES = preload("uid://dts7kpjjdblk2")
@onready var drill_sfx: AudioStreamPlayer = $DrillSFX

func _ready():
	_generate_initial_map()
	latest_row = visible_rows
	GameData.current_fuel = max_fuel
	game_started = false


func _physics_process(delta: float) -> void:
	if game_started == true:
		GameData.current_fuel -= idle_fuel_rate * delta

	hud.update_fuel_label()
	hud.update_score_label()

	if GameData.current_fuel <= 0:
		_run_out_of_fuel()

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
	# Get data of the drilled block
	var drilled_block_data = _get_block_data_by_coords(block_coords)

	# Erase block
	if %GameGrid.get_cell_source_id(block_coords) != -1:
		if !game_started:
			game_started = true
		%GameGrid.erase_cell(block_coords)
		
		drill_sfx.play()

		# TODO: Fade out blocks intead
		for col in range(starting_col, starting_col + columns):
			%GameGrid.erase_cell(Vector2i(col, block_coords.y - 4))

	# Increase score
	GameData.current_score += drilled_block_data.value
	
	_spawn_drill_particles(block_coords)

	# Reduce fuel
	GameData.current_fuel -= fuel_rate

	if GameData.current_fuel <= 0:
		_run_out_of_fuel()

	# Create new row to make it infinite
	_add_new_row()


func _get_random_block_coord() -> Vector2i:
	var random_number = randf()
	
	var cumulative_chance = 0.0
	for block in block_types:
		cumulative_chance += block.drop_chance
		if random_number <= cumulative_chance:
			return block.tile_coords
			
	return block_types.front().tile_coords


func _get_block_data_by_coords(coords: Vector2i) -> Block:
	var tile_data: TileData = %GameGrid.get_cell_tile_data(coords)
	if tile_data:
		var block_type: String = tile_data.get_custom_data("Type")
		for block in block_types:
			if block.name == block_type:
				return block
	return block_types.front()


func _run_out_of_fuel() -> void:
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func _spawn_drill_particles(grid_coords: Vector2i):
	var particles = DRILL_PARTICLES.instantiate()
	particles.global_position = %GameGrid.map_to_local(grid_coords)
	add_child(particles)
	particles.emitting = true
	particles.finished.connect(particles.queue_free)
