extends PanelContainer

func _ready():
	# Determine screen scaling.
	var designed_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var current_width = DisplayServer.window_get_size(0).x
	
	var scale = current_width / float(designed_width)
	get_tree().root.content_scale_factor = scale
