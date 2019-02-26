extends Node

enum Music { MUSIC_NOMUSIC = -1, MUSIC_MENU = 0, MUSIC_UPGRADE, MUSIC_INGAME, MUSIC_GAME_OVER, MUSIC_NUM }
enum SoundEffect { SE_CLICK = 0, SE_BUY_UPGRADE, SE_SHIP_COLLISION, SE_BARRIER_COLLISION, SE_GOOD_POWERUP, SE_BAD_POWERUP, SE_LIFE, SE_MOTHERSHIP_GREEN, SE_MOTHERSHIP_RED, SE_MOTHERSHIP_GOLD, SE_NUM }

var music_player

var music_tracks = []
var current_music_track

var sound_effects = []
var sound_effect_players = []

func _ready():
    load_music()
    load_sound_effects()
    init_music_streams()
    init_sound_effect_players()

func init_music_streams():
    current_music_track = Music.MUSIC_NOMUSIC
    music_player = AudioStreamPlayer.new()
    music_player.set_name("MusicPlayer")
    add_child(music_player)

func play_music(track):
    if track != current_music_track:
        stop_music()
        music_player.set_stream(music_tracks[int(track)])
        music_player.play()
        current_music_track = track

func play_sound_effect(sound_effect):
    if sound_effect_players[int(sound_effect)].is_playing():
        sound_effect_players[int(sound_effect)].stop()
    sound_effect_players[int(sound_effect)].play()

func load_music():
    music_tracks.append(load("res://Assets/sound/music/title_theme.wav"))
    music_tracks.append(load("res://Assets/sound/music/upgrade_theme.wav"))
    music_tracks.append(load("res://Assets/sound/music/in_game_theme.wav"))
    music_tracks.append(load("res://Assets/sound/music/game_over_theme.wav"))

    for i in range(Music.MUSIC_NUM):
        music_tracks[i].loop_begin = 0
        music_tracks[i].loop_end = 1000000000
        music_tracks[i].loop_mode = AudioStreamSample.LOOP_FORWARD

func load_sound_effects():
    sound_effects.append(load("res://Assets/sound/effects/se_click.wav"))
    sound_effects.append(load("res://Assets/sound/effects/se_buy_upgrade.wav"))

func init_sound_effect_players():
    for i in range(SoundEffect.SE_NUM):
        sound_effect_players.append(AudioStreamPlayer.new())
        if i < sound_effects.size():
            sound_effect_players[i].set_stream(sound_effects[i])
        
        sound_effect_players[i].set_name("SoundEffectPlayer" + str(i))
        add_child(sound_effect_players[i])   

func stop_music():
    if music_player.is_playing():
        music_player.stop()
        current_music_track = Music.MUSIC_NOMUSIC
        
        