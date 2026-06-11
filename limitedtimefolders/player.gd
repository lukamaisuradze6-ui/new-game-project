extends CharacterBody2D

@export var SPEED: float = 300.0

# --- HEALTH & UI VARIABLES ---
var health: int = 100
var health_label: Label = null
var countdown_label: Label = null
var ui_layer: CanvasLayer = null

# --- COMBAT DODGE VARIABLES ---
var left_position: Vector2 = Vector2.ZERO
var middle_position: Vector2 = Vector2.ZERO
var right_position: Vector2 = Vector2.ZERO

# Track which lane the player is currently in (0 = Left, 1 = Middle, 2 = Right)
var current_lane: int = 1 

# Controlled directly by the enemy script during battle
var can_dodge: bool = false 


# --- SETUP HEALTH UI & COUNTDOWN ON SCREEN ---
func _ready() -> void:
	# 1. Create a CanvasLayer so UI elements stick to the monitor glass
	ui_layer = CanvasLayer.new()
	add_child(ui_layer)
	
	# 2. Setup the Health Label (Top Right)
	health_label = Label.new()
	ui_layer.add_child(health_label)
	health_label.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	
	var screen_size = get_viewport_rect().size
	health_label.position = Vector2(screen_size.x - 120, 25)
	health_label.scale = Vector2(1.5, 1.5)
	
	# 3. Setup the Countdown Label (DEAD CENTER)
	countdown_label = Label.new()
	ui_layer.add_child(countdown_label)
	
	# FIXED: Use Godot layout anchors to force absolute screen-centering
	countdown_label.anchor_left = 0.5
	countdown_label.anchor_right = 0.5
	countdown_label.anchor_top = 0.5
	countdown_label.anchor_bottom = 0.5
	
	# This keeps it centered even when the character scales or changes content
	countdown_label.grow_horizontal = Control.GROW_DIRECTION_BOTH
	countdown_label.grow_vertical = Control.GROW_DIRECTION_BOTH
	countdown_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	countdown_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Crank up the scale so it's a massive warning right in the middle of the fight zone
	countdown_label.scale = Vector2(4.0, 4.0) 
	
	# Offset the pivot point so scaling doesn't push the number off-center
	countdown_label.pivot_offset = countdown_label.size / 2
	
	countdown_label.text = "" # Start empty
	update_health_display()


# --- UPDATE DISPLAY METRICS ---
func update_health_display() -> void:
	if health_label:
		health_label.text = "HP: " + str(health)


# --- MANAGE COUNTDOWN VISIBILITY ---
func set_countdown_text(new_text: String) -> void:
	if countdown_label:
		countdown_label.text = new_text


# --- DAMAGE TRIGGER FUNCTION ---
func take_damage(amount: int) -> void:
	health -= amount
	if health < 0:
		health = 0
		
	update_health_display()
	print("[PLAYER] OUCH! Got hit by laser. Health remaining: ", health)
	
	var shake_tween = create_tween()
	shake_tween.tween_property(self, "modulate", Color(5, 0, 0, 1), 0.1) 
	shake_tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.15) 


# --- OVERWORLD WASD MOVEMENT ---
func _physics_process(_delta: float) -> void:
	var direction := Vector2.ZERO

	if Input.is_key_pressed(KEY_D): # Right
		direction.x += 1
	if Input.is_key_pressed(KEY_A): # Left
		direction.x -= 1
	if Input.is_key_pressed(KEY_S): # Down
		direction.y += 1
	if Input.is_key_pressed(KEY_W): # Up
		direction.y -= 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()

	velocity = direction * SPEED
	move_and_slide()


# --- COMBAT LANE DETECTION ---
func _input(event: InputEvent) -> void:
	if not can_dodge:
		return
		
	if event is InputEventKey and event.pressed and not event.is_echo():
		var target_pos := Vector2.ZERO
		
		if event.keycode == KEY_A:
			target_pos = left_position
			current_lane = 0
			print("[PLAYER] Pressed A! Target Position: ", target_pos)
		elif event.keycode == KEY_S:
			target_pos = middle_position
			current_lane = 1
			print("[PLAYER] Pressed S! Target Position: ", target_pos)
		elif event.keycode == KEY_D:
			target_pos = right_position
			current_lane = 2
			print("[PLAYER] Pressed D! Target Position: ", target_pos)
			
		if target_pos != Vector2.ZERO:
			print("[PLAYER] Executing Tween Slide to: ", target_pos)
			var tween = create_tween()
			tween.tween_property(self, "global_position", target_pos, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
