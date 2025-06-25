@tool
class_name Room extends Node2D


var coords: Vector2i
var exits_tlbr: Array[int]

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
