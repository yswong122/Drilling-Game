extends Node2D

@onready var hud: Control = $UILayer/HUD
@onready var drill_sfx: AudioStreamPlayer = $DrillSFX


const DRILL_PARTICLES = preload("uid://dts7kpjjdblk2")


func _ready() -> void:
	## Set fuel and score to starting value if game not started, reset starting fuel if new level.
	if GameData.game_started:
		GameData.set_fuel()
	else:
		GameData.init()

	%GameGrid.generate_initial_blocks()


func _process(delta: float) -> void:
	if GameData.game_started:
		GameData.reduce_idle_fuel(delta)

	if GameData.is_run_out_of_fuel():
		_finish_level()

	hud.update_labels()


func _on_player_drill_block_at_position(position_to_drill: Vector2) -> void:

	var drilled_block_value: int = %GameGrid.drill_position(position_to_drill)

	if drilled_block_value:
		GameData.level_start()
		%Player.update_position(position_to_drill)
		GameData.increase_score(drilled_block_value)
		GameData.reduce_drilling_fuel()

		# TODO: separate drill particle manager
		_spawn_drill_particles(%GameGrid.get_block_coords(position_to_drill))

		# TODO: separate drill sfx manager
		drill_sfx.pitch_scale = randf_range(0.5,1)
		drill_sfx.play()

	if GameData.is_run_out_of_fuel():
		_finish_level()

	%GameGrid.add_new_row()


func _finish_level():
	set_process(false)
	if GameData.is_over_threshold():
		_next_level()
	else:
		_game_over()
	return


func _next_level() -> void:
	GameData.level_over()
	get_tree().change_scene_to_file("res://scenes/shop.tscn")


func _game_over() -> void:
	GameData.game_over()
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")


func _spawn_drill_particles(grid_coords: Vector2i) -> void:
	var particles = DRILL_PARTICLES.instantiate()
	particles.global_position = %GameGrid.map_to_local(grid_coords)
	add_child(particles)
	particles.emitting = true
	particles.finished.connect(particles.queue_free)
