extends KinematicBody2D

#Hud
var disabled = Color(1,1,1,0.2)
var enabled = Color(1,1,1,1)

#Movimiento
export var normal = Vector2(0, -1)
export var grav = 10
export var vel = 42
export var salto = -150
export var toxicity = 0
var timer = -1
var motion = Vector2()

#Animaciones
enum dirx {right, left, idle}
enum diry {up, down, none}

#Activadores venenos
var veneno1 = false
var veneno2 = false
var veneno3 = false

#Posicion del respawn más cercano
var resx = 0
var resy = 0

func _ready():
	vel = 42
	dirx = idle
	diry = none
	set_process_input(true)
	pass

func _physics_process(delta):
	
	#Counters
	if timer > 0:
		timer -= 1	
	elif timer == 0:
		_reset()
		
	#Animate
	animate()
	setypos()

	
	#Movement
	motion.y += grav
	motion = move_and_slide(motion, normal)
	pass
	
	
###################################################################################################

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
			
	if Input.is_action_just_pressed("ui_act1") && veneno1:
		veneno1()
	pass
	
	if Input.is_action_just_pressed("ui_act2") && veneno2:
		veneno2()
	pass
	
	if Input.is_action_just_pressed("ui_act3") && veneno3:
		veneno3()
	pass

###################################################################################################

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
	
###################################################################################################

func veneno1():                                      #Venenos
	$Hud/Group/J.set_modulate(disabled)
	vel = 84
	salto = -250
	timer = 40
	toxicity = 20
	pass
	
func veneno2():
	$Hud/Group/J2.set_modulate(disabled)
	pass
	
func veneno3():
	$Hud/Group/J3.set_modulate(disabled)
	pass
	
	



###################################################################################################

func _reset():                                       #reset de stats (veneno1)
	$Hud/Group/J.set_modulate(enabled)
	salto = -150
	vel = 42
	timer = -1
	

###################################################################################################

func activate(veneno):                               #activadores para los venenos
	if veneno == 1:
		$Hud/Group/J.visible = true
		veneno1 = true
	elif veneno == 2:
		$Hud/Group/J2.visible = true
		veneno2 = true
	elif veneno == 3:
		$Hud/Group/J3.visible = true
		veneno3 = true
	pass
	
############################################### RESPAWN ###################################################

func setpos(posx, posy):                            #Mueve el jugador a la posición por parametro
	position.x = posx
	position.y = posy
	pass


func _on_dead_body_entered(body):                   #Impactas objeto caida
	setpos(resx, resy)
	pass


func _on_res00_body_entered(body):                  #Impactas respawner
	resx = position.x
	resy = position.y
	pass
