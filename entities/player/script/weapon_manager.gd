extends Node3D
class_name WeaponManager

var weapon_obj
var anim_list: Array = [] #[longsword_attack_1 longsword_attack_2 longsword_attack_3 longsword_attack_4]

@onready var animation_tree: AnimationTree = %AnimationTree
var atk_anim_tree: AnimationNodeStateMachine
var combat_blend_tree: AnimationNodeBlendTree

func _ready() -> void:
	if get_children().size() > 0:
		load_weapon_animation()

func _process(delta: float) -> void:
	if get_children().size() > 0:
		load_weapon_animation()
	
func load_weapon_animation() -> void:
	
	if get_children().size() > 0:
		for child in get_children():
			if child is LongSword or child is GreatSword:
				weapon_obj = get_child(0)
				weapon_obj.animation_tree = animation_tree
				
				anim_list = weapon_obj.properties.anim_list
				
	atk_anim_tree = animation_tree.tree_root
	combat_blend_tree = atk_anim_tree.get_node("combat")
	
	var index := 0

	for i in combat_blend_tree.get_node_list():
		if combat_blend_tree.get_node(i) is AnimationNodeBlendTree:
			for j in combat_blend_tree.get_node(i).get_node_list():
				if combat_blend_tree.get_node(i).get_node(j) is AnimationNodeAnimation:
					
					if index < anim_list.size():
						combat_blend_tree.get_node(i).get_node(j).animation = anim_list[index]
						index += 1
				
					#print(combat_blend_tree.get_node(i).get_node(j).animation)
		
		
