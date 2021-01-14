extends Node2D


onready var ScreenSizeOnStart : Vector2;
onready var XSplitPoint;
onready var YSplitPoint;

var ScalePlot = 70
var DataCrv = Curve2D.new()
var ApproximationCrv = Curve2D.new()
var NoiseRng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	ScreenSizeOnStart = get_viewport().size
	XSplitPoint = ScreenSizeOnStart.x / 2
	YSplitPoint = ScreenSizeOnStart.y * 2 / 3
	
	print("| x_size=" + String(ScreenSizeOnStart.x) + ", y_size=" + String(ScreenSizeOnStart.y));
	print("| XSplitPoint=" + String(XSplitPoint) + ", YSplitPoint=" + String(YSplitPoint));
	self.add_child(Utility.add_plot_label("x", Vector2(ScreenSizeOnStart.x - 10, YSplitPoint)));
	self.add_child(Utility.add_plot_label("y", Vector2(XSplitPoint + 5, 0)));
	
	
	
	# newton
	#newit(approximation_data, abc, data);

func newit(approximation_data, abc, data):
	var new_approximation_data = approximation_data
	var current_guess = abc
	for i in 3:
		var next_guess = Math.newton_iteration(data[0], data[1], current_guess)
		new_approximation_data = Math.generate_approximation_plot_data(data[0], next_guess[0], next_guess[1], next_guess[2])
		fill_crv(ApproximationCrv, data[0], Utility.apply_y_mirror(new_approximation_data[1]))
		current_guess = next_guess
		print("ABC_newtons=" + String(current_guess))

var cached_data = [0, 0, 0]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Singleton.a != cached_data[0] || Singleton.b != cached_data[1] || Singleton.points != cached_data[2]):
		cached_data[0] = Singleton.a
		cached_data[1] = Singleton.b
		cached_data[2] = Singleton.points
		var data = Math.generate_data_plot_data(cached_data[0], cached_data[1], cached_data[2])
		print("X=" + String(data[0]))
		print("Y=" + String(data[1]))
		fill_crv(DataCrv, data[0], Utility.apply_y_mirror(data[1]))
		var abc = Math.calculate_approximation_plot_data_parameters(data[0], data[1], false)
		var approximation_data = Math.generate_approximation_plot_data(data[0], abc[0], abc[1], abc[2])
		fill_crv(ApproximationCrv, approximation_data[0], Utility.apply_y_mirror(approximation_data[1]))
		self.update();

func _on_Plot_draw():
	draw_axes()
	draw_data_plot()
	draw_approximation_plot()

func draw_axes():
	# x-axis
	draw_line(Vector2(0, YSplitPoint), Vector2(ScreenSizeOnStart.x, YSplitPoint), Color.whitesmoke)
	# y-axis
	draw_line(Vector2(XSplitPoint, 0), Vector2(XSplitPoint, ScreenSizeOnStart.y), Color.whitesmoke)

func draw_data_plot():
	draw_polyline(DataCrv.get_baked_points(), Color.red, 2, true);
	pass

func draw_approximation_plot():
	draw_polyline(ApproximationCrv.get_baked_points(), Color.blue, 2, true);
	pass

func fill_crv(crv : Curve2D, x : Array, y : Array):
	crv.clear_points()
	for i in range(x.size()):
		crv.add_point(adapt_to_window(x[i], y[i]))

func adapt_to_window(x, y) -> Vector2:
	return Vector2(x*ScalePlot + XSplitPoint, y*ScalePlot + YSplitPoint)
