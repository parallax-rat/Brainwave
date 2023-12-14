extends Node

enum {
	SELECT,
	ATTACK,
	HEAL,
	LEFT_2,
	LEFT_4,
	RIGHT_2,
	RIGHT_4,
	TAUNT,
	BGM,
	}

@onready var bg_music = %BGMusic
@onready var audio_stream_player = %AudioStreamPlayer
@onready var sound = {
	SELECT: preload("res://Audio/select.ogg"),
	ATTACK: preload("res://Audio/attack.wav"),
	HEAL: preload("res://Audio/heal.wav"),
	LEFT_2: preload("res://Audio/left 2.wav"),
	LEFT_4: preload("res://Audio/left 4.wav"),
	RIGHT_2: preload("res://Audio/right 2.wav"),
	RIGHT_4: preload("res://Audio/right 4.wav"),
	TAUNT: preload("res://Audio/taunt.wav"),
	BGM: preload("res://Audio/Music/Spinning out.ogg"),
}


func _on_enemy_attacked(attack):
	play(attack.sound_effect)


func _on_player_attacked(attack:Skill):
	play(attack.sound_effect)


func play(to_play):
	audio_stream_player.stream = sound[to_play]
	audio_stream_player.play()


func _on_bg_music_finished():
	bg_music.play()
