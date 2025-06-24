extends Menu


func _ready() -> void:
	Global.on_state_changed.connect(handle_global_state_changed)


func _on_options_button_down() -> void:
	pass # Replace with function body.


func _on_quit_button_down() -> void:
	Global.main_menu()


func handle_global_state_changed(state: Global.State) -> void:
	visible = state == Global.State.PAUSED
