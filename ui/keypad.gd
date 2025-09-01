extends GridContainer

signal number_pressed(number: int)
signal backspace_pressed()
signal clear_pressed()
signal dot_pressed()

func _on__pressed(number: int) -> void:
	number_pressed.emit(number)


func _on_backspace_pressed() -> void:
	backspace_pressed.emit()


func _on_clear_pressed() -> void:
	clear_pressed.emit()


func _on_dot_pressed() -> void:
	dot_pressed.emit()
