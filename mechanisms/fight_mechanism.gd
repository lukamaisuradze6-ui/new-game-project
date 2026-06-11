extends Node2D

@onready var player_spawn = $PlayerSpawn
@onready var enemy_spawn = $EnemySpawn

# --- GRAB THE ENEMY'S THREE MARKERS ---
@onready var enemy_left = $EnemySpawn/LeftPos
@onready var enemy_middle = $EnemySpawn/MiddlePos
@onready var enemy_right = $EnemySpawn/RightPos

# --- GRAB THE PLAYER'S THREE MARKERS ---
@onready var player_left = $PlayerSpawn/LeftPos
@onready var player_middle = $PlayerSpawn/MiddlePos
@onready var player_right = $PlayerSpawn/RightPos

func _ready() -> void:
	if Settings.current_player_scene and Settings.current_enemy_scene:
		
		# 1. Instance them
		var player_instance = Settings.current_player_scene.instantiate()
		var enemy_instance = Settings.current_enemy_scene.instantiate()
		
		# 2. Position them at their starting spawns
		player_instance.global_position = player_spawn.global_position
		enemy_instance.global_position = enemy_spawn.global_position
		
		# 3. Add them to the arena scene
		add_child(player_instance)
		add_child(enemy_instance)
		
		# 4. FREEZE OVERWORLD MOVEMENT
		player_instance.set_physics_process(false)
		
		# 5. FIXED BRIDGE #1: GIVE THE PLAYER THEIR ACTUAL LANE COORDINATES
		# This stops target_pos from being Vector2(0,0)
		player_instance.left_position = player_left.global_position
		player_instance.middle_position = player_middle.global_position
		player_instance.right_position = player_right.global_position
		
		# 6. GIVE THE ENEMY THEIR ACTUAL LANE COORDINATES
		enemy_instance.left_position = enemy_left.global_position
		enemy_instance.middle_position = enemy_middle.global_position
		enemy_instance.right_position = enemy_right.global_position
		
		# 7. FIXED BRIDGE #2: LINK THE PLAYER REFERENCE TO THE ENEMY
		# This fills the enemy's 'player_ref' so it can unlock 'can_dodge'!
		enemy_instance.player_ref = player_instance
		
		# 8. TRIGGER THE AI LOOP
		enemy_instance.start_battle_loop()
		
		print("Fighters arranged, player lane links fixed, and battle loop started safely!")
	else:
		print("Error: Fight scene loaded but settings.gd was empty!")
