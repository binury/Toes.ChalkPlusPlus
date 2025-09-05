extends Resource
class_name ColorNameDB

export var csv_path: String setget set_csv_path

var colors := {
}

func set_csv_path(path: String) -> void:
	csv_path = path
	if path != "":
		load_csv(path)

func load_csv(path: String) -> void:
	var f = File.new()
	if not f.file_exists(path):
		push_error("CSV not found: %s" % path)
		return

	f.open(path, File.READ)
	var header = f.get_csv_line()

	while not f.eof_reached():
		var row = f.get_csv_line()
		if row.size() == 0: 
			continue
		if row.size() < 2:
			continue # TODO

		var entry = {
			"name": row[0],
			"hex": row[1],
			"good_name": row[2]
		}
		colors[entry.hex] = entry.name

	f.close()


func _nearest_color_name(c: Color) -> String:
	var best_name := ""
	var best_dist := INF

	for color in colors.keys():
		var color_name: String = colors[color]
		var other: = Color(color)

		# Euclidean distance
		var dist = pow(c.r - other.r, 2) + pow(c.g - other.g, 2) + pow(c.b - other.b, 2)
		if dist < best_dist:
			best_dist = dist
			best_name = color_name

	return best_name


func find_name_for_color(c: String) -> String:
	if c[0] != "#":
		c = "#%s" % c
	if colors.has(c.to_lower()):
		return colors[c.to_lower()]
	
	return _nearest_color_name(Color(c))
