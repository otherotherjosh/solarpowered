extends Control


@export var video_stream_player: VideoStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1).timeout
	video_stream_player.play()
	await video_stream_player.finished
	video_stream_player.hide()
	await get_tree().create_timer(1).timeout
	Global.play_level()
