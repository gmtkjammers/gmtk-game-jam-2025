extends Node3D

@export var footsteps_player: AudioStreamPlayer3D
@export var effects_player: AudioStreamPlayer3D
@export var player_body: CharacterBody3D

@export var get_hat_sfx: AudioStream
@export var lose_hat_sfx: AudioStream
@export var get_horse_sfx: AudioStream
@export var increase_size_sfx : AudioStream
@export var increase_lasso_sfx : AudioStream

func _ready() -> void:
	player_body.got_horse.connect(play_horse_sfx)
	player_body.got_hat.connect(play_get_hat_sfx)
	player_body.took_damage.connect(play_lose_hat_sfx)
	player_body.increased_size.connect(play_increase_size_sfx)
	player_body.increased_lasso.connect(play_increase_lasso_sfx)

func _physics_process(_delta: float) -> void:
	var is_player_moving = player_body.velocity.x != 0 or player_body.velocity.z != 0
	if is_player_moving and not footsteps_player.playing:
		footsteps_player.play()
		return
	
	if player_body.velocity == Vector3.ZERO and footsteps_player.playing:
		footsteps_player.stop()

func play_horse_sfx():
	effects_player.stream = get_horse_sfx
	effects_player.play()

func play_get_hat_sfx():
	effects_player.stream = get_hat_sfx
	effects_player.play()

func play_lose_hat_sfx():
	effects_player.stream = lose_hat_sfx
	effects_player.play()

func play_increase_size_sfx():
	effects_player.stream = increase_size_sfx
	effects_player.play()

func play_increase_lasso_sfx():
	effects_player.stream = increase_lasso_sfx
	effects_player.play()
