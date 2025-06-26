class_name Menu extends Control


func _on_play_button_down() -> void:
	Global.play_cutscene()


func _on_options_button_down() -> void:
	pass # Replace with function body.


func _on_quit_button_down() -> void:
	get_tree().quit()
