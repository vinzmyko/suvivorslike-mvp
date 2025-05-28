class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum = 0

func add_item(item, weight:int):
	items.append({"item": item, "weight": weight})
	weight_sum += weight


func remove_item(item_to_remove):
	#return all the items that != item_to_remove
	items = items.filter(func (item): return item["item"] != item_to_remove)
	# recalculate the weight_sum for all the new items since we removed one
	weight_sum = 0
	for item in items:
		weight_sum += item["weight"]


func pick_item(exclude: Array = []):
	var adjusted_items: Array[Dictionary] = items
	var adjusted_weight_sum = weight_sum
	if exclude.size() > 0:
		adjusted_items = []
		adjusted_weight_sum = 0
		for item in items: #iteration through original items array
			if item["item"] in exclude: #if the current item were looping through is in the exclude array
				continue # go to the next iteration. ie. next item in the items array
			adjusted_items.append(item)
			adjusted_weight_sum += item["weight"]
	
	#how it works is the chosen_weight is going to be biased to the larger number basically
	var chosen_weight = randi_range(1, adjusted_weight_sum) #random number to check which item to pick
	var iteration_sum = 0 #total number that picks the top of the weight
	for item in adjusted_items: 
		iteration_sum += item["weight"] #sums all the weights of each item for percentages
		if chosen_weight <= iteration_sum: #if the random number if 
			return item["item"]

