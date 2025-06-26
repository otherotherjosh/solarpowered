class_name RoomManager extends Node2D


signal on_room_enter(exit_tlbr: Array[int])

var rooms: Array[Room]
var room_curr: Room

@onready var room_generator: RoomGenerator = $RoomGenerator


## looks for room at coords and generates if needed
func enter_room_at_coords(coords: Vector2i) -> void:
	var filtered := rooms.filter(func(r: Room): return r.coords == coords)
	if !filtered.size():
		filtered.append(room_generator.generate_room(coords))
	enter_room(filtered[0])


## unloads room and loads new room
func enter_room(room_next: Room) -> void:
	var entrance_tlbr := -1
	if room_curr:
		var direction := room_curr.coords - room_next.coords
		room_curr.set_process(false)
		room_generator.remove_child(room_curr)
		# set which entrance to spawn player at
		match direction:
			Vector2i.UP:
				entrance_tlbr = 2
			Vector2i.LEFT:
				entrance_tlbr = 3
			Vector2i.DOWN:
				entrance_tlbr = 0
			Vector2i.RIGHT:
				entrance_tlbr = 1
	room_curr = room_next
	if entrance_tlbr != -1:
		on_room_enter.emit(entrance_tlbr)
	room_curr.set_process(true)
	room_generator.add_child(room_curr)
