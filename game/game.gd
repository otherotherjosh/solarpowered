extends Node2D


@onready var room_manager: RoomManager = %RoomManager
@onready var room_generator: RoomGenerator = %RoomManager/RoomGenerator
@onready var player: Player = $Player


func _ready() -> void:
	# generate spawn room
	var spawn_room := room_generator.generate_room(Vector2i.ZERO, [1, 0, 0, 0])
	room_manager.rooms.append(spawn_room)
	room_manager.enter_room(spawn_room)
	#generate second room
	room_manager.rooms.append(room_generator.generate_room(Vector2i.UP, [1, 1, 1, 1]))
	
	# spawn player position
	var spawnable_cells: Array[Vector2i] = []
	for cell in (spawn_room.tile_map_layer.get_used_cells_by_id(
			1, room_generator.MIDDLE_CENTER_TILE)):
		if spawnable_cells.size() == 0:
			spawnable_cells.append(cell)
		elif cell.y > spawnable_cells[0].y:
			spawnable_cells.clear()
			spawnable_cells.append(cell)
	player.global_position = spawn_room.tile_map_layer.to_global(
			spawn_room.tile_map_layer.map_to_local(
					spawnable_cells[randi_range(0, spawnable_cells.size() - 1)])
	)


func _on_room_manager_room_enter(exit_tlbr: int) -> void:
	var room := room_manager.room_curr
	var entrance_cell = room.exit_cells[exit_tlbr]
	player.global_position = room.to_global(room.tile_map_layer.map_to_local(entrance_cell))
