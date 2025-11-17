extends Node2D

@onready var score_label = $Control/ScoreLabel


func _ready() -> void:
	var final_score = GameData.current_score
	score_label.text = "Final Score: " + str(final_score)


func _on_restart_button_pressed() -> void:
	GameData.reset()
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
