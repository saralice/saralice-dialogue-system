@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("SDS", "res://addons/saralice_dialogue_system/sds.gd")


func _exit_tree():
	remove_autoload_singleton("SDS")
