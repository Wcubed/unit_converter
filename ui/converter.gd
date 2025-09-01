extends VBoxContainer

@onready var input_value := %InputValue

func _on_keypad_number_pressed(number: int) -> void:
	input_value.text += "%d" % number


func _on_keypad_backspace_pressed() -> void:
	input_value.text = input_value.text.left(input_value.text.length() - 1)


func _on_keypad_clear_pressed() -> void:
	input_value.text = ""


func _on_keypad_dot_pressed() -> void:
	if !input_value.text.contains("."):
		input_value.text += "."
