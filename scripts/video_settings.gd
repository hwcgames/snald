extends Node

func apply():
	OS.vsync_enabled = PersistMan.get_key("vsync")
