extends Node

enum Music { MUSIC_NOMUSIC = -1, MUSIC_MENU = 0, MUSIC_UPGRADE, MUSIC_INGAME, MUSIC_GAME_OVER }
enum SoundEffect { SE_EXPLOSION = 0 }

var music_player

var music_tracks = []
var current_music_track

var sound_effects = []

func _ready():
    load_music()
    load_sound_effects()
    init_music_streams()

func init_music_streams():
    current_music_track = Music.MUSIC_NOMUSIC
    music_player = AudioStreamPlayer.new()
    add_child(music_player)

func play_music(track):
    if track != current_music_track:
        stop_music()
        music_player.set_stream(music_tracks[int(track)])
        music_player.play()
        current_music_track = track

func play_sound_effect(sound_effect):
    pass

func load_music():
    music_tracks.append(load("res://Assets/sound/music/title_theme.wav"))
    music_tracks.append(load("res://Assets/sound/music/upgrade_theme.wav"))
    music_tracks.append(load("res://Assets/sound/music/in_game_theme.wav"))
    music_tracks.append(load("res://Assets/sound/music/game_over_theme.wav"))

func load_sound_effects():
    pass

func stop_music():
    if music_player.is_playing():
        music_player.stop()
        current_music_track = Music.MUSIC_NOMUSIC
        
        