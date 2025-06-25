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
const ROOM = preload("res://rooms/room.tscn")

@export var square_min_size := 3
@export var square_max_size := 10
@export var squares_min := 3
@export var squares_max := 15


## generates a room
func generate_room(exits_tlbr: Array[int]) -> void:
	var room := ROOM.instantiate() as Room
	add_child(room)
	room.exits_tlbr = exits_tlbr
	room.tile_map_layer.clear()
	var square_count := randi_range(squares_min, squares_max)
	generate_square_floor(square_count, room)
	var cells := room.tile_map_layer.get_used_cells()
	generate_walls(cells, room)
	

## lays down a bunch of squares as MIDDLE_CENTER_TILE
func generate_square_floor(square_count: int, room: Room) -> void:
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
		tile_square(square, room)


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
func tile_square(square: Square, room: Room) -> void:
	for x in range(square.top_left.x, square.bottom_right.x + 1):
		for y in range(square.top_left.y, square.bottom_right.y + 1):
			room.tile_map_layer.set_cell(Vector2i(x, y), 1, MIDDLE_CENTER_TILE)
			

## sets floor tiles into wall tiles based on neighboring cells
func generate_walls(cells: Array[Vector2i], room: Room) -> void:
	var exit_cells_top: Array[Vector2i]
	var exit_cells_left: Array[Vector2i]
	var exit_cells_bottom: Array[Vector2i]
	var exit_cells_right: Array[Vector2i]
	
	for cell in cells:
		var neighbors_tlbr: Array[int] = [0, 0, 0, 0]
		var directions_tlbr := [Vector2i.UP, Vector2i.LEFT, Vector2i.DOWN, Vector2i.RIGHT]
		for i in range(4):
			neighbors_tlbr[i] = (cells.has(cell + directions_tlbr[i])) as int
			
		match neighbors_tlbr:
			[0, 0, 1, 1]:
				room.tile_map_layer.set_cell(cell, 1, TOP_LEFT_TILE)
			[0, 1, 1, 1]:
				room.tile_map_layer.set_cell(cell, 1, TOP_CENTER_TILE)
				if exit_cells_top.size() == 0:
					exit_cells_top.append(cell)
				elif exit_cells_top[0].y > cell.y:
					exit_cells_top.clear()
					exit_cells_top.append(cell)
			[0, 1, 1, 0]:
				room.tile_map_layer.set_cell(cell, 1, TOP_RIGHT_TILE)
			[1, 0, 1, 1]:
				room.tile_map_layer.set_cell(cell, 1, MIDDLE_LEFT_TILE)
				if exit_cells_left.size() == 0:
					exit_cells_left.append(cell)
				elif exit_cells_left[0].x > cell.x:
					exit_cells_left.clear()
					exit_cells_left.append(cell)					
			[1, 1, 1, 0]:
				room.tile_map_layer.set_cell(cell, 1, MIDDLE_RIGHT_TILE)
				if exit_cells_right.size() == 0:
					exit_cells_right.append(cell)
				elif exit_cells_right[0].x < cell.x:
					exit_cells_right.clear()
					exit_cells_right.append(cell)
			[1, 0, 0, 1]:
				room.tile_map_layer.set_cell(cell, 1, BOTTOM_LEFT_TILE)
			[1, 1, 0, 1]:
				room.tile_map_layer.set_cell(cell, 1, BOTTOM_CENTER_TILE)
				if exit_cells_bottom.size() == 0:
					exit_cells_bottom.append(cell)
				elif exit_cells_bottom[0].y < cell.y:
					exit_cells_bottom.clear()
					exit_cells_bottom.append(cell)
			[1, 1, 0, 0]:
				room.tile_map_layer.set_cell(cell, 1, BOTTOM_RIGHT_TILE)
			_:
				room.tile_map_layer.set_cell(cell, 1, MIDDLE_CENTER_TILE)
	
	# poke holes for exits
	var exit_cells_tlbr := [
			exit_cells_top, exit_cells_left, exit_cells_bottom, exit_cells_right]
	for i in range(4):
		if room.exits_tlbr[i]:
			var cell_index = randi_range(0,  exit_cells_tlbr[i].size() - 1)
			var exit_cell: Vector2i = exit_cells_tlbr[i][cell_index]
			room.tile_map_layer.set_cell(exit_cell, 1, MIDDLE_CENTER_TILE)


## its a square
class Square:
	var top_left: Vector2i
	var bottom_right: Vector2i
	
	func _init(top_left: Vector2i, bottom_right: Vector2i) -> void:
		self.top_left = top_left
		self.bottom_right = bottom_right
