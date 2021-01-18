extends MarginContainer

var VisibilityTween : Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	VisibilityTween = get_node("/root/App/Tween/");
	_on_Container_mouse_exited()

func is_mouse_within_container() -> bool:
	# trying to overcome problem with entering children nodes triggering this event
	var mouse_position = get_viewport().get_mouse_position();
	var container_lefttop_position = self.get_position()
	var container_rightbottom_position = container_lefttop_position + self.get_size()
	return (mouse_position.x < container_rightbottom_position.x && mouse_position.x > container_lefttop_position.x) && (mouse_position.y < container_rightbottom_position.y && mouse_position.y > container_lefttop_position.y)

func _on_Container_mouse_entered():
	# same problem with false-invocing
	if (self.get_modulate().a > 0.5):
		return
	VisibilityTween.interpolate_property(self, "modulate:a", 0.3, 0.95, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	VisibilityTween.start()

func _on_Container_mouse_exited():
	if (is_mouse_within_container()):
		return
	VisibilityTween.interpolate_property(self, "modulate:a", 0.95, 0.3, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	VisibilityTween.start()
