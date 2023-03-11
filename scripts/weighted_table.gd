class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum = 0

func add_item(item, weight:int):
	items.append({"item": item, "weight": weight})
	weight_sum += weight


func pick_item():
	#how it works is the chosen_weight is going to be biased to the larger number basically
	var chosen_weight = randi_range(1, weight_sum) #random number to check which item to pick
	var iteration_sum = 0 #total number that picks the top of the weight
	for item in items: 
		iteration_sum += item["weight"] #sums all the weights of each item for percentages
		if chosen_weight <= iteration_sum: #if the random number if 
			return item["item"]

