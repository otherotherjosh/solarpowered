@tool
class_name Room extends Node2D


var coords: Vector2i
var exits_tlbr: Array[int]
var exit_cells: Array[Vector2i]

@onready var tile_map_layer: TileMapLayer = $TileMapLayer


func _ready() -> void:
	for i in range(4):
		exit_cells.append(Vector2i.ZERO)
