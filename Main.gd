extends Node

const FILE_PATH = "user://MCM/fsr_enabler/config.ini"

const DEF_MODE      = "Disabled"
const DEF_SHARPNESS = 0.5
const DEF_DEBUG     = false

var current_mode      : String = DEF_MODE
var current_sharpness : float  = DEF_SHARPNESS
var debug_info        : bool   = DEF_DEBUG

var _debug_label : Label = null
var _last_scene : Node = null

func _ready():
    process_priority = 10000
    process_mode = Node.PROCESS_MODE_ALWAYS
    _init_debug_label()
    _load_and_apply()
    get_tree().tree_changed.connect(_on_tree_changed)
    print("[FSRZone] Loaded")

func _on_tree_changed():
    var current = get_tree().current_scene
    if current != null and current != _last_scene:
        _last_scene = current
        _reapply_after_scene_change()

func _reapply_after_scene_change() -> void:
    await get_tree().process_frame
    _apply_all()

    await get_tree().process_frame
    _apply_all()

    await get_tree().create_timer(0.25).timeout
    _apply_all()

    await get_tree().create_timer(0.75).timeout
    _apply_all()

    print("[FSRZone] FSR reapplied after map change")

func _init_debug_label():
    var layer = CanvasLayer.new()
    layer.layer = 100
    add_child(layer)

    _debug_label = Label.new()
    _debug_label.position = Vector2(10, 10)
    _debug_label.add_theme_font_size_override("font_size", 14)
    _debug_label.visible = false
    layer.add_child(_debug_label)

func _load_and_apply():
    var cfg = ConfigFile.new()
    if cfg.load(FILE_PATH) != OK:
        _apply_all()
        return
    apply_from_config(cfg)

func apply_from_config(cfg: ConfigFile):
    current_mode      = _get(cfg, "Dropdown", "fsr_mode",   DEF_MODE)
    current_sharpness = _get(cfg, "Float",    "sharpness",  DEF_SHARPNESS)
    debug_info        = _get(cfg, "Bool",     "debug_info", DEF_DEBUG)
    _apply_all()

func _get(cfg: ConfigFile, section: String, key: String, default):
    var data = cfg.get_value(section, key, null)
    if data is Dictionary and data.has("value"):
        return data["value"]
    return default

func _apply_all():
    _apply_fsr()
    _apply_debug()

func _apply_fsr():
    var rid = get_viewport().get_viewport_rid()

    match current_mode:
        "Disabled":
            RenderingServer.viewport_set_scaling_3d_mode(rid, RenderingServer.VIEWPORT_SCALING_3D_MODE_BILINEAR)
            RenderingServer.viewport_set_scaling_3d_scale(rid, 1.0)
        "Native Quality":
            RenderingServer.viewport_set_scaling_3d_mode(rid, RenderingServer.VIEWPORT_SCALING_3D_MODE_FSR2)
            RenderingServer.viewport_set_scaling_3d_scale(rid, 1.0)
        "Quality":
            RenderingServer.viewport_set_scaling_3d_mode(rid, RenderingServer.VIEWPORT_SCALING_3D_MODE_FSR2)
            RenderingServer.viewport_set_scaling_3d_scale(rid, 0.77)
        "Balanced":
            RenderingServer.viewport_set_scaling_3d_mode(rid, RenderingServer.VIEWPORT_SCALING_3D_MODE_FSR2)
            RenderingServer.viewport_set_scaling_3d_scale(rid, 0.67)
        "Performance":
            RenderingServer.viewport_set_scaling_3d_mode(rid, RenderingServer.VIEWPORT_SCALING_3D_MODE_FSR2)
            RenderingServer.viewport_set_scaling_3d_scale(rid, 0.5)

    if current_mode != "Disabled":
        RenderingServer.viewport_set_fsr_sharpness(rid, current_sharpness)

    print("[FSRZone] Mode: ", current_mode, " | Sharpness: ", current_sharpness)

func _apply_debug():
    if not is_instance_valid(_debug_label):
        return

    if not debug_info or current_mode == "Disabled":
        _debug_label.visible = false
        return

    var scale_map = {
        "Disabled":       1.0,
        "Native Quality": 1.0,
        "Quality":        0.77,
        "Balanced":       0.67,
        "Performance":    0.5
    }
    var scale = scale_map.get(current_mode, 1.0)
    _debug_label.text = "FSR Enabler | Mode: %s | Scale: %.0f%% | Sharpness: %.2f" % [
        current_mode,
        scale * 100.0,
        current_sharpness
    ]
    _debug_label.visible = true