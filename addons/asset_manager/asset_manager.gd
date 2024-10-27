@tool
extends EditorPlugin

var dock
class AssetManager extends EditorDebuggerPlugin:

	func _has_capture(prefix):
		# Return true if you wish to handle message with this prefix.
		return prefix == "asset_manager"

	func _capture(message, data, session_id):
		if message == "asset_manager:ping":
			get_session(session_id).send_message("asset_manager:echo", data)

	func _setup_session(session_id):
		# Add a new tab in the debugger session UI containing a label.
		var label = Label.new()
		label.name = "Example plugin"
		label.text = "Example plugin"
		var session = get_session(session_id)
		# Listens to the session started and stopped signals.
		session.started.connect(func (): print("Session started"))
		session.stopped.connect(func (): print("Session stopped"))
		session.add_session_tab(label)

var debugger = AssetManager.new()

func _enter_tree():
	dock = preload("res://addons/asset_manager/main-panel.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_LEFT_UL, dock)


func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()
