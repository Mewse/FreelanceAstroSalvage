extends KinematicBody2D

var motion = Vector2(1,0) # Start flying directly right
var speed = 100
var orbit_target
var orbit_angle = 0

func _ready():
	add_to_group("player")

func _physics_process(delta):
	move(delta)

func move(delta):
	if orbit_target:
		orbit(delta)
	else:
		move_and_slide(motion*speed)
	pass
	
func orbit(delta):
	var new_position = Vector2()
	new_position.x = cos(orbit_angle) * (position.x - orbit_target.x) - sin(orbit_angle) * (position.y - orbit_target.y) + orbit_target.x
	new_position.y = sin(orbit_angle) * (position.x - orbit_target.x) + cos(orbit_angle) * (position.y - orbit_target.y) + orbit_target.y
	position = new_position
	orbit_angle += deg2rad(1 * delta )
	print(orbit_angle)
	look_at((position - new_position).normalized())
	
func leave_orbit():
	orbit_target = null
	
func enter_orbit(new_target):
	orbit_target = new_target
	
func _input(event):
	if Input.is_action_just_pressed("ui_leave_orbit"):
		leave_orbit()
