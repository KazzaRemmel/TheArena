extends Node

const BASE_RANGE = 100
const BASE_DAMAGE = 15

var anvil_count = 0
@export var anvil_ability_scene: PackedScene

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var additional_rotation_degrees = 360.0 / (anvil_count + 1)
	var anvil_distance = randf_range(0, BASE_RANGE)

	for i in anvil_count + 1:

		var adjusted_direction = direction.rotated(deg_to_rad(i * additional_rotation_degrees))
		var spawn_position = player.global_position + ( adjusted_direction * anvil_distance )
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position ,1 << 0) #create a raycast that goes from player to the spawn position of enemy, with collision mask 1, shifted 0 bits. Bit shifting has to be done, with its value being collision layer of the object we're looking for minus one (in this case the terrain i.e. the wall)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters) #shoot the ray and check if it collides
		if !result.is_empty():
			spawn_position = result["position"]

		var anvil_ability = anvil_ability_scene.instantiate()
		get_tree().get_first_node_in_group("foreground_layer").add_child(anvil_ability)
		anvil_ability.global_position = spawn_position
		anvil_ability.hitbox_component.damage = BASE_DAMAGE

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrade: Dictionary):
	if upgrade.id == "anvil_count":
		anvil_count = current_upgrade["anvil_count"]["quantity"]

