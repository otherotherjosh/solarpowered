@tool
class_name RoomGenerator extends Node2D


const TOP_LEFT_TILE := Vector2i(0, 0)
const TOP_CENTER_TILE := Vector2i(1, 0)
const TOP_RIGHT_TILE := Vector2i(2, 0)
const MIDDLE_LEFT_TILE := Vector2i(0, 1)
const MIDDLE_CENTER_TILE := Vector2i(1, 1)
const MIDDLE_RIGHT_TILE := Vector2i(2, 1)
const BOTTOM_LEFT_TILE := Vector2i(0, 2)
const BOTTOM_CENTER_TILE := Vector2i(1, 2)
const BOTTOM_RIGHT_TILE := Vector2i(2, 2)

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@export var square_min_size := 3
@export var square_max_size := 10
@export var squares_min := 3
@export var squares_max := 15


## generates a room
func generate_room() -> void:
	tile_map_layer.clear()
	var square_count := randi_range(squares_min, squares_max)
	generate_square_floor(square_count)
	var cells := tile_map_layer.get_used_cells()
	generate_walls(cells)
	

## lays down a bunch of squares as MIDDLE_CENTER_TILE
func generate_square_floor(square_count) -> void:
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
			randi_range(square.top_left.x + 1, square.bottom_right.x - 1) + offset_x,
			randi_range(square.top_left.y + 1, square.bottom_right.y - 1) + offset_y
	)


## adds square to tile map
func tile_square(square: Square) -> void:
	for x in range(square.top_left.x, square.bottom_right.x + 1):
		for y in range(square.top_left.y, square.bottom_right.y + 1):
			tile_map_layer.set_cell(Vector2i(x, y), 1, MIDDLE_CENTER_TILE)
			
			#var atlas_coords := set_cell_atlas_coords(x, y, square)
			

## sets floor tiles into wall tiles based on neighboring cells
func generate_walls(cells: Array[Vector2i]) -> void:
	for cell in cells:
		var neighbors_tlbr: Array[int] = [0, 0, 0, 0]
		var directions_tlbr := [Vector2i.UP, Vector2i.LEFT, Vector2i.DOWN, Vector2i.RIGHT]
		for i in range(4):
			neighbors_tlbr[i] = (cells.has(cell + directions_tlbr[i])) as int
			
		match neighbors_tlbr:
			[0, 0, 1, 1]:
				tile_map_layer.set_cell(cell, 1, TOP_LEFT_TILE)
			[0, 1, 1, 1]:
				tile_map_layer.set_cell(cell, 1, TOP_CENTER_TILE)
			[0, 1, 1, 0]:
				tile_map_layer.set_cell(cell, 1, TOP_RIGHT_TILE)
			[1, 0, 1, 1]:
				tile_map_layer.set_cell(cell, 1, MIDDLE_LEFT_TILE)
			[1, 1, 1, 0]:
				tile_map_layer.set_cell(cell, 1, MIDDLE_RIGHT_TILE)
			[1, 0, 0, 1]:
				tile_map_layer.set_cell(cell, 1, BOTTOM_LEFT_TILE)
			[1, 1, 0, 1]:
				tile_map_layer.set_cell(cell, 1, BOTTOM_CENTER_TILE)
			[1, 1, 0, 0]:
				tile_map_layer.set_cell(cell, 1, BOTTOM_RIGHT_TILE)
			_:
				tile_map_layer.set_cell(cell, 1, MIDDLE_CENTER_TILE)


## its a square
class Square:
	var top_left: Vector2i
	var bottom_right: Vector2i
	
	func _init(top_left: Vector2i, bottom_right: Vector2i) -> void:
		self.top_left = top_left
		self.bottom_right = bottom_right
