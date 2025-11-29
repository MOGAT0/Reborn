extends LongSword

@export var stats: WeaponStat
@export var properties: WeaponInfo
@onready var atk_col: CollisionShape3D = %atk_col

var animation_tree: AnimationTree
var animation_state

var attack_index: int = 0
var wait_time: float = 0.0

var combo_failed: bool = false

var switch_timer : float = 0.0
@export var player: Player
var aceleration_index : int = 0



func _process(delta: float) -> void:
	atk_col.disabled = !GlobalScript.can_damage
	if animation_tree:
		animation_state = animation_tree["parameters/playback"]
	
	switch_timer += delta
	switch_timer = clamp(switch_timer,0,properties.switch_time)

	if Input.is_action_just_pressed("attack") and switch_timer >= properties.switch_time:
		combo_failed = false 

		attack_index += 1
		if attack_index > properties.anim_list.size():
			attack_index = 1

		wait_time = 0.0
		switch_timer = 0.0

		if player:
			player._accelerate(-0.5,properties.delay_aceleration[aceleration_index])
			
		aceleration_index += 1
		if aceleration_index > properties.delay_aceleration.size() - 1:
			aceleration_index = 0
		

	if attack_index > 0:
		wait_time += delta

		if wait_time >= properties.wait_time:
			combo_failed = true
			attack_index = 0
			aceleration_index = 0
			wait_time = 0.0
			
	#print(attack_index)

			
			
	

		
		
	
