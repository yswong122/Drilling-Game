extends Node2D

@onready var hud: Control = $UILayer/HUD
@onready var drill_sfx: AudioStreamPlayer = $DrillSFX

const DRILL_PARTICLES = preload("uid://dts7kpjjdblk2")


func _ready() -> void:
	GameData.reset()
	%GameGrid.generate_initial_blocks()


func _process(delta: float) -> void:
	if GameData.is_game_started():
		GameData.reduce_idle_fuel(delta)

	if GameData.is_run_out_of_fuel():
		_game_over()

	hud.update_labels()


func _on_player_drill_block_at_position(position_to_drill: Vector2) -> void:
	var drilled_block_value: int = %GameGrid.drill_position(position_to_drill)

	if drilled_block_value:
		%Player.update_position(position_to_drill)
		GameData.increase_score(drilled_block_value)
		GameData.reduce_drilling_fuel()
		_spawn_drill_particles(%GameGrid.get_block_coords(position_to_drill))
		drill_sfx.play()

	if GameData.is_run_out_of_fuel():
		_game_over()

	%GameGrid.add_new_row()


func _game_over() -> void:
	GameData.game_over()
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")


func _spawn_drill_particles(grid_coords: Vector2i) -> void:
	var particles = DRILL_PARTICLES.instantiate()
	particles.global_position = %GameGrid.map_to_local(grid_coords)
	add_child(particles)
	particles.emitting = true
	particles.finished.connect(particles.queue_free)
