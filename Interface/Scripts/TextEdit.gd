extends TextEdit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextEdit_focus_entered():
	self.text = ""
	pass # Replace with function body.


func _on_TextEdit_focus_exited():
	if (self.text == ""):
		self.text = "Enter data..."
	pass # Replace with function body.
