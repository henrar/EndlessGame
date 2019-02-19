extends Node

enum Music { MUSIC_NOMUSIC = -1, MUSIC_MENU = 0 }
enum SoundEffect { SE_EXPLOSION = 0 }

var audio_stream_player
var audio_stream_sample
var current_music_track

func _ready():
    init_music_streams()

func init_music_streams():
    current_music_track = Music.MUSIC_NOMUSIC
    audio_stream_player = AudioStreamPlayer.new()
    audio_stream_sample = AudioStreamSample.new()

    audio_stream_sample.format = AudioStreamSample.FORMAT_16_BITS
    audio_stream_sample.stereo = true
    audio_stream_sample.mix_rate = 48000

    audio_stream_player.set_stream(audio_stream_sample)

    add_child(audio_stream_player)

func play_music(track):
    pass

func play_sound_effect(sound_effect):
    pass

func stop_music():
    if audio_stream_player.is_playing():
        audio_stream_player.stop()
        current_music_track = Music.MUSIC_NOMUSIC