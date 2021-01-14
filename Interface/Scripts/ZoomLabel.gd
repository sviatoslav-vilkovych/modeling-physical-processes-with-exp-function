extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var camera = get_node("/root/App/Plot/Camera2D")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.text = String(camera.zoom.x);
#	pass
