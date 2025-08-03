extends Node3D

@export var enemy: CharacterBody3D
## Not using this now since they never actually stop moving
@export var footsteps_player: AudioStreamPlayer3D
@export var fx_player: AudioStreamPlayer3D

@export var footsteps_sfx: AudioStream
@export var caught_sfx: AudioStream
## Only for the shooting enemies
@export var gun_sfx: AudioStream

func _ready() -> void:
	if footsteps_sfx != null:
		footsteps_player.stream = footsteps_sfx
		footsteps_player.play()

	enemy.got_caught.connect(play_caught_sfx)
	enemy.got_caught.connect(stop_footsteps)

	if enemy.has_signal("has_shot"):
		enemy.has_shot.connect(play_gun_sfx)

func play_caught_sfx():
	fx_player.stream = caught_sfx
	fx_player.play()

func play_gun_sfx():
	fx_player.stream = gun_sfx
	fx_player.play()

func stop_footsteps():
	footsteps_player.stop()