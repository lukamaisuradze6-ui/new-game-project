extends CharacterBody2D

# --- BATTLE VARIABLES ---
var left_position: Vector2 = Vector2.ZERO
var middle_position: Vector2 = Vector2.ZERO
var right_position: Vector2 = Vector2.ZERO

# Track which lane the enemy is currently attacking (0 = Left, 1 = Middle, 2 = Right)
var current_lane: int = 1 

# Reference to the player instance so the enemy can toggle player controls and UI
var player_ref: Node2D = null


# --- OVERWORLD BEHAVIOR (The Touch Trigger) ---
func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.name == "Player": 
		print("Touch! Switching to Fight Mechanism...")
		
		Settings.current_player_scene = load("res://limitedtimefolders/player.tscn")
		Settings.current_enemy_scene = load("res://limitedtimefolders/enemy.tscn")
		
		get_tree().change_scene_to_file("res://mechanisms/Fight_Mechanism.tscn")


# --- BATTLE BEHAVIOR (The Countdown / 0.3s Dash / Laser Shoot) ---
func start_battle_loop() -> void:
	print("[ENEMY] Battle loop successfully started. Thinking...")
	choose_next_move()

func choose_next_move() -> void:
	# --- 1. DYNAMIC COUNTDOWN SYSTEM ---
	if player_ref:
		player_ref.set_countdown_text("3")
	await get_tree().create_timer(0.66).timeout
	
	if player_ref:
		player_ref.set_countdown_text("2")
	await get_tree().create_timer(0.66).timeout
	
	if player_ref:
		player_ref.set_countdown_text("1")
	await get_tree().create_timer(0.66).timeout
	
	# Cancel/Clear the countdown text immediately because movement is starting!
	if player_ref:
		player_ref.set_countdown_text("")

	# 2. Pick a random spot: 0 = Left, 1 = Middle, 2 = Right
	var choice = randi() % 3
	var target_position: Vector2
	
	if choice == 0:
		target_position = left_position
		current_lane = 0
		print("[ENEMY] Decided to move LEFT!")
	elif choice == 1:
		target_position = middle_position
		current_lane = 1
		print("[ENEMY] Decided to move MIDDLE!")
	else:
		target_position = right_position
		current_lane = 2
		print("[ENEMY] Decided to move RIGHT!")
		
	# --- OPEN PLAYER DODGE WINDOW ---
	if player_ref:
		player_ref.can_dodge = true
		print("[ENEMY] Dodge window is now OPEN! Smash A, S, or D!")
	else:
		print("[ENEMY] ERROR: player_ref is missing! Cannot open dodge window.")
		
	# 3. Quick dash to that place in 0.3 seconds
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	# 4. Wait for the fast 0.3-second movement to finish
	await tween.finished
	
	# --- CLOSE PLAYER DODGE WINDOW ---
	if player_ref:
		player_ref.can_dodge = false
		print("[ENEMY] Dodge window is now CLOSED! Controls locked.")
	
	# --- UNLEASH HYPER-COMPRESSED LASER BEAM ---
	print("[ENEMY] UNLEASHING HYPER-COMPRESSED LASER BEAM!")
	shoot_laser_beam()
	
	# Wait 0.8 seconds for the effect to finish before restarting the turn sequence
	await get_tree().create_timer(0.8).timeout
	
	# Repeat the loop infinitely
	choose_next_move()


# --- HYPER-COMPRESSED DETONATION BEAM WITH DAMAGE METRICS ---
func shoot_laser_beam() -> void:
	var effect_holder = Node2D.new()
	get_parent().add_child(effect_holder)
	effect_holder.global_position = global_position

	# --- THE STABLE SLIM WHITE CORE LINE ---
	var laser_line = Line2D.new()
	effect_holder.add_child(laser_line)
	laser_line.width = 4.0 
	laser_line.default_color = Color(1.0, 1.0, 1.0, 1.0)
	laser_line.add_point(Vector2.ZERO)
	laser_line.add_point(Vector2(0, 1000))

	# --- PURE WHITE LASER FIELD PARTICLES ---
	var spark_particles = GPUParticles2D.new()
	effect_holder.add_child(spark_particles)
	
	var spark_material = ParticleProcessMaterial.new()
	spark_material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	spark_material.emission_box_extents = Vector3(3, 500, 1) 
	
	spark_material.direction = Vector3(0, 1, 0)
	spark_material.spread = 0.0 
	spark_material.gravity = Vector3(0, 0, 0)
	
	spark_material.initial_velocity_min = 4000.0 
	spark_material.initial_velocity_max = 5000.0
	
	spark_material.scale_min = 1.0
	spark_material.scale_max = 3.0
	
	spark_particles.process_material = spark_material
	spark_particles.amount = 400
	spark_particles.lifetime = 0.15 
	spark_particles.modulate = Color(2.0, 2.0, 2.0, 1.0) 
	spark_particles.position = Vector2(0, 500)

	spark_particles.emitting = true
	
	# --- LANE COLLISION CHECK ---
	if player_ref:
		if player_ref.current_lane == self.current_lane:
			player_ref.take_damage(33)
		else:
			print("[BATTLE] Safe! Player dodged the lane.")
	
	# --- ANIMATE INSTANTANEOUS BURST ---
	await get_tree().create_timer(0.35).timeout
	spark_particles.emitting = false
	
	var line_tween = create_tween().set_parallel(true)
	line_tween.tween_property(laser_line, "modulate:a", 0.0, 0.15)
	line_tween.tween_property(laser_line, "width", 0.0, 0.15)
	
	# --- CLEANUP ---
	await line_tween.finished
	await get_tree().create_timer(0.1).timeout
	effect_holder.queue_free()
