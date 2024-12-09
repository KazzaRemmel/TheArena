class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum: int = 0

func add_item(item, weight: int):
	items.append({"item": item, "weight": weight})
	weight_sum += weight



func remove_item(item_to_remove):
	items = items.filter(func (item): return item["item"] != item_to_remove)
	weight_sum = 0
	for item in items:
		weight_sum += item["weight"]

func pick_item(exclude: Array = []): #thi says if there is no exclude array passed, you can pass an empty array
	var adjusted_items: Array[Dictionary] = items
	var adjusted_weight_sum = weight_sum

	if exclude.size() > 0:
		adjusted_weight_sum = 0
		adjusted_items = []


		for item in items:
			if item["item"] in exclude:
				continue #this makes the for loop continue executing with the next item, as in, the adjusted below do NOT run for this item, move
			adjusted_items.append(item)
			adjusted_weight_sum += item["weight"]

	var chosen_weight = randi_range(1,adjusted_weight_sum)
	var iteration_sum = 0
	for item in adjusted_items:
		iteration_sum += item["weight"] #if the chosen (random) weight is greater than the iteration sum, the object will not be chosen
		if chosen_weight <= iteration_sum: #therefore, the higher weighted objects get chosen more often
			return item["item"]
