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
	"Attack": preload("res://Audio/deadly_combat/body_hit_small_23.wav"),
	"Heal": preload("res://Audio/heal.wav"),
	"Taunt": preload("res://Audio/taunt2.wav"),
}


func _ready():
	Global.audio_bus = self


func _on_enemy_attacked(attack):
	if attack.skill_name == "Taunt":
		play(attack.sound_effect)
		await get_tree().create_timer(2.0).timeout
		audio_stream_player.stop()


func play(to_play):
	audio_stream_player.stream = sound[to_play]
	audio_stream_player.play()


func _on_bg_music_finished():
	bg_music.play()
