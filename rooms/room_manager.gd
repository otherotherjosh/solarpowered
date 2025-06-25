class_name RoomManager extends Node2D


var rooms := {}
var room_curr: Room
var directions: Array[Vector2i] = [Vector2i.UP, Vector2i.LEFT, Vector2i.DOWN, Vector2i.RIGHT]

@onready var room_generator: RoomGenerator = $RoomGenerator


func _ready():
	# generate spawn room
	rooms[Vector2i.ZERO] = room_generator.generate_room(Vector2i.ZERO, [1, 0, 0, 0])
	# room above, with exits on all sides
	rooms[Vector2i.UP] = room_generator.generate_room(Vector2i.UP, [1, 1, 1, 1])
	
	enter_room(rooms[Vector2i.ZERO])


## looks for room at coords and generates if needed
func enter_room_at_coords(coords: Vector2i) -> void:
	if !rooms[coords]:
		rooms[coords] = room_generator.generate_room(coords)
	enter_room(rooms[coords])


## unloads room and loads new room
func enter_room(room_next: Room) -> void:
	#var direction
	room_generator.remove_child(room_curr)
