extends Camera2D

func _process(_delta):
	if Input.is_action_just_released('wheel_down') and self.zoom.x < 1:
			self.zoom.x = stepify(self.zoom.x + 0.05, 0.01)
			self.zoom.y = stepify(self.zoom.y + 0.05, 0.01)
			Singleton.zoom = self.zoom
	if Input.is_action_just_released('wheel_up') and self.zoom.x > 0.5:
			self.zoom.x = stepify(self.zoom.x - 0.05, 0.01)
			self.zoom.y = stepify(self.zoom.y - 0.05, 0.01)
			Singleton.zoom = self.zoom
