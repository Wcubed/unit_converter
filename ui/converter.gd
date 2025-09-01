extends VBoxContainer

@onready var input_value := %InputValue
@onready var output_value := %OutputValue

@onready var input_units := %InputUnits
@onready var output_units := %OutputUnits
@onready var input_abr := %InputAbbreviation
@onready var output_abr := %OutputAbbreviation

# What to multiply the input value with to get to a standard SI unit.
var to_standard_unit := 1.0
# What to multiply the standard SI unit with to get to the output unit.
var to_output_unit := 1.0

# List of units, and how many they are of the standard SI unit for this measurement.
var units := {}

var abbreviations := {
	# Lengths
	"Meters": "m",
	"Kilometers": "km",
	"Inches": "in",
	"Feet": "ft",
	"Yards": "yd",
	"Miles": "mi",
	# Time
	"Seconds": "s",
	"Minutes": "min",
	"Hours": "h",
	"Days": "d",
	"Weeks": "w",
}

# Update the available list of units
func update_units(new_units: Dictionary):
	units = new_units
	input_units.clear()
	output_units.clear()
	
	for unit in units:
		input_units.add_item(unit)
		output_units.add_item(unit)
	
	input_units.select(0)
	output_units.select(1)
	
	input_or_output_unit_changed()

func _on_keypad_number_pressed(number: int) -> void:
	input_value.text += "%d" % number
	recalculate_output()


func _on_keypad_backspace_pressed() -> void:
	input_value.text = input_value.text.left(input_value.text.length() - 1)
	recalculate_output()


func _on_keypad_clear_pressed() -> void:
	input_value.text = ""
	recalculate_output()


func _on_keypad_dot_pressed() -> void:
	if !input_value.text.contains("."):
		input_value.text += "."
		recalculate_output()

func _on_keypad_swap_pressed() -> void:
	# Swap the input and output unit.
	var input_index = input_units.selected
	input_units.select(output_units.selected)
	output_units.select(input_index)
	
	input_or_output_unit_changed()

func input_or_output_unit_changed():
	var unit_name: String = input_units.get_item_text(input_units.selected)
	var unit_value = units[unit_name]
	to_standard_unit = unit_value
	input_abr.text = abbreviations[unit_name]
	
	unit_name = output_units.get_item_text(output_units.selected)
	unit_value = units[unit_name]
	to_output_unit = 1/float(unit_value)
	output_abr.text = abbreviations[unit_name]
	
	recalculate_output()

func recalculate_output():
	if input_value.text.is_empty():
		output_value.text = ""
	else:
		var input = float(input_value.text)
		var standard_unit = input * float(to_standard_unit)
		var output = standard_unit * float(to_output_unit)
		
		output_value.text = display_float_without_nonsignificant_zeroes(output)


func _on_input_units_item_selected(index: int) -> void:
	input_or_output_unit_changed()


func _on_output_units_item_selected(index: int) -> void:
	input_or_output_unit_changed()


func _on_paste_button_pressed() -> void:
	var value = float(DisplayServer.clipboard_get())
	input_value.text = display_float_without_nonsignificant_zeroes(value)
	recalculate_output()

func _on_copy_button_pressed() -> void:
	DisplayServer.clipboard_set(output_value.text)

func display_float_without_nonsignificant_zeroes(input: float) -> String:
	var text = "%f" % input
	
	# Remove trailing nonsignificant zeroes
	if text.contains("."):
		while text.ends_with("0"):
			text = text.trim_suffix("0")
		# A trailing "." is not necessary
		text = text.trim_suffix(".")
	
	return text
