class_name Utility

static func create_2d_array(width, height, value):
	var a = []
	for y in range(height):
		a.append([])
		a[y].resize(width)
		for x in range(width):
			a[y][x] = value
	return a

static func add_plot_label(text, position):
	var label = Label.new()
	label.text = text;
	label.set_position(position)
	return label;
	
static func apply_y_mirror(y) -> Array:
	var m = []
	m.resize(y.size())
	for i in y.size():
		m[i] = -y[i]
	return m;
