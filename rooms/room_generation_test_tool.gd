@tool
extends Node


@export var generate_room: bool:
	set = _set_generate_room
@export var clear_room: bool:
	set = _set_clear_room
@export var room_generator: RoomGenerator


func _set_generate_room(value: bool) -> void:
	generate_room = false
	if not room_generator:
		print("room generator not found!")
		return
	if value:
		room_generator.generate_room()


func _set_clear_room(value: bool) -> void:
	clear_room = false
	if not room_generator:
		print("room generator not found!")
		return
	if value:
		room_generator.tile_map_layer.clear()
