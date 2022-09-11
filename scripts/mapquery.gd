extends Node

func query(filter: Dictionary) -> Array:
	var map = $"/root/gameplay/QodotMap"
	if not map is QodotMap:
		return []
	var matches = []
	for child in map.get_children():
		if not child is QodotEntity:
			continue
		var properties = child.properties
		var ok = true
		for key in filter.keys():
			var still_ok = properties[key] == filter[key] if key in properties else true
			if not still_ok:
				ok = false;
				break
		if ok:
			matches.push_front(child)
	return matches
