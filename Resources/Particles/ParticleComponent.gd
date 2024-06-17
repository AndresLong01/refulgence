extends GPUParticles2D
class_name ParticleComponent

@export var particle_system: GPUParticles2D

func _ready() -> void:
	particle_system.emitting = true
