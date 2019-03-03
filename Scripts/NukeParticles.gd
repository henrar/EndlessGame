extends Node2D

onready var nuke_particle = get_node("NukeParticles")

func _process(delta):
    if not nuke_particle.emitting:
        queue_free()
