extends Resource
class_name WeaponStat

@export_group("Properties")
#region weapon damage
@export var STR: int #strength damage
@export var DEX: int #dps
@export var MAGI: int #magic damage
@export var Poise: int #poise damage
@export var Crit: float #chance of crit percentage
#endregion

#region cost
@export var StaminaCost: int
@export var ManaCost: int
#endregion
