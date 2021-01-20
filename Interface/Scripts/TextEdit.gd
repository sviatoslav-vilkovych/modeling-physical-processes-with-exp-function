extends TextEdit

func _on_TextEdit_focus_entered():
	self.text = ""

func _on_TextEdit_focus_exited():
	if (self.text == ""):
		self.text = "Enter data..."
