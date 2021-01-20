extends Label

onready var camera = get_node("/root/App/Plot/Camera2D")

func _process(_delta):
	self.text = String(camera.zoom.x);
