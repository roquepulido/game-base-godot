extends KinematicBody2D

var motion = Vector2()
const UP = Vector2(0,-1)
export (int) var max_gravity = 500
export (int) var acceleration = 50
export (int) var gravity_step = 20
export (int) var max_speed = 200
export (int) var jump_heigth = -500
var friction = false
var sword_is_out = false
var can_move = true

#-------------------------
var attack = false
var multiattack = false
var cont_attack = 0
var delay_attack = 0.5
var timer_attack = 0
#----------------------

func sacar_espada():
	if sword_is_out == false:
		$Sprite.stop()
		$Sprite.play("sword_draw")
		can_move = false
		yield(get_node("Sprite"),"animation_finished")
		sword_is_out = true
		can_move = true
		print("te puedes mover")
		
	else:
		$Sprite.stop()
		$Sprite.play("sword_hide")
		can_move = false
		yield(get_node("Sprite"),"animation_finished")
		print("te puedes mover")
		sword_is_out = false
		can_move = true
	pass
	
func _physics_process(delta):
	motion.y = min(motion.y + gravity_step, max_gravity)
	
	#----------------------------------------------------------------------------
	if Input.is_action_just_pressed("ui_select"):
		print("cont_attack = ")
		print(cont_attack)
		cont_attack += 1
		
		#---------------------poner animaicion y su yield-------------------
	if cont_attack == 1 :
		can_move = false
		print("animacion ataque 1")
		$Sprite.play("attack1")
		yield($Sprite,"animation_finished")
		if cont_attack == 1: 
			cont_attack = 0
			can_move = true
	if cont_attack == 2:
		print ("animacion ataque 2")
		$Sprite.play("attack2")
		yield($Sprite,"animation_finished")
		if cont_attack == 2: 
			cont_attack = 0
			can_move = true
	if cont_attack >= 3:
		print("animacion ataque 3")
		$Sprite.play("attack3")
		yield($Sprite,"animation_finished")
		cont_attack = 0
		can_move = true
	
	#-------------------------------------------------------------------------------
	if Input.is_action_pressed("ui_right") && can_move == true:
		motion.x = min (motion.x + acceleration, max_speed)
		$Sprite.flip_h = false
		if sword_is_out == false: $Sprite.play("run")
		else: $Sprite.play("run_sword")

	elif Input.is_action_pressed("ui_left") && can_move == true:
		motion.x = max (motion.x - acceleration, -max_speed)
		$Sprite.flip_h = true
		if sword_is_out == false: $Sprite.play("run")
		else: $Sprite.play("run_sword")
	
	else:
		if sword_is_out == false && can_move ==true: $Sprite.play("idle")
		elif sword_is_out == true && can_move==true: $Sprite.play("idle_sword")
		
		friction = true
		motion.x = lerp (motion.x, 0, 0.2)

	if is_on_floor():
#		if Input.is_action_just_pressed("ui_select"):sacar_espada()

		if Input.is_action_just_pressed("ui_up"):motion.y = jump_heigth
	
	else:
		if motion.y < 0: $Sprite.play("jump")
		else: 
			$Sprite.play("fall")
			
	
	motion = move_and_slide(motion,UP)
