extends Node2D


@export var room_scenes: Array[PackedScene] = []
@export var player_scene: PackedScene
@export var max_rooms: int = 0
@export var room_size: Vector2 = Vector2(320, 180)

@export var room_selection: Array[Room]

var player
var room_grid := {}
var directions := [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]


func _ready():
	#generate_rooms(max_rooms)
	pass


func generate_rooms(count: int):
	var start_pos = Vector2.ZERO
	room_grid[start_pos] = spawn_room(start_pos, true)  # first room

	var frontier = [start_pos]

	while frontier.size() > 0 and room_grid.size() < count:
		var current = frontier.pick_random()
		frontier.erase(current)

		directions.shuffle()
		for dir in directions:
			var new_pos = current + dir
			if not room_grid.has(new_pos):
				room_grid[new_pos] = spawn_room(new_pos)
				frontier.append(new_pos)
				break  # branch one room per loop


func spawn_room(grid_pos: Vector2, is_spawn: bool = false) -> Node2D:
	var room_scene = room_scenes.pick_random()
	var room = room_scene.instantiate()
	room.position = grid_pos * room_size
	add_child(room)

	if is_spawn:
		var spawn = room.get_node_or_null("**/PlayerSpawn")
		if spawn:
			player = player_scene.instantiate()
			player.global_position = room.global_position + spawn.position
			get_tree().current_scene.add_child(player)
		else:
			push_error("No 'PlayerSpawn' found in the first room!")
	
	return room
