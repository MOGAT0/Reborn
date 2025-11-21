@icon("fsm_icon.png")
extends Node
class_name StateMachine

@export var initial_state: State

var current_state:State
var states: Dictionary[String,State] = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			child.state_machine = self
			states[child.name.to_lower()] = child
		
		if initial_state:
			current_state = initial_state
			initial_state.enter()
			
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
	
	#print(current_state.name)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func change_state(new_state_name: String):
	var new_state: State = states.get(new_state_name.to_lower())
	
	assert(new_state,"State Not Found: " + new_state_name)
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
