extends KinematicBody2D

var motion = Vector2(1,0) # Start flying directly right
var speed = 400
var orbit_speed = PI
var orbit_target
var orbit_angle = 0 # Orbit angle in radians

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
#	new_position.x = cos(orbit_angle) * (position.x - orbit_target.x) - sin(orbit_angle) * (position.y - orbit_target.y) + orbit_target.x
#	new_position.y = sin(orbit_angle) * (position.x - orbit_target.x) + cos(orbit_angle) * (position.y - orbit_target.y) + orbit_target.y
#	position = new_position
#	orbit_angle += deg2rad(1 * delta )
#	print(orbit_angle)
#	look_at((position - new_position).normalized())
	var radius = (position - orbit_target).length()
	new_position.x = orbit_target.x + radius * cos(orbit_angle)
	new_position.y = orbit_target.y + radius * sin(orbit_angle)
	if new_position != position:
		look_at(new_position)
		rotate(deg2rad(90))
	position = new_position
	orbit_angle += orbit_speed*delta
	
#
#	var s = sin(orbit_angle)
#	var c = cos(orbit_angle)
#
#	var origin = Vector2()
#
#	origin.x = position.x - orbit_target.x
#	origin.y = position.y - orbit_target.y
#
#	new_position.x = origin.x * c - origin.y * s
#	new_position.y = origin.x * s + origin.y * c
#
#	var translated = Vector2()
#	translated.x = new_position.x + orbit_target.x
#	translated.y = new_position.y + orbit_target.y
#
#	position = translated.normalized()
	
func calculate_starting_angle():
	var radius = (position - orbit_target).length()
	var starting_angle = acos((position.x - orbit_target.x) / radius)
	return starting_angle

func leave_orbit():
	orbit_target = null
	var new_motion = Vector2()
	new_motion.x = cos(orbit_angle+deg2rad(90))
	new_motion.y = sin(orbit_angle+deg2rad(90))
	motion = new_motion.normalized()
	get_tree().call_group("asteroid", "player_leave_orbit")
	
func enter_orbit(new_target):
	orbit_target = new_target
	orbit_angle = calculate_starting_angle()
	
func _input(event):
	if Input.is_action_just_pressed("ui_leave_orbit"):
		leave_orbit()


func _on_VisibilityNotifier2D_screen_exited():
	get_tree().call_group("game", "player_offscreen")
	print("Off screen")
