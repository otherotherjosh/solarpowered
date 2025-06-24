extends Node2D

@export var rooms: Array[PackedScene] = []

var last_room_position := Vector2.ZERO
var room_offset := Vector2(40, 0)

func _ready():
	generate_rooms(1)
	
func generate_rooms(count: int):
	for i in count:
		var room_scene = rooms.pick_random()
		var room_instance = room_scene.instantiate()
		room_instance.position = last_room_position
		add_child(room_instance)
		last_room_position += room_offset
