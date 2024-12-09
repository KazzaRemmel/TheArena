extends Node

const SPAWN_RADIUS = 350
@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var bat_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer = $Timer


var enemy_table = WeightedTable.new()
var base_spawn_time = 0
var number_to_spawn = 1

func _ready():
	enemy_table.add_item(basic_enemy_scene, 10)
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)



func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO

	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0,TAU))

	for i in 4: #runs from 0 to 3 (4 times)

		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		var additional_check_offset = random_direction*20 #we dont want to spawn the enemy exactly at the ray end, what if the ray end is 1px away from the wall?
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additional_check_offset,1 << 0) #create a raycast that goes from player to the spawn position of enemy, with collision mask 1, shifted 0 bits. Bit shifting has to be done, with its value being collision layer of the object we're looking for minus one (in this case the terrain i.e. the wall)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters) #shoot the ray and check if it collides
		if result.is_empty():
			#this means there is no wall in the direction that we're asking the enemy to spawn at, so all good
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90)) #let's check another direction to spawn the enemy

	return spawn_position









func on_timer_timeout():
	timer.start()

	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	for i in number_to_spawn:
		var enemy_scene = enemy_table.pick_item()
		var enemy = enemy_scene.instantiate() as Node2D

		var entities_layer = get_tree().get_first_node_in_group("entities_layer")
		entities_layer.add_child(enemy)
		enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int):

	var time_off = (.1/12) * arena_difficulty #there are 12 (5 second) intervals in a minute, and here, the goal to decrease by .1 every minute, so every 5 seconds, the spawn timer is decreased by 0.1/12, until eventualy you hit the minute mark, the spawn time becomes 0.9
	time_off = min(time_off, .7) #clamping the time off to 0.7 as a max, so spawn time is min 0.3
	timer.wait_time = base_spawn_time - time_off

	if arena_difficulty == 6:
		enemy_table.add_item(wizard_enemy_scene, 15)
	elif arena_difficulty == 18:
		enemy_table.add_item(bat_enemy_scene, 10)

	if (arena_difficulty % 6) == 0:
		number_to_spawn += 1
