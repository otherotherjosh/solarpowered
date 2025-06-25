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
	var square := squares[randi_range(0, squares.size() - 1)]
	var offset_x: int = randi_range(0, 1) * -size.x
	var offset_y: int = randi_range(0, 1) * -size.y
	return Vector2i(
			randi_range(square.top_left.x + 3, square.bottom_right.x - 3) + offset_x,
			randi_range(square.top_left.y + 3, square.bottom_right.y - 3) + offset_y
	)


## adds square to tile map
func tile_square(square: Square) -> void:
	for x in range(square.top_left.x, square.bottom_right.x + 1):
		for y in range(square.top_left.y, square.bottom_right.y + 1):
			var coords := Vector2i(x, y)
			var atlas_coords := set_cell_atlas_coords(x, y, square)
			tile_map_layer.set_cell(coords, 1, atlas_coords)
			

## returns the tile atlas coords for a cell based on the cells around it
func set_cell_atlas_coords(x: int, y: int, square: Square) -> Vector2i:
	# set all non border tiles to floor type
	if (x > square.top_left.x and x < square.bottom_right.x and
			y > square.top_left.y and y < square.bottom_right.y):
		return MIDDLE_CENTER_TILE
	
	# top, left, bottom, right
	var taken_cells_tlbr := [1, 1, 1, 1]
	
	if x == square.top_left.x:
		taken_cells_tlbr[1] = tile_map_layer.get_cell_atlas_coords(
				Vector2i(x - 1, y)) != Vector2i(-1, -1) as int
	if x == square.bottom_right.x:
		taken_cells_tlbr[3] = tile_map_layer.get_cell_atlas_coords(
				Vector2i(x + 1, y)) != Vector2i(-1, -1) as int
	if y == square.top_left.y:
		taken_cells_tlbr[0] = tile_map_layer.get_cell_atlas_coords(
				Vector2i(x, y - 1)) != Vector2i(-1, -1) as int
	if y == square.bottom_right.y:
		taken_cells_tlbr[2] = tile_map_layer.get_cell_atlas_coords(
				Vector2i(x, y + 1)) != Vector2i(-1, -1) as int
	
	match taken_cells_tlbr:
		[0, 0, 1, 1]:
			return TOP_LEFT_TILE
		[0, 1, 1, 1]:
			return TOP_CENTER_TILE
		[0, 1, 1, 0]:
			return TOP_RIGHT_TILE
		[1, 0, 1, 1]:
			return MIDDLE_LEFT_TILE
		[1, 1, 1, 0]:
			return MIDDLE_RIGHT_TILE
		[1, 0, 0, 1]:
			return BOTTOM_LEFT_TILE
		[1, 1, 0, 1]:
			return BOTTOM_CENTER_TILE
		[1, 1, 0, 0]:
			return BOTTOM_RIGHT_TILE
		_:
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
