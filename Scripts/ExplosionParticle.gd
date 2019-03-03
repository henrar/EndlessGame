extends Node2D

onready var explosion_particle = get_node("ExplosionParticle")

func _process(delta):
    if not explosion_particle.emitting:
        queue_free()
