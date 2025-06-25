@tool
extends Node


@export var generate_room: bool:
	set = _set_generate_room
@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@export var max_room_size := Vector2i(27, 21)
@export var square_min_size := 3
@export var square_max_size := 10


func _ready() -> void:
	pass


## generates a room
func handle_generate_room() -> void:
	tile_map_layer.clear()
	
	var square_count := randi_range(2, 5)
	var squares: Array[Square]
	for i in range(square_count):
		var top_left := get_random_square_position(squares)
		var bottom_right := Vector2i(
				top_left.x + randi_range(square_min_size, square_max_size),
				top_left.y + randi_range(square_min_size, square_max_size)
		)
		var square := Square.new(top_left, bottom_right)
		squares.append(square)
		tile_square(square)


## returns random position to start a new square from within an existing square
func get_random_square_position(squares: Array[Square]) -> Vector2i:
	if squares.size() == 0:
		return Vector2i(0, 0)
	var square := squares[randi_range(0, squares.size() - 1)]
	return Vector2i(
			randi_range(square.top_left.x, square.bottom_right.x),
			randi_range(square.top_left.y, square.bottom_right.y)
	)


## adds square to tile map
func tile_square(square: Square) -> void:
	for x in range(square.top_left.x, square.bottom_right.x + 1):
		for y in range(square.top_left.y, square.bottom_right.y +1):
			tile_map_layer.set_cell(Vector2i(x, y), 1, Vector2i(1, 1))
			print("set tile: %s" % Vector2i(x, y))


func _set_generate_room(value: bool) -> void:
	if value:
		handle_generate_room()
	generate_room = false


## its a square
class Square:
	var top_left: Vector2i
	var bottom_right: Vector2i
	
	func _init(top_left: Vector2i, bottom_right: Vector2i) -> void:
		self.top_left = top_left
		self.bottom_right = bottom_right
