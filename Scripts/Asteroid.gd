extends Area2D

func _ready():
	pass

func _on_Asteroid_body_entered(body):
	if body is KinematicBody2D:
		$CollisionShape2D.disabled = true
		print("Entering orbit at %s" % body.position)
		get_tree().call_group("player", "enter_orbit", position)

func player_leave_orbit():
	$Timer.start()

func _on_Timer_timeout():
	$CollisionShape2D.disabled = false
