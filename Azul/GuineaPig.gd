extends KinematicBody2D

#Hud
var disabled = Color(1,1,1,0.2)
var enabled = Color(1,1,1,1)

#Movimiento
export var normal = Vector2(0, -1)
export var grav = 10
export var vel = 42
export var salto = -160
export var toxicity = 0
export var max_toxicity = 100
var timer = -1
var timer3 = -1
var motion = Vector2()
var positionv3 = Vector2(0, 0)
var mprev3 = Vector2()
var prev3 = Vector2(0, 0)
var cantp = true
var respawn = Vector2()
var gosht_busters = false

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

var camera = false

func _ready():
	
	vel = 42
	dirx = idle
	diry = none
	set_process_input(true)
	pass

func _physics_process(delta):
	
	#cozas DLC
	if toxicity >= max_toxicity:
		$Sound/Death.playing = true
		set_modulate(enabled)
		setpos(resx, resy)
		toxicity = 0
		timer = 0
		timer3 = -1
		_reset()
	
	#Counters
	if timer > 0:
		timer -= 1	
	elif timer == 0:
		$Hud/Group/J.set_modulate(enabled)
		_reset()
	
	if timer3 > 0:
		timer3 -= 1
	elif timer3 == 0:
		setpos(prev3.x,prev3.y)
		set_modulate(enabled)
		gosht_busters = false
		timer3 = -1
		$Hud/Group/J3.set_modulate(enabled)
		
	#Animate
	animate()
	setypos()
	
	#Movement
	motion.y += grav
	motion = move_and_slide(motion, normal)
	
	#Barra
	barraupdater()
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
			$Sound/Jump.playing = true
			
	if Input.is_action_just_pressed("ui_act1") && veneno1:
		$Sound/Poison.playing = true
		veneno1()
	
	if Input.is_action_just_pressed("ui_act2") && veneno2:
		$Sound/Poison.playing = true
		veneno2()
	
	if Input.is_action_just_pressed("ui_act3") && veneno3:
		$Sound/Poison.playing = true
		veneno3()
		
	if Input.is_action_just_pressed("ui_cancel"):
    	OS.window_fullscreen = !OS.window_fullscreen
	pass
	
func _control_veneno_3():
	if Input.is_action_pressed("ui_right"):
		positionv3.x = 1
	elif Input.is_action_pressed("ui_left"):
		positionv3.x = -1
	else:
		positionv3.x = 0
	if Input.is_action_pressed("ui_up"):
		positionv3.y = -1
	elif Input.is_action_pressed("ui_down"):
		positionv3.y = 1
	else:
		positionv3.y = 0
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
	vel = 120
	salto = -255
	timer = 40
	toxicity += 10
	pass
	
func veneno2():
	$Hud/Group/J2.set_modulate(disabled)
	pass
	
func veneno3():
	if !gosht_busters:
		gosht_busters = true
		$Hud/Group/J3.set_modulate(disabled)
		var gosht_resource = preload("res://gosht.tscn")
		var gosht = gosht_resource.instance()
		get_node("..").add_child(gosht)
		set_modulate(disabled)
		_control_veneno_3()
		prev3 = position
		position = position + positionv3 * 20
		timer3 = 150
		toxicity += 40
	pass
	

###################################################################################################

func _reset():                                       #reset de stats (veneno1)
	salto = -150
	gosht_busters = false
	if is_on_floor():
		vel = 42
		
		if dirx == idle:
			motion.x = 0
		elif dirx == right && Input.is_action_pressed("ui_right"):
			motion.x = vel
		elif dirx == left  && Input.is_action_pressed("ui_left"):
			motion.x = -vel
	
		timer = -1
	pass
###################################################################################################

func activate(veneno):                               #activadores para los venenos
	if veneno == 1 && !veneno1:
		$Hud/Group/J.visible = true
		$Hud/Group/Toxic.visible = true
		veneno1 = true
		$Sound/PoisonActivate.playing = true
	elif veneno == 2 && !veneno2:
		$Hud/Group/J2.visible = true
		veneno2 = true
		$Sound/PoisonActivate.playing = true
	elif veneno == 3 && !veneno3:
		$Hud/Group/J3.visible = true
		veneno3 = true
		$Sound/PoisonActivate.playing = true
	pass
	
############################################### RESPAWN ###################################################

func setpos(posx, posy):                            #Mueve el jugador a la posición por parametro
	if get_parent().has_node("gosht"):
		var gosht = get_parent().get_node("gosht")
		get_parent().remove_child(gosht)
		timer3 = -1
		set_modulate(enabled)
	position.x = posx
	position.y = posy
	_reset()
	pass


func _on_dead_body_entered(body):                   #Impactas objeto caida
	toxicity = 0
	$Sound/Death.playing = true
	setpos(resx, resy)
	$Hud/Group/J.set_modulate(enabled)
	$Hud/Group/J2.set_modulate(enabled)
	$Hud/Group/J3.set_modulate(enabled)
	_reset()
	pass


func _on_res00_body_entered(body):                  #Impactas respawner
	toxicity = 0
	resx = position.x
	resy = position.y
	pass

################################################# BARRA #####################################################

func barraupdater():
	if $Hud/Group/Toxic.value < toxicity:
		$Hud/Group/Toxic.value += 2
	elif $Hud/Group/Toxic.value > toxicity:
		$Hud/Group/Toxic.value -= 2
	pass


func _on_camera_body_entered(body):
	if !camera:
		$Camera2D.zoom = Vector2(0.25,0.25)
	pass # replace with function body
