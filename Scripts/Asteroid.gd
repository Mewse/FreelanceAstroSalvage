extends Area2D

func _ready():
	pass

func _on_Asteroid_body_entered(body):
	if body is KinematicBody2D:
		print("Entering orbit at %s" % position)
		get_tree().call_group("player", "enter_orbit", position)
