extends Node

var McmHelpers = preload("res://ModConfigurationMenu/Scripts/Doink Oink/MCM_Helpers.tres")

const MOD_ID    = "fsr_enabler"
const FILE_PATH = "user://MCM/fsr_enabler"

func _ready():
	var _config = ConfigFile.new()

	_config.set_value("Dropdown", "fsr_mode", {
		"name"    = "FSR Mode",
		"tooltip" = "Upscaling mode. Higher quality = more GPU cost.",
		"default" = "Disabled",
		"value"   = "Disabled",
		"options" = {
			"Disabled":       "Disabled",
			"Native Quality": "Native Quality",
			"Quality":        "Quality",
			"Balanced":       "Balanced",
			"Performance":    "Performance",
		}
	})

	_config.set_value("Float", "sharpness", {
		"name"     = "Sharpness",
		"tooltip"  = "FSR sharpness. Only applies when FSR is enabled.",
		"default"  = 0.5,
		"value"    = 0.5,
		"minRange" = 0.0,
		"maxRange" = 1.0
	})

	_config.set_value("Bool", "debug_info", {
		"name"    = "Debug Info",
		"tooltip" = "Shows current FSR mode and scale on screen",
		"default" = false,
		"value"   = false
	})

	if !FileAccess.file_exists(FILE_PATH + "/config.ini"):
		DirAccess.open("user://").make_dir(FILE_PATH)
		_config.save(FILE_PATH + "/config.ini")
	else:
		McmHelpers.CheckConfigurationHasUpdated(MOD_ID, _config, FILE_PATH + "/config.ini")
		_config.load(FILE_PATH + "/config.ini")

	McmHelpers.RegisterConfiguration(
		MOD_ID,
		"FSR Enabler",
		FILE_PATH,
		"kakka",
		{"config.ini" = _on_config_updated}
	)

func _on_config_updated(config: ConfigFile):
	var main = get_node_or_null("/root/FSREnablerMain")
	if main:
		main.apply_from_config(config)

func get_setting(section: String, key: String, default_val):
	var _config = ConfigFile.new()
	if _config.load(FILE_PATH + "/config.ini") != OK:
		return default_val
	var data = _config.get_value(section, key, null)
	if data is Dictionary and data.has("value"):
		return data["value"]
	return default_val