extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_released('wheel_down'):
			self.zoom.x = stepify(self.zoom.x + 0.05, 0.01)
			self.zoom.y = stepify(self.zoom.y + 0.05, 0.01)
			Singleton.zoom = self.zoom
	if Input.is_action_just_released('wheel_up') and self.zoom.x > 0.05:
			self.zoom.x = stepify(self.zoom.x - 0.05, 0.01)
			self.zoom.y = stepify(self.zoom.y - 0.05, 0.01)
			Singleton.zoom = self.zoom
