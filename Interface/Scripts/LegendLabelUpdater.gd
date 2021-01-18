extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if (self.name == "ApproxFuncLabel"):
		self.set_text(Singleton.approximation_function)


var cached_actual_function = ""
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (self.name != "ApproxFuncLabel" && Singleton.actual_function != cached_actual_function):
		cached_actual_function = Singleton.actual_function;
		self.set_text(cached_actual_function);
