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
		clear_room = true
		room_generator.generate_room([1, 1, 1, 1])


func _set_clear_room(value: bool) -> void:
	clear_room = false
	if not room_generator:
		print("room generator not found!")
		return
	for child in room_generator.get_children():
		child.queue_free()
