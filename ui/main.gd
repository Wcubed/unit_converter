extends PanelContainer

@onready var converter := %Converter
@onready var tabs := %MeasurementTabs

var measurements := {
	"Length": {
		"Meters": 1.0,
		"Kilometers": 1000.0,
		"Inches": 0.0254,
		"Feet": 0.3048,
		"Yards": 0.9144,
		"Miles": 1609.344,
	},
	"Time": {
		"Seconds": 1.0,
		"Minutes": 60,
		"Hours": 3600,
		"Days": 86_400,
		"Weeks": 604_800,
	}
}

func _ready():
	# Determine screen scaling.
	var designed_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var current_width = DisplayServer.window_get_size(0).x
	
	var scale = current_width / float(designed_width)
	get_tree().root.content_scale_factor = scale
	
	# Update the measurement tab bar.
	tabs.clear_tabs()
	for measurement in measurements:
		tabs.add_tab(measurement)
	
	converter.update_units(measurements["Length"])


func _on_measurement_tabs_tab_changed(tab: int) -> void:
	var measurement = tabs.get_tab_title(tab)
	converter.update_units(measurements[measurement])
