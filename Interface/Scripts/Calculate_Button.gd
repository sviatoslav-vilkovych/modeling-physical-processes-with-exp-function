extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

onready var a_textEdit = get_node("/root/App/CanvasLayer/Interface/Input/Panel/MarginContainer/VBoxContainer/StartPoint_Container/TextEdit")
onready var b_textEdit = get_node("/root/App/CanvasLayer/Interface/Input/Panel/MarginContainer/VBoxContainer/EndPoint_Container/TextEdit")
onready var points_textEdit = get_node("/root/App/CanvasLayer/Interface/Input/Panel/MarginContainer/VBoxContainer/Points_Container/TextEdit")
onready var function_textEdit = get_node("/root/App/CanvasLayer/Interface/Input/Panel/MarginContainer/VBoxContainer/Function_Container/TextEdit")

func _on_Calculate_Button_pressed():
	Singleton.a = float(a_textEdit.text)
	Singleton.b = float(b_textEdit.text)
	Singleton.points = int(points_textEdit.text)
	Singleton.actual_function = function_textEdit.text
	pass # Replace with function body.
