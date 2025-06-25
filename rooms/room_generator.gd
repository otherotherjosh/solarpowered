@tool
extends Node2D


const TOP_LEFT_TILE := Vector2i(0, 0)
const TOP_CENTER_TILE := Vector2i(1, 0)
const TOP_RIGHT_TILE := Vector2i(2, 0)
const MIDDLE_LEFT_TILE := Vector2i(0, 1)
const MIDDLE_CENTER_TILE := Vector2i(1, 1)
const MIDDLE_RIGHT_TILE := Vector2i(2, 1)
const BOTTOM_LEFT_TILE := Vector2i(0, 2)
const BOTTOM_CENTER_TILE := Vector2i(1, 2)
const BOTTOM_RIGHT_TILE := Vector2i(2, 2)

@export var generate_room: bool:
	set = _set_generate_room
@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@export var max_room_size := Vector2i(27, 21)
@export var square_min_size := 3
@export var square_max_size := 10


## generates a room
func handle_generate_room() -> void:
	tile_map_layer.clear()
	
	var square_count := randi_range(5, 10)
	var squares: Array[Square]
	for i in range(square_count):
		var size := Vector2i(
				randi_range(square_min_size, square_max_size),
				randi_range(square_min_size, square_max_size)
		)
		var top_left := get_random_square_position(squares, size)
		var bottom_right := top_left + size
		var square := Square.new(top_left, bottom_right)
		squares.append(square)
		tile_square(square)


## returns random position to start a new square from within an existing square
func get_random_square_position(squares: Array[Square], size: Vector2i) -> Vector2i:
	if squares.size() == 0:
		return Vector2i(0, 0)
	var square := squares[randi_range(2, squares.size() - 3)]
	var offset_x: int = randi_range(0, 1) * -size.x
	var offset_y: int = randi_range(0, 1) * -size.y
	return Vector2i(
			randi_range(square.top_left.x, square.bottom_right.x) + offset_x,
			randi_range(square.top_left.y, square.bottom_right.y) + offset_y
	)


## adds square to tile map
func tile_square(square: Square) -> void:
	for x in range(square.top_left.x, square.bottom_right.x + 1):
		for y in range(square.top_left.y, square.bottom_right.y + 1):
			var coords := Vector2i(x, y)
			var atlas_coords := get_tilemap_atlas_coords(coords, square)
			tile_map_layer.set_cell(coords, 1, atlas_coords)
			

## returns the tile atlas coords for a cell based on the cells around it
func get_tilemap_atlas_coords(coords: Vector2i, square: Square) -> Vector2i:
	#if (
			#coords.x > square.top_left.x and coords.x < square.bottom_right.x and
			#coords.y > square.top_left.y and coords.y < square.bottom_right.y
	#): # set all non border tiles to floor type
		#return MIDDLE_CENTER_TILE
	
	# handle left hand side
	#if coords.x == square.top_left.x
	
	return MIDDLE_CENTER_TILE
				


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
