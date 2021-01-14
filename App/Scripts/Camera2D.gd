extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_released('wheel_down'):
			self.zoom.x += 0.05
			self.zoom.y += 0.05
	if Input.is_action_just_released('wheel_up') and self.zoom.x > 0.05:
			self.zoom.x -= 0.05
			self.zoom.y -= 0.05