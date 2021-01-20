extends Node2D


onready var ScreenSizeOnStart : Vector2;
onready var XSplitPoint;
onready var YSplitPoint;

var ScalePlot = 200
var DataCrv = Curve2D.new()
var DataOrigin : Array
var ApproximationCrv = Curve2D.new()
var ApproximationOrigin : Array

var NoiseRng = RandomNumberGenerator.new()

onready var DataRichTextLabel = get_node("/root/App/CanvasLayer/Interface/Input/Panel/MarginContainer/VBoxContainer/TabContainer/Data/RichTextLabel")
onready var ApproximationRichTextLabel = get_node("/root/App/CanvasLayer/Interface/Input/Panel/MarginContainer/VBoxContainer/TabContainer/Approximation Data/RichTextLabel")

# Called when the node enters the scene tree for the first time.
func _ready():
	ScreenSizeOnStart = get_viewport().size
	XSplitPoint = ScreenSizeOnStart.x / 2
	YSplitPoint = ScreenSizeOnStart.y * 2 / 3
	
	print("| x_size=" + String(ScreenSizeOnStart.x) + ", y_size=" + String(ScreenSizeOnStart.y));
	print("| XSplitPoint=" + String(XSplitPoint) + ", YSplitPoint=" + String(YSplitPoint));
	self.add_child(Utility.add_plot_label("x", Vector2(ScreenSizeOnStart.x - 10, YSplitPoint)));
	self.add_child(Utility.add_plot_label("y", Vector2(XSplitPoint + 5, 0)));

var cached_data = [0, 0, 0]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Singleton.a != cached_data[0] || Singleton.b != cached_data[1] || Singleton.points != cached_data[2]):
		cached_data[0] = Singleton.a
		cached_data[1] = Singleton.b
		cached_data[2] = Singleton.points
		print("StartPoint = " + String(cached_data[0]) + " | EndPoint = " + String(cached_data[1]) + " | PointsAmount = " + String(cached_data[2]))
		var data = Math.generate_data_plot_data(cached_data[0], cached_data[1], cached_data[2])
		data = Math.polute_data_with_noise(data)
		print("X=" + String(data[0]))
		print("Y=" + String(data[1]))
		fill_crv(DataCrv, DataOrigin, data[0], Utility.apply_y_mirror(data[1]))
		fill_richtextlabel(DataRichTextLabel, data, [])
		var abc = Math.calculate_approximation_plot_data_parameters(data[0], data[1], false)
		fill_textedits(abc);
		var approximation_data = Math.generate_approximation_plot_data(data[0], abc[0], abc[1], abc[2])
		fill_crv(ApproximationCrv, ApproximationOrigin, approximation_data[0], Utility.apply_y_mirror(approximation_data[1]))
		fill_richtextlabel(ApproximationRichTextLabel, approximation_data, data)
		# calculate MSE
		var mse = Math.mse(data[1], approximation_data[1]);
		get_node("/root/App/CanvasLayer/Interface/Input/Panel/MarginContainer/VBoxContainer/MSE_Container/TextEdit").set_text(String(mse));
	self.update();

func _on_Plot_draw():
	draw_axes()
	draw_sticks()
	draw_data_plot()
	draw_approximation_plot()

func draw_sticks():
	draw_x_sticks();
	draw_y_sticks();
	pass

func draw_x_sticks():
	var starting_point = Vector2(0 + int(XSplitPoint) % int(ScalePlot), YSplitPoint);
	while (starting_point.x < ScreenSizeOnStart.x):
		draw_line(Vector2(starting_point.x, starting_point.y - 5), Vector2(starting_point.x, starting_point.y + 5), Color.whitesmoke)
		starting_point += Vector2(int(ScalePlot), 0)
	pass
func draw_y_sticks():
	var starting_point = Vector2(XSplitPoint, 0 + int(YSplitPoint) % int(ScalePlot));
	while (starting_point.y < ScreenSizeOnStart.y):
		draw_line(Vector2(starting_point.x - 5, starting_point.y), Vector2(starting_point.x + 5, starting_point.y), Color.whitesmoke)
		starting_point += Vector2(0, int(ScalePlot))
	pass

func draw_axes():
	# x-axis
	draw_line(Vector2(0, YSplitPoint), Vector2(ScreenSizeOnStart.x, YSplitPoint), Color.whitesmoke)
	# y-axis
	draw_line(Vector2(XSplitPoint, 0), Vector2(XSplitPoint, ScreenSizeOnStart.y), Color.whitesmoke)

func draw_data_plot():
	var baked = DataCrv.get_baked_points()
	draw_polyline(baked, Color8(255, 199, 69, 150), 2, true);
	for i in DataOrigin.size():
		draw_circle(DataOrigin[i], 3, Color8(255, 199, 69, 255))
	pass

func draw_approximation_plot():
	draw_polyline(ApproximationCrv.get_baked_points(), Color8(138, 174, 255, 150), 2, true);
	pass

func fill_crv(crv : Curve2D, origin: Array, x : Array, y : Array):
	crv.clear_points()
	origin.resize(x.size())
	for i in range(x.size()):
		var adapted = adapt_to_window(x[i], y[i])
		crv.add_point(adapted)
		origin[i] = adapted

func fill_richtextlabel(richTextLabel: RichTextLabel, data : Array, to_delta_data : Array):
	richTextLabel.clear();
	for i in data[0].size():
		var x = stepify(data[0][i], 0.000001)
		var y = stepify(data[1][i], 0.000001)
		if (to_delta_data.size() != 0):
			var delta_y = stepify(abs(to_delta_data[1][i] - data[1][i]), 0.000001)
			richTextLabel.add_text("x = " + (" " if x > 0 else "") + String(x) + ",\ty = " + String(y) + ",\tdelta = " + String(delta_y))	
		else:
			richTextLabel.add_text("x = " + (" " if x > 0 else "") + String(x) + ",\ty = " + String(y))
		richTextLabel.newline()

func fill_textedits(abc):
	get_node("/root/App/CanvasLayer/Interface/Input/Panel/MarginContainer/VBoxContainer/StartPoint_Container/TextEdit").set_text(String(Singleton.a))
	get_node("/root/App/CanvasLayer/Interface/Input/Panel/MarginContainer/VBoxContainer/EndPoint_Container/TextEdit").set_text(String(Singleton.b))
	get_node("/root/App/CanvasLayer/Interface/Input/Panel/MarginContainer/VBoxContainer/Points_Container/TextEdit").set_text(String(Singleton.points))
	get_node("/root/App/CanvasLayer/Interface/Input/Panel/MarginContainer/VBoxContainer/Function_Container/TextEdit").set_text(Singleton.actual_function)
	
	get_node("/root/App/CanvasLayer/Interface/Input/Panel/MarginContainer/VBoxContainer/HBoxContainer/A_Container/TextEdit").set_text(String(abc[0]))
	get_node("/root/App/CanvasLayer/Interface/Input/Panel/MarginContainer/VBoxContainer/HBoxContainer/B_Container/TextEdit").set_text(String(abc[1]))
	get_node("/root/App/CanvasLayer/Interface/Input/Panel/MarginContainer/VBoxContainer/HBoxContainer/C_Container/TextEdit").set_text(String(abc[2]))
	pass
func adapt_to_window(x, y) -> Vector2:
	return Vector2(x*ScalePlot + XSplitPoint, y*ScalePlot + YSplitPoint)
