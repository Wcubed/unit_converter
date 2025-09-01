extends PanelContainer

@onready var converter := %Converter
@onready var tabs := %MeasurementTabs

# Available measurements to convert between.
# Text between brackets will be used as abreviation of a unit.
# The value oaf a unit is how many standard SI units fit in there
# For example, a kilometer is 1000 meter, hence it having a value of "1000.0"
var measurements := {
	"Length": {
		"Meters (m)": 1.0,
		"Kilometers (km)": 1000.0,
		"Inches (in)": 0.0254,
		"Feet (ft)": 0.3048,
		"Yards (yr)": 0.9144,
		"Furlong (fur)": 201.16839,
		"Miles (mi)": 1609.344,
		"Nautical Mile (nmi)": 1851.99933,
		"Lightyears (ly)": 9460737900000000,
	},
	"Area": {
		"Square Meters (m²)": 1.0,
		"Square Kilometers (km²)": 1_000_000,
		"Acres (ac)": 4046.86267,
		"Hectares (ha)": 10_000,
		"Square Yards (yd²)": 0.83613,
		"Square Miles (mi²)": 2_589_989.17385,
	},
	"Time": {
		"Seconds (s)": 1.0,
		"Minutes (min)": 60,
		"Hours (h)": 3600,
		"Days (d)": 86_400,
		"Weeks (w)": 604_800,
	}
}

func _ready():
	# Determine screen scaling.
	var designed_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var current_width = DisplayServer.window_get_size(0).x
	
	var global_scale = current_width / float(designed_width)
	get_tree().root.content_scale_factor = global_scale
	
	# Update the measurement tab bar.
	tabs.clear_tabs()
	for measurement in measurements:
		tabs.add_tab(measurement)
	
	converter.update_units(measurements["Length"])


func _on_measurement_tabs_tab_changed(tab: int) -> void:
	var measurement = tabs.get_tab_title(tab)
	converter.update_units(measurements[measurement])
