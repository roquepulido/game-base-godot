extends KinematicBody2D
var motion = Vector2()
const UP = Vector2(0,-1)
export (int) var max_gravity = 500
export (int) var acceleration = 50
export (int) var gravity_step = 20
export (int) var max_speed = 300
export (int) var jump_heigth = -500
export (int) var life=200

var sword_is_out = false
var can_move = true
var attack = false
var multiattack = false
var cont_attack = 0
var timer_attack = 0
var is_jump=false
var Idle=true

func test_anim(anim):
	for i in range(0,anim.size()):
		print (anim[i])
		$AnimatedSprite.play(anim[i])
		yield($AnimatedSprite,"animation_finished")
	print ("Todas las animaciones")
	$AnimatedSprite.play("Idle")

func sacar_espada():
	if Input.is_action_just_pressed("Espada"):
		if sword_is_out == false:
			can_move=false
			$AnimatedSprite.play("Sword_draw")
			yield($AnimatedSprite,"animation_finished")
			sword_is_out=true
			can_move=true
		else:
			can_move=false
			$AnimatedSprite.play("Sword_hide")
			yield($AnimatedSprite,"animation_finished")
			sword_is_out=false
			can_move=true

func sword_attack():
	if Input.is_action_just_pressed("Attack") && sword_is_out==true && can_move==true && cont_attack==0:
		$Cooldown.start(0.5)
		can_move=false
		$AnimatedSprite.play("Attack1")
		cont_attack=1
	elif Input.is_action_just_pressed("Attack") && sword_is_out==true  && cont_attack==1 && $AnimatedSprite.frame>=3:
		$Cooldown.start(0.6)
		$AnimatedSprite.play("Attack2")
		cont_attack=2
	elif Input.is_action_just_pressed("Attack") && sword_is_out==true  && cont_attack==2 && $AnimatedSprite.frame<=4:
		$Cooldown.start(0.6)
		$AnimatedSprite.play("Attack3")
		cont_attack=0

func hand_attack():
	if Input.is_action_just_pressed("Attack") && sword_is_out==false && can_move==true && cont_attack==0:
		$Cooldown.start(0.3)
		can_move=false
		$AnimatedSprite.play("Punch1")
		cont_attack=1
	elif Input.is_action_just_pressed("Attack") && sword_is_out==false  && cont_attack==1 && $AnimatedSprite.frame>=1:
		$Cooldown.start(0.4)
		$AnimatedSprite.play("Punch2")
		cont_attack=2
	elif Input.is_action_just_pressed("Attack") && sword_is_out==false  && cont_attack==2 && $AnimatedSprite.frame>=2:
		$Cooldown.start(0.6)
		$AnimatedSprite.play("Punch3")
		cont_attack=0

func jump_fall():
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = jump_heigth
			is_jump=true
			$AnimatedSprite.play("Jump")
			yield($AnimatedSprite,"animation_finished")
			is_jump=false
		

func moving():
	if Input.is_action_pressed("ui_right") && can_move == true && is_jump==false:
		Idle=false
		motion.x = min (motion.x + acceleration, max_speed)
		$AnimatedSprite.flip_h = false
		if sword_is_out==false:
			$AnimatedSprite.play("Run")
		else:
			$AnimatedSprite.play("Run_sword")

	elif Input.is_action_pressed("ui_left") && can_move == true  && is_jump==false:
		Idle=false
		motion.x = max (motion.x - acceleration, -max_speed)
		$AnimatedSprite.flip_h = true
		if sword_is_out==false:
			$AnimatedSprite.play("Run")
		else:
			$AnimatedSprite.play("Run_sword")
	else:
		Idle=true
		
	if Idle==true:
		if sword_is_out == false && can_move ==true && is_jump==false: 
			$AnimatedSprite.play("Idle")
		elif sword_is_out == true && can_move ==true && is_jump==false:
			$AnimatedSprite.play("Idle_sword")
			
	motion.x = lerp (motion.x, 0, 0.2)

func gravity():
	motion.y = min(motion.y + gravity_step, max_gravity)
	
func _ready():
#TEST ANIMACIONES
#	test_anim($AnimatedSprite.frames.get_animation_names())
#--------------------------#
	$AnimatedSprite.play("Idle")
	pass
	
func _physics_process(delta):
	
	sacar_espada()
#	sword_attack()
#	hand_attack()
	moving()
	jump_fall()
	gravity()
	
	
	motion=move_and_slide(motion,UP)
	
	


func _on_Cooldown_timeout():
	cont_attack=0
	can_move=true
