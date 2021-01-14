extends Panel

var VisibilityTween : Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	VisibilityTween = get_node("/root/App/Tween/");
	_on_Panel_mouse_exited()

func _on_Panel_mouse_entered():
	# same problem with false-invocing
	if (self.get_modulate().a > 0.5):
		return
	VisibilityTween.interpolate_property(self, "modulate:a", 0.3, 0.9, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	VisibilityTween.start()


func _on_Panel_mouse_exited():
	if (is_mouse_within_panel()):
		return
	VisibilityTween.interpolate_property(self, "modulate:a", 0.9, 0.3, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	VisibilityTween.start()

func is_mouse_within_panel() -> bool:
	# trying to overcome problem with entering children nodes triggering this event
	var mouse_position = get_viewport().get_mouse_position();
	var panel_lefttop_position = self.get_position()
	var panel_rightbottom_position = panel_lefttop_position + self.get_size()
	return (mouse_position.x < panel_rightbottom_position.x && mouse_position.x > panel_lefttop_position.x) && (mouse_position.y < panel_rightbottom_position.y && mouse_position.y > panel_lefttop_position.y)
