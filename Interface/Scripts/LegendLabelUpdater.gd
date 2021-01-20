extends Label

func _ready():
	if (self.name == "ApproxFuncLabel"):
		self.set_text(Singleton.approximation_function)

var cached_actual_function = ""
func _process(delta):
	if (self.name != "ApproxFuncLabel" && Singleton.actual_function != cached_actual_function):
		cached_actual_function = Singleton.actual_function;
		self.set_text(cached_actual_function + " (зашумлена)");
