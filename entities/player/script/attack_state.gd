extends State
class_name AttackState

@onready var player: Player = $"../.."
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var animation_state = animation_tree["parameters/playback"]

var atk_anim_tree: AnimationNodeStateMachine
var combat_blend_tree: AnimationNodeBlendTree

@onready var ground_ray: ShapeCast3D = %ground_ray

@export var weapon_manager: WeaponManager

var anim_list: Array = [""]

func enter():
	animation_tree["parameters/conditions/combat"] = true
	anim_list = weapon_manager.weapon_obj.properties.anim_list
	
	atk_anim_tree = animation_tree.tree_root
	combat_blend_tree = atk_anim_tree.get_node("combat")
	player.FOV = player.normal_fov
	
	player.is_crouching = false
	
func update(delta:float):
	
	if weapon_manager.weapon_obj.combo_failed:
		
		if player.velocity.y > 0.0:
			state_machine.change_state("jump")
			return
		elif player.velocity.length() == 0:
			state_machine.change_state("idle")
			return
		elif player.velocity.length() != 0.0:
			state_machine.change_state("move")
			return
		elif !player.is_on_floor() and !ground_ray.is_colliding():
			state_machine.change_state("fall_idle")
			return
	else:
		#player.player_dir = Vector2.ZERO
		print(animation_tree["parameters/combat/attack_transition/current_state"])
		if animation_tree:
			animation_tree["parameters/combat/attack_transition/transition_request"] = "attack_buffer_%d" % weapon_manager.weapon_obj.attack_index
			
func exit():
	animation_tree["parameters/conditions/combat"] = false
