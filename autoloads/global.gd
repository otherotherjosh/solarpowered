extends Node
## Handles loading of scenes and pausing and things


enum State {
	MAIN_MENU,
	PAUSED,
	PLAYING,
}

signal on_state_changed(new_state: State)

const ROOMS_SCENE := "res://rooms/rooms.tscn"
const MENU_SCENE := "res://menus/menu.tscn"
const PAUSE_SCENE := "res://menus/pause.tscn"

var state: State:
	set = _set_state


func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	main_menu()
	
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		handle_ui_cancel()


## what to do when player presses ESC
func handle_ui_cancel() -> void:
	match state:
		State.PAUSED:
			state = State.PLAYING
		State.PLAYING:
			state = State.PAUSED


func play_level() -> void:
	get_tree().change_scene_to_file(ROOMS_SCENE)
	state = State.PLAYING
	

func main_menu() -> void:
	get_tree().change_scene_to_file(MENU_SCENE)
	state = State.MAIN_MENU


func pause() -> void:
	state = State.PAUSED


func _set_state(value: State) -> void:
	if state == value:
		return
	state = value
	on_state_changed.emit(state)
