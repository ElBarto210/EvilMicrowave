extends KinematicBody2D

#Movimiento
export var normal = Vector2(0, -1)
export var grav = 10
export var vel = 70
export var salto = -200
var motion = Vector2()

#Animaciones
enum dirx {right, left, idle}
enum diry {up, down, none}

func _ready():
	dirx = idle
	diry = none
	set_process_input(true)
	pass

func _physics_process(delta):
	
	#Animate
	animate()
	setypos()

	
	#Movement
	motion.y += grav
	motion = move_and_slide(motion, normal)
	pass
	
	
#####################################################################################################

func _input(event):                   #Cuando hagas el movimiento, solo asegurate de que en cada momento del movimiento estableces
                                      #la dirección del movimento para que las animaciones sigan funcionando
	if Input.is_action_pressed("ui_right"):
		motion.x = vel
		dirx = right
	elif Input.is_action_pressed("ui_left"):
		motion.x = -vel
		dirx = left
	else:
		motion.x = 0
		if is_on_floor():
			dirx = idle

	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = salto
	pass

####################################################################################################

func setypos():                                    #Cambia el estado de dirección vertical
	if motion.y > 0:
		diry = down
	elif motion.y < 0:
		diry = up
	else:
		diry = none
	pass

func animate():                                      #Animaciones

	if is_on_floor():
		if motion.x == 0:
			dirx = idle
		diry = none
		if dirx != idle:
			$Anim.play("run")
	else:
		if diry == up:
			$Anim.play("jumpup")
		elif diry == down:
			$Anim.play("jumpdown")
			
	if dirx != idle:
		if dirx == left:
			$Anim.flip_h = true
		elif dirx == right:
			$Anim.flip_h = false	
	else:
		if diry == none:
			$Anim.play("default")
	pass