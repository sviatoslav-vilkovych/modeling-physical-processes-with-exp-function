extends Button

onready var a_textEdit = get_node("/root/App/CanvasLayer/Interface/Input/Panel/MarginContainer/VBoxContainer/StartPoint_Container/TextEdit")
onready var b_textEdit = get_node("/root/App/CanvasLayer/Interface/Input/Panel/MarginContainer/VBoxContainer/EndPoint_Container/TextEdit")
onready var points_textEdit = get_node("/root/App/CanvasLayer/Interface/Input/Panel/MarginContainer/VBoxContainer/Points_Container/TextEdit")
onready var function_textEdit = get_node("/root/App/CanvasLayer/Interface/Input/Panel/MarginContainer/VBoxContainer/Function_Container/TextEdit")

func _on_Calculate_Button_pressed():
	Singleton.a = float(a_textEdit.text)
	Singleton.b = float(b_textEdit.text)
	Singleton.points = int(points_textEdit.text)
	Singleton.actual_function = function_textEdit.text
