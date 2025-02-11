

--    Coded by Milton.XD
--    author: Milton.XD
local render_world_to_screen, rage_exploit, ui_get_binds, ui_get_alpha, entity_get_players, entity_get, entity_get_entities, entity_get_game_rules, common_set_clan_tag, common_is_button_down, common_get_username, common_get_date, ffi_cast, ffi_typeof, render_gradient, render_text, render_texture, render_rect_outline, render_rect, entity_get_local_player, ui_create, ui_get_style, math_floor, math_abs, math_max, math_ceil, math_min, math_random, utils_trace_bullet, render_screen_size, render_load_font, render_load_image_from_file, render_measure_text, render_poly, render_poly_blur, common_add_notify, common_add_event, utils_console_exec, utils_execute_after, utils_create_interface, utils_trace_line, ui_find, entity_get_threat, string_format, hooked_function, entity_get_player_resource, common_get_unixtime, table_insert = render.world_to_screen, rage.exploit, ui.get_binds, ui.get_alpha, entity.get_players, entity.get, entity.get_entities, entity.get_game_rules, common.set_clan_tag, common.is_button_down, common.get_username, common.get_date, ffi.cast, ffi.typeof, render.gradient, render.text, render.texture, render.rect_outline, render.rect, entity.get_local_player, ui.create, ui.get_style, math.floor, math.abs, math.max, math.ceil, math.min, math.random, utils.trace_bullet, render.screen_size, render.load_font, render.load_image_from_file, render.measure_text, render.poly, render.poly_blur, common.add_notify, common.add_event, utils.console_exec, utils.execute_after, utils.create_interface, utils.trace_line, ui.find, entity.get_threat, string.format, nil, entity.get_player_resource, common.get_unixtime, table.insert

ui.sidebar("Venture", "star-shooting")
local lib = {
    gradient = require("neverlose/gradient")
}
local timer = require("neverlose/timer")
local drag_system = require("neverlose/drag_system")
local base64 = require ("neverlose/base64")
local clipboard = require ("neverlose/clipboard")
local pui = require("neverlose/pui")
local JSON = panorama.loadstring([[
        return {
stringify: JSON.stringify,
parse: JSON.parse
};
]])()

local playtime = db.venture_playtime or 0
local x_add_lua = 0
local x_add_dt = 0
local x_add_os = 0
local x_add_rect = 0

scope_animation = function(check, start_val, end_val, speed)
    if check then
        return math.max(start_val + (end_val - start_val) * globals.frametime * speed, 0)
    else
        return math.max(start_val - (end_val + start_val) * globals.frametime * speed / 2, 0)
    end
end

local refs = {
    hideshots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    mindmg = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"),
    lag = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
    hsopt = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
    fd = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    enable = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"),
    yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
    hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
    yawbase = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
    yawoffset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    yawmod = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
    yawoff = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
    bodyyaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
    inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
    left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
    right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
    options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
    pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
    freestand = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
    disableyaw = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
    bodyfrees = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
    removesc = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"),
    slow = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    legs = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    strafe = ui.find("Miscellaneous", "Main", "Movement", "Air Strafe"),
    ap = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"),
    legs = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    scope = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"),
    hc = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"),
    --hc = ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Hit Chance"),
    DA = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Dormant Aimbot"),
    Body = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
    safepoint = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"),
    fping = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),

}


local groups = {
    verify = pui.create("\f<house>", "Verify System", 1),
    main1 = pui.create("\f<house>", "Venture ", 1),
    main2 = pui.create("\f<house>", "", 1),
    main5 = pui.create("\f<house>", "Recomendations", 1),
    main3 = pui.create("\f<house>", "Main ", 2),
    main4 = pui.create("\f<house>", " ", 2),

    aa1 = pui.create("\f<shield>", "\f<shield> Anti-Aim ", 1),
    aa2 = pui.create("\f<shield>", "\f<triangle-exclamation> Anti-Brute Force ", 1),
    aa3 = pui.create("\f<shield>", "Main ", 2),
    aa4 = pui.create("\f<shield>", "Defensive ", 2),

    misc1 = pui.create("\f<person>", " ", 1),
    misc2 = pui.create("\f<person>", "Settings ", 2),
}

local reqs = {
    style = ui.get_style "Button",
}


groups.main1:label("\a928491FF\f<user>    \aDBDBDBFFuser:")
groups.main1:button(common.get_username(), function() end, true)
groups.main1:label("\a928491FF\f<code-compare>   \aDBDBDBFF update:")
groups.main1:button("04.2.v2", function() end, true)
groups.main1:label("\a928491FF\f<paper-plane>   \aDBDBDBFF version:")
groups.main1:button("secret", function() end, true)

-- groups.main1:label("\f<user>".."   Welcome, \b"..style_hex.."\bFFFFFFFF["..common.get_username().."]")
-- groups.main1:label("\f<pen-to-square>".."\bFFFFFFFF\b"..style_hex.."[   Latest Update - 24.06.2024]")


local menu_items = {
        main = {
            links = groups.main5:label("\a928491FF\f<share-from-square>\aDBDBDBFF   links"),
            discord_button = groups.main5:button("\aFFFFFFFF\f<discord>  Discord ", function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/xUE2k7gmUz") end, true),
            youtube_button = groups.main5:button("\aFFFFFFFF \f<youtube>  Youtube  ", function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@stormzhvh") end, true),            
            wmk_color = groups.main5:color_picker("\a928491FF\f<palette>\aDBDBDBFF          -  Select the Accent Color  -", 146, 132, 145, 255),

        
            home_info = groups.main2:list("", "Configs", "Venture "),
            inc_label = groups.main2:label("                 \aFFFFFFFF          -    venture ®    -     "),
            upgrade = groups.main3:list("", "Upgrade to Secret"),
            upgrade_label = groups.main3:label("Join discord  ->  Prices"),
            upgrade_discord_button = groups.main3:button("\aFFFFFFFF \f<discord>  Discord ", function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/xUE2k7gmUz") end, true),

            groups.main3:label("\a928491FF \f<clock>   \aF2F2F2FFPlaytime"),
            playtime_button = groups.main3:button("dsada", function() end, true),

        },

        aa = {
            enable_aa = groups.aa1:switch("\f<user-shield> Toggle Venture Anti-Aim"),
            style_aa = groups.aa1:list("Anti-Aim type", "None", "\f<cloud-bolt>  Presets", "\f<gear>  Antiaim Builder", "\f<folder>  Settings"),

            fs_disablers = groups.aa3:selectable("Freestand Disablers", {"Fakelag", "Standing", "Moving", "Slowmode", "Crouching", "Crouch Move", "In Air", "Air Crouch"}),
            force_defensive = groups.aa3:selectable("Defensives Conditions", {"Global", "Standing", "Moving", "Slowmode", "Crouching", "Crouch Move", "In Air", "Air Crouch"}),
            manual_yaw = groups.aa3:combo("Manuals & FS", {"Disabled", "Left", "Right", "Freestanding"}),
            anims = groups.aa3:selectable("Anim. Breakers", {"Static legs in Air", "Follow Direction", "Jitter Legs", "Body Lean"}), 
            auto_tp = groups.aa3:switch("Auto Teleport"),
            avoid_backstab = groups.aa3:switch("Avoid Backstab"),
            safe_head = groups.aa3:switch("Safe Head"), 

            preset_list = groups.aa3:list("","              <None Preset Selected>", "meta ", "aggressive ", "jitter ", "delay", "\aDBDBDBFFslow - \a4D4D4DFF[beta]", "\aDBDBDBFFfast delay - \a4D4D4DFF[beta]", "\aDBDBDBFFmanipulation - \a4D4D4DFF[beta]", "\aDBDBDBFFbrute-force - \a4D4D4DFF[beta]", "\aDBDBDBFFbrute-force 2 - \a4D4D4DFF[secret]", "\aDBDBDBFFbrute-force 3 - \a4D4D4DFF[secret]"),
            discord_preset = groups.aa3:label("More Presets can be found in our discord"),
            --preset_list = groups.aa3:list("", "             <None Preset Selected>", "meta ", "aggressive ", "jitter ", "delay", "\aDBDBDBFFslow - \a4D4D4DFF[beta]", "\aDBDBDBFFfast delay - \a4D4D4DFF[beta]", "\aDBDBDBFFlag jitter - \a4D4D4DFF[beta]", "\aDBDBDBFFmanipulation - \a4D4D4DFF[beta]"),
            none_builder = groups.aa3:label("        Neverlose Angles is set as default       \n          Select Presets or Entire Builder  "),
            state_condition = groups.aa3:combo("Player State", {"Fakelag", "Standing", "Moving", "Slowmode", "Crouching", "Crouch Move", "In Air", "Air Crouch"})
        },
        settings = {
            list = groups.misc1:list("", "Visuals", "Modifications"),
            toggle_settings = groups.misc1:switch("Activate Visuals & Modifications", false),
            logs = groups.misc2:switch("Render Events", false),
            crosshair_indicators = groups.misc2:switch("Crosshair Widgets", false),
            aspect_ratio = groups.misc2:switch("Aspect Ratio", false), 
            scope_overlay = groups.misc2:switch("Scope Overlay", false), 
            performance_mode = groups.misc2:switch("Optimize Cvars", false),
            viewmodel = groups.misc2:switch("Viewmodel", false), 
            override_indicator = groups.misc2:switch("Override Indicator", false), 
            skeet_indicators = groups.misc2:switch("500$ Indicator", false), 
            debug_panel = groups.misc2:switch("Debug Panel", false), 

        -- settings
            trashtalk = groups.misc2:switch("Trashtalk", false),
            fake_latency = groups.misc2:switch("Fake Latency", false),
            hitchance = groups.misc2:switch("Air Hitchance", false),
            ragebot_logic = groups.misc2:switch("Resolver Logic", false),
            esp_list = groups.misc2:list("Flags in ESP Section", "Revolver Helper", "Scout Body Damage"), 
        },
}
menu_items.main.upgrade_label:tooltip("Cheaper Prices")
menu_items.main.upgrade_discord_button:tooltip("Cheaper Prices")
local gears = {
    auto_tp_gear = menu_items.aa.auto_tp:create(),
    force_defensive_gear = menu_items.aa.force_defensive:create(),
    aspect_ratio_gear = menu_items.settings.aspect_ratio:create(),
    scope_overlay_gear = menu_items.settings.scope_overlay:create(),
    performance_mode_gear = menu_items.settings.performance_mode:create(),
    viewmodel_gear = menu_items.settings.viewmodel:create(),
    override_indicator_gear = menu_items.settings.override_indicator:create(),
    skeet_indicators_gear = menu_items.settings.skeet_indicators:create(),
    fake_latency_gear = menu_items.settings.fake_latency:create(),
    logs_gear = menu_items.settings.logs:create(),
    hitchance_gear = menu_items.settings.hitchance:create(),
    ragebot_logic_gear = menu_items.settings.ragebot_logic:create(),
    crosshair_indicators_gear = menu_items.settings.crosshair_indicators:create(),
    trashtalk_gear = menu_items.settings.trashtalk:create(),
}
  
    local aspect_ratio_slider = gears.aspect_ratio_gear:slider("Proportion", 0, 200, 0, 0.01)


local gears_items = {

    crosshair_style = gears.crosshair_indicators_gear:combo("Style", "Simple", "Modern", "Solid"),
    y_padding = gears.crosshair_indicators_gear:slider("Y", -100, 100, 0),
    x_padding = gears.crosshair_indicators_gear:slider("X", -100, 100, 0),
    crosshair_accent = gears.crosshair_indicators_gear:color_picker("Accent", color(104,236,86,255)),
    crosshair_other = gears.crosshair_indicators_gear:color_picker("Other", color(255,255,255,255)),
    crosshair_build = gears.crosshair_indicators_gear:switch("Version", true),

    teleport_weapon = gears.auto_tp_gear:selectable("Weapon", {"Taser", "Knife", "Scout", "AWP", "Shotgun", "Pistols"}):depend({ menu_items.aa.enable_aa , true },{ menu_items.aa.enable_aa , true }),
    disable_tp = gears.auto_tp_gear:selectable("Disable", {"Peek Assist", "CT Team"}):depend({ menu_items.aa.enable_aa , true },{ menu_items.aa.enable_aa , true }),
    defensive_type = gears.force_defensive_gear:combo("Trigger", {"Always On", "On Peek"}),

    --SETITNGS -- Visuals
    aspect_ratio_169 = gears.aspect_ratio_gear:button(" 16:9  ", function() aspect_ratio_slider:set(177) end),
    aspect_ratio_1610 = gears.aspect_ratio_gear:button("16:10 ", function() aspect_ratio_slider:set(160) end),
    aspect_ratio_32 = gears.aspect_ratio_gear:button("   3:2  ", function() aspect_ratio_slider:set(150) end),
    aspect_ratio_43 = gears.aspect_ratio_gear:button("  4:3   ", function() aspect_ratio_slider:set(133) end),
    aspect_ratio_54 = gears.aspect_ratio_gear:button("  5:4   ", function() aspect_ratio_slider:set(125) end),


    scope_inverted = gears.scope_overlay_gear:switch("Inverted", false),
    scope_gap = gears.scope_overlay_gear:slider("Gap", 0, 500, 5),
    scope_size = gears.scope_overlay_gear:slider("Size", 0, 500, 75),
    scope_color = gears.scope_overlay_gear:color_picker("Color", color(255,255,255,118)),

    optimise_mode = gears.performance_mode_gear:combo("Quality", "Low", "Normal", "High"),

    viewmodel_fov = gears.viewmodel_gear:slider("Field of View", 0, 1000, 680, 0.1),
    viewmodel_xoff = gears.viewmodel_gear:slider("Offset X", -100, 100, 25, 0.1),
    viewmodel_yoff = gears.viewmodel_gear:slider("Offset Y", -100, 100, 0, 0.1),
    viewmodel_zoff = gears.viewmodel_gear:slider("Offset Z", -100, 100, -15, 0.1),

    override_indicator_options =  gears.override_indicator_gear:selectable("Indicator", "Damage", "Hitchance"),
    override_indicator_font =  gears.override_indicator_gear:list("Font", "Defualt", "Small", "Console", "Bold"),
    override_indicator_color =  gears.override_indicator_gear:color_picker("Color"),

    skeet_indicators_sel = gears.skeet_indicators_gear:selectable("500$ Indicators:",{ 'Double Tap', 'Hideshots', 'Minimum Damage', 'Body Aim', 'Hitchance', 'Dormant Aimbot', 'Safepoint','Freestanding', 'Fake Duck', "Ping" }, 0),
    skeet_padding = gears.skeet_indicators_gear:slider("Padding", -200, 200, 0),


        --SETITNGS -- modifications
    trashtalk_death = gears.trashtalk_gear:switch("Enable on Death"),
    fake_latency_amount = gears.fake_latency_gear:slider("Amount", 0, 200, 200),

    logs_events = gears.logs_gear:selectable("Events", "Aimbot", "Anti-Brute"),
    watermark_position = gears.logs_gear:combo("Position", {"Top Right", "Top Left", "Top", "Bottom Right", "Bottom Left", "Bottom"}, 0),
    logs_option = gears.logs_gear:selectable("Logs Options", { 'Console', 'Screen' }, 0),
    hit_color = gears.logs_gear:color_picker("Hit", color(255,241,218,255)),
    miss_color = gears.logs_gear:color_picker("Missed", color(255,241,218,255)),
    border_switch = gears.logs_gear:switch("Border", false),
    border_types = gears.logs_gear:selectable("Types", { 'Shadow', 'Outline' }, 0),
    border_thickness = gears.logs_gear:slider("Thickness", 0, 20, 0),

    hitchance_in_air = gears.hitchance_gear:slider("Scout Air", 0, 100, 35),

    baim_logic = gears.ragebot_logic_gear:switch("Force Body *Lethal*"),
    close_aimbot = gears.ragebot_logic_gear:switch("100HP Logic *Close*"),
    dormant_logic = gears.ragebot_logic_gear:switch("AI Dormant Aimbot"),
}

    gears_items.baim_logic:tooltip("Forces Body Aim when enemy is Lethal.")
    gears_items.dormant_logic:tooltip("Auto-Enable/Disables dormant aimbot when enemy is/isn't dormant.")
    gears_items.close_aimbot:tooltip("Forces 100HP at close distance and when local player is lethal")
--menuvisibility


--- Settings

        gears_items.border_types:depend({gears_items.border_switch, true})
        gears_items.border_thickness:depend({gears_items.border_switch, true}, {gears_items.border_types, "Outline"})
        menu_items.main.upgrade:depend({menu_items.main.home_info, 2})
        menu_items.main.upgrade_label:depend({menu_items.main.home_info, 2})
        menu_items.main.upgrade_discord_button:depend({menu_items.main.home_info, 2})
        menu_items.settings.list:depend({menu_items.settings.toggle_settings, true})
        menu_items.settings.aspect_ratio:depend({menu_items.settings.toggle_settings, true}, {menu_items.settings.list, 1})
        menu_items.settings.crosshair_indicators:depend({menu_items.settings.toggle_settings, true}, {menu_items.settings.list, 1})
        menu_items.settings.scope_overlay:depend({menu_items.settings.toggle_settings, true}, {menu_items.settings.list, 1})
        menu_items.settings.viewmodel:depend({menu_items.settings.toggle_settings, true}, {menu_items.settings.list, 1})
        menu_items.settings.performance_mode:depend({menu_items.settings.toggle_settings, true}, {menu_items.settings.list, 1})
        menu_items.settings.override_indicator:depend({menu_items.settings.toggle_settings, true}, {menu_items.settings.list, 1})
        menu_items.settings.skeet_indicators:depend({menu_items.settings.toggle_settings, true}, {menu_items.settings.list, 1})
        menu_items.settings.esp_list:depend({menu_items.settings.toggle_settings, true}, {menu_items.settings.list, 2})
        menu_items.settings.trashtalk:depend({menu_items.settings.toggle_settings, true}, {menu_items.settings.list, 2})
        menu_items.settings.fake_latency:depend({menu_items.settings.toggle_settings, true}, {menu_items.settings.list, 2})
        menu_items.settings.hitchance:depend({menu_items.settings.toggle_settings, true}, {menu_items.settings.list, 2})
        menu_items.settings.logs:depend({menu_items.settings.toggle_settings, true}, {menu_items.settings.list, 1})
        menu_items.settings.ragebot_logic:depend({menu_items.settings.toggle_settings, true}, {menu_items.settings.list, 2})
        menu_items.settings.debug_panel:depend({menu_items.settings.toggle_settings, true}, {menu_items.settings.list, 2})

    
        gears_items.logs_option:depend({gears_items.logs_events, "Aimbot"})
        gears_items.hit_color:depend({gears_items.logs_events, "Aimbot"})
        gears_items.miss_color:depend({gears_items.logs_events, "Aimbot"})

    --Antiaim
        menu_items.aa.style_aa:depend({ menu_items.aa.enable_aa , true })

        menu_items.aa.manual_yaw:depend({ menu_items.aa.enable_aa , true }, {menu_items.aa.style_aa, 4})
        menu_items.aa.anims:depend({ menu_items.aa.enable_aa , true }, {menu_items.aa.style_aa, 4})
        menu_items.aa.auto_tp:depend({ menu_items.aa.enable_aa , true }, {menu_items.aa.style_aa, 4})
        menu_items.aa.avoid_backstab:depend({ menu_items.aa.enable_aa , true }, {menu_items.aa.style_aa, 4})
        menu_items.aa.safe_head:depend({ menu_items.aa.enable_aa , true }, {menu_items.aa.style_aa, 4})
        menu_items.aa.force_defensive:depend({ menu_items.aa.enable_aa , true }, {menu_items.aa.style_aa, 4})
        menu_items.aa.fs_disablers:depend({ menu_items.aa.enable_aa , true }, {menu_items.aa.style_aa, 4})

        -- Preset items
        

        -- builder items
        menu_items.aa.none_builder:depend({ menu_items.aa.enable_aa , true } ,{ menu_items.aa.style_aa , 1})
        menu_items.aa.preset_list:depend({ menu_items.aa.enable_aa , true } , { menu_items.aa.style_aa , 2})
        menu_items.aa.discord_preset:depend({ menu_items.aa.enable_aa , true } , { menu_items.aa.style_aa , 2})
        menu_items.aa.state_condition:depend({ menu_items.aa.enable_aa , true } , { menu_items.aa.style_aa , 3})


            gradient_anim = function(color1, color2, text, speed)
            local r1, g1, b1 = color1.r, color1.g, color1.b
            local r2, g2, b2 = color2.r, color2.g, color2.b
            local highlight_fraction = (globals.realtime / 2 % 0.8 * speed) - 1.5
            local output = ""
            for idx = 1, #text do
                local character = text:sub(idx, idx)
                local character_fraction = idx / #text
                local r, g, b = r1, g1, b1
                local highlight_delta = (character_fraction - highlight_fraction)
                if highlight_delta >= 0.2 and highlight_delta <= 1.5 then
                    if highlight_delta > 0.8 then
                        highlight_delta = 1.5 - highlight_delta
                    end
                    local r_fraction, g_fraction, b_fraction = r2 - r, g2 - g, b2 - b
                    r = r + r_fraction * highlight_delta
                    g = g + g_fraction * highlight_delta
                    b = b + b_fraction * highlight_delta
                end
                output = output .. ('\a%0x%0x%0x%0x%s'):format(r, g, b, 255, text:sub(idx, idx))
            end
            return output
        end
        


        --------------------------  PLAYTIME  -------------------------------


        local function updatePlaytimeDisplay()
            local totalHours = math.floor(playtime / 60) / 60
            local totalSeconds = playtime % 60
        
            menu_items.main.playtime_button:name(string.format("%d Hours", totalHours))
        end
        
        local function onSecondPassed()
            totalHours = math.floor(playtime / 60) / 60
            playtime = playtime + 1
            updatePlaytimeDisplay() 
            utils.execute_after(1, onSecondPassed)  
        end
        
        events.shutdown:set(function()
            db.venture_playtime = playtime
        end)
        
        onSecondPassed()
        

    local FLAGS = {
        ON_GROUND = 257,
        DUCKING = 263,
        IN_AIR = 256,
        IN_AIR_DUCKING = 262,
    }


    local STATES = {
        FAKELAG = 1,
        STAND = 2,
        WALK = 3,
        SLOW_WALK = 4,
        DUCK = 5,
        DUCK_MOVE = 6,  
        AIR = 7,
        AIR_DUCK = 8,   
    }

    local function anti_aim_states()
        local lp = entity.get_local_player()
        if not lp then return end
        local velocity = lp.m_vecVelocity:length2d()
        local flags = lp.m_fFlags
        if not (refs.dt:get() or refs.hideshots:get()) then
            return STATES.FAKELAG
        end
    
        local state_table = {
            [FLAGS.ON_GROUND] = {
                [velocity < 3] = STATES.STAND,
                [velocity >= 3 and velocity < 81] = STATES.SLOW_WALK,
                [velocity >= 81] = STATES.WALK,
            },
            [FLAGS.DUCKING] = {
                [velocity < 3] = STATES.DUCK,
                [velocity >= 3] = STATES.DUCK_MOVE,
            },
            [FLAGS.IN_AIR] = STATES.AIR,
            [FLAGS.IN_AIR_DUCKING] = STATES.AIR_DUCK,
        }
    
        local state = state_table[flags]
        if state then
            if type(state) == "table" then
                for condition, value in pairs(state) do
                    if condition then
                        return value
                    end
                end
            else
                return state
            end
        else 
            return STATES.WALK
        end
    end

    

local get_entity_address = utils.get_vfunc("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")

local anims_address = nil

local update_hook = function(lp)

    lp = entity.get_local_player()
    if lp == nil then return end
    if not lp:is_alive() then return end
    if lp:get_index() == nil then return end

    anims_address = get_entity_address(lp:get_index())

    if menu_items.aa.anims:get("Follow Direction") then
        lp.m_flPoseParameter[globals.tickcount %4 > 1 and 0.5 or 1] = math.random(0, 10)/10
        refs.legs:override("Sliding")
    end

    if menu_items.aa.anims:get("Jitter Legs") then
        lp.m_flPoseParameter[0] = globals.tickcount %4 > 1 and 100 / 100 or 1
            refs.legs:set("Sliding")
    end

    if menu_items.aa.anims:get("Static legs in Air") then
        lp.m_flPoseParameter[6] = 1
    end
    
    -- if menu_items.aa.anims:get("Body Lean") then
    --         ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', anims_address) + 0x2990)[0][12].m_flWeight = 1
    -- end
end

events.post_update_clientside_animation:set(update_hook)



local states = {
    [1] = "Fakelag",
    [2] = "Standing",
    [3] = "Moving",
    [4] = "Slowmode",
    [5] = "Crouching",
    [6] = "Crouch Move",
    [7] = "In Air",
    [8] = "Air Crouch",
}

local defensive_states = {
    [2] = "Standing",
    [3] = "Moving",
    [4] = "Slowmode",
    [5] = "Crouching",
    [6] = "Crouch Move",
    [7] = "In Air",
    [8] = "Air Crouch",
}


local antibrute_builder = {}
local condition_builder = {}
local defensive_builder = {}
local builder_gears = {}
local brute_builder_gears = {}



for state_name, id in pairs(STATES) do
    condition_builder[id] = {
        enable = groups.aa3:switch("Allow " .. states[id] .. "\r Condition"),
        yaw = groups.aa3:combo("Yaw Method", {"Static", "Left/Right", "Delayed Switch", "Yaw Manipulation"}),
        mani_method = groups.aa3:combo("Manipulation Method", {"Static", "Switch"}),
        flick_single = groups.aa3:slider("⊳  Offset", -180, 180, 0, 1, "°"),
        flick_left = groups.aa3:slider("⊳  Left Offset", -180, 180, 0, 1, "°"),
        flick_right = groups.aa3:slider("⊳  Right Offset", -180, 180, 0, 1, "°"),
        manipulation_random = groups.aa3:slider("⊳  Manipulation", -180, 180, 0, 1, "°"),
        delay_mani_metod = groups.aa3:combo("Delay Logic", {"Cosine", "Normal", "Sine"}),
        delay_mani = groups.aa3:slider("⊳  Delayed", 2, 20, 0, 1, "°"),
        cosine_speed_mani = groups.aa3:slider("⊳  Speed", 2, 20, 0, 1, "°"),

        offset = groups.aa3:slider("⊳  Offset", -180, 180, 0, 1, "°"),
        left_offset = groups.aa3:slider("⊳  Left Offset", -180, 180, 0, 1, "°"),
        right_offset = groups.aa3:slider("⊳  Right Offset", -180, 180, 0, 1, "°"),

        delay_logic = groups.aa3:combo("Delay Logic", {"Cosine", "Normal", "Sine"}),
        delay_ticks = groups.aa3:slider("⊳  Delay Ticks", 2, 20, 10),
        delay_speed = groups.aa3:slider("⊳  Speed", 2, 20, 0),
        yawmod = groups.aa3:combo("Yaw Modifier", {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"}),
        byaw = groups.aa3:switch("Body Yaw")
    }

    defensive_builder[id] = {
        enable = groups.aa4:switch("\f<shield-halved>  Toggle " .. states[id] .. "\r Condition"),
        pitch = groups.aa4:combo("Pitch", {"Down", "Fake Down", "Fake Up", "Custom", "Switch"}),
        yaw = groups.aa4:combo("Yaw", {"None", "Default", "Custom"}),
    }

    antibrute_builder[id] = {
        enable = groups.aa2:switch("Toggle " .. states[id] .. "\r"),
        phase_type = groups.aa2:combo("Anti-Brute Force", "Custom"),
        custom_phases = groups.aa2:list("", "First Switch", "Second Switch", "Third Switch", "Fourth Switch"),
        -- custom
 






        -- preset
        preset_select = groups.aa2:combo("Preset", "Meta", "Delay"),


    }

    builder_gears[id] = {
        delay_logic = condition_builder[id].delay_logic:create(),
        --delay_speed = condition_builder[id].delay_speed:create(),
        yaw = condition_builder[id].yaw:create(),
        delay_ticks = condition_builder[id].delay_ticks:create(),
        yawmod = condition_builder[id].yawmod:create(),
        byaw = condition_builder[id].byaw:create(),
        d_pitch = defensive_builder[id].pitch:create(),
        d_yaw = defensive_builder[id].yaw:create(),
    }

    
    brute_builder_gears[id] = {
        phase_type = antibrute_builder[id].phase_type:create(),
    }
    -- = builder_gears[id].yaw:label("This method uses Defensive angles to manipulate.", 2, 20, 0)


    -- FIRST ANTI
        antibrute_builder[id].p1_yaw = brute_builder_gears[id].phase_type:combo("\a"..menu_items.main.wmk_color:get():to_hex().. "[1]  \aDBDBDBFF⊳  Yaw Method", {"Static", "Left/Right", "Delayed Switch"})
        antibrute_builder[id].p1_offset = brute_builder_gears[id].phase_type:slider("⊳  Offset", -180, 180, 0, 1, "°")
        antibrute_builder[id].p1_left_offset = brute_builder_gears[id].phase_type:slider("⊳  Left Offset", -180, 180, 0, 1, "°")
        antibrute_builder[id].p1_right_offset = brute_builder_gears[id].phase_type:slider("⊳  Right Offset", -180, 180, 0, 1, "°")
        antibrute_builder[id].p1_delay_logic = brute_builder_gears[id].phase_type:combo("Delay Logic", {"Cosine", "Normal", "Sine"})
        antibrute_builder[id].p1_delay_ticks = brute_builder_gears[id].phase_type:slider("⊳  Delay Ticks", 2, 20, 10)
        antibrute_builder[id].p1_delay_speed = brute_builder_gears[id].phase_type:slider("⊳  Speed", 2, 20, 0)
        antibrute_builder[id].p1_cosine_random = brute_builder_gears[id].phase_type:slider("⊳  Variability", 0, 100, 0, 1, "%")
        antibrute_builder[id].p1_yawmod = brute_builder_gears[id].phase_type:combo("Yaw Modifier", {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"})
        antibrute_builder[id].p1_yawmod_off = brute_builder_gears[id].phase_type:slider("⊳  Offset", -180, 180, 0, 1, "°")
        antibrute_builder[id].p1_yawmod_random = brute_builder_gears[id].phase_type:slider("⊳  Variability", 0, 180, 0, 1, "%")

    -- SECOND ANTI
        antibrute_builder[id].p2_yaw = brute_builder_gears[id].phase_type:combo("\a"..menu_items.main.wmk_color:get():to_hex().. "[2]  \aDBDBDBFF⊳  Yaw Method", {"Static", "Left/Right", "Delayed Switch"})
        antibrute_builder[id].p2_offset = brute_builder_gears[id].phase_type:slider("⊳  Offset", -180, 180, 0, 1, "°")
        antibrute_builder[id].p2_left_offset = brute_builder_gears[id].phase_type:slider("⊳  Left Offset", -180, 180, 0, 1, "°")
        antibrute_builder[id].p2_right_offset = brute_builder_gears[id].phase_type:slider("⊳  Right Offset", -180, 180, 0, 1, "°")
        antibrute_builder[id].p2_delay_logic = brute_builder_gears[id].phase_type:combo("Delay Logic", {"Cosine", "Normal", "Sine"})
        antibrute_builder[id].p2_delay_ticks = brute_builder_gears[id].phase_type:slider("⊳  Delay Ticks", 2, 20, 10)
        antibrute_builder[id].p2_delay_speed = brute_builder_gears[id].phase_type:slider("⊳  Speed", 2, 20, 0)
        antibrute_builder[id].p2_cosine_random = brute_builder_gears[id].phase_type:slider("⊳  Variability", 0, 100, 0, 1, "%")
        antibrute_builder[id].p2_yawmod = brute_builder_gears[id].phase_type:combo("Yaw Modifier", {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"})
        antibrute_builder[id].p2_yawmod_off = brute_builder_gears[id].phase_type:slider("⊳  Offset", -180, 180, 0, 1, "°")
        antibrute_builder[id].p2_yawmod_random = brute_builder_gears[id].phase_type:slider("⊳  Variability", 0, 180, 0, 1, "%")
    
    -- THIRD ANTI
        antibrute_builder[id].p3_yaw = brute_builder_gears[id].phase_type:combo("\a"..menu_items.main.wmk_color:get():to_hex().. "[3]  \aDBDBDBFF⊳  Yaw Method", {"Static", "Left/Right", "Delayed Switch"})
        antibrute_builder[id].p3_offset = brute_builder_gears[id].phase_type:slider("⊳  Offset", -180, 180, 0, 1, "°")
        antibrute_builder[id].p3_left_offset = brute_builder_gears[id].phase_type:slider("⊳  Left Offset", -180, 180, 0, 1, "°")
        antibrute_builder[id].p3_right_offset = brute_builder_gears[id].phase_type:slider("⊳  Right Offset", -180, 180, 0, 1, "°")
        antibrute_builder[id].p3_delay_logic = brute_builder_gears[id].phase_type:combo("Delay Logic", {"Cosine", "Normal", "Sine"})
        antibrute_builder[id].p3_delay_ticks = brute_builder_gears[id].phase_type:slider("⊳  Delay Ticks", 2, 20, 10)
        antibrute_builder[id].p3_delay_speed = brute_builder_gears[id].phase_type:slider("⊳  Speed", 2, 20, 0)
        antibrute_builder[id].p3_cosine_random = brute_builder_gears[id].phase_type:slider("⊳  Variability", 0, 100, 0, 1, "%")
        antibrute_builder[id].p3_yawmod = brute_builder_gears[id].phase_type:combo("Yaw Modifier", {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"})
        antibrute_builder[id].p3_yawmod_off = brute_builder_gears[id].phase_type:slider("⊳  Offset", -180, 180, 0, 1, "°")
        antibrute_builder[id].p3_yawmod_random = brute_builder_gears[id].phase_type:slider("⊳  Variability", 0, 180, 0, 1, "%")

    
    -- FOURTH ANTI
        antibrute_builder[id].p4_yaw = brute_builder_gears[id].phase_type:combo("\a"..menu_items.main.wmk_color:get():to_hex().. "[4]  \aDBDBDBFF⊳  Yaw Method", {"Static", "Left/Right", "Delayed Switch"})
        antibrute_builder[id].p4_offset = brute_builder_gears[id].phase_type:slider("⊳  Offset", -180, 180, 0, 1, "°")
        antibrute_builder[id].p4_left_offset = brute_builder_gears[id].phase_type:slider("⊳  Left Offset", -180, 180, 0, 1, "°")
        antibrute_builder[id].p4_right_offset = brute_builder_gears[id].phase_type:slider("⊳  Right Offset", -180, 180, 0, 1, "°")
        antibrute_builder[id].p4_delay_logic = brute_builder_gears[id].phase_type:combo("Delay Logic", {"Cosine", "Normal", "Sine"})
        antibrute_builder[id].p4_delay_ticks = brute_builder_gears[id].phase_type:slider("⊳  Delay Ticks", 2, 20, 10)
        antibrute_builder[id].p4_delay_speed = brute_builder_gears[id].phase_type:slider("⊳  Speed", 2, 20, 0)
        antibrute_builder[id].p4_cosine_random = brute_builder_gears[id].phase_type:slider("⊳  Variability", 0, 100, 0, 1, "%")
        antibrute_builder[id].p4_yawmod = brute_builder_gears[id].phase_type:combo("Yaw Modifier", {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"})
        antibrute_builder[id].p4_yawmod_off = brute_builder_gears[id].phase_type:slider("⊳  Offset", -180, 180, 0, 1, "°")
        antibrute_builder[id].p4_yawmod_random = brute_builder_gears[id].phase_type:slider("⊳  Variability", 0, 180, 0, 1, "%")

    -- NORMAL
    condition_builder[id].cosine_random = builder_gears[id].delay_logic:slider("⊳  Variability", 0, 100, 0, 1, "%")

    condition_builder[id].offset_random = builder_gears[id].yaw:slider("⊳  Variability", 0, 180, 0, 1, "%")
    condition_builder[id].yawmod_off = builder_gears[id].yawmod:slider("⊳  Offset", -180, 180, 0, 1, "°")
    condition_builder[id].yawmod_random = builder_gears[id].yawmod:slider("⊳  Variability", 0, 180, 0, 1, "%")

    condition_builder[id].fake_random = builder_gears[id].byaw:slider("⊳  Fake Random", 1, 100, 0, 1, "%")
    condition_builder[id].left_limit = builder_gears[id].byaw:slider("⊳  Left Limit", 0, 60, 0, 1, "°")
    condition_builder[id].right_limit = builder_gears[id].byaw:slider("⊳  Right Limit", 0, 60, 0, 1, "°")
    condition_builder[id].options = builder_gears[id].byaw:selectable("⊳  Options", {"Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce"})
    condition_builder[id].fs = builder_gears[id].byaw:combo("⊳  Freestanding", {"Off", "Peek Fake", "Peek Real"})

    defensive_builder[id].c_pitch = builder_gears[id].d_pitch:slider("⊳  Custom", -89, 89, 0, 1, "°")
    defensive_builder[id].w1_pitch = builder_gears[id].d_pitch:slider("⊳  Phase 1", -89, 89, 0, 1, "°")
    defensive_builder[id].w2_pitch = builder_gears[id].d_pitch:slider("⊳  Phase 2", -89, 89, 0, 1, "°")
    defensive_builder[id].offset = builder_gears[id].d_yaw:slider("⊳  Offset", -180, 180, 0, 1, "°")
    defensive_builder[id].offset_random = builder_gears[id].d_yaw:slider("⊳  Variability", 0, 180, 0, 1, "%")
    -- Dependencies for condition_builder

    antibrute_builder[id].enable:depend({ condition_builder[id].enable, true }, { menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] })
    antibrute_builder[id].phase_type:depend({ condition_builder[id].enable, true }, { menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true})
    antibrute_builder[id].custom_phases:depend({ condition_builder[id].enable, true }, { menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true},
     {antibrute_builder[id].phase_type, "Custom"})
    

     --FIRST
    antibrute_builder[id].p1_yaw:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 1})
    antibrute_builder[id].p1_offset:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 1}, {antibrute_builder[id].p1_yaw, "Static"})
    antibrute_builder[id].p1_left_offset:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 1}, {antibrute_builder[id].p1_yaw, "Delayed Switch", "Left/Right"})
    antibrute_builder[id].p1_right_offset:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 1}, {antibrute_builder[id].p1_yaw, "Delayed Switch", "Left/Right"})
    antibrute_builder[id].p1_delay_logic:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 1}, {antibrute_builder[id].p1_yaw, "Delayed Switch"})
    antibrute_builder[id].p1_delay_ticks:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 1}, {antibrute_builder[id].p1_yaw, "Delayed Switch"}, {antibrute_builder[id].p1_delay_logic, "Normal"})
    antibrute_builder[id].p1_delay_speed:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 1}, {antibrute_builder[id].p1_yaw, "Delayed Switch"}, {antibrute_builder[id].p1_delay_logic, "Cosine", "Sine"})
    antibrute_builder[id].p1_cosine_random:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 1}, {antibrute_builder[id].p1_yaw, "Delayed Switch"})
    antibrute_builder[id].p1_yawmod:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 1})
    antibrute_builder[id].p1_yawmod_off:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 1})
    antibrute_builder[id].p1_yawmod_random:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 1})
    
    
    --SECOND
    antibrute_builder[id].p2_yaw:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 2})
    antibrute_builder[id].p2_offset:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 2}, {antibrute_builder[id].p2_yaw, "Static"})
    antibrute_builder[id].p2_left_offset:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 2}, {antibrute_builder[id].p2_yaw, "Delayed Switch", "Left/Right"})
    antibrute_builder[id].p2_right_offset:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 2}, {antibrute_builder[id].p2_yaw, "Delayed Switch", "Left/Right"})
    antibrute_builder[id].p2_delay_logic:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 2}, {antibrute_builder[id].p2_yaw, "Delayed Switch"})
    antibrute_builder[id].p2_delay_ticks:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 2}, {antibrute_builder[id].p2_yaw, "Delayed Switch"}, {antibrute_builder[id].p2_delay_logic, "Normal"})
    antibrute_builder[id].p2_delay_speed:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 2}, {antibrute_builder[id].p2_yaw, "Delayed Switch"}, {antibrute_builder[id].p2_delay_logic, "Cosine", "Sine"})   
    antibrute_builder[id].p2_cosine_random:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 2}, {antibrute_builder[id].p2_yaw, "Delayed Switch"})
    antibrute_builder[id].p2_yawmod:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 2})
    antibrute_builder[id].p2_yawmod_off:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 2})
    antibrute_builder[id].p2_yawmod_random:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 2})
 
    
    --THIRD
    antibrute_builder[id].p3_yaw:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 3})
    antibrute_builder[id].p3_offset:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 3}, {antibrute_builder[id].p3_yaw, "Static"})
    antibrute_builder[id].p3_left_offset:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 3}, {antibrute_builder[id].p3_yaw, "Delayed Switch", "Left/Right"})
    antibrute_builder[id].p3_right_offset:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 3}, {antibrute_builder[id].p3_yaw, "Delayed Switch", "Left/Right"})
    antibrute_builder[id].p3_delay_logic:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 3}, {antibrute_builder[id].p3_yaw, "Delayed Switch"})
    antibrute_builder[id].p3_delay_ticks:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 3}, {antibrute_builder[id].p3_yaw, "Delayed Switch"}, {antibrute_builder[id].p3_delay_logic, "Normal"})
    antibrute_builder[id].p3_delay_speed:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 3}, {antibrute_builder[id].p3_yaw, "Delayed Switch"}, {antibrute_builder[id].p3_delay_logic, "Cosine", "Sine"})   
    antibrute_builder[id].p3_cosine_random:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 3}, {antibrute_builder[id].p3_yaw, "Delayed Switch"})
    antibrute_builder[id].p3_yawmod:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 3})
    antibrute_builder[id].p3_yawmod_off:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 3})
    antibrute_builder[id].p3_yawmod_random:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 3})

   
    --FOURTH
    antibrute_builder[id].p4_yaw:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 4})
    antibrute_builder[id].p4_offset:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 4}, {antibrute_builder[id].p4_yaw, "Static"})
    antibrute_builder[id].p4_left_offset:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 4}, {antibrute_builder[id].p4_yaw, "Delayed Switch", "Left/Right"})
    antibrute_builder[id].p4_right_offset:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 4}, {antibrute_builder[id].p4_yaw, "Delayed Switch", "Left/Right"})
    antibrute_builder[id].p4_delay_logic:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 4}, {antibrute_builder[id].p4_yaw, "Delayed Switch"})
    antibrute_builder[id].p4_delay_ticks:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 4}, {antibrute_builder[id].p4_yaw, "Delayed Switch"}, {antibrute_builder[id].p4_delay_logic, "Normal"})
    antibrute_builder[id].p4_delay_speed:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 4}, {antibrute_builder[id].p4_yaw, "Delayed Switch"}, {antibrute_builder[id].p4_delay_logic, "Cosine", "Sine"})   
    antibrute_builder[id].p4_cosine_random:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 4}, {antibrute_builder[id].p4_yaw, "Delayed Switch"})
    antibrute_builder[id].p4_yawmod:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 4})
    antibrute_builder[id].p4_yawmod_off:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 4})
    antibrute_builder[id].p4_yawmod_random:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Custom"}, {antibrute_builder[id].custom_phases, 4})

    
    antibrute_builder[id].preset_select:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, {antibrute_builder[id].enable, true}, {antibrute_builder[id].phase_type, "Presets"})



    condition_builder[id].enable:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] })
    condition_builder[id].yaw:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true })
    --condition_builder[id].manipulation_label:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].yaw, "Yaw Manipulation" })
    condition_builder[id].mani_method:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].yaw, "Yaw Manipulation" })
    condition_builder[id].flick_single:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].yaw, "Yaw Manipulation" }, {condition_builder[id].mani_method, "Static"})
    condition_builder[id].flick_left:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].yaw, "Yaw Manipulation" }, {condition_builder[id].mani_method, "Switch"})
    condition_builder[id].flick_right:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].yaw, "Yaw Manipulation" }, {condition_builder[id].mani_method, "Switch"})
    condition_builder[id].manipulation_random:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].yaw, "Yaw Manipulation" })
    condition_builder[id].delay_mani_metod:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].yaw, "Yaw Manipulation" }, {condition_builder[id].mani_method, "Switch"})
    condition_builder[id].delay_mani:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].yaw, "Yaw Manipulation" }, {condition_builder[id].delay_mani_metod, "Normal"}, {condition_builder[id].mani_method, "Switch"})
    condition_builder[id].cosine_speed_mani:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].yaw, "Yaw Manipulation" }, {condition_builder[id].delay_mani_metod, "Cosine", "Sine"}, {condition_builder[id].mani_method, "Switch"})
    condition_builder[id].offset:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].yaw, "Static" })
    condition_builder[id].offset_random:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].yaw, "Static" })
    condition_builder[id].left_offset:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].yaw, "Left/Right", "Delayed Switch" })
    condition_builder[id].right_offset:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].yaw, "Left/Right", "Delayed Switch" })
    
    condition_builder[id].delay_logic:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].yaw, "Delayed Switch" })
    condition_builder[id].delay_ticks:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].yaw, "Delayed Switch" }, {condition_builder[id].delay_logic, "Normal"})
    condition_builder[id].delay_speed:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].yaw, "Delayed Switch" }, {condition_builder[id].delay_logic, "Cosine", "Sine"})
    condition_builder[id].cosine_random:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].yaw, "Delayed Switch" }, {condition_builder[id].delay_logic, "Normal", "Cosine", "Sine"})
    condition_builder[id].yawmod:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true })
    condition_builder[id].yawmod_off:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].yawmod, "Random Center", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"})
    condition_builder[id].yawmod_random:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].yawmod, "Random Center", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"})

    condition_builder[id].byaw:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true })
    condition_builder[id].fake_random:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].byaw, true })
    condition_builder[id].left_limit:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].byaw, true })
    condition_builder[id].right_limit:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].byaw, true })
    condition_builder[id].options:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].byaw, true })
    condition_builder[id].fs:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, states[id] }, { condition_builder[id].enable, true }, { condition_builder[id].byaw, true })

    -- Dependencies for defensive_builder
    defensive_builder[id].enable:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, defensive_states[id] }, { condition_builder[id].enable, true })
    defensive_builder[id].pitch:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, defensive_states[id] }, { defensive_builder[id].enable, true }, { condition_builder[id].enable, true })
    defensive_builder[id].c_pitch:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, defensive_states[id] }, { defensive_builder[id].enable, true }, {defensive_builder[id].pitch, "Custom"} , { condition_builder[id].enable, true })
    defensive_builder[id].w1_pitch:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, defensive_states[id] }, { defensive_builder[id].enable, true }, {defensive_builder[id].pitch, "Switch"} , { condition_builder[id].enable, true })
    defensive_builder[id].w2_pitch:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, defensive_states[id] }, { defensive_builder[id].enable, true }, {defensive_builder[id].pitch, "Switch"} , { condition_builder[id].enable, true })
    defensive_builder[id].yaw:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, defensive_states[id] }, { defensive_builder[id].enable, true }, { condition_builder[id].enable, true })
    defensive_builder[id].offset:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, defensive_states[id] }, { defensive_builder[id].enable, true }, { defensive_builder[id].yaw, "Custom" }, { condition_builder[id].enable, true })
    defensive_builder[id].offset_random:depend({ menu_items.aa.enable_aa, true }, { menu_items.aa.style_aa, 3 }, { menu_items.aa.state_condition, defensive_states[id] }, { defensive_builder[id].enable, true }, { defensive_builder[id].yaw, "Custom" }, { condition_builder[id].enable, true })

end
local preset_switch = groups.aa1:button("Switch to Presets", function() menu_items.aa.style_aa:set(2) end, true)

:depend({ menu_items.aa.style_aa, 3})

local misses_db = db.venture_antibrute_miss or 0

--------------------------------------

local antiBruteforceLogs = {}
local LMAX_ANTI_LOGS = 3  -- maximum logs on-screen at once
local antiNextIndex = 1 

function addAntiBruteforceLog()
    local newLog = {
        alpha = 1000,
        current_y = 930,  -- starting vertical position
        target_y = 930 - ((#antiBruteforceLogs < LMAX_ANTI_LOGS and #antiBruteforceLogs or LMAX_ANTI_LOGS) * 30)
    }
    
    if #antiBruteforceLogs < LMAX_ANTI_LOGS then
        table.insert(antiBruteforceLogs, newLog)
    else
        antiBruteforceLogs[antiNextIndex] = newLog
        antiNextIndex = antiNextIndex % LMAX_ANTI_LOGS + 1
    end
end

----------- MISS DETECTION --------------  

local last_event_time = 0
local last_health = 100

local function check_health_change()
    local lp = entity.get_local_player()
    if not lp then return false end
    
    local current_health = lp.m_iHealth
    if not current_health then return false end
    
    -- Check if health decreased
    if current_health < last_health then
        local health_diff = last_health - current_health
        print(string.format("HIT DETECTED - Damage taken: %d", health_diff))
        last_health = current_health
        return true
    end
    
    -- Update last known health if it increased (healing)
    if current_health > last_health then
        last_health = current_health
    end
    
    return false
end

-- Reset health on spawn
events.round_start:set(function()
    last_health = 100
end)

events.player_spawn:set(function(e)
    local lp = entity.get_local_player()
    if not lp then return end
    
    -- Reset health when local player spawns
    if e.userid == lp:get_player_info().userid then
        last_health = 100
    end
end)


events.bullet_impact:set(function(e)
    -- Basic safety checks
    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() then return end
    local shooter = entity.get(e.userid, true)
    if not shooter or not shooter:is_enemy() then return end

    -- Time check to prevent double calls
    local current_time = globals.tickcount
    if current_time == last_event_time then return end

    -- Get positions
    local impact = vector(e.x, e.y, e.z)
    local shooter_pos = shooter:get_origin()
    local player_pos = lp:get_origin()
    local player_head = lp:get_hitbox_position(0)

    -- Get player height based on duck state
    local duck_amount = lp.m_flDuckAmount
    local player_height = duck_amount > 0 and 54 or 72
    local max_player_height = player_pos.z + player_height

    -- Create direction vector from shooter to impact
    local bullet_dir = (impact - shooter_pos):normalized()

    -- Calculate closest point of approach
    local to_player = player_pos - shooter_pos
    local to_head = player_head - shooter_pos

    -- Project player position onto bullet trajectory
    local dist_body = (to_player:dot(bullet_dir))
    local dist_head = (to_head:dot(bullet_dir))

    -- Calculate perpendicular distance from bullet path to player
    local closest_body = math.abs((to_player - (bullet_dir * dist_body)):length())
    local closest_head = math.abs((to_head - (bullet_dir * dist_head)):length())

    -- Get the closest distance
    local closest_distance = math.min(closest_body, closest_head)

    -- Trace bullet
    local dmg, trace = utils.trace_bullet(shooter, shooter_pos, impact)
    local was_hit = check_health_change()
    if not trace then return end
    if trace:did_hit() then
        -- For hits, check if bullet is within player's height bounds
        local bullet_z = impact.z
        local is_within_height = bullet_z >= player_pos.z and bullet_z <= max_player_height

        if trace.entity == lp and is_within_height and was_hit then
            last_event_time = current_time
            print("HIT - Enemy bullet hit you!")
            miss_state = false
            return
        elseif closest_distance <= 65 then  -- Removed height check for misses
            last_event_time = current_time
            miss_state = true
            misses_db = misses_db + 1
                addAntiBruteforceLog()
            print("MISS - Enemy bullet missed you by " .. math.floor(closest_distance) .. " units!")
        end
    end

    
    if misses_db > 4 then
        misses_db = 0
    elseif misses_db < 4 then
        misses_db = misses_db
    end
    

end)


events.round_start(function()
    addAntiBruteforceLog()
    misses_db = 0
    print("Resetarted round, reseted antibruteforce")
    db.venture_antibrute_miss = misses_db
end)
---- antiaim shit

    local switch_ticks = 0
    local switch = false

    local defensive_switch_ticks = 0
    local defensive_switch = false

    local brute_yaw_offset_add = 0  
    local brute_yawmod_off_add = 0
    local brute_yawmod_add = "Disabled"

    local yawmod_add = "Disabled"
    local yaw_offset_add = 0
    local yawmod_off_add = 0
    local defensive_yaw_add = 0
    local pitch_add = ""

    local body_yaw_add = false
    local options_add = ""
    local freestanding_add = "Off"
    local right_limit_add = 0
    local left_limit_add = 0



    local antiaim_callback = {}

    antiaim_callback.current_side = false
    antiaim_callback.desync_delta = 0


    antiaim_callback.time_to_ticks = function(t)
        return math.floor(0.5 + (t / globals.tickinterval))
    end

    local last_weapon = nil
    local swap_time = nil
    local weapon_ready = false

    antiaim_callback.is_weapon_switching = function()
        local localplayer = entity.get_local_player()
        if not localplayer then
            return
        end
    
        local active_weapon = localplayer.m_hActiveWeapon
        if not active_weapon then
            return
        end
    
        local current_weapon = active_weapon.m_iItemDefinitionIndex
        local can_shoot = active_weapon.can_shoot 
    
        if last_weapon ~= current_weapon then
            last_weapon = current_weapon
            swap_time = globals.realtime 
            weapon_ready = true 
            print("true") 
            return
        end
    
        if weapon_ready then
            local current_time = globals.realtime
            local draw_time = 0.65 -- swap delay time
    
            if can_shoot or (current_time - swap_time >= draw_time) then
                return false
            else
                return true
            end
            return
        end
    end

    antiaim_callback.is_person_nade = function()
        local localplayer = entity.get_local_player()
            if not localplayer then return end

            local active_weapon = localplayer.m_hActiveWeapon
            if active_weapon then
                local weapon_id = active_weapon.m_iItemDefinitionIndex
                local grenades = {
                    [43] = "Flashbang",
                    [44] = "HE Grenade",
                    [45] = "Smoke Grenade",
                    [46] = "Molotov",
                    [47] = "Decoy",
                    [48] = "Incendiary"
                }

                if grenades[weapon_id] then
                    return true
                else
                    return false
                end
            else
                return false
            end
            end

            local function get_safe_value(value, default)
                return value ~= nil and value or default
            end

    antiaim_callback.is_person_onshot = function()
        local localplayer = entity.get_local_player()
        if not localplayer then
            return
        end
    
        local active_weapon = localplayer.m_hActiveWeapon
        if not active_weapon then
            return
        end
    
        if refs.hideshots:get() then return end
        local next_attack_time = active_weapon.m_flNextPrimaryAttack
        
        if globals.curtime < next_attack_time then
            return true
        else
            return false
        end
    end

    antiaim_callback.get_desync_delta = function() 
            local player = entity.get_local_player()

            if player == nil then
                return
            end

            antiaim_callback.desync_delta = math.normalize_yaw(player.m_flPoseParameter[11] * 120 - 60) / 2
    end

    antiaim_callback.get_desync_side = function()
        antiaim_callback.current_side = antiaim_callback.desync_delta < 0
    end


    -- Function to handle defensive force logic
    antiaim_callback.defensive_force = function()
    if menu_items.aa.force_defensive:get(anti_aim_states(defensive_states[id])) then
        refs.lag:set("Always On")
        return true
    else
        refs.lag:set("On Peek")
        return false
    end
    end

    antiaim_callback.freestand_disablers = function()
        if menu_items.aa.fs_disablers:get(anti_aim_states(states[id])) then
            return false
        else
            return true
        end
        end



    antiaim_callback.handle = function(cmd)
    if not menu_items.aa.enable_aa:get() then
        return  
    end

    local local_player = entity.get_local_player()
    if local_player == nil or globals.choked_commands ~= 0 then
        return  
    end
    rage.antiaim:override_hidden_yaw_offset(0)

    if menu_items.aa.style_aa:get() == 4 or menu_items.aa.style_aa:get() == 3 or menu_items.aa.style_aa:get() == 2 then
    local aa_state = anti_aim_states() 

    pitch_add = "Down"

-- Handle yaw offset
local yaw_type = condition_builder[aa_state].yaw:get()

if yaw_type == "Static" then
    random_yaw = utils.random_int(condition_builder[aa_state].offset:get(), condition_builder[aa_state].offset:get() + condition_builder[aa_state].offset_random:get())
    yaw_offset_add = random_yaw

elseif yaw_type == "Left/Right" then
    local desync_side = antiaim_callback.current_side 
    yaw_offset_add = desync_side and condition_builder[aa_state].left_offset:get() or condition_builder[aa_state].right_offset:get()

elseif yaw_type == "Delayed Switch" then
    local delay_method = condition_builder[aa_state].delay_logic:get()
    local delay_ticks = condition_builder[aa_state].delay_ticks:get()
    local delay_speed = condition_builder[aa_state].delay_speed:get() 
    local cosine_random = condition_builder[aa_state].cosine_random:get()

    if delay_method == "Cosine" then
        local current_time = globals.curtime
        local start_time = globals.curtime - globals.curtime  -- This should only be set once

        local cosine_formula = (1 + math.cos((current_time - start_time) * (delay_speed * 3))) / 2
        local delay_ticks = antiaim_callback.time_to_ticks(delay_speed / 60)
        local cosine_mapped_ticks = math.floor(cosine_formula * delay_ticks)
        local half_delay_ticks = math.floor(delay_ticks / 2)
        switch = cosine_mapped_ticks < half_delay_ticks

    elseif delay_method == "Sine" then
        local current_time = globals.curtime
        local start_time = globals.curtime - globals.curtime  -- This should only be set once

        local sine_formula = (1 + math.sin((current_time - start_time) * (delay_speed * 3))) / 2
        local delay_ticks = antiaim_callback.time_to_ticks(delay_speed / 60)
        local sine_mapped_ticks = math.floor(sine_formula * delay_ticks)
        local half_delay_ticks = math.floor(delay_ticks / 2)
        switch = sine_mapped_ticks < half_delay_ticks

    elseif delay_method == "Normal" then
        local delay_ticks = antiaim_callback.time_to_ticks(delay_ticks / 60)
        switch_ticks = (switch_ticks + 1) % (delay_ticks + 1)

        local half_delay_ticks = math.floor(delay_ticks / 2)
        switch = switch_ticks < half_delay_ticks
    end

    local random_factor = cosine_random / 100
    local randomized_offset = math.random(-100, 100) * random_factor

    if switch then
        yaw_offset_add = condition_builder[aa_state].left_offset:get() + randomized_offset
        rage.antiaim:inverter(true)
    else
        yaw_offset_add = condition_builder[aa_state].right_offset:get() + randomized_offset
        rage.antiaim:inverter(false)
    end

elseif yaw_type == "Yaw Manipulation" then
    if rage.exploit:get() < 1 then return end
    
    rage.antiaim:inverter(false)
    local state = condition_builder[aa_state]
    local mani_method = state.mani_method:get()
    local delay_mani_method = state.delay_mani_metod:get()
    local delay_mani = state.delay_mani:get()
    local delay_speed_mani = state.cosine_speed_mani:get()
    
    local switch = false
    local current_time = globals.curtime
    local start_time = state.start_time or current_time
    state.start_time = start_time -- Store start_time in the state table
    
    if mani_method == "Switch" then
        local delay_ticks = antiaim_callback.time_to_ticks(delay_speed_mani / 60)
        local half_delay_ticks = math.floor(delay_ticks / 2)
        
        if delay_mani_method == "Cosine" then
            local cosine_formula = (1 + math.cos((current_time - start_time) * (delay_speed_mani * 3))) / 2
            local cosine_mapped_ticks = math.floor(cosine_formula * delay_ticks)
            switch = cosine_mapped_ticks < half_delay_ticks
        elseif delay_mani_method == "Sine" then
            local sine_formula = (1 + math.sin((current_time - start_time) * (delay_speed_mani * 3))) / 2
            local sine_mapped_ticks = math.floor(sine_formula * delay_ticks)
            switch = sine_mapped_ticks < half_delay_ticks
        elseif delay_mani_method == "Normal" then
            local normal_delay_ticks = antiaim_callback.time_to_ticks(delay_mani / 60)
            switch_ticks = (switch_ticks + 1) % (normal_delay_ticks + 1)
            switch = switch_ticks < math.floor(normal_delay_ticks / 2)
        else
            return
        end
        
        if switch then
            rage.antiaim:override_hidden_yaw_offset(-state.flick_left:get()) -- First direction
        else
            rage.antiaim:override_hidden_yaw_offset(-state.flick_right:get()) -- Second direction
        end
    elseif mani_method == "Static" then
        rage.antiaim:override_hidden_pitch(89)
        rage.antiaim:override_hidden_yaw_offset(state.flick_single:get())
        rage.antiaim:override_hidden_yaw_offset(-state.flick_single:get() - 20)
    end

    state.yawmod:set("Random")
    state.yawmod_off:set(state.manipulation_random:get())
    refs.freestand:override(false)
    rage.antiaim:override_hidden_pitch(89)
    refs.hsopt:override("Break LC")
    refs.lag:override("Always On")
    cmd.force_defensive = cmd.command_number % 7 == 0
end

        




-- elseif yaw_type == "Delayed Switch" then
--     local delay_ticks = antiaim_callback.time_to_ticks(condition_builder[aa_state].delay_ticks:get() / 150)

--     switch_ticks = (switch_ticks + 1) % (delay_ticks + 1)

--     local half_delay_ticks = math.floor(delay_ticks / 2)
--     switch = switch_ticks < half_delay_ticks

--     if switch then
--         yaw_offset_add = condition_builder[aa_state].left_offset:get()
--         rage.antiaim:inverter(true)
--     else
--         yaw_offset_add = condition_builder[aa_state].right_offset:get()
--         rage.antiaim:inverter(false)
--     end
-- end

-- Handle yaw modifier
    local yawmod_type = condition_builder[aa_state].yawmod:get()
    if yawmod_type ~= "Disabled" then
        yawmod_add = yawmod_type
        yawmod_off_add = utils.random_int(condition_builder[aa_state].yawmod_off:get(), condition_builder[aa_state].yawmod_off:get() + condition_builder[aa_state].yawmod_random:get())
    else
        yawmod_add = yawmod_type
        yawmod_off_add = condition_builder[aa_state].yawmod_off:get()
    end

    body_yaw_add = condition_builder[aa_state].byaw:get()
    options_add = condition_builder[aa_state].options:get()
    freestanding_add = condition_builder[aa_state].fs:get()

    local randomize_value = condition_builder[aa_state].fake_random:get()
    local left_limit = condition_builder[aa_state].left_limit:get()
    local right_limit = condition_builder[aa_state].right_limit:get()

    if randomize_value > 0 then
        -- Calculate the maximum random adjustment based on the randomize slider value
        local max_adjustment = (randomize_value / 100) * 30 -- Adjust 30 as a base randomness factor
        
        -- Randomly adjust the limits
        local random_adjust_left = math.random(-max_adjustment, max_adjustment)
        local random_adjust_right = math.random(-max_adjustment, max_adjustment)

        -- Apply the random adjustments to the limits
        right_limit_add = math.max(0, math.min(60, right_limit + random_adjust_right))
        left_limit_add = math.max(0, math.min(60, left_limit + random_adjust_left))
    end

    -- right_limit_add = condition_builder[aa_state].right_limit:get()
    -- left_limit_add = condition_builder[aa_state].left_limit:get()

    -- Handle defensive settings
    if defensive_builder[aa_state].enable:get() and antiaim_callback.defensive_force(true) then
        refs.hidden:override(true)
        yaw_offset_add = 0
    elseif yaw_type == "Yaw Manipulation" then
        refs.hidden:override(true)
    else
        refs.hidden:override(false)
    end

    if antiaim_callback.defensive_force(true) and defensive_builder[aa_state].enable:get() then
        if defensive_builder[aa_state].pitch:get() ~= "Custom" then
            pitch_add = defensive_builder[aa_state].pitch:get()
        else
            rage.antiaim:override_hidden_pitch(defensive_builder[aa_state].c_pitch:get())
        end
        if defensive_builder[aa_state].pitch:get() == "Switch" then
            rage.antiaim:override_hidden_pitch(utils.random_int(defensive_builder[aa_state].w1_pitch:get(), defensive_builder[aa_state].w2_pitch:get()))
        end
    end

    -- Handle defensive yaw offset
            if antiaim_callback.defensive_force(true) and defensive_builder[aa_state].enable:get() then
                if defensive_builder[aa_state].yaw:get() == "None" then
                    rage.antiaim:override_hidden_yaw_offset(yaw_offset_add)

                elseif defensive_builder[aa_state].yaw:get() == "Custom" then
                    sideway_angle = defensive_builder[aa_state].offset:get() -- offset_random -- rage.antiaim:inverter() and
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int(sideway_angle, -sideway_angle + defensive_builder[aa_state].offset_random:get()))

                elseif defensive_builder[aa_state].yaw:get() == "Default" and condition_builder[aa_state].yaw:get() == "Static" then
                    rage.antiaim:override_hidden_yaw_offset(utils.random_int((condition_builder[aa_state].offset:get() * -1), (condition_builder[aa_state].offset:get() * -1) + condition_builder[aa_state].offset_random:get()))

                elseif defensive_builder[aa_state].yaw:get() == "Default" and condition_builder[aa_state].yaw:get() == "Left/Right" then
                    local desync_side = antiaim_callback.current_side
                    --rage.antiaim:override_hidden_yaw_offset(desync_side andcondition_builder[aa_state].left_offset:get() or condition_builder[aa_state].right_offset:get())
                rage.antiaim:override_hidden_yaw_offset(desync_side and (condition_builder[aa_state].left_offset:get() * -1) or (condition_builder[aa_state].right_offset:get() * -1))

                elseif defensive_builder[aa_state].yaw:get() == "Default" and condition_builder[aa_state].yaw:get() == "Delayed Switch" then
                    local delay_method = condition_builder[aa_state].delay_logic:get()
                    local delay_ticks = condition_builder[aa_state].delay_ticks:get()
                    local delay_speed = condition_builder[aa_state].delay_speed:get()
                    
                    if delay_method == "Cosine" or delay_method == "Sine" then
                        local current_time = globals.curtime
                        local start_time = globals.curtime - globals.curtime
                
                        local formula
                        if delay_method == "Cosine" then
                            formula = (1 + math.cos((current_time - start_time) * (delay_speed * 3))) / 2
                        elseif delay_method == "Sine" then
                            formula = (1 + math.sin((current_time - start_time) * (delay_speed * 3))) / 2
                        end
                
                        local mapped_ticks = math.floor(formula * antiaim_callback.time_to_ticks(delay_speed / 60))
                        local half_delay_ticks = math.floor(delay_ticks / 2)
                        switch = mapped_ticks < half_delay_ticks
                
                    elseif delay_method == "Normal" then
                        local delay_ticks = antiaim_callback.time_to_ticks(delay_ticks / 60)
                        switch_ticks = (switch_ticks + 1) % (delay_ticks + 1)
                        local half_delay_ticks = math.floor(delay_ticks / 2)
                        switch = switch_ticks < half_delay_ticks
                    end
                
                    -- Apply yaw offsets based on the switch state (no randomization)
                    if switch then
                        -- Left direction
                        yaw_offset_add = condition_builder[aa_state].left_offset:get()
                    else
                        -- Right direction
                        yaw_offset_add = condition_builder[aa_state].right_offset:get()
                    end   
                end
            end
            if persistent_start_time == nil then
                persistent_start_time = 0
            end
            
            if switch_ticks == nil then
                switch_ticks = 0
            end

            -- Inside your update function or main code block:
            if antibrute_builder[aa_state].enable:get() then
                local left_offset, right_offset = 0, 0
                local yaw_type = nil
                local delay_method, delay_ticks, delay_speed, cosine_random = 0, 0, 0, 0
            
                -- Get yaw type based on misses_db
                if misses_db == 1 then
                    yaw_type = antibrute_builder[aa_state].p1_yaw:get()
                elseif misses_db == 2 then
                    yaw_type = antibrute_builder[aa_state].p2_yaw:get()
                elseif misses_db == 3 then
                    yaw_type = antibrute_builder[aa_state].p3_yaw:get()
                elseif misses_db == 4 then
                    yaw_type = antibrute_builder[aa_state].p4_yaw:get()
                end
            
                if yaw_type == "Static" then
                    if misses_db == 1 then
                        offset = antibrute_builder[aa_state].p1_offset:get()
                    elseif misses_db == 2 then
                        offset = antibrute_builder[aa_state].p2_offset:get()
                    elseif misses_db == 3 then
                        offset = antibrute_builder[aa_state].p3_offset:get()
                    elseif misses_db == 4 then
                        offset = antibrute_builder[aa_state].p4_offset:get()
                    end
                    brute_yaw_offset_add = offset
            
                    -- Reset persistent timing variables when leaving Delayed Switch
                    persistent_start_time = globals.curtime
                    switch_ticks = 0
            
                elseif yaw_type == "Left/Right" then
                    local desync_side = antiaim_callback.current_side 
                    if misses_db == 1 then
                        left_offset = antibrute_builder[aa_state].p1_left_offset:get()
                        right_offset = antibrute_builder[aa_state].p1_right_offset:get()
                    elseif misses_db == 2 then
                        left_offset = antibrute_builder[aa_state].p2_left_offset:get()
                        right_offset = antibrute_builder[aa_state].p2_right_offset:get()
                    elseif misses_db == 3 then
                        left_offset = antibrute_builder[aa_state].p3_left_offset:get()
                        right_offset = antibrute_builder[aa_state].p3_right_offset:get()
                    elseif misses_db == 4 then
                        left_offset = antibrute_builder[aa_state].p4_left_offset:get()
                        right_offset = antibrute_builder[aa_state].p4_right_offset:get()
                    end
                    brute_yaw_offset_add = desync_side and left_offset or right_offset
            
                    -- Reset persistent timing variables when leaving Delayed Switch
                    persistent_start_time = globals.curtime
                    switch_ticks = 0
            
                elseif yaw_type == "Delayed Switch" then
                    -- Retrieve delay settings and left/right offsets
                    if misses_db == 1 then
                        delay_method  = antibrute_builder[aa_state].p1_delay_logic:get()
                        delay_ticks   = antibrute_builder[aa_state].p1_delay_ticks:get()
                        delay_speed   = antibrute_builder[aa_state].p1_delay_speed:get()
                        cosine_random = antibrute_builder[aa_state].p1_cosine_random:get()
                        left_offset   = antibrute_builder[aa_state].p1_left_offset:get()
                        right_offset  = antibrute_builder[aa_state].p1_right_offset:get()
                    elseif misses_db == 2 then
                        delay_method  = antibrute_builder[aa_state].p2_delay_logic:get()
                        delay_ticks   = antibrute_builder[aa_state].p2_delay_ticks:get()
                        delay_speed   = antibrute_builder[aa_state].p2_delay_speed:get()
                        cosine_random = antibrute_builder[aa_state].p2_cosine_random:get()
                        left_offset   = antibrute_builder[aa_state].p2_left_offset:get()
                        right_offset  = antibrute_builder[aa_state].p2_right_offset:get()
                    elseif misses_db == 3 then
                        delay_method  = antibrute_builder[aa_state].p3_delay_logic:get()
                        delay_ticks   = antibrute_builder[aa_state].p3_delay_ticks:get()
                        delay_speed   = antibrute_builder[aa_state].p3_delay_speed:get()
                        cosine_random = antibrute_builder[aa_state].p3_cosine_random:get()
                        left_offset   = antibrute_builder[aa_state].p3_left_offset:get()
                        right_offset  = antibrute_builder[aa_state].p3_right_offset:get()
                    elseif misses_db == 4 then
                        delay_method  = antibrute_builder[aa_state].p4_delay_logic:get()
                        delay_ticks   = antibrute_builder[aa_state].p4_delay_ticks:get()
                        delay_speed   = antibrute_builder[aa_state].p4_delay_speed:get()
                        cosine_random = antibrute_builder[aa_state].p4_cosine_random:get()
                        left_offset   = antibrute_builder[aa_state].p4_left_offset:get()
                        right_offset  = antibrute_builder[aa_state].p4_right_offset:get()
                    end
            
                    -- Initialize persistent_start_time once when entering the phase
                    if persistent_start_time == 0 then
                        persistent_start_time = globals.curtime
                    end
            
                    local switch = false
                    if delay_method == "Cosine" then
                        local current_time = globals.curtime
                        local cosine_formula = (1 + math.cos((current_time - persistent_start_time) * (delay_speed * 3))) / 2
                        local ticks = antiaim_callback.time_to_ticks(delay_speed / 60)
                        local cosine_mapped_ticks = math.floor(cosine_formula * ticks)
                        local half_ticks = math.floor(ticks / 2)
                        switch = cosine_mapped_ticks < half_ticks
            
                    elseif delay_method == "Sine" then
                        local current_time = globals.curtime
                        local sine_formula = (1 + math.sin((current_time - persistent_start_time) * (delay_speed * 3))) / 2
                        local ticks = antiaim_callback.time_to_ticks(delay_speed / 60)
                        local sine_mapped_ticks = math.floor(sine_formula * ticks)
                        local half_ticks = math.floor(ticks / 2)
                        switch = sine_mapped_ticks < half_ticks
            
                    elseif delay_method == "Normal" then
                        local ticks = antiaim_callback.time_to_ticks(delay_ticks / 60)
                        switch_ticks = (switch_ticks + 1) % (ticks + 1)
                        local half_ticks = math.floor(ticks / 2)
                        switch = switch_ticks < half_ticks
                    end
            
                    local random_factor = cosine_random / 100
                    local randomized_offset = math.random(-100, 100) * random_factor
            
                    if switch then
                        brute_yaw_offset_add = left_offset + randomized_offset
                        rage.antiaim:inverter(true)
                    else
                        brute_yaw_offset_add = right_offset + randomized_offset
                        rage.antiaim:inverter(false)
                    end
                end
            
                    -- Yawmod Section
                    if misses_db == 1 then
                        yawmod_type = get_safe_value(antibrute_builder[aa_state].p1_yawmod:get(), "Disabled")
                        yaw_mod_off = get_safe_value(antibrute_builder[aa_state].p1_yawmod_off:get(), 0)
                        yaw_mod_random = get_safe_value(antibrute_builder[aa_state].p1_yawmod_random:get(), 0)
                    elseif misses_db == 2 then
                        yawmod_type = get_safe_value(antibrute_builder[aa_state].p2_yawmod:get(), "Disabled")
                        yaw_mod_off = get_safe_value(antibrute_builder[aa_state].p2_yawmod_off:get(), 0)
                        yaw_mod_random = get_safe_value(antibrute_builder[aa_state].p2_yawmod_random:get(), 0)
                    elseif misses_db == 3 then
                        yawmod_type = get_safe_value(antibrute_builder[aa_state].p3_yawmod:get(), "Disabled")
                        yaw_mod_off = get_safe_value(antibrute_builder[aa_state].p3_yawmod_off:get(), 0)
                        yaw_mod_random = get_safe_value(antibrute_builder[aa_state].p3_yawmod_random:get(), 0)
                    elseif misses_db == 4 then
                        yawmod_type = get_safe_value(antibrute_builder[aa_state].p4_yawmod:get(), "Disabled")
                        yaw_mod_off = get_safe_value(antibrute_builder[aa_state].p4_yawmod_off:get(), 0)
                        yaw_mod_random = get_safe_value(antibrute_builder[aa_state].p4_yawmod_random:get(), 0)
                    end
                
                    -- Safe arithmetic operations
                    if yawmod_type ~= "Disabled" then
                        brute_yawmod_add = yawmod_type
                        -- Ensure both values are numbers before arithmetic
                        if type(yaw_mod_off) == "number" and type(yaw_mod_random) == "number" then
                            brute_yawmod_off_add = utils.random_int(yaw_mod_off, yaw_mod_off + yaw_mod_random)
                        else
                            brute_yawmod_off_add = 0
                        end
                    else
                        brute_yawmod_add = yawmod_type
                        brute_yawmod_off_add = yaw_mod_off or 0
                    end
                
                    -- Safe configuration table

                    antibrute_configs = {
                        custom = {
                            p0 = {
                                get_safe_value(yaw_offset_add, 0),    -- YAW OFF
                                get_safe_value(yawmod_off_add, 0),    -- MOD OFF
                                get_safe_value(yawmod_add, "Disabled")  -- MOD 
                            },
                            p1 = {
                                get_safe_value(brute_yaw_offset_add, 0),
                                get_safe_value(brute_yawmod_off_add, 0),
                                get_safe_value(brute_yawmod_add, "Disabled")
                            },
                            p2 = {
                                get_safe_value(brute_yaw_offset_add, 0),
                                get_safe_value(brute_yawmod_off_add, 0),
                                get_safe_value(brute_yawmod_add, "Disabled")
                            },
                            p3 = {
                                get_safe_value(brute_yaw_offset_add, 0),
                                get_safe_value(brute_yawmod_off_add, 0),
                                get_safe_value(brute_yawmod_add, "Disabled")
                            },
                            p4 = {
                                get_safe_value(brute_yaw_offset_add, 0),
                                get_safe_value(brute_yawmod_off_add, 0),
                                get_safe_value(brute_yawmod_add, "Disabled")
                            },
                        }
                    }
                
                    -- Safe array access
                    if antibrute_configs.custom["p"..misses_db] then
                        yaw_offset_add = antibrute_configs.custom["p"..misses_db][1]
                        yawmod_off_add = antibrute_configs.custom["p"..misses_db][2]
                        yawmod_add = antibrute_configs.custom["p"..misses_db][3]
                    end
                end
                


            
    if menu_items.aa.safe_head:get() then
        local local_player = entity.get_local_player()
        if local_player == nil then return end
        local weapon = local_player:get_player_weapon()
        if not weapon then return end
        local name = weapon:get_classname()

        if anti_aim_states() == 8 then
            if string.match(name, "Knife") or string.match(name, "Taser") then
                refs.hidden:set(false)
                options_add = ""
                yawmod_add = "Disabled"
                yaw_offset_add = 0
                refs.inverter:set(true)
            end
        end
    end
    -- Set final values
    refs.pitch:set(pitch_add or "Down")
    refs.yawoffset:set(yaw_offset_add)
    refs.yawoff:set(yawmod_off_add or 0)
    refs.yawmod:set(yawmod_add or "Disabled")
    refs.bodyyaw:set(body_yaw_add)
    refs.options:set(options_add)
    refs.freestanding:set(freestanding_add)
    refs.right_limit:set(right_limit_add)
    refs.left_limit:set(left_limit_add)
    end



    local manual_yaw = menu_items.aa.manual_yaw:get()

    if manual_yaw == "Left" then
        refs.yawoffset:set(-90)
    elseif manual_yaw == "Right" then
        refs.yawoffset:set(90)
    elseif manual_yaw == "Disabled" then
        refs.yawoffset:set(yaw_offset_add) -- error here
        refs.freestand:override(false)  
    elseif manual_yaw == "Freestanding" and antiaim_callback.freestand_disablers(true) then
        refs.freestand:override(true)
    else
        refs.freestand:override(false)
    end


    if menu_items.aa.auto_tp:get() then
        if local_player == nil then return end
            local weapon = local_player:get_player_weapon()
            if not weapon then return end
            local index = weapon:get_weapon_index()
            local name = weapon:get_classname()


            local auto_tp_enabled = false
            if refs.hideshots:get() then return end
            if gears_items.disable_tp:get("Peek Assist") and refs.ap:get() then return end
            if gears_items.disable_tp:get("CT Team") and local_player.m_iTeamNum == 3 then return end

            if gears_items.teleport_weapon:get("Scout") and string.match(name, "SSG08") then auto_tp_enabled = true end
            if gears_items.teleport_weapon:get("Taser") and string.match(name, "Taser") then auto_tp_enabled = true end
            if gears_items.teleport_weapon:get("Knife") and string.match(name, "Knife") then auto_tp_enabled = true end
            if gears_items.teleport_weapon:get("AWP") and string.match(name, "AWP") then auto_tp_enabled = true end
            if gears_items.teleport_weapon:get("Shotgun") and (string.match(name, "Mag7") or string.match(name, "Sawedoff") or string.match(name, "NOVA") or string.match(name, "XM1014")) then auto_tp_enabled = true end
            if gears_items.teleport_weapon:get("Pistols") and (string.match(name, "Glock") or string.match(name, "P250") or string.match(name, "FiveSeven") or string.match(name, "DEagle") or string.match(name, "Elite") or string.match(name, "Tec9") or string.match(name, "HKP2000")) then auto_tp_enabled = true end

                    if (auto_tp_enabled == true and entity.get_threat(true) ~= nil) then
                        rage.exploit:force_teleport()
                        auto_tp_enabled = false
                    end
                end
                
        if menu_items.aa.avoid_backstab:get() then
            refs.backstab:override(true)
        else
            refs.backstab:override(false)
        end
    if menu_items.aa.style_aa:get() == 2 then
    return
    end
    end


    local settings_callback = {}

    settings_callback.power_off = function()
        if not menu_items.settings.toggle_settings:get() then 
            menu_items.settings.aspect_ratio:set(false)
            menu_items.settings.scope_overlay:set(false)
            menu_items.settings.performance_mode:set(false)
            menu_items.settings.viewmodel:set(false)
            menu_items.settings.override_indicator:set(false)
            menu_items.settings.fake_latency:set(false)
            menu_items.settings.logs:set(false)
            menu_items.settings.hitchance:set(false)
            menu_items.settings.ragebot_logic:set(false)
        end
    end

    a = 0
b = 0
c = 0
d = 0
e = 0

    sktch_fnt = render.load_font("Calibri", vector(23, 23.5), "adb")
    local stats = {
        total_shots = 0,
        hits = 0
    }
    settings_callback.skeet_indicator = function()
        if not menu_items.settings.skeet_indicators:get() then return end
        local binds = ui.get_binds()
        local local_player = entity.get_local_player()
        if not globals.is_in_game then return end
        if not local_player:is_alive() then return end
        local screensize = render.screen_size()
        local ind_dst = 0
        local ind_spr = 40
        local txtm = render.measure_text(sktch_fnt, "c", "DT")
        local clr_dt
        if not gears_items.skeet_indicators_sel:get("Double Tap") then
            clr_dt = color(225, 57, 57, 0)
        elseif gears_items.skeet_indicators_sel:get("Double Tap") and rage.exploit:get() < 1 then
            clr_dt = color(220, 21, 21)
        else
            clr_dt = color(225, 255, 255)
        end
        for i = 1, #binds do
            local c_name = binds[i].name
            if c_name == 'Min. Damage' and binds[i].active then
                b = 1
                c = binds[i].value
            end
        end
        if c ~= refs.mindmg:get() then
            b = 0
        end

        for i = 1, #binds do
            local c_name2 = binds[i].name
            if c_name2 == 'Hit Chance' and binds[i].active then
                d = 1
                e = binds[i].value
            end
        end
        if e ~= refs.hc:get() then
            d = 0
        end
        if gears_items.skeet_indicators_sel:get("Double Tap") and refs.dt:get() then
            render.gradient(vector(48 - txtm.x, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 - 2), vector(27 - txtm.x + 10, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 + txtm.y), color(0, 0, 0, 60), color(0, 0, 0, 5), color(0, 0, 0, 50), color(0, 0, 0, 5))
            render.gradient(vector(48 - txtm.x, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 - 2), vector(27 - txtm.x + 50, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 + txtm.y), color(0, 0, 0, 60), color(0, 0, 0, 5),color(0, 0, 0, 50), color(0, 0, 0, 5))
            render.text(sktch_fnt, vector(17, gears_items.skeet_padding:get() + screensize.y / 1.75  + ind_dst + 100), clr_dt, "с", "DT") ind_dst = ind_dst + ind_spr
        end
        if gears_items.skeet_indicators_sel:get("Hideshots") and refs.hideshots:get() then
            render.gradient(vector(48 - txtm.x, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst - 5 + 100 - 2),vector(27 - txtm.x + 10, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 + txtm.y - 5), color(0, 0, 0, 60), color(0, 0, 0, 5), color(0, 0, 0, 50), color(0, 0, 0, 5))
            render.gradient(vector(48 - txtm.x, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst - 5 + 100 - 2),vector(27 - txtm.x + 50, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 + txtm.y - 5), color(0, 0, 0, 60), color(0, 0, 0, 5), color(0, 0, 0, 50), color(0, 0, 0, 5)) 
            render.text(sktch_fnt, vector(17, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst - 5 + 100), color(136, 207, 52), "с", "ONSHOT") ind_dst = ind_dst + ind_spr
        end
        if gears_items.skeet_indicators_sel:get("Dormant Aimbot") and refs.DA:get() then
            render.gradient(vector(48 - txtm.x, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 - 2 - 5),vector(27 - txtm.x + 10, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 + txtm.y - 5), color(0, 0, 0, 60), color(0, 0, 0, 5), color(0, 0, 0, 50), color(0, 0, 0, 5))
            render.gradient(vector(48 - txtm.x, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 - 2 - 5), vector(27 - txtm.x + 50, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 + txtm.y - 5), color(0, 0, 0, 60), color(0, 0, 0, 5), color(0, 0, 0, 50), color(0, 0, 0, 5))
            render.text(sktch_fnt, vector(17, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst - 5 + 100), color(136, 207, 52), "с", "DA") ind_dst = ind_dst + ind_spr
        end
        if gears_items.skeet_indicators_sel:get("Safepoint") and refs.safepoint:get() == "Force" then
            render.gradient(vector(48 - txtm.x, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 - 2 - 5), vector(27 - txtm.x + 10, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 + txtm.y - 5), color(0, 0, 0, 60), color(0, 0, 0, 5), color(0, 0, 0, 50), color(0, 0, 0, 5))
            render.gradient(vector(48 - txtm.x, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 - 2 - 5), vector(27 - txtm.x + 50, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 + txtm.y - 5), color(0, 0, 0, 60), color(0, 0, 0, 5), color(0, 0, 0, 50), color(0, 0, 0, 5))
            render.text(sktch_fnt, vector(17, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst - 5 + 100), color(136, 207, 52), "с", "SAFE") ind_dst = ind_dst + ind_spr
        end
        if gears_items.skeet_indicators_sel:get("Body Aim") and refs.Body:get() == "Force" then
            render.gradient(vector(48 - txtm.x, gears_items.skeet_padding:get() +  screensize.y / 1.75 + ind_dst + 100 - 2 - 5), vector(27 - txtm.x + 10, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 + txtm.y - 5), color(0, 0, 0, 60), color(0, 0, 0, 5), color(0, 0, 0, 50), color(0, 0, 0, 5))
            render.gradient(vector(48 - txtm.x, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 - 2 - 5),vector(27 - txtm.x + 50, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 + txtm.y - 5), color(0, 0, 0, 60),color(0, 0, 0, 5), color(0, 0, 0, 50), color(0, 0, 0, 5))
            render.text(sktch_fnt, vector(17, gears_items.skeet_padding:get() +screensize.y / 1.75 + ind_dst - 5 + 100), color(136, 207, 52), "с", "BAIM") ind_dst = ind_dst + ind_spr
        end
        if gears_items.skeet_indicators_sel:get("Freestanding") and refs.freestand:get() then
            render.gradient(vector(48 - txtm.x, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 - 2 - 5),vector(27 - txtm.x + 10, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 + txtm.y - 5), color(0, 0, 0, 60),color(0, 0, 0, 5), color(0, 0, 0, 50), color(0, 0, 0, 5))
            render.gradient(vector(48 - txtm.x, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 - 2 - 5),vector(27 - txtm.x + 50, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 + txtm.y - 5), color(0, 0, 0, 60),color(0, 0, 0, 5), color(0, 0, 0, 50), color(0, 0, 0, 5))
            render.text(sktch_fnt, vector(17, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst - 5 + 100), color(136, 207, 52), "с", "Freestanding")ind_dst = ind_dst + ind_spr
        end
        if gears_items.skeet_indicators_sel:get("Fake Duck") and refs.fd:get() then
            render.gradient(vector(48 - txtm.x, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst - 5 + 100 - 2),vector(27 - txtm.x + 10, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 + txtm.y - 5), color(0, 0, 0, 60),color(0, 0, 0, 5), color(0, 0, 0, 50), color(0, 0, 0, 5))
            render.gradient(vector(48 - txtm.x, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst - 5 + 100 - 2),vector(27 - txtm.x + 50, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 100 + txtm.y - 5), color(0, 0, 0, 60),color(0, 0, 0, 5), color(0, 0, 0, 50), color(0, 0, 0, 5))
            render.text(sktch_fnt, vector(17, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst - 5 + 100), color(136, 207, 52), "с", "FD")ind_dst = ind_dst + ind_spr
        end
        if gears_items.skeet_indicators_sel:get("Minimum Damage") and b == 1 then
            render.gradient(vector(48 - txtm.x, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 95 - 2 - 5),vector(27 - txtm.x + 10, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 95 + txtm.y - 5), color(0, 0, 0, 60),color(0, 0, 0, 5), color(0, 0, 0, 50), color(0, 0, 0, 5))
            render.gradient(vector(48 - txtm.x, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 95 - 2 - 5),vector(27 - txtm.x + 50, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 95 + txtm.y - 5), color(0, 0, 0, 60),color(0, 0, 0, 5), color(0, 0, 0, 50), color(0, 0, 0, 5))
            render.text(sktch_fnt, vector(17, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst - 5 + 95), color(255, 255, 255), "с", "DMG: ",refs.mindmg:get()) ind_dst = ind_dst + ind_spr
        end
        if gears_items.skeet_indicators_sel:get("Hitchance") and d == 1 then
            render.gradient(vector(48 - txtm.x, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 95 - 2 - 10),vector(27 - txtm.x + 10, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 95 + txtm.y - 10), color(0, 0, 0, 60),color(0, 0, 0, 5), color(0, 0, 0, 50), color(0, 0, 0, 5))
            render.gradient(vector(48 - txtm.x, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 95 - 2 - 10),vector(27 - txtm.x + 50, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 95 + txtm.y - 10), color(0, 0, 0, 60), color(0, 0, 0, 5), color(0, 0, 0, 50), color(0, 0, 0, 5))
            render.text(sktch_fnt, vector(17, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 90), color(255, 255, 255), "с", "HC: ",refs.hc:get())ind_dst = ind_dst + ind_spr
        end
        if gears_items.skeet_indicators_sel:get("Ping") and refs.fping:get() ~= 0 then
            render.gradient(vector(48 - txtm.x, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 90 - 2),vector(27 - txtm.x + 10, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 90 + txtm.y), color(0, 0, 0, 60), color(0, 0, 0, 5),color(0, 0, 0, 50), color(0, 0, 0, 5))
            render.gradient(vector(48 - txtm.x, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 90 - 2),vector(27 - txtm.x + 50, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 90 + txtm.y), color(0, 0, 0, 60), color(0, 0, 0, 5),color(0, 0, 0, 50), color(0, 0, 0, 5))
            render.text(sktch_fnt, vector(17, gears_items.skeet_padding:get() + screensize.y / 1.75 + ind_dst + 92), color(300 - refs.fping:get(), 207, 52), "с", "PING") ind_dst = ind_dst + ind_spr
        end
        
        
        -- client.set_event_callback("player_connect_full", function(e)
        --     if client.userid_to_entindex(e.userid) == entity.get_local_player() then
        --         stats = {
        --             total_shots = 0,
        --             hits = 0
        --         }
        --     end
        -- end)
        
    end

    if stats.total_shots > 0 then
        local accuracy_text = string.format("%s/%s (%.1f%%)", stats.hits, stats.total_shots, (stats.hits / stats.total_shots) * 100)
            print(accuracy_text)
            print(stats.hits, stats.total_shots, (stats.hits / stats.total_shots) * 100)
    end

    local flag_urls = {
        Germany = "https://www.worldometers.info/img/flags/gm-flag.gif",
        Netherlands = "https://www.worldometers.info/img/flags/nl-flag.gif",
        Russia = "https://www.worldometers.info/img/flags/rs-flag.gif",
        Sweden = "https://www.worldometers.info/img/flags/sw-flag.gif",
        Finland = "https://www.worldometers.info/img/flags/fi-flag.gif",
        Norway = "https://www.worldometers.info/img/flags/no-flag.gif",
        Poland = "https://www.worldometers.info/img/flags/pl-flag.gif",
        Romania = "https://www.worldometers.info/img/flags/ro-flag.gif",
        Turkey = "https://www.worldometers.info/img/flags/tu-flag.gif",
        UK = "https://www.worldometers.info/img/flags/uk-flag.gif",
        France = "https://www.worldometers.info/img/flags/fr-flag.gif",
        Denmark = "https://www.worldometers.info/img/flags/da-flag.gif",
        Hungary = "https://www.worldometers.info/img/flags/hu-flag.gif"
    }
    local cached_pfps = {}
    local last_selected_flag = nil
    


    local previous_aspect_ratio = nil
    settings_callback.aspect_ratio = function()
        if not menu_items.settings.aspect_ratio:get() then return end
    
        local values = {
            ["16:9"] = 177,
            ["16:10"] = 160,
            ["3:2"] = 150,
            ["4:3"] = 133,
            ["5:4"] = 125
        }
    
        local buttons = {
            ["16:9"] = gears_items.aspect_ratio_169,
            ["16:10"] = gears_items.aspect_ratio_1610,
            ["3:2"] = gears_items.aspect_ratio_32,
            ["4:3"] = gears_items.aspect_ratio_43,
            ["5:4"] = gears_items.aspect_ratio_54
        }
    
        for ratio, button in pairs(buttons) do
            button:set_callback(function()
                local value = values[ratio]
                if value then
                    aspect_ratio_slider:set(value)
                    cvar.r_aspectratio:float(value / 100)
                    previous_aspect_ratio = value
                end
            end)
        end
    end
    
    
    settings_callback.aspect_ratio_handler = function()
        local current_aspect_ratio = aspect_ratio_slider:get()
        if current_aspect_ratio ~= previous_aspect_ratio then
            previous_aspect_ratio = current_aspect_ratio
            cvar.r_aspectratio:float(current_aspect_ratio / 100)
        end
    end


local currentDisplayedValue = 0  
    settings_callback.get_distance = function(player, enemy)
        local pos1 = player['m_vecOrigin']
        local pos2 = enemy['m_vecOrigin']

        if pos1 and pos2 then
            local dx = pos2.x - pos1.x
            local dy = pos2.y - pos1.y
            local dz = pos2.z - pos1.z

            local distance = math.sqrt(dx * dx + dy * dy + dz * dz)
            
            currentDisplayedValue = math.floor(math.max(0, math.min(100, 100 - ((distance - 310) / 1)))) 

            return distance
        end

        return nil
    end

    --local dormant_aimbot_lua_ref = ui.find("Scripts", "\aE2F5FDE8D\aD0EEFDD9o\aBDE8FCC9r\aAAE2FBBAm\a98DBFAABa\a85D5FA9Cn\a72CEF98Dt\a60C8F87D \a4DC1F76EA\a3ABBF75Fi\a27B5F650m\a15AEF541b\a02A8F432o\a02A8F432t", "dormant aimbot", "dormant aimbot", "Dormant aimbot")


    local phase_first = {
        "♛ ｖｅｎｔｕｒｅ.ｌｕａ♛",
        "ＴＡＰＰＥＤ ＢＹ ＶＥＮＴＵＲＥ(っ◔◡◔)っ",
        "▶ＪＵＳＴ ＧＥＴ ＶＥＮＴＵＲＥ.ＬＵＡ ＲＥＴＡＲＤ",
        "ｖｅｎｔｕｒｅ.ｌｕａ ｄｏｎｔ ｎｅｅｄ ｕｐｄａｔｅ (◣◢)",
        "ᴡʜʏ ʏᴏᴜ ᴅᴇᴀᴅ ɴᴏᴏʙ? ɢᴏ ʙᴜʏ ᴠᴇɴᴛᴜʀᴇ -  ʜᴛᴛᴘs://ɴᴇᴠᴇʀʟᴏsᴇ.ᴄᴄ/ᴍᴀʀᴋᴇᴛ/ɪᴛᴇᴍ?ɪᴅ=9ʙǫɢʙʜ",
        "♕ ᴠᴇɴᴛᴜʀᴇ ɢɪᴠᴇs ᴍᴇ ɢᴏᴅ ᴍᴏᴅᴇ ♕",
        "１ , ｉ ｃａｎｔ ｆｅｅｌ ｕｒ ａｎｔｉ -ａｉｍｓ",
        "ｓｌｅｅｐ ｎｉｇｇａ ⸜(｡˃ ᵕ ˂ )⸝♡",
        "ｈｔｔｐｓ://ｄｉｓｃｏｒｄ.ｇｇ/ｈ７ＺｈＴ８ｂＹｐＫ  (,,> ᴗ <,,)",
        "♕ ɪ sᴍᴏᴋᴇ ᴡɪɴsᴛᴏɴ ɪɴ ᴍʏ ᴍ5 ᴀɴᴅ ꜰᴜᴄᴋ ʏᴏᴜ ᴀɴᴅ ʏᴏᴜʀ ᴍᴏᴍ ♕",
        "𝕋ℍ𝔸ℕ𝕂 𝕐𝕆𝕌  𝙼𝙸𝙻𝙻𝙸𝚃𝙾𝙽 𝔽𝕆ℝ 𝕄𝔸𝕂𝕀ℕ𝔾 𝕍Ɇ₦₮ɄⱤɆ.ⱠɄ₳",
        "•┈┈┈••✦ 𝙿𝚁𝙰𝚈 𝚃𝙾 𝙼𝚈 𝙳𝙸𝙲𝙺 ✦••┈┈┈•",
        "sᴛᴀʏ ᴜɴʜɪᴛᴛᴀʙʟᴇ - sᴛᴀʏ ᴠᴇɴᴛᴜʀᴇ.ʟᴜᴀ",
        "【ＶＥＮＴＵＲＥ.ＬＵＡ ＡＮＴＩ-ＡＩＭＢＯＴ ＳＹＳＴＥＭ   (◣◢)】",
        "𝐗𝐃, 𝐔 𝐑𝐄𝐀𝐋𝐋𝐘 𝐓𝐇𝐈𝐍𝐊 𝐔 𝐂𝐀𝐍 𝐁𝐄𝐀𝐓 𝐌𝐘 𝐀𝐀?",
        "Ｉ ＰＩＳＳＥＤ ＹＯＵ ＢＩＴＣＨ, ＨＡＨＡＨＡ",
        "【»»»𝙸 𝚂𝙼𝙾𝙺𝙴 𝙲𝙷𝙰𝙿𝙼𝙰𝙽 𝙰𝙽𝙳 𝙵𝚄𝙲𝙺 𝚈𝙾𝚄«««",
        "Venture 2025® 1NLE best lua",
        "отлетел от Venture (￣_￣)",
        "упал от лучшей луа Venture (◕‿◕)"

    }
    
    
    local phase_dead = {
        "ꜰᴜᴄᴋɪɴɢ ʙᴏᴛ ᴡʜᴀᴛ ᴅɪᴅ ʏᴏᴜ ᴅᴏ?",
        "ʙʀᴀᴠᴏ ꜰᴜᴄᴋɪɴɢ ʀᴇᴛᴀʀᴅ, ᴡᴘ.",
        "𝚊𝚏𝚝𝚎𝚛 𝚢𝚘𝚞𝚛 𝚊𝚌𝚝𝚒𝚘𝚗𝚜, 𝚒 𝚠𝚘𝚞𝚕𝚍 𝚐𝚘𝚞𝚐𝚎 𝚘𝚞𝚝 𝚖𝚢 𝚎𝚢𝚎𝚜.",
        "𝚎𝚟𝚎𝚗 𝚖𝚢 𝚐𝚛𝚊𝚗𝚍𝚖𝚊 𝚖𝚘𝚟𝚎𝚜 𝚋𝚎𝚝𝚝𝚎𝚛 𝚝𝚑𝚊𝚗 𝚢𝚘𝚞",
        "ʟᴜᴄᴋʙᴀsᴇᴅ ʙᴏᴛ ᴋɪʟʟᴇᴅ ᴍᴇ, sᴏ ᴄʀɪɴɢᴇ.",
        "ᴡʜᴇɴ ʏᴏᴜ ᴡɪʟʟ sʟᴇᴇᴘ - ɪ ᴡɪʟʟ ᴋɴɪꜰᴇ ᴜ ᴘɪᴇᴄᴇ ᴏꜰ sʜɪᴛ.",
        "AHAHAHAHAHHAHAHAH, ᴡᴀɪᴛ ꜰᴏʀ ᴛʜᴇ ɴᴇxᴛ ʀᴏᴜɴᴅ.",
        "𝐢 𝐬𝐡𝐢𝐭 𝐨𝐧 𝐲𝐨𝐮𝐫 𝐝𝐚𝐝'𝐬 𝐡𝐞𝐚𝐝",
        "𝐢'𝐯𝐞 𝐧𝐞𝐯𝐞𝐫 𝐬𝐞𝐞𝐧 𝐚 𝐝𝐮𝐦𝐛𝐞𝐫 𝐩𝐞𝐫𝐬𝐨𝐧 𝐥𝐢𝐤𝐞 𝐲𝐨𝐮, 𝐤𝐲𝐬.",
        "𝐨𝐤 𝐥𝐮𝐜𝐤 𝐢𝐬 𝐨𝐧 𝐲𝐨𝐮𝐫 𝐬𝐢𝐝𝐞",
    }

    events.player_death:set(function(e)
        if not menu_items.settings.trashtalk:get() then return end
        local lp = entity.get_local_player()
       -- if (lp == nil or not lp:is_alive()) then return end 
        
        local attacker = entity.get(e.attacker, true)
        local victim = entity_get(e.userid, true)

        if lp == attacker and victim ~= lp then
            utils.execute_after(2, utils.console_exec,"say "..phase_first[math.random(1, #phase_first)])
        end
        if victim == lp and attacker:get_name() ~= "CWorld" and gears_items.trashtalk_death:get()then
            utils.execute_after(2, utils.console_exec,"say "..phase_dead[math.random(1, #phase_dead)])
        end
    end)



    settings_callback.dormant_logic = function()
        local player = entity.get_local_player()
        if not player or not player:is_alive() then return end
        if not menu_items.settings.ragebot_logic:get() then return end
        if not gears_items.dormant_logic:get() then return end
        
        local screen_size = render.screen_size() / 2
        local x = screen_size.x
        local y = screen_size.y
    
        local enemies = entity.get_players(player_enemies, true)
    
        if enemies then
        for _, enemy in ipairs(enemies) do
            if enemy:is_alive() and enemy:is_dormant() then
                render.text(2, vector(x+ 905 ,y), color(255,255,255,255), "c", "DORMANT AIMBOT ON")
                refs.DA:set(true)
                --dormant_aimbot_lua_ref:set(true)
                         else
                refs.DA:set(false)
                --dormant_aimbot_lua_ref:set(true)
                end
            end
        end
    end

settings_callback.force100 = function()
    local player = entity.get_local_player()
    if not player or not player:is_alive() then return end
    if not menu_items.settings.ragebot_logic:get() then return end
    if not gears_items.close_aimbot:get() then return end
        local weapon = player:get_player_weapon()
        local index = weapon:get_weapon_index()

        if index == 40 then
            local enemies = entity.get_players(player_enemies, true) 

            if enemies then  -- Ensure enemies is not nil
                for _, enemy in ipairs(enemies) do
                    if enemy and enemy:is_alive() then  -- Check if enemy is valid and alive
                        if player.m_iHealth < 92 or player.m_ArmorValue == 0 then
                            local distance = settings_callback.get_distance(player, enemy)
                            if distance and distance <= 350 then
                                ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Min. Damage"):override(100)
                            else
                                return end
                        end
                    end
                end
            end
        end
    end


settings_callback.baim_lethal = function()
    local player = entity.get_local_player()
    if not player or not player:is_alive() then return end
    if not menu_items.settings.ragebot_logic:get() then return end
    if not gears_items.baim_logic:get() then return end
            local weapon = player:get_player_weapon()
            local weapon_id = weapon:get_weapon_index()

            if not player or not player:is_alive() then
                return
            end

            if weapon == nil or false then
                return
            end

            threat = entity.get_threat()
            if not threat then
                return
            end

            if weapon_id == 40 then
                hp = threat.m_iHealth

                if hp <= 90 and hp > 0 then
                    refs.Body:override("Force")
                elseif hp > 90 then
                    return 
                end
            end
        end

    settings_callback.scope_overlay = function()
        local r, g, b, a = gears_items.scope_color:get().r, gears_items.scope_color:get().b, gears_items.scope_color:get().g, gears_items.scope_color:get().a
        local inverted = gears_items.scope_inverted:get()
        local screen_size_x = render.screen_size().x
        local screen_size_y = render.screen_size().y

        lp = entity.get_local_player()
            if not lp then return end
            if not lp:is_alive() then return end
            if not menu_items.settings.toggle_settings:get() then return end
            if not menu_items.settings.scope_overlay:get() then return end
                refs.scope:set("Remove All")
                if entity.get_local_player().m_bIsScoped then
                    render.gradient(vector(screen_size_x / 2 + gears_items.scope_gap:get() + 1, screen_size_y / 2),
                        vector(screen_size_x / 2 + gears_items.scope_gap:get() + gears_items.scope_size:get() + 1, screen_size_y / 2 + 1),
                        color(r, g, b, not inverted and a or 0), color(r, g, b, inverted and a or 0),
                        color(r, g, b, not inverted and a or 0), color(r, g, b, inverted and a or 0)) --right
                    render.gradient(vector(screen_size_x / 2 - gears_items.scope_gap:get(), screen_size_y / 2),
                        vector(screen_size_x / 2 - gears_items.scope_gap:get() - gears_items.scope_size:get(), screen_size_y / 2 + 1),
                        color(r, g, b, not inverted and a or 0), color(r, g, b, inverted and a or 0),
                        color(r, g, b, not inverted and a or 0), color(r, g, b, inverted and a or 0)) --left
                    render.gradient(vector(screen_size_x / 2, screen_size_y / 2 - gears_items.scope_gap:get()),
                        vector(screen_size_x / 2 + 1, screen_size_y / 2 - gears_items.scope_gap:get() - gears_items.scope_size:get()),
                        color(r, g, b, not inverted and a or 0), color(r, g, b, not inverted and a or 0),
                        color(r, g, b, inverted and a or 0), color(r, g, b, inverted and a or 0)) --up
                    render.gradient(vector(screen_size_x / 2, screen_size_y / 2 + gears_items.scope_gap:get() + 1),
                        vector(screen_size_x / 2 + 1, screen_size_y / 2 + gears_items.scope_gap:get() + gears_items.scope_size:get() + 1),
                        color(r, g, b, not inverted and a or 0), color(r, g, b, not inverted and a or 0),
                        color(r, g, b, inverted and a or 0), color(r, g, b, inverted and a or 0)) --down
        end
    end


    settings_callback.unset_viewmodel = function()
        cvar.viewmodel_fov:float(tonumber(cvar.viewmodel_fov:string()))
        cvar.viewmodel_offset_x:float(tonumber(cvar.viewmodel_offset_x:string()))
        cvar.viewmodel_offset_y:float(tonumber(cvar.viewmodel_offset_y:string()))
        cvar.viewmodel_offset_z:float(tonumber(cvar.viewmodel_offset_z:string()))
    end

    settings_callback.set_viewmodel = function()
    if not menu_items.settings.viewmodel:get() then return settings_callback.unset_viewmodel() end
        cvar.viewmodel_fov:float(gears_items.viewmodel_fov:get() / 10, true)
        cvar.viewmodel_offset_x:float(gears_items.viewmodel_xoff:get() / 10, true)
        cvar.viewmodel_offset_y:float(gears_items.viewmodel_yoff:get() / 10, true)
        cvar.viewmodel_offset_z:float(gears_items.viewmodel_zoff:get() / 10, true)
end

    
settings_callback.override_indicator = function()
    if not menu_items.settings.override_indicator:get() then return end
    local active_binds = ui.get_binds()
    local screensize = render.screen_size()
    x_add_lua = scope_animation(scoped, x_add_lua, 31, 10) or 0

       if gears_items.override_indicator_options:get("Damage") then
            for i, v in pairs(active_binds) do
                if v.name ~= "Min. Damage" then goto continue end

                render.text(gears_items.override_indicator_font:get(), vector(screensize.x / 2 + 14 + x_add_lua, screensize.y / 2 - 12), gears_items.override_indicator_color:get(), "C", v.value)
                ::continue::
            end
        end
        if gears_items.override_indicator_options:get("Hitchance") then
            for i, v in pairs(active_binds) do
                if v.name ~= "Hit Chance" then goto continue end

                render.text(gears_items.override_indicator_font:get(), vector(screensize.x / 2 + 14 + x_add_lua, screensize.y / 2 - 22), gears_items.override_indicator_color:get(), "", v.value)
                ::continue::
            end
        end
end
settings_callback.fake_latency = function()
    if menu_items.settings.fake_latency:get() then
        ui.find("Miscellaneous", "Main", "Other", "Fake Latency"):override(gears_items.fake_latency_amount:get())
    else
        ui.find("Miscellaneous", "Main", "Other", "Fake Latency"):override(ui.find("Miscellaneous", "Main", "Other", "Fake Latency"):get())
    end
end

settings_callback.lerpik = function(start, vend, time)
    return start + (vend - start) * time
end


local attacked = {}
local LnextIndex = 1
local LtextXpos = render.screen_size().x/2-105 
local LrectXpos = render.screen_size().x/2-120 
local LtextYposoffset = 9
local LrectHeight = 25
local LtextOffset = 5
local LmaxPos = 300
local LrectYpos = 240
local LMAX_LOGS = 3  
local hitgroup_str = {
    [0] = 'generic',
    'head',
    'chest',
    'stomach',
    'left arm',
    'right arm',
    'left leg',
    'right leg',
    'head',
    'generic',
    'gear'
}


settings_callback.logs_processing = function(e) 
    if menu_items.settings.logs:get() and gears_items.logs_events:get("Aimbot") and gears_items.logs_option:get('Screen') then
    local newLog = {
        event = e,
        log = {
            current_y = 960,
            target_y = 930 - ((#attacked < LMAX_LOGS and #attacked or LMAX_LOGS) * 30),
            alpha = 500,
            moving_up = true,
        }
    }

    if #attacked < LMAX_LOGS then
        table.insert(attacked, newLog)
    else
        attacked[LnextIndex] = newLog
        LnextIndex = LnextIndex % LMAX_LOGS + 1
    end
end
end

-- local watermark_pos = {
--     log = {
--         current_y = 3,
--         current_x = 10,
--     }
-- }
local antiBruteforceLog = {
    alpha = 1000,
    current_y = 930,
    target_y = 930 -- You can adjust this if you want an animated effect
}

settings_callback.render_events = function()
    watermark_selected_pos = gears_items.watermark_position:get()
    if watermark_selected_pos == "Top Right" then
        current_y = 3
        current_x = 890
    elseif watermark_selected_pos == "Top Left" then
        current_y = 3
        current_x = -865
    elseif watermark_selected_pos == "Top" then
        current_y = 3
        current_x = 10
    elseif watermark_selected_pos == "Bottom Right" then
        current_y = 1050
        current_x = 890
    elseif watermark_selected_pos == "Bottom Left" then
        current_y = 1050
        current_x = -868
    elseif watermark_selected_pos == "Bottom" then
        current_y = 1050
        current_x = 20
    end
    
    lp = entity.get_local_player()

    if not lp or not lp:is_alive() then 
        wtm_condition = "offline"
    else
        wtm_condition = "active"
    end

    local watermark_size = render.measure_text(1, "", "venture  ✧  secret  ✧  "..wtm_condition)

    local venture_animtext = lib.gradient.text_animate("venture", -0.5, {
        color(255,255,255,255), 
        color(menu_items.main.wmk_color:get().r, menu_items.main.wmk_color:get().g, menu_items.main.wmk_color:get().b, menu_items.main.wmk_color:get().a)
    })

    

    local watermark_start = vector(LrectXpos - watermark_size.x/2 + 98 + current_x, current_y - 1)
    local watermark_end = vector(LrectXpos + LrectYpos + watermark_size.x/2 - 123 + current_x, current_y + LrectHeight + 
    1)
    if gears_items.border_switch:get() then
        if gears_items.border_types:get("Shadow") then
    render.shadow(watermark_start, watermark_end, color(menu_items.main.wmk_color:get().r, menu_items.main.wmk_color:get().g, menu_items.main.wmk_color:get().b, menu_items.main.wmk_color:get().a), 35, 0, 5)
        end
    end
    render.rect(watermark_start, watermark_end, color(30, 30, 30, 255), 4)

    if gears_items.border_switch:get() then
        if gears_items.border_types:get("Outline") then
    render.rect_outline(watermark_start, watermark_end, color(menu_items.main.wmk_color:get().r, menu_items.main.wmk_color:get().g, menu_items.main.wmk_color:get().b, 255), gears_items.border_thickness:get(), 4)
        end
    end
    
    local LtextPosHit = vector(LtextXpos - watermark_size.x/2 + 93 + current_x, current_y + LtextOffset + 1)

    render.text(
        1,
        LtextPosHit,
        color(175, 175, 175, 255),
        nil,
        "\a" .. menu_items.main.wmk_color:get():to_hex() ..venture_animtext:get_animated_text().."  \aFFFFFFFF✧\a"..menu_items.main.wmk_color:get():to_hex()..  "  secret".."  \aFFFFFFFF✧\a"..menu_items.main.wmk_color:get():to_hex().."  ".. wtm_condition


       )
       venture_animtext:animate()



    if not lp then return end

    local players = entity.get_players(true, true)
    if not players or #players == 0 then
        return 
    end

    if menu_items.settings.logs:get() and gears_items.logs_events:get("Anti-Brute") then
    for i = #antiBruteforceLogs, 1, -1 do
        local log = antiBruteforceLogs[i]
        
        -- Animate vertical position (for a smooth slide effect)
        log.current_y = settings_callback.lerpik(log.current_y, log.target_y, 0.05)
        
        -- Determine the text message based on misses_db
-- Determine the text message based on the stored phase for this log:
        local messageText = ""
        if misses_db == 0 then
            messageText = "V  anti-brute force reseted"
        else
            -- If the log entry doesn’t yet have a stored phase, store the current misses_db
            if not log.display_phase then
                log.display_phase = misses_db
            end
            messageText = "V  anti-brute force updated (phase " .. log.display_phase .. ")"
        end


        -- Measure text size so we can center the box correctly
        local antibrute_size = render.measure_text(1, "", messageText)
        local anti_current_x = 20  -- horizontal offset
        
        -- Determine the positions for the box background
        local antibrute_start = vector(LrectXpos - antibrute_size.x/2 + 98 + anti_current_x, log.current_y - 1)
        local antibrute_end   = vector(LrectXpos + LrectYpos + antibrute_size.x/2 - 123 + anti_current_x, log.current_y + LrectHeight + 1)
        
        -- Render the shadow if enabled
        if gears_items.border_switch:get() then
            if gears_items.border_types:get("Shadow") then
                render.shadow(
                    antibrute_start, 
                    antibrute_end, 
                    color(
                        menu_items.main.wmk_color:get().r,
                        menu_items.main.wmk_color:get().g,
                        menu_items.main.wmk_color:get().b,
                        log.alpha
                    ), 
                    35, 0, 5
                )
            end
        
        -- Render the background rectangle
        render.rect(antibrute_start, antibrute_end, color(30, 30, 30, log.alpha), 4)
        
        -- Render the outline if enabled
        if gears_items.border_switch:get() then
            if gears_items.border_types:get("Outline") then
                render.rect_outline(
                    antibrute_start, 
                    antibrute_end, 
                    color(
                        menu_items.main.wmk_color:get().r,
                        menu_items.main.wmk_color:get().g,
                        menu_items.main.wmk_color:get().b,
                        log.alpha
                    ), 
                    gears_items.border_thickness:get(), 
                    4
                )
            end
        end
        
        -- Calculate text position (centered)
        local LtextPosHit = vector(LtextXpos - antibrute_size.x/2 + 93 + anti_current_x, log.current_y + LtextOffset + 1)
        
        -- Render the anti‑bruteforce text with the proper message
        render.text(
            1,
            LtextPosHit,
            color(175, 175, 175, log.alpha),
            nil,
            messageText
        )
        
        -- Fade out the log gradually
        log.alpha = log.alpha - 1
        
        -- Remove the log if it has completely faded out
        if log.alpha <= 0 then
            table.remove(antiBruteforceLogs, i)
        end
    end
    end
end
    
   
    if menu_items.settings.logs:get() and gears_items.logs_events:get("Aimbot") and gears_items.logs_option:get('Screen') then
        
        for i = #attacked, 1, -1 do
            local attack = attacked[i]
            if attack then
                local log = attack.log
                log.current_y = settings_callback.lerpik(log.current_y, log.target_y, 0.05)

                if not attack.event then return end
                local target = attack.event.target
                local target_name = target and target:get_name() or "Unknown"
                local damage = attack.event.damage or 0
                local wanted_damage = attack.event.wanted_damage or 0
                local hitgroup = hitgroup_str[attack.event.hitgroup]
                local backtrack = attack.event.backtrack or 0
                local timer_bar_width = (log.alpha / 500) * (LrectXpos + LrectYpos - LrectXpos)

                if not attack.event.state and attack then
                    local LtxtSizeHit = render.measure_text(1, "", "hit " .. target_name .. " for " .. damage .. "damage in " .. hitgroup)

                    
                    -- Calculate centered X-position
                    local Lrect_startHit = vector(LrectXpos - LtxtSizeHit.x/2 + 96, log.current_y - 1)
                    local Lrect_endHit = vector(LrectXpos + LrectYpos + LtxtSizeHit.x/2 - 98, log.current_y + LrectHeight + 1)

    
                    
                    -- Ensure box is centered correctly
                    if gears_items.border_switch:get() then
                        if gears_items.border_types:get("Shadow") then
                            render.shadow(Lrect_startHit, Lrect_endHit, color(gears_items.hit_color:get().r, gears_items.hit_color:get().g, gears_items.hit_color:get().b, log.alpha), 35, 0, 9)
                        end
                    end
                    
                    render.rect(Lrect_startHit, Lrect_endHit, color(30, 30, 30, log.alpha), 8)

                    if gears_items.border_switch:get() then
                        if gears_items.border_types:get("Outline") then
                        render.rect_outline(Lrect_startHit, Lrect_endHit, color(gears_items.hit_color:get().r, gears_items.hit_color:get().g, gears_items.hit_color:get().b, log.alpha), gears_items.border_thickness:get(), 8)
                    end
                end

                    if not gears_items.border_switch:get() then
                    local timer_bar_start = vector(Lrect_startHit.x + 3, log.current_y + 2)
                    local timer_bar_end = vector(timer_bar_start.x + timer_bar_width - 160, log.current_y + 2)
                    render.rect(timer_bar_start, timer_bar_end, color(gears_items.hit_color:get().r, gears_items.hit_color:get().g, gears_items.hit_color:get().b, log.alpha), 2)
                    end
                    -- Position text centered to the box
                    local LtextPosHit = vector(LtextXpos - LtxtSizeHit.x/2 + 95, log.current_y + LtextOffset + 2)

                    -- Add glow effect for hit text (no change needed here)
                    render.text(
                        1,
                        LtextPosHit,
                        color(175, 175, 175, log.alpha),
                        nil,
                        "\a"..gears_items.hit_color:get():to_hex().."V  \aAFAFAFFFHit \a"..gears_items.hit_color:get():to_hex() .. target_name .. " \aAFAFAFFFfor \a"..gears_items.hit_color:get():to_hex() .. damage .. " \aAFAFAFFFdamage in \a"..gears_items.hit_color:get():to_hex() .. hitgroup
                    )
                    
                elseif attack then
                        local state = attack.event.state or "unknown"
                        local wanted_hitgroup = hitgroup_str[attack.event.wanted_hitgroup] or "unknown"
                    
                        local LtxtSizeMiss = render.measure_text(1, "", "missed " .. target_name .. " due to " .. state .. " in " .. wanted_hitgroup .. "!")
                        local Lrect_startMiss = vector(LrectXpos - LtxtSizeMiss.x/2 + 96, log.current_y - 1)
                        local Lrect_endMiss = vector(LrectXpos + LrectYpos + LtxtSizeMiss.x/2 - 113, log.current_y + LrectHeight + 1)
                    
                        if gears_items.border_switch:get() then
                            if gears_items.border_types:get("Shadow") then
                                render.shadow(Lrect_startMiss, Lrect_endMiss, color(gears_items.miss_color:get().r, gears_items.miss_color:get().g, gears_items.miss_color:get().b, log.alpha), 35, 0, 10)
                            end 
                        end
                    
                        render.rect(Lrect_startMiss, Lrect_endMiss, color(30, 30, 30, log.alpha), 9)
                    
                        if gears_items.border_switch:get() then
                            if gears_items.border_types:get("Outline") then
                                render.rect_outline(Lrect_startMiss, Lrect_endMiss, color(gears_items.miss_color:get().r, gears_items.miss_color:get().g, gears_items.miss_color:get().b, log.alpha), gears_items.border_thickness:get(), 9)
                            end
                        end
                    
                        -- Timer bar should also be aligned with the box
                        if not gears_items.border_switch:get() then
                            local timer_bar_start = vector(Lrect_startMiss.x, log.current_y + 3)
                            local timer_bar_end = vector(timer_bar_start.x + timer_bar_width - 93, log.current_y + 3)
                            render.rect(timer_bar_start, timer_bar_end, color(gears_items.miss_color:get().r, gears_items.miss_color:get().g, gears_items.miss_color:get().b, log.alpha), 2)
                        end
                    
                        -- Position text centered to the box
                        local LtextPosMiss = vector(LtextXpos - LtxtSizeMiss.x/2 + 95, log.current_y + LtextOffset + 2)
                    
                        -- Add glow effect for miss text (no change needed here)
                        render.text(
                            1,
                            LtextPosMiss,
                            color(175, 175, 175, log.alpha),
                            nil,
                            "\a"..gears_items.miss_color:get():to_hex().."V  \aAFAFAFFFMissed \a"..gears_items.miss_color:get():to_hex() .. target_name .. " \aAFAFAFFFdue to \a" ..gears_items.miss_color:get():to_hex().. state .. " \aAFAFAFFFin \a"..gears_items.miss_color:get():to_hex() .. wanted_hitgroup
                        )
                    end
        
                log.alpha = log.alpha - 1 -- Slower alpha decrease for longer duration
                if log.alpha <= 0 then
                    table.remove(attacked, i)
                    if LnextIndex > i then
                        LnextIndex = LnextIndex - 1
                    end
                end
            end
        end
    end
end



    settings_callback.aimbot_logs = function(e)
        if not entity.get_local_player() then return end
        hitbox = hitgroup_str[e.hitgroup]
        damage = e.damage or 0
        hitchance = e.hitchance
        backtrack = e.backtrack
        wanted_damage = e.wanted_damage
        wanted_hitbox = hitgroup_str[e.wanted_hitgroup]
        reason = e.state
        target = entity.get(e.target)
        name = target:get_name()
    
    
    
        mismatch_damage = " (+0)"
        if damage > wanted_damage then
            mismatch_damage = " (+" .. damage - wanted_damage .. ")"
        end
        if damage < wanted_damage then
            mismatch_damage = " (-" .. wanted_damage - damage .. ")"
        end
    
        if hitbox ~= wanted_hitbox then
            mismatch_hitbox = "(-" .. wanted_hitbox .. ")"
        else
            mismatch_hitbox = ""
        end
    
        hit = false
        unregistered = false
        missed = false
    
        if reason == nil then
            if damage > -1 then
                hit = true
            else
                if damage < 0 then
                    unregistered = true
                end
            end
        end
    
        if reason ~= nil then
            missed = true
        end
    if gears_items.logs_events:get("Aimbot") then
        local screen = render.screen_size() / 2 
        local x = screen.x
        local y = screen.y

        local rectWidth = 240
        local rectHeight = 10
        local rectX = x - rectWidth / 2 
        local rectY = y - 125

        render.rect(vector(rectX, rectY), vector(rectX + rectWidth, rectY + rectHeight), color(255,255,255,255), 2)

        if hit == true and gears_items.logs_option:get('Console') then
            print_raw(("\a"..gears_items.hit_color:get():to_hex().."Venture \aFFFFFFF | Hit %s's %s%s for %s%s damage (%s%s) | (%s ticks)")
                :format(name, hitbox, mismatch_hitbox, damage, mismatch_damage, hitchance, "hc", backtrack)) --, targetname, hitbox, hitchance, damage))
        end
    
        if missed == true and gears_items.logs_option:get('Console') then
            print_raw(("\a"..gears_items.miss_color:get():to_hex().."Venture \aFFFFFFF | Missed %s's %s for %s damage (%s%s) due to %s | (%s ticks)")
                :format(name, wanted_hitbox, wanted_damage, hitchance, "hc", reason, backtrack)) --, targetname, hitbox, hitchance, damage))
        end

        if unregistered == true and gears_items.logs_option:get('Console') then
            print_raw(("\a"..gears_items.miss_color:get():to_hex().."Venture \aFFFFFFF | Missed %s's %s for %s damage (%s%s) due to unregistered shot | (%s ticks)")
                :format(name, wanted_hitbox, wanted_damage, hitchance, "hc", backtrack)) --, targetname, hitbox, hitchance, damage))
        end
    end
 end

 

settings_callback.performance_mode = function()
    if not menu_items.settings.performance_mode:get() then return end

     if gears_items.optimise_mode:get() == "Low" then
        cvar.r_shadows:int(0)
        cvar.cl_csm_static_prop_shadows:int(0)
        cvar.cl_csm_shadows:int(0)
        cvar.cl_csm_world_shadows:int(0)
        cvar.cl_foot_contact_shadows:int(0)
        cvar.cl_csm_viewmodel_shadows:int(0)
        cvar.cl_csm_rope_shadows:int(0)
        cvar.cl_csm_sprite_shadows:int(0)
        cvar.r_dynamic:int(0)
        cvar.cl_autohelp:int(0)
        cvar.r_drawparticles:int(1)
        cvar.r_eyesize:int(0)
        cvar.r_eyeshift_z:int(0)
        cvar.r_eyeshift_y:int(0)
        cvar.r_eyeshift_x:int(0)
        cvar.r_eyemove:int(0)
        cvar.r_eyegloss:int(0)
        cvar.r_drawtracers_firstperson:int(0)
        cvar.r_drawtracers:int(0)
        cvar.fog_enable_water_fog:int(0)
        cvar.mat_postprocess_enable:int(0)
        cvar.cl_disablefreezecam:int(0)
        cvar.cl_freezecampanel_position_dynamic:int(0)
        cvar.r_drawdecals:int(0)
        cvar.muzzleflash_light:int(0)
        cvar.r_drawropes:int(0)
        cvar.r_drawsprites:int(0)
        cvar.cl_disablehtmlmotd:int(0)
        cvar.cl_freezecameffects_showholiday:int(0)
        cvar.m_rawinput:int(0)
        cvar.cl_bob_lower_amt:int(0)
        cvar.cl_detail_multiplier:int(0)
        cvar.mat_drawwater:int(0)
        cvar.cl_foot_contact_shadows:int(0)
        cvar.func_break_max_pieces:int(0)
    elseif gears_items.optimise_mode:get() == "Normal" then
        cvar.r_shadows:int(1)
        cvar.cl_csm_static_prop_shadows:int(1)
        cvar.cl_csm_shadows:int(1)
        cvar.cl_csm_world_shadows:int(1)
        cvar.cl_foot_contact_shadows:int(1)
        cvar.cl_csm_viewmodel_shadows:int(1)
        cvar.cl_csm_rope_shadows:int(1)
        cvar.cl_csm_sprite_shadows:int(1)
        cvar.r_dynamic:int(1)
        cvar.cl_autohelp:int(1)
        cvar.r_drawparticles:int(1)
        cvar.r_eyesize:int(1)
        cvar.r_eyeshift_z:int(1)
        cvar.r_eyeshift_y:int(1)
        cvar.r_eyeshift_x:int(1)
        cvar.r_eyemove:int(1)
        cvar.r_eyegloss:int(1)
        cvar.r_drawtracers_firstperson:int(1)
        cvar.r_drawtracers:int(1)
        cvar.fog_enable_water_fog:int(1)
        cvar.mat_postprocess_enable:int(1)
        cvar.cl_disablefreezecam:int(1)
        cvar.cl_freezecampanel_position_dynamic:int(1)
        cvar.r_drawdecals:int(1)
        cvar.muzzleflash_light:int(1)
        cvar.r_drawropes:int(1)
        cvar.r_drawsprites:int(1)
        cvar.cl_disablehtmlmotd:int(1)
        cvar.cl_freezecameffects_showholiday:int(1)
        cvar.m_rawinput:int(1)
        cvar.cl_bob_lower_amt:int(1)
        cvar.cl_detail_multiplier:int(1)
        cvar.mat_drawwater:int(1)
        cvar.cl_foot_contact_shadows:int(1)
        cvar.func_break_max_pieces:int(1)
    elseif gears_items.optimise_mode:get() == "High" then
        cvar.r_shadows:int(2)
        cvar.cl_csm_static_prop_shadows:int(2)
        cvar.cl_csm_shadows:int(2)
        cvar.cl_csm_world_shadows:int(2)
        cvar.cl_foot_contact_shadows:int(2)
        cvar.cl_csm_viewmodel_shadows:int(2)
        cvar.cl_csm_rope_shadows:int(2)
        cvar.cl_csm_sprite_shadows:int(2)
        cvar.r_dynamic:int(2)
        cvar.cl_autohelp:int(2)
        cvar.r_drawparticles:int(2)
        cvar.r_eyesize:int(2)
        cvar.r_eyeshift_z:int(2)
        cvar.r_eyeshift_y:int(2)
        cvar.r_eyeshift_x:int(2)
        cvar.r_eyemove:int(2)
        cvar.r_eyegloss:int(2)
        cvar.r_drawtracers_firstperson:int(2)
        cvar.r_drawtracers:int(2)
        cvar.fog_enable_water_fog:int(2)
        cvar.mat_postprocess_enable:int(2)
        cvar.cl_disablefreezecam:int(2)
        cvar.cl_freezecampanel_position_dynamic:int(2)
        cvar.r_drawdecals:int(2)
        cvar.muzzleflash_light:int(2)
        cvar.r_drawropes:int(2)
        cvar.r_drawsprites:int(1)
        cvar.cl_disablehtmlmotd:int(2)
        cvar.cl_freezecameffects_showholiday:int(2)
        cvar.m_rawinput:int(2)
        cvar.cl_bob_lower_amt:int(2)
        cvar.cl_detail_multiplier:int(2)
        cvar.mat_drawwater:int(2)
        cvar.cl_foot_contact_shadows:int(2)
        cvar.func_break_max_pieces:int(2)
    end
end

        settings_callback.debug_rendering = function()
            local screen_size = render.screen_size() / 2
            local x = screen_size.x
            local y = screen_size.y
                if menu_items.settings.debug_panel:get() then
                render.text(1, vector(x + 500, y - 200), color(), "C", "Antibrute phase: "..misses_db)
                end

        end
                          --  render.text(1, vector(x, y), color(), "C", misses_db)


            settings_callback.hitchance_inair = function()
                
                local lp = entity.get_local_player()
                if not lp or not lp:is_alive() then
                    return
                end
                
                if menu_items.settings.hitchance:get() then 


                local weapon = lp:get_player_weapon()
                local weapon_id = weapon:get_weapon_index()

                if weapon_id == 40 and (anti_aim_states() == 7 or anti_aim_states() == 8) then
                        refs.hc:override(gears_items.hitchance_in_air:get())
                    else
                        refs.hc:override(refs.hc:get())
                    end
                end
                end


                                    
            -- local watermark_animation = lib.gradient.text_animate("venture beta", -1.2, {
            --     --color(98,118,156),
            --     menu_items.main.wmk_color:get(),
            --     color(0,0,0, 255),
            --     --ui.get_style("Link Active")
            -- })
            
    
            settings_callback.crosshair_indicators = function()
                local lp = entity.get_local_player()
                if not lp then return end
                if not lp:is_alive() then return end
                local alpha = math.sin(globals.realtime * 3) * 127 +127.5 
                local chrg = rage.exploit:get()
                local scoped = lp.m_bIsScoped
                local screen_size = render.screen_size() / 2
                local x = screen_size.x
                local y = screen_size.y

                
              --  render.text(1, vector(x, y), color(), "C", misses_db)
                if not menu_items.settings.crosshair_indicators:get() then return end
                
                if anti_aim_states() == 1 then
                    alt_cond = "fakelag"
                    state_cond = "FAKELAG"
                    shad_pix = 10
                    s_c = "FL"
                elseif anti_aim_states() == 5 then
                    alt_cond = "ducking"
                    state_cond = "CROUCHING"
                    shad_pix = 10
                    s_c = " DU"
                elseif anti_aim_states() == 6 then
                    alt_cond = "c+move"
                    state_cond = "CROUCH-MOVE"
                    shad_pix = 10
                    s_c = "  DM"
                elseif anti_aim_states() == 2 then
                    alt_cond = "standing"
                    state_cond = "STANDING"
                    shad_pix = 10
                    s_c = "     STA"
                elseif anti_aim_states() == 7 then
                    alt_cond = "jumpin"
                    state_cond = "IN-AIR"
                    shad_pix = 10
                    s_c = "    AIR"
                elseif anti_aim_states() == 8 then
                    alt_cond = "jumpin"
                    state_cond = "AIR-DUCK"
                    shad_pix = 11
                    s_c = "  AD"
                elseif anti_aim_states() == 4 then
                    alt_cond = "slowmode"
                    state_cond = "SLOWMODE"
                    shad_pix = 10
                    s_c = " SW"
                elseif anti_aim_states() == 3 then
                    alt_cond = "running"
                    state_cond = "RUNNING"
                    shad_pix = 8
                    s_c = "       MOV"
                end
            
                dt_x = 0
                if refs.dt:get() and refs.ap:get() then
                    dt_x = 9
                    ap_x = 0
                elseif not refs.ap:get() then
                    dt_x = 0
                elseif not rage.exploit:get() == 1 and refs.ap:get() then
                    dt_x = 9
                    ap_x = 4
                elseif refs.ap:get() and not refs.dt:get() then
                    ap_x = 4
                end
            
                local y_add = 0
                local venture_ind_text = lib.gradient.text_animate("VENTURE", -1, {
                    color(gears_items.crosshair_accent:get().r, gears_items.crosshair_accent:get().g, gears_items.crosshair_accent:get().b, gears_items.crosshair_accent:get().a),
                    color(255,255,255,255), 
                })
                
                venture_ind_text:animate()

                    if gears_items.crosshair_style:get() == "Simple" then                         --antiaim_callback.unsafe_aa  
                        x_add_lua = scope_animation(scoped, x_add_lua, 45, 10) or 0
                        x_add_dt = scope_animation(scoped, x_add_dt, 27, 10) or 0
                        x_add_os = scope_animation(scoped, x_add_os, 20, 10) or 0
                        
                        --render.shadow(vector(x + x_add_lua - 28, y + 18 + gears_items.y_padding:get()), vector(x + x_add_lua + 28, y + 18 + gears_items.y_padding:get()), color(200, 200, 210, 255), 20, 0, 10)
                        if gears_items.crosshair_build:get() then
                            render.text(2, vector(x - 10 + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add), color(255,255,255,alpha), "c", "(")
                            render.text(2, vector(x + 10 + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add), color(255,255,255,alpha), "c", ")")
                            render.text(2, vector(x + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add), color(255,255,255,alpha), "c", "DEV")
                        y_add = y_add + 8
                        end

                        --render.shadow(vector(x + x_add_lua - 28, y + 18 + gears_items.y_padding:get()), vector(x + x_add_lua + 28, y + 18 + gears_items.y_padding:get()), color(200, 200, 210, 255), 20, 0, 10)
                        render.text(2, vector(x + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add), gears_items.crosshair_accent:get(), "c", venture_ind_text:get_animated_text())
                        y_add = y_add + 8
                
                        --render.shadow(vector(x + x_add_lua - shad_pix - 1, y + 26 + gears_items.y_padding:get()), vector(x + x_add_lua + shad_pix - 1, y + 26 + gears_items.y_padding:get()), color(200, 200, 210, 255), 20, 0, 10)
                
                        render.text(2, vector(x + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add), gears_items.crosshair_other:get(), "c", state_cond)
                        y_add = y_add + 8
                
                
                                if refs.Body:get() == "Force" then
                            render.text(2, vector(x + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add), color(255,255,255,255), "c", "BAIM")
                            y_add = y_add + 8
                            else
                                y_add = y_add
                            end
                            if refs.hideshots:get() then
                                render.text(2, vector(x + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add), color(255,255,255,255), "c", "OS-AA")
                                y_add = y_add + 8
                            else
                                y_add = y_add
                            end
                        
                        if refs.dt:get() then
                            if refs.ap:get() then
                                --render.shadow(vector(x + x_add_lua - 15, y + 35 + gears_items.y_padding:get()), vector(x + x_add_lua + 15, y + 35 + gears_items.y_padding:get()), color(200, 200, 210, 255), 20, 0, 10)
                                render.text(2, vector(x + 6 + gears_items.x_padding:get() - ap_x + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add),
                                color(255, 255, 255, 255), "c", "(" .. math.floor(rage.exploit:get() * 1000 / 10) .. ")")
                            end
                            if chrg == 1 then
                                --render.shadow(vector(x + x_add_lua - 5, y + 35 + gears_items.y_padding:get()), vector(x + x_add_lua + 2, y + 35 + gears_items.y_padding:get()), color(200, 200, 210, 255), 20, 0, 10)
                                render.text(2, vector(x - dt_x + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add),
                                color(91, 220, 104, 255), "c", "DT")
                                else
                                    --render.shadow(vector(x + x_add_lua - 5, y + 35 + gears_items.y_padding:get()), vector(x + x_add_lua + 2, y + 35 + gears_items.y_padding:get()), color(200, 200, 210, 255), 20, 0, 10)
                
                                    --render.text(pixel_10, vector(x - 13, y + 18 + y_add), color(255,255,255,255), "c", "dt")
                                    render.text(2, vector(x - dt_x + gears_items.x_padding:get()--[[ + 8]] + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add),
                                        color(220, 91, 91, 255), "c", "DT")
                                    end
                                    y_add = y_add + 8
                              else
                                  y_add = y_add
                            end
                    

                        elseif gears_items.crosshair_style:get() == "Modern" then
                            x_add_lua = scope_animation(scoped, x_add_lua, 60, 10) or 0
                            x_add_dt = scope_animation(scoped, x_add_dt, 27, 10) or 0
                            x_add_os = scope_animation(scoped, x_add_os, 20, 10) or 0
                            
                            --render.shadow(vector(x + x_add_lua - 28, y + 18 + gears_items.y_padding:get()), vector(x + x_add_lua + 28, y + 18 + gears_items.y_padding:get()), color(200, 200, 210, 255), 20, 0, 10)

    
                            --render.shadow(vector(x + x_add_lua - 28, y + 18 + gears_items.y_padding:get()), vector(x + x_add_lua + 28, y + 18 + gears_items.y_padding:get()), color(200, 200, 210, 255), 20, 0, 10)
                            if gears_items.crosshair_build:get() then
                                render.text(2, vector(x + 18 + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add), gears_items.crosshair_accent:get(), "c", "DEV")
                            end
                            render.text(2, vector(x - 10 + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add), gears_items.crosshair_accent:get(), "c", " VENTURE")
                            y_add = y_add + 8
                    
                            --render.shadow(vector(x + x_add_lua - shad_pix - 1, y + 26 + gears_items.y_padding:get()), vector(x + x_add_lua + shad_pix - 1, y + 26 + gears_items.y_padding:get()), color(200, 200, 210, 255), 20, 0, 10)
                    
                            render.text(2, vector(x - 20 + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add), gears_items.crosshair_other:get(), "c", s_c)
                            y_add = y_add + 8
                    
                            if refs.dt:get() then
                                if chrg == 1 then
                                    --render.shadow(vector(x + x_add_lua - 5, y + 35 + gears_items.y_padding:get()), vector(x + x_add_lua + 2, y + 35 + gears_items.y_padding:get()), color(200, 200, 210, 255), 20, 0, 10)
                                        render.text(2, vector(x - 19 + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add),
                                            color(91, 220, 104, 255), "c", "DT")
                                    else
                                        render.text(2, vector(x - 19 + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add),
                                            color(220, 91, 91, 255), "c", "DT")
                                    end
                                        y_add = y_add + 8
                                  else
                                      y_add = y_add
                                end

                                render.text(2, vector(x - 16 + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add), color(255,255,255,110), "c", "BAIM")
                                if refs.Body:get() == "Force" then
                                        render.text(2, vector(x - 16 + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add), color(255,255,255,255), "c", "BAIM")
                                end
                                render.text(2, vector(x - 1 + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add), color(255,255,255,110), "c", "  OS")
                                if refs.hideshots:get() then
                                        render.text(2, vector(x - 1 + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add), color(255,255,255,255), "c", "  OS")
                                end
                                render.text(2, vector(x + 12 + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add), color(255,255,255,110), "c", "AP")
                                if refs.ap:get() then
                                        render.text(2, vector(x + 12 + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add), color(255,255,255,255), "c", "AP")
                                end
                                render.text(2, vector(x + 23 + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add), color(255,255,255,110), "c", " FS")
                                if refs.freestand:get() then
                                        render.text(2, vector(x + 23 + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add), color(255,255,255,255), "c", " FS")
                                end 
                            elseif gears_items.crosshair_style:get() == "Solid" then
                                x_add_lua = scope_animation(scoped, x_add_lua, 45, 10) or 0
                                x_add_safe = scope_animation(scoped, x_add_lua, 20, 10) or 0
                                x_add_dangerous = scope_animation(scoped, x_add_lua, 20, 10) or 0
                                render.text(2, vector(x + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add), gears_items.crosshair_accent:get(), "c", "VENTURE")
                                y_add = y_add + 8
                        
                                --render.shadow(vector(x + x_add_lua - shad_pix - 1, y + 26 + gears_items.y_padding:get()), vector(x + x_add_lua + shad_pix - 1, y + 26 + gears_items.y_padding:get()), color(200, 200, 210, 255), 20, 0, 10)
                            if antiaim_callback.is_person_nade(true) then 
                                render.text(2, vector(x + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add), color(199, 91, 91, 255), "c", "VERY DANGEROUS")
                            elseif (antiaim_callback.is_person_onshot(true) or antiaim_callback.is_weapon_switching(true)) then
                                    render.text(2, vector(x + gears_items.x_padding:get() + x_add_dangerous, y + 18 + gears_items.y_padding:get() + y_add), color(216, 147, 116, 255), "c", "DANGEROUS")
                        else
                                render.text(2, vector(x + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add), color(87, 210, 103, 255), "c", "SAFE")
                                end
                                y_add = y_add + 8

                                if refs.dt:get() then
                                            render.text(2, vector(x + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add),
                                                color(226, 52, 52, 255), "c", "CHARGED")
                                        
                                            y_add = y_add + 8
                                      else
                                          y_add = y_add
                                    end
                                    if refs.freestand:get() then
                                        render.text(2, vector(x + gears_items.x_padding:get() + x_add_lua, y + 18 + gears_items.y_padding:get() + y_add),
                                        color(20, 233, 239, 255), "c", "FREESTAND")
                                end
                            end
                            venture_ind_text:animate()

                            
                 end

            
    
            esp.enemy:new_text("Revolver Helper", "DMG+", function()
                local local_player = entity.get_local_player()
                if not local_player then return "DMG" end
                local weapon = local_player:get_player_weapon()
                if not weapon then return "DMG" end
                local index = weapon:get_weapon_index()
                if index == 64 then
                    if player:is_player() then
                        local local_origin = local_player:m_vecOrigin()
                        local player_origin = player:m_vecOrigin()
                        if not (local_origin and player_origin) then return "DMG" end
        
                        local dist = local_origin:dist2d(player_origin)
                        local health = player:m_iHealth()
                        local armor = player:m_ArmorValue()
                        local damage = 115
        
                        if armor > 0 then
                            damage = damage * 0.5 -- Reduce damage if the enemy has armor
                        end
        
                        if dist > 5000 then
                            damage = damage * 0.85 -- Reduce damage at long range
                        end
        
                        if health <= damage then
                            return "DMG+"
                        else
                            return "DMG"
                        end
                    end
                end
                return "DMG"
            end)
    
            esp.enemy:new_text("Scout Body Damage", "- dmg -", function(player)
                local local_player = entity.get_local_player()
                if local_player == nil then return end
                local weapon = local_player:get_player_weapon()
                local weapon_id = weapon:get_weapon_index()


                local enemy_pos = player.m_vecOrigin
                local hitbox_pos = player:get_hitbox_position(5)
                local distance = hitbox_pos:dist(local_player.m_vecOrigin)
            
                local trace_result = utils.trace_line(local_player.m_vecOrigin, hitbox_pos)
                local local_x, local_y = local_player.m_vecOrigin.x, local_player.m_vecOrigin.y
                local enemy_x, enemy_y = player.m_vecOrigin.x, player.m_vecOrigin.y
            
                local dif1 = local_x - enemy_x
                local dif2 = local_y - enemy_y
            
                local tot_distance = math.sqrt(dif1^2 + dif2^2)
                local damage = 93
            
                local dist_to_dmg = tot_distance / 135
            
                local final_dmg = math.floor(damage - dist_to_dmg)
                local stomach_multiplier = 1
            
            
                local max_damage = final_dmg * stomach_multiplier
                if weapon_id == 40 then 
                return tostring("━  \aFF6262FF"..max_damage.."  \aFFFFFFFF━")
                end
            
            end)

            

    
        local config_setup = pui.setup(cfg_data, condition_builder, defensive_builder, builder_gears)
        local config_save = pui.save(saved_config)
        pui.load(config_save)


    events.createmove(function(cmd)
        antiaim_callback.handle(cmd)
        
        antiaim_callback.get_desync_delta()
        antiaim_callback.get_desync_side()
        antiaim_callback.defensive_force()
        antiaim_callback.freestand_disablers()
            
        end)
        events.render(function(e)
                
            settings_callback.render_events(e)
            settings_callback.crosshair_indicators()
            settings_callback.debug_rendering()
            settings_callback.power_off()
            settings_callback.fake_latency()
            settings_callback.aspect_ratio_handler()
            settings_callback.scope_overlay()
            settings_callback.set_viewmodel()
            settings_callback.override_indicator()
            settings_callback.performance_mode()
            settings_callback.hitchance_inair()
            settings_callback.dormant_logic()
            settings_callback.force100()
            settings_callback.baim_lethal()
            settings_callback.skeet_indicator()


            local gradient_animation = lib.gradient.text_animate("Venture Secret", 1.5, {
                --color(98,118,156),
                ui.get_style("Link Active"),
                -- color(146, 148, 175, 255),
                color(45,45,45, 255),
                --ui.get_style("Link Active")
            })
            ui.sidebar(gradient_animation:get_animated_text(), "star-shooting")
            gradient_animation:animate()
    
        end)
        
        events.aim_ack(function(e)
            settings_callback.logs_processing(e)
            settings_callback.aimbot_logs(e)
        end)


        local antiaim_builder_cfg = {
            condition_builder = condition_builder,
            defensive_builder = defensive_builder,
            builder_gears = builder_gears,
        }

        local brute_builder_cfg = {
            brute_builder_gears = brute_builder_gears,
            antibrute_builder = antibrute_builder,
        }

        local cfg_system = { }
        configs_db = db.equity_configs or { }
        configs_db.cfg_list = configs_db.cfg_list or {{'Default', 'W3siYW5pbXMiOlsiU3RhdGljIGxlZ3MgaW4gQWlyIiwifiJdLCJhdXRvX3RwIjpmYWxzZSwiYXZvaWRfYmFja3N0YWIiOmZhbHNlLCJlbmFibGVfYWEiOnRydWUsImZvcmNlX2RlZmVuc2l2ZSI6WyJTbG93bW9kZSIsIkluIEFpciIsIkFpciBDcm91Y2giLCJ+Il0sImZzX2Rpc2FibGVycyI6WyJDcm91Y2ggTW92ZSIsIkluIEFpciIsIkFpciBDcm91Y2giLCJ+Il0sIm1hbnVhbF95YXciOiJEaXNhYmxlZCIsInByZXNldF9saXN0IjoxLjAsInNhZmVfaGVhZCI6dHJ1ZSwic3RhdGVfY29uZGl0aW9uIjoiQ3JvdWNoaW5nIiwic3R5bGVfYWEiOjIuMH0seyJhc3BlY3RfcmF0aW8iOnRydWUsImNyb3NzaGFpcl9pbmRpY2F0b3JzIjpmYWxzZSwiZGVidWdfcGFuZWwiOmZhbHNlLCJlc3BfbGlzdCI6MS4wLCJmYWtlX2xhdGVuY3kiOmZhbHNlLCJoaXRjaGFuY2UiOmZhbHNlLCJsaXN0IjoxLjAsImxvZ3MiOnRydWUsIm92ZXJyaWRlX2luZGljYXRvciI6dHJ1ZSwicGVyZm9ybWFuY2VfbW9kZSI6ZmFsc2UsInJhZ2Vib3RfbG9naWMiOmZhbHNlLCJzY29wZV9vdmVybGF5IjpmYWxzZSwic2tlZXRfaW5kaWNhdG9ycyI6dHJ1ZSwidG9nZ2xlX3NldHRpbmdzIjp0cnVlLCJ0cmFzaHRhbGsiOnRydWUsInZpZXdtb2RlbCI6dHJ1ZX0seyJiYWltX2xvZ2ljIjpmYWxzZSwiYm9yZGVyX3N3aXRjaCI6dHJ1ZSwiYm9yZGVyX3RoaWNrbmVzcyI6Mi4wLCJib3JkZXJfdHlwZXMiOlsiU2hhZG93IiwiT3V0bGluZSIsIn4iXSwiY2xvc2VfYWltYm90IjpmYWxzZSwiY3Jvc3NoYWlyX2FjY2VudCI6IiM5Q0EyOTNGRiIsImNyb3NzaGFpcl9idWlsZCI6dHJ1ZSwiY3Jvc3NoYWlyX290aGVyIjoiIzg0OEQ5MkZGIiwiY3Jvc3NoYWlyX3N0eWxlIjoiU2ltcGxlIiwiZGVmZW5zaXZlX3R5cGUiOiJBbHdheXMgT24iLCJkaXNhYmxlX3RwIjpbIn4iXSwiZG9ybWFudF9sb2dpYyI6ZmFsc2UsImZha2VfbGF0ZW5jeV9hbW91bnQiOjc3LjAsImhpdF9jb2xvciI6IiM4MDgxQTM4MSIsImhpdGNoYW5jZV9pbl9haXIiOjM1LjAsImxvZ3NfZXZlbnRzIjpbIkFpbWJvdCIsIkFudGktQnJ1dGUiLCJ+Il0sImxvZ3Nfb3B0aW9uIjpbIkNvbnNvbGUiLCJ+Il0sIm1pc3NfY29sb3IiOiIjQTM4MDgwODEiLCJvcHRpbWlzZV9tb2RlIjoiTG93Iiwib3ZlcnJpZGVfaW5kaWNhdG9yX2NvbG9yIjoiI0ZGRkZGRkZGIiwib3ZlcnJpZGVfaW5kaWNhdG9yX2ZvbnQiOjEuMCwib3ZlcnJpZGVfaW5kaWNhdG9yX29wdGlvbnMiOlsiRGFtYWdlIiwiSGl0Y2hhbmNlIiwifiJdLCJzY29wZV9jb2xvciI6IiNGRkZGRkY3NiIsInNjb3BlX2dhcCI6NS4wLCJzY29wZV9pbnZlcnRlZCI6ZmFsc2UsInNjb3BlX3NpemUiOjc1LjAsInNrZWV0X2luZGljYXRvcnNfc2VsIjpbIkRvdWJsZSBUYXAiLCJIaWRlc2hvdHMiLCJNaW5pbXVtIERhbWFnZSIsIkJvZHkgQWltIiwiSGl0Y2hhbmNlIiwiRG9ybWFudCBBaW1ib3QiLCJTYWZlcG9pbnQiLCJGcmVlc3RhbmRpbmciLCJGYWtlIER1Y2siLCJQaW5nIiwifiJdLCJza2VldF9wYWRkaW5nIjotMTE2LjAsInRlbGVwb3J0X3dlYXBvbiI6WyJ+Il0sInRyYXNodGFsa19kZWF0aCI6dHJ1ZSwidmlld21vZGVsX2ZvdiI6NjgwLjAsInZpZXdtb2RlbF94b2ZmIjoyNS4wLCJ2aWV3bW9kZWxfeW9mZiI6MC4wLCJ2aWV3bW9kZWxfem9mZiI6LTE1LjAsIndhdGVybWFya19wb3NpdGlvbiI6IlRvcCBSaWdodCIsInhfcGFkZGluZyI6MC4wLCJ5X3BhZGRpbmciOjAuMH0seyJjb25kaXRpb25fYnVpbGRlciI6W3siYnlhdyI6dHJ1ZSwiY29zaW5lX3JhbmRvbSI6MC4wLCJjb3NpbmVfc3BlZWRfbWFuaSI6Mi4wLCJkZWxheV9sb2dpYyI6IkNvc2luZSIsImRlbGF5X21hbmkiOjIuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjoyLjAsImRlbGF5X3RpY2tzIjoxMC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZmxpY2tfc2luZ2xlIjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0xOS4wLCJtYW5pX21ldGhvZCI6IlN0YXRpYyIsIm1hbmlwdWxhdGlvbl9yYW5kb20iOjAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjQ0LjAsInlhdyI6IkxlZnQvUmlnaHQiLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9yYW5kb20iOjAuMCwiY29zaW5lX3NwZWVkX21hbmkiOjIuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjoyLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MTIuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZsaWNrX3NpbmdsZSI6MC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMjUuMCwibWFuaV9tZXRob2QiOiJTdGF0aWMiLCJtYW5pcHVsYXRpb25fcmFuZG9tIjowLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0Ijo0MC4wLCJ5YXciOiJEZWxheWVkIFN3aXRjaCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9yYW5kb20iOjAuMCwiY29zaW5lX3NwZWVkX21hbmkiOjIuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjoyLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MTYuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZsaWNrX3NpbmdsZSI6MC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMzAuMCwibWFuaV9tZXRob2QiOiJTdGF0aWMiLCJtYW5pcHVsYXRpb25fcmFuZG9tIjowLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0Ijo0MC4wLCJ5YXciOiJEZWxheWVkIFN3aXRjaCIsInlhd21vZCI6IjUtV2F5IiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9yYW5kb20iOjAuMCwiY29zaW5lX3NwZWVkX21hbmkiOjIuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjoyLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6Mi4wLCJkZWxheV90aWNrcyI6MTAuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MTAuMCwiZmxpY2tfbGVmdCI6MC4wLCJmbGlja19yaWdodCI6MC4wLCJmbGlja19zaW5nbGUiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTMwLjAsIm1hbmlfbWV0aG9kIjoiU3RhdGljIiwibWFuaXB1bGF0aW9uX3JhbmRvbSI6MC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6NDAuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IjUtV2F5IiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9yYW5kb20iOjAuMCwiY29zaW5lX3NwZWVkX21hbmkiOjIuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjoyLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MTYuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZsaWNrX3NpbmdsZSI6MC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjU0LjAsImxlZnRfb2Zmc2V0IjotMjYuMCwibWFuaV9tZXRob2QiOiJTdGF0aWMiLCJtYW5pcHVsYXRpb25fcmFuZG9tIjowLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6NTQuMCwicmlnaHRfb2Zmc2V0Ijo0Ni4wLCJ5YXciOiJEZWxheWVkIFN3aXRjaCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiY29zaW5lX3JhbmRvbSI6MC4wLCJjb3NpbmVfc3BlZWRfbWFuaSI6Mi4wLCJkZWxheV9sb2dpYyI6IkNvc2luZSIsImRlbGF5X21hbmkiOjIuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjoxNi4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZmxpY2tfc2luZ2xlIjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0xNy4wLCJtYW5pX21ldGhvZCI6IlN0YXRpYyIsIm1hbmlwdWxhdGlvbl9yYW5kb20iOjAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjQzLjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJjb3NpbmVfcmFuZG9tIjowLjAsImNvc2luZV9zcGVlZF9tYW5pIjoyLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6Mi4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjE2LjAsImRlbGF5X3RpY2tzIjo4LjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEwLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZmxpY2tfc2luZ2xlIjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0yNi4wLCJtYW5pX21ldGhvZCI6IlN0YXRpYyIsIm1hbmlwdWxhdGlvbl9yYW5kb20iOjAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjM4LjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJjb3NpbmVfcmFuZG9tIjowLjAsImNvc2luZV9zcGVlZF9tYW5pIjoyLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6Mi4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjE0LjAsImRlbGF5X3RpY2tzIjo1LjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEuMCwiZmxpY2tfbGVmdCI6MC4wLCJmbGlja19yaWdodCI6MC4wLCJmbGlja19zaW5nbGUiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTIwLjAsIm1hbmlfbWV0aG9kIjoiU3RhdGljIiwibWFuaXB1bGF0aW9uX3JhbmRvbSI6MC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6NDMuMCwieWF3IjoiRGVsYXllZCBTd2l0Y2giLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfV0sImRlZmVuc2l2ZV9idWlsZGVyIjpbeyJjX3BpdGNoIjowLjAsImVuYWJsZSI6dHJ1ZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJTd2l0Y2giLCJ3MV9waXRjaCI6ODUuMCwidzJfcGl0Y2giOjg5LjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In1dfSx7ImFudGlicnV0ZV9idWlsZGVyIjpbeyJjdXN0b21fcGhhc2VzIjoxLjAsImVuYWJsZSI6ZmFsc2UsInAxX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwMV9kZWxheV9sb2dpYyI6IkNvc2luZSIsInAxX2RlbGF5X3NwZWVkIjoyMC4wLCJwMV9kZWxheV90aWNrcyI6MjAuMCwicDFfbGVmdF9vZmZzZXQiOjEzMC4wLCJwMV9vZmZzZXQiOjIyLjAsInAxX3JpZ2h0X29mZnNldCI6MTMwLjAsInAxX3lhdyI6IlN0YXRpYyIsInAxX3lhd21vZCI6IkNlbnRlciIsInAxX3lhd21vZF9vZmYiOi0xNjkuMCwicDFfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInAyX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwMl9kZWxheV9sb2dpYyI6IkNvc2luZSIsInAyX2RlbGF5X3NwZWVkIjoyMC4wLCJwMl9kZWxheV90aWNrcyI6MjAuMCwicDJfbGVmdF9vZmZzZXQiOjEzMC4wLCJwMl9vZmZzZXQiOjEzMC4wLCJwMl9yaWdodF9vZmZzZXQiOjEzMC4wLCJwMl95YXciOiJTdGF0aWMiLCJwMl95YXdtb2QiOiJEaXNhYmxlZCIsInAyX3lhd21vZF9vZmYiOi01NS4wLCJwMl95YXdtb2RfcmFuZG9tIjoxMC4wLCJwM19jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDNfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwM19kZWxheV9zcGVlZCI6MjAuMCwicDNfZGVsYXlfdGlja3MiOjIwLjAsInAzX2xlZnRfb2Zmc2V0IjoxMzAuMCwicDNfb2Zmc2V0IjotMTU4LjAsInAzX3JpZ2h0X29mZnNldCI6MTMwLjAsInAzX3lhdyI6IlN0YXRpYyIsInAzX3lhd21vZCI6IkRpc2FibGVkIiwicDNfeWF3bW9kX29mZiI6LTE4MC4wLCJwM195YXdtb2RfcmFuZG9tIjoxMDAuMCwicDRfY29zaW5lX3JhbmRvbSI6MTAwLjAsInA0X2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDRfZGVsYXlfc3BlZWQiOjE1LjAsInA0X2RlbGF5X3RpY2tzIjoyMC4wLCJwNF9sZWZ0X29mZnNldCI6LTE2LjAsInA0X29mZnNldCI6MTMwLjAsInA0X3JpZ2h0X29mZnNldCI6NDkuMCwicDRfeWF3IjoiU3RhdGljIiwicDRfeWF3bW9kIjoiRGlzYWJsZWQiLCJwNF95YXdtb2Rfb2ZmIjoxMzAuMCwicDRfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInBoYXNlX3R5cGUiOiJDdXN0b20iLCJwcmVzZXRfc2VsZWN0IjoiTWV0YSJ9LHsiY3VzdG9tX3BoYXNlcyI6NC4wLCJlbmFibGUiOmZhbHNlLCJwMV9jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDFfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwMV9kZWxheV9zcGVlZCI6MjAuMCwicDFfZGVsYXlfdGlja3MiOjIwLjAsInAxX2xlZnRfb2Zmc2V0IjoxMzAuMCwicDFfb2Zmc2V0IjoxMzAuMCwicDFfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDFfeWF3IjoiU3RhdGljIiwicDFfeWF3bW9kIjoiRGlzYWJsZWQiLCJwMV95YXdtb2Rfb2ZmIjoxMzAuMCwicDFfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInAyX2Nvc2luZV9yYW5kb20iOjEwLjAsInAyX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDJfZGVsYXlfc3BlZWQiOjIwLjAsInAyX2RlbGF5X3RpY2tzIjoyMC4wLCJwMl9sZWZ0X29mZnNldCI6MTMwLjAsInAyX29mZnNldCI6LTU1LjAsInAyX3JpZ2h0X29mZnNldCI6MTMwLjAsInAyX3lhdyI6IlN0YXRpYyIsInAyX3lhd21vZCI6IkRpc2FibGVkIiwicDJfeWF3bW9kX29mZiI6LTE1OC4wLCJwMl95YXdtb2RfcmFuZG9tIjoxODAuMCwicDNfY29zaW5lX3JhbmRvbSI6MTAwLjAsInAzX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDNfZGVsYXlfc3BlZWQiOjE1LjAsInAzX2RlbGF5X3RpY2tzIjoyMC4wLCJwM19sZWZ0X29mZnNldCI6LTE2LjAsInAzX29mZnNldCI6LTE4MC4wLCJwM19yaWdodF9vZmZzZXQiOjQ5LjAsInAzX3lhdyI6IlN0YXRpYyIsInAzX3lhd21vZCI6IkRpc2FibGVkIiwicDNfeWF3bW9kX29mZiI6MTMwLjAsInAzX3lhd21vZF9yYW5kb20iOjEwMC4wLCJwNF9jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDRfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwNF9kZWxheV9zcGVlZCI6MjAuMCwicDRfZGVsYXlfdGlja3MiOjIwLjAsInA0X2xlZnRfb2Zmc2V0IjoxMzAuMCwicDRfb2Zmc2V0IjoxMzAuMCwicDRfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDRfeWF3IjoiU3RhdGljIiwicDRfeWF3bW9kIjoiRGlzYWJsZWQiLCJwNF95YXdtb2Rfb2ZmIjoxMzAuMCwicDRfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInBoYXNlX3R5cGUiOiJDdXN0b20iLCJwcmVzZXRfc2VsZWN0IjoiTWV0YSJ9LHsiY3VzdG9tX3BoYXNlcyI6Mi4wLCJlbmFibGUiOmZhbHNlLCJwMV9jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDFfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwMV9kZWxheV9zcGVlZCI6MjAuMCwicDFfZGVsYXlfdGlja3MiOjIwLjAsInAxX2xlZnRfb2Zmc2V0IjoxMzAuMCwicDFfb2Zmc2V0IjoxNi4wLCJwMV9yaWdodF9vZmZzZXQiOjEzMC4wLCJwMV95YXciOiJTdGF0aWMiLCJwMV95YXdtb2QiOiJDZW50ZXIiLCJwMV95YXdtb2Rfb2ZmIjotNTUuMCwicDFfeWF3bW9kX3JhbmRvbSI6MTAuMCwicDJfY29zaW5lX3JhbmRvbSI6MTAwLjAsInAyX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDJfZGVsYXlfc3BlZWQiOjE1LjAsInAyX2RlbGF5X3RpY2tzIjoyMC4wLCJwMl9sZWZ0X29mZnNldCI6LTE2LjAsInAyX29mZnNldCI6LTE1OC4wLCJwMl9yaWdodF9vZmZzZXQiOjQ5LjAsInAyX3lhdyI6IkRlbGF5ZWQgU3dpdGNoIiwicDJfeWF3bW9kIjoiRGlzYWJsZWQiLCJwMl95YXdtb2Rfb2ZmIjotMTgwLjAsInAyX3lhd21vZF9yYW5kb20iOjEwMC4wLCJwM19jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDNfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwM19kZWxheV9zcGVlZCI6MjAuMCwicDNfZGVsYXlfdGlja3MiOjIwLjAsInAzX2xlZnRfb2Zmc2V0IjoxMzAuMCwicDNfb2Zmc2V0IjoxMzAuMCwicDNfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDNfeWF3IjoiU3RhdGljIiwicDNfeWF3bW9kIjoiRGlzYWJsZWQiLCJwM195YXdtb2Rfb2ZmIjoxMzAuMCwicDNfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInA0X2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwNF9kZWxheV9sb2dpYyI6IkNvc2luZSIsInA0X2RlbGF5X3NwZWVkIjoyMC4wLCJwNF9kZWxheV90aWNrcyI6MjAuMCwicDRfbGVmdF9vZmZzZXQiOjEzMC4wLCJwNF9vZmZzZXQiOjEzMC4wLCJwNF9yaWdodF9vZmZzZXQiOjEzMC4wLCJwNF95YXciOiJTdGF0aWMiLCJwNF95YXdtb2QiOiJEaXNhYmxlZCIsInA0X3lhd21vZF9vZmYiOjEzMC4wLCJwNF95YXdtb2RfcmFuZG9tIjoxMDAuMCwicGhhc2VfdHlwZSI6IkN1c3RvbSIsInByZXNldF9zZWxlY3QiOiJNZXRhIn0seyJjdXN0b21fcGhhc2VzIjoxLjAsImVuYWJsZSI6ZmFsc2UsInAxX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwMV9kZWxheV9sb2dpYyI6IkNvc2luZSIsInAxX2RlbGF5X3NwZWVkIjoyMC4wLCJwMV9kZWxheV90aWNrcyI6MjAuMCwicDFfbGVmdF9vZmZzZXQiOjEzMC4wLCJwMV9vZmZzZXQiOi01LjAsInAxX3JpZ2h0X29mZnNldCI6MTMwLjAsInAxX3lhdyI6IlN0YXRpYyIsInAxX3lhd21vZCI6IkNlbnRlciIsInAxX3lhd21vZF9vZmYiOi0xNTguMCwicDFfeWF3bW9kX3JhbmRvbSI6MTgwLjAsInAyX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwMl9kZWxheV9sb2dpYyI6IkNvc2luZSIsInAyX2RlbGF5X3NwZWVkIjoyMC4wLCJwMl9kZWxheV90aWNrcyI6MjAuMCwicDJfbGVmdF9vZmZzZXQiOjEzMC4wLCJwMl9vZmZzZXQiOi0xODAuMCwicDJfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDJfeWF3IjoiU3RhdGljIiwicDJfeWF3bW9kIjoiRGlzYWJsZWQiLCJwMl95YXdtb2Rfb2ZmIjoxMzAuMCwicDJfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInAzX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwM19kZWxheV9sb2dpYyI6IkNvc2luZSIsInAzX2RlbGF5X3NwZWVkIjoyMC4wLCJwM19kZWxheV90aWNrcyI6MjAuMCwicDNfbGVmdF9vZmZzZXQiOjEzMC4wLCJwM19vZmZzZXQiOjEzMC4wLCJwM19yaWdodF9vZmZzZXQiOjEzMC4wLCJwM195YXciOiJTdGF0aWMiLCJwM195YXdtb2QiOiJEaXNhYmxlZCIsInAzX3lhd21vZF9vZmYiOjEzMC4wLCJwM195YXdtb2RfcmFuZG9tIjoxMDAuMCwicDRfY29zaW5lX3JhbmRvbSI6MTAwLjAsInA0X2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDRfZGVsYXlfc3BlZWQiOjIwLjAsInA0X2RlbGF5X3RpY2tzIjoyMC4wLCJwNF9sZWZ0X29mZnNldCI6MTMwLjAsInA0X29mZnNldCI6MTMwLjAsInA0X3JpZ2h0X29mZnNldCI6MTMwLjAsInA0X3lhdyI6IlN0YXRpYyIsInA0X3lhd21vZCI6IkRpc2FibGVkIiwicDRfeWF3bW9kX29mZiI6MTMwLjAsInA0X3lhd21vZF9yYW5kb20iOjEwMC4wLCJwaGFzZV90eXBlIjoiQ3VzdG9tIiwicHJlc2V0X3NlbGVjdCI6Ik1ldGEifSx7ImN1c3RvbV9waGFzZXMiOjEzMC4wLCJlbmFibGUiOmZhbHNlLCJwMV9jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDFfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwMV9kZWxheV9zcGVlZCI6MjAuMCwicDFfZGVsYXlfdGlja3MiOjIwLjAsInAxX2xlZnRfb2Zmc2V0IjoxMzAuMCwicDFfb2Zmc2V0IjoxMzAuMCwicDFfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDFfeWF3IjoiU3RhdGljIiwicDFfeWF3bW9kIjoiRGlzYWJsZWQiLCJwMV95YXdtb2Rfb2ZmIjoxMzAuMCwicDFfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInAyX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwMl9kZWxheV9sb2dpYyI6IkNvc2luZSIsInAyX2RlbGF5X3NwZWVkIjoyMC4wLCJwMl9kZWxheV90aWNrcyI6MjAuMCwicDJfbGVmdF9vZmZzZXQiOjEzMC4wLCJwMl9vZmZzZXQiOjEzMC4wLCJwMl9yaWdodF9vZmZzZXQiOjEzMC4wLCJwMl95YXciOiJTdGF0aWMiLCJwMl95YXdtb2QiOiJEaXNhYmxlZCIsInAyX3lhd21vZF9vZmYiOjEzMC4wLCJwMl95YXdtb2RfcmFuZG9tIjoxMDAuMCwicDNfY29zaW5lX3JhbmRvbSI6MTAwLjAsInAzX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDNfZGVsYXlfc3BlZWQiOjIwLjAsInAzX2RlbGF5X3RpY2tzIjoyMC4wLCJwM19sZWZ0X29mZnNldCI6MTMwLjAsInAzX29mZnNldCI6MTMwLjAsInAzX3JpZ2h0X29mZnNldCI6MTMwLjAsInAzX3lhdyI6IlN0YXRpYyIsInAzX3lhd21vZCI6IkRpc2FibGVkIiwicDNfeWF3bW9kX29mZiI6MTMwLjAsInAzX3lhd21vZF9yYW5kb20iOjEwMC4wLCJwNF9jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDRfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwNF9kZWxheV9zcGVlZCI6MjAuMCwicDRfZGVsYXlfdGlja3MiOjIwLjAsInA0X2xlZnRfb2Zmc2V0IjoxMzAuMCwicDRfb2Zmc2V0IjoxMzAuMCwicDRfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDRfeWF3IjoiU3RhdGljIiwicDRfeWF3bW9kIjoiRGlzYWJsZWQiLCJwNF95YXdtb2Rfb2ZmIjoxMzAuMCwicDRfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInBoYXNlX3R5cGUiOiJDdXN0b20iLCJwcmVzZXRfc2VsZWN0IjoiTWV0YSJ9LHsiY3VzdG9tX3BoYXNlcyI6MTMwLjAsImVuYWJsZSI6ZmFsc2UsInAxX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwMV9kZWxheV9sb2dpYyI6IkNvc2luZSIsInAxX2RlbGF5X3NwZWVkIjoyMC4wLCJwMV9kZWxheV90aWNrcyI6MjAuMCwicDFfbGVmdF9vZmZzZXQiOjEzMC4wLCJwMV9vZmZzZXQiOjEzMC4wLCJwMV9yaWdodF9vZmZzZXQiOjEzMC4wLCJwMV95YXciOiJTdGF0aWMiLCJwMV95YXdtb2QiOiJEaXNhYmxlZCIsInAxX3lhd21vZF9vZmYiOjEzMC4wLCJwMV95YXdtb2RfcmFuZG9tIjoxMDAuMCwicDJfY29zaW5lX3JhbmRvbSI6MzguMCwicDJfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwMl9kZWxheV9zcGVlZCI6MjAuMCwicDJfZGVsYXlfdGlja3MiOjIwLjAsInAyX2xlZnRfb2Zmc2V0IjoxMzAuMCwicDJfb2Zmc2V0IjotNTguMCwicDJfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDJfeWF3IjoiU3RhdGljIiwicDJfeWF3bW9kIjoiRGlzYWJsZWQiLCJwMl95YXdtb2Rfb2ZmIjoxMzAuMCwicDJfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInAzX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwM19kZWxheV9sb2dpYyI6IkNvc2luZSIsInAzX2RlbGF5X3NwZWVkIjoxMC4wLCJwM19kZWxheV90aWNrcyI6MTIuMCwicDNfbGVmdF9vZmZzZXQiOi0yNC4wLCJwM19vZmZzZXQiOi0xNjkuMCwicDNfcmlnaHRfb2Zmc2V0Ijo2NS4wLCJwM195YXciOiJTdGF0aWMiLCJwM195YXdtb2QiOiJEaXNhYmxlZCIsInAzX3lhd21vZF9vZmYiOjEzMC4wLCJwM195YXdtb2RfcmFuZG9tIjoxMDAuMCwicDRfY29zaW5lX3JhbmRvbSI6MTAuMCwicDRfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwNF9kZWxheV9zcGVlZCI6MjAuMCwicDRfZGVsYXlfdGlja3MiOjIwLjAsInA0X2xlZnRfb2Zmc2V0IjoxMzAuMCwicDRfb2Zmc2V0IjotNTUuMCwicDRfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDRfeWF3IjoiU3RhdGljIiwicDRfeWF3bW9kIjoiRGlzYWJsZWQiLCJwNF95YXdtb2Rfb2ZmIjotMTU4LjAsInA0X3lhd21vZF9yYW5kb20iOjE4MC4wLCJwaGFzZV90eXBlIjoiQ3VzdG9tIiwicHJlc2V0X3NlbGVjdCI6Ik1ldGEifSx7ImN1c3RvbV9waGFzZXMiOjIuMCwiZW5hYmxlIjpmYWxzZSwicDFfY29zaW5lX3JhbmRvbSI6MTAwLjAsInAxX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDFfZGVsYXlfc3BlZWQiOjIwLjAsInAxX2RlbGF5X3RpY2tzIjoyMC4wLCJwMV9sZWZ0X29mZnNldCI6MTMwLjAsInAxX29mZnNldCI6NS4wLCJwMV9yaWdodF9vZmZzZXQiOjEzMC4wLCJwMV95YXciOiJTdGF0aWMiLCJwMV95YXdtb2QiOiJDZW50ZXIiLCJwMV95YXdtb2Rfb2ZmIjotNTguMCwicDFfeWF3bW9kX3JhbmRvbSI6MzguMCwicDJfY29zaW5lX3JhbmRvbSI6MTAwLjAsInAyX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDJfZGVsYXlfc3BlZWQiOjEwLjAsInAyX2RlbGF5X3RpY2tzIjoxMi4wLCJwMl9sZWZ0X29mZnNldCI6LTI0LjAsInAyX29mZnNldCI6MTMwLjAsInAyX3JpZ2h0X29mZnNldCI6NjUuMCwicDJfeWF3IjoiRGVsYXllZCBTd2l0Y2giLCJwMl95YXdtb2QiOiJEaXNhYmxlZCIsInAyX3lhd21vZF9vZmYiOi0xNjkuMCwicDJfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInAzX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwM19kZWxheV9sb2dpYyI6IkNvc2luZSIsInAzX2RlbGF5X3NwZWVkIjoyMC4wLCJwM19kZWxheV90aWNrcyI6MjAuMCwicDNfbGVmdF9vZmZzZXQiOjEzMC4wLCJwM19vZmZzZXQiOjEzMC4wLCJwM19yaWdodF9vZmZzZXQiOjEzMC4wLCJwM195YXciOiJTdGF0aWMiLCJwM195YXdtb2QiOiJEaXNhYmxlZCIsInAzX3lhd21vZF9vZmYiOi01NS4wLCJwM195YXdtb2RfcmFuZG9tIjoxMC4wLCJwNF9jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDRfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwNF9kZWxheV9zcGVlZCI6MjAuMCwicDRfZGVsYXlfdGlja3MiOjIwLjAsInA0X2xlZnRfb2Zmc2V0IjoxMzAuMCwicDRfb2Zmc2V0IjotMTU4LjAsInA0X3JpZ2h0X29mZnNldCI6MTMwLjAsInA0X3lhdyI6IlN0YXRpYyIsInA0X3lhd21vZCI6IkRpc2FibGVkIiwicDRfeWF3bW9kX29mZiI6LTE4MC4wLCJwNF95YXdtb2RfcmFuZG9tIjoxMDAuMCwicGhhc2VfdHlwZSI6IkN1c3RvbSIsInByZXNldF9zZWxlY3QiOiJNZXRhIn0seyJjdXN0b21fcGhhc2VzIjo0LjAsImVuYWJsZSI6dHJ1ZSwicDFfY29zaW5lX3JhbmRvbSI6MTAwLjAsInAxX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDFfZGVsYXlfc3BlZWQiOjIwLjAsInAxX2RlbGF5X3RpY2tzIjoyMC4wLCJwMV9sZWZ0X29mZnNldCI6MTMwLjAsInAxX29mZnNldCI6MTUuMCwicDFfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDFfeWF3IjoiU3RhdGljIiwicDFfeWF3bW9kIjoiQ2VudGVyIiwicDFfeWF3bW9kX29mZiI6LTU1LjAsInAxX3lhd21vZF9yYW5kb20iOjU1LjAsInAyX2Nvc2luZV9yYW5kb20iOjUuMCwicDJfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwMl9kZWxheV9zcGVlZCI6MTUuMCwicDJfZGVsYXlfdGlja3MiOjExLjAsInAyX2xlZnRfb2Zmc2V0IjotMjEuMCwicDJfb2Zmc2V0Ijo1NS4wLCJwMl9yaWdodF9vZmZzZXQiOjQ5LjAsInAyX3lhdyI6IkRlbGF5ZWQgU3dpdGNoIiwicDJfeWF3bW9kIjoiRGlzYWJsZWQiLCJwMl95YXdtb2Rfb2ZmIjotMzMuMCwicDJfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInAzX2Nvc2luZV9yYW5kb20iOjEwLjAsInAzX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDNfZGVsYXlfc3BlZWQiOjIwLjAsInAzX2RlbGF5X3RpY2tzIjoyMC4wLCJwM19sZWZ0X29mZnNldCI6LTQuMCwicDNfb2Zmc2V0IjotNTUuMCwicDNfcmlnaHRfb2Zmc2V0IjoyNy4wLCJwM195YXciOiJMZWZ0L1JpZ2h0IiwicDNfeWF3bW9kIjoiQ2VudGVyIiwicDNfeWF3bW9kX29mZiI6LTI3LjAsInAzX3lhd21vZF9yYW5kb20iOjEyLjAsInA0X2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwNF9kZWxheV9sb2dpYyI6IkNvc2luZSIsInA0X2RlbGF5X3NwZWVkIjoyMC4wLCJwNF9kZWxheV90aWNrcyI6MjAuMCwicDRfbGVmdF9vZmZzZXQiOi0xOC4wLCJwNF9vZmZzZXQiOi0xODAuMCwicDRfcmlnaHRfb2Zmc2V0Ijo0NC4wLCJwNF95YXciOiJMZWZ0L1JpZ2h0IiwicDRfeWF3bW9kIjoiRGlzYWJsZWQiLCJwNF95YXdtb2Rfb2ZmIjoxMzAuMCwicDRfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInBoYXNlX3R5cGUiOiJDdXN0b20iLCJwcmVzZXRfc2VsZWN0IjoiTWV0YSJ9XX0sMTMzLjBd'}}
        configs_db.menu_list = configs_db.menu_list or {'Default'}
        
        local notify_label_timer = nil
        local notify_label = groups.main3:label('')
        local cfg_selector = groups.main3:list('', configs_db.menu_list)
        local data_transfer = groups.main3:combo("Data Transfer", "Global")

        notify_label:visibility(false)

        local notify_label_timer = timer.create(3000, false, function()
            notify_label:visibility(false)  -- Clear the label
        end)
        if notify_label_timer then
            notify_label_timer:stop()
        end

        local all_cfg = pui.setup({menu_items.aa, menu_items.settings, gears_items, antiaim_builder_cfg, brute_builder_cfg, aspect_ratio_slider}, true)
        local aa_cfg = pui.setup({menu_items.aa, antiaim_builder_cfg}, true)
        local brute_cfg = pui.setup({brute_builder_cfg}, true)

        configs_db.cfg_list[1][2] = 'W3siYW5pbXMiOlsiU3RhdGljIGxlZ3MgaW4gQWlyIiwifiJdLCJhdXRvX3RwIjpmYWxzZSwiYXZvaWRfYmFja3N0YWIiOmZhbHNlLCJlbmFibGVfYWEiOnRydWUsImZvcmNlX2RlZmVuc2l2ZSI6WyJTbG93bW9kZSIsIkluIEFpciIsIkFpciBDcm91Y2giLCJ+Il0sImZzX2Rpc2FibGVycyI6WyJDcm91Y2ggTW92ZSIsIkluIEFpciIsIkFpciBDcm91Y2giLCJ+Il0sIm1hbnVhbF95YXciOiJEaXNhYmxlZCIsInByZXNldF9saXN0IjoxLjAsInNhZmVfaGVhZCI6dHJ1ZSwic3RhdGVfY29uZGl0aW9uIjoiQ3JvdWNoaW5nIiwic3R5bGVfYWEiOjIuMH0seyJhc3BlY3RfcmF0aW8iOnRydWUsImNyb3NzaGFpcl9pbmRpY2F0b3JzIjpmYWxzZSwiZGVidWdfcGFuZWwiOmZhbHNlLCJlc3BfbGlzdCI6MS4wLCJmYWtlX2xhdGVuY3kiOmZhbHNlLCJoaXRjaGFuY2UiOmZhbHNlLCJsaXN0IjoxLjAsImxvZ3MiOnRydWUsIm92ZXJyaWRlX2luZGljYXRvciI6dHJ1ZSwicGVyZm9ybWFuY2VfbW9kZSI6ZmFsc2UsInJhZ2Vib3RfbG9naWMiOmZhbHNlLCJzY29wZV9vdmVybGF5IjpmYWxzZSwic2tlZXRfaW5kaWNhdG9ycyI6dHJ1ZSwidG9nZ2xlX3NldHRpbmdzIjp0cnVlLCJ0cmFzaHRhbGsiOnRydWUsInZpZXdtb2RlbCI6dHJ1ZX0seyJiYWltX2xvZ2ljIjpmYWxzZSwiYm9yZGVyX3N3aXRjaCI6dHJ1ZSwiYm9yZGVyX3RoaWNrbmVzcyI6Mi4wLCJib3JkZXJfdHlwZXMiOlsiU2hhZG93IiwiT3V0bGluZSIsIn4iXSwiY2xvc2VfYWltYm90IjpmYWxzZSwiY3Jvc3NoYWlyX2FjY2VudCI6IiM5Q0EyOTNGRiIsImNyb3NzaGFpcl9idWlsZCI6dHJ1ZSwiY3Jvc3NoYWlyX290aGVyIjoiIzg0OEQ5MkZGIiwiY3Jvc3NoYWlyX3N0eWxlIjoiU2ltcGxlIiwiZGVmZW5zaXZlX3R5cGUiOiJBbHdheXMgT24iLCJkaXNhYmxlX3RwIjpbIn4iXSwiZG9ybWFudF9sb2dpYyI6ZmFsc2UsImZha2VfbGF0ZW5jeV9hbW91bnQiOjc3LjAsImhpdF9jb2xvciI6IiM4MDgxQTM4MSIsImhpdGNoYW5jZV9pbl9haXIiOjM1LjAsImxvZ3NfZXZlbnRzIjpbIkFpbWJvdCIsIkFudGktQnJ1dGUiLCJ+Il0sImxvZ3Nfb3B0aW9uIjpbIkNvbnNvbGUiLCJ+Il0sIm1pc3NfY29sb3IiOiIjQTM4MDgwODEiLCJvcHRpbWlzZV9tb2RlIjoiTG93Iiwib3ZlcnJpZGVfaW5kaWNhdG9yX2NvbG9yIjoiI0ZGRkZGRkZGIiwib3ZlcnJpZGVfaW5kaWNhdG9yX2ZvbnQiOjEuMCwib3ZlcnJpZGVfaW5kaWNhdG9yX29wdGlvbnMiOlsiRGFtYWdlIiwiSGl0Y2hhbmNlIiwifiJdLCJzY29wZV9jb2xvciI6IiNGRkZGRkY3NiIsInNjb3BlX2dhcCI6NS4wLCJzY29wZV9pbnZlcnRlZCI6ZmFsc2UsInNjb3BlX3NpemUiOjc1LjAsInNrZWV0X2luZGljYXRvcnNfc2VsIjpbIkRvdWJsZSBUYXAiLCJIaWRlc2hvdHMiLCJNaW5pbXVtIERhbWFnZSIsIkJvZHkgQWltIiwiSGl0Y2hhbmNlIiwiRG9ybWFudCBBaW1ib3QiLCJTYWZlcG9pbnQiLCJGcmVlc3RhbmRpbmciLCJGYWtlIER1Y2siLCJQaW5nIiwifiJdLCJza2VldF9wYWRkaW5nIjotMTE2LjAsInRlbGVwb3J0X3dlYXBvbiI6WyJ+Il0sInRyYXNodGFsa19kZWF0aCI6dHJ1ZSwidmlld21vZGVsX2ZvdiI6NjgwLjAsInZpZXdtb2RlbF94b2ZmIjoyNS4wLCJ2aWV3bW9kZWxfeW9mZiI6MC4wLCJ2aWV3bW9kZWxfem9mZiI6LTE1LjAsIndhdGVybWFya19wb3NpdGlvbiI6IlRvcCBSaWdodCIsInhfcGFkZGluZyI6MC4wLCJ5X3BhZGRpbmciOjAuMH0seyJjb25kaXRpb25fYnVpbGRlciI6W3siYnlhdyI6dHJ1ZSwiY29zaW5lX3JhbmRvbSI6MC4wLCJjb3NpbmVfc3BlZWRfbWFuaSI6Mi4wLCJkZWxheV9sb2dpYyI6IkNvc2luZSIsImRlbGF5X21hbmkiOjIuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjoyLjAsImRlbGF5X3RpY2tzIjoxMC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZmxpY2tfc2luZ2xlIjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0xOS4wLCJtYW5pX21ldGhvZCI6IlN0YXRpYyIsIm1hbmlwdWxhdGlvbl9yYW5kb20iOjAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjQ0LjAsInlhdyI6IkxlZnQvUmlnaHQiLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9yYW5kb20iOjAuMCwiY29zaW5lX3NwZWVkX21hbmkiOjIuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjoyLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MTIuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZsaWNrX3NpbmdsZSI6MC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMjUuMCwibWFuaV9tZXRob2QiOiJTdGF0aWMiLCJtYW5pcHVsYXRpb25fcmFuZG9tIjowLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0Ijo0MC4wLCJ5YXciOiJEZWxheWVkIFN3aXRjaCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9yYW5kb20iOjAuMCwiY29zaW5lX3NwZWVkX21hbmkiOjIuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjoyLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MTYuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZsaWNrX3NpbmdsZSI6MC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMzAuMCwibWFuaV9tZXRob2QiOiJTdGF0aWMiLCJtYW5pcHVsYXRpb25fcmFuZG9tIjowLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0Ijo0MC4wLCJ5YXciOiJEZWxheWVkIFN3aXRjaCIsInlhd21vZCI6IjUtV2F5IiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9yYW5kb20iOjAuMCwiY29zaW5lX3NwZWVkX21hbmkiOjIuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjoyLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6Mi4wLCJkZWxheV90aWNrcyI6MTAuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MTAuMCwiZmxpY2tfbGVmdCI6MC4wLCJmbGlja19yaWdodCI6MC4wLCJmbGlja19zaW5nbGUiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTMwLjAsIm1hbmlfbWV0aG9kIjoiU3RhdGljIiwibWFuaXB1bGF0aW9uX3JhbmRvbSI6MC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6NDAuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IjUtV2F5IiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9yYW5kb20iOjAuMCwiY29zaW5lX3NwZWVkX21hbmkiOjIuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjoyLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MTYuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZsaWNrX3NpbmdsZSI6MC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjU0LjAsImxlZnRfb2Zmc2V0IjotMjYuMCwibWFuaV9tZXRob2QiOiJTdGF0aWMiLCJtYW5pcHVsYXRpb25fcmFuZG9tIjowLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6NTQuMCwicmlnaHRfb2Zmc2V0Ijo0Ni4wLCJ5YXciOiJEZWxheWVkIFN3aXRjaCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiY29zaW5lX3JhbmRvbSI6MC4wLCJjb3NpbmVfc3BlZWRfbWFuaSI6Mi4wLCJkZWxheV9sb2dpYyI6IkNvc2luZSIsImRlbGF5X21hbmkiOjIuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjoxNi4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZmxpY2tfc2luZ2xlIjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0xNy4wLCJtYW5pX21ldGhvZCI6IlN0YXRpYyIsIm1hbmlwdWxhdGlvbl9yYW5kb20iOjAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjQzLjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJjb3NpbmVfcmFuZG9tIjowLjAsImNvc2luZV9zcGVlZF9tYW5pIjoyLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6Mi4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjE2LjAsImRlbGF5X3RpY2tzIjo4LjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEwLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZmxpY2tfc2luZ2xlIjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0yNi4wLCJtYW5pX21ldGhvZCI6IlN0YXRpYyIsIm1hbmlwdWxhdGlvbl9yYW5kb20iOjAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjM4LjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJjb3NpbmVfcmFuZG9tIjowLjAsImNvc2luZV9zcGVlZF9tYW5pIjoyLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6Mi4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjE0LjAsImRlbGF5X3RpY2tzIjo1LjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEuMCwiZmxpY2tfbGVmdCI6MC4wLCJmbGlja19yaWdodCI6MC4wLCJmbGlja19zaW5nbGUiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTIwLjAsIm1hbmlfbWV0aG9kIjoiU3RhdGljIiwibWFuaXB1bGF0aW9uX3JhbmRvbSI6MC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6NDMuMCwieWF3IjoiRGVsYXllZCBTd2l0Y2giLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfV0sImRlZmVuc2l2ZV9idWlsZGVyIjpbeyJjX3BpdGNoIjowLjAsImVuYWJsZSI6dHJ1ZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJTd2l0Y2giLCJ3MV9waXRjaCI6ODUuMCwidzJfcGl0Y2giOjg5LjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In1dfSx7ImFudGlicnV0ZV9idWlsZGVyIjpbeyJjdXN0b21fcGhhc2VzIjoxLjAsImVuYWJsZSI6ZmFsc2UsInAxX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwMV9kZWxheV9sb2dpYyI6IkNvc2luZSIsInAxX2RlbGF5X3NwZWVkIjoyMC4wLCJwMV9kZWxheV90aWNrcyI6MjAuMCwicDFfbGVmdF9vZmZzZXQiOjEzMC4wLCJwMV9vZmZzZXQiOjIyLjAsInAxX3JpZ2h0X29mZnNldCI6MTMwLjAsInAxX3lhdyI6IlN0YXRpYyIsInAxX3lhd21vZCI6IkNlbnRlciIsInAxX3lhd21vZF9vZmYiOi0xNjkuMCwicDFfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInAyX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwMl9kZWxheV9sb2dpYyI6IkNvc2luZSIsInAyX2RlbGF5X3NwZWVkIjoyMC4wLCJwMl9kZWxheV90aWNrcyI6MjAuMCwicDJfbGVmdF9vZmZzZXQiOjEzMC4wLCJwMl9vZmZzZXQiOjEzMC4wLCJwMl9yaWdodF9vZmZzZXQiOjEzMC4wLCJwMl95YXciOiJTdGF0aWMiLCJwMl95YXdtb2QiOiJEaXNhYmxlZCIsInAyX3lhd21vZF9vZmYiOi01NS4wLCJwMl95YXdtb2RfcmFuZG9tIjoxMC4wLCJwM19jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDNfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwM19kZWxheV9zcGVlZCI6MjAuMCwicDNfZGVsYXlfdGlja3MiOjIwLjAsInAzX2xlZnRfb2Zmc2V0IjoxMzAuMCwicDNfb2Zmc2V0IjotMTU4LjAsInAzX3JpZ2h0X29mZnNldCI6MTMwLjAsInAzX3lhdyI6IlN0YXRpYyIsInAzX3lhd21vZCI6IkRpc2FibGVkIiwicDNfeWF3bW9kX29mZiI6LTE4MC4wLCJwM195YXdtb2RfcmFuZG9tIjoxMDAuMCwicDRfY29zaW5lX3JhbmRvbSI6MTAwLjAsInA0X2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDRfZGVsYXlfc3BlZWQiOjE1LjAsInA0X2RlbGF5X3RpY2tzIjoyMC4wLCJwNF9sZWZ0X29mZnNldCI6LTE2LjAsInA0X29mZnNldCI6MTMwLjAsInA0X3JpZ2h0X29mZnNldCI6NDkuMCwicDRfeWF3IjoiU3RhdGljIiwicDRfeWF3bW9kIjoiRGlzYWJsZWQiLCJwNF95YXdtb2Rfb2ZmIjoxMzAuMCwicDRfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInBoYXNlX3R5cGUiOiJDdXN0b20iLCJwcmVzZXRfc2VsZWN0IjoiTWV0YSJ9LHsiY3VzdG9tX3BoYXNlcyI6NC4wLCJlbmFibGUiOmZhbHNlLCJwMV9jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDFfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwMV9kZWxheV9zcGVlZCI6MjAuMCwicDFfZGVsYXlfdGlja3MiOjIwLjAsInAxX2xlZnRfb2Zmc2V0IjoxMzAuMCwicDFfb2Zmc2V0IjoxMzAuMCwicDFfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDFfeWF3IjoiU3RhdGljIiwicDFfeWF3bW9kIjoiRGlzYWJsZWQiLCJwMV95YXdtb2Rfb2ZmIjoxMzAuMCwicDFfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInAyX2Nvc2luZV9yYW5kb20iOjEwLjAsInAyX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDJfZGVsYXlfc3BlZWQiOjIwLjAsInAyX2RlbGF5X3RpY2tzIjoyMC4wLCJwMl9sZWZ0X29mZnNldCI6MTMwLjAsInAyX29mZnNldCI6LTU1LjAsInAyX3JpZ2h0X29mZnNldCI6MTMwLjAsInAyX3lhdyI6IlN0YXRpYyIsInAyX3lhd21vZCI6IkRpc2FibGVkIiwicDJfeWF3bW9kX29mZiI6LTE1OC4wLCJwMl95YXdtb2RfcmFuZG9tIjoxODAuMCwicDNfY29zaW5lX3JhbmRvbSI6MTAwLjAsInAzX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDNfZGVsYXlfc3BlZWQiOjE1LjAsInAzX2RlbGF5X3RpY2tzIjoyMC4wLCJwM19sZWZ0X29mZnNldCI6LTE2LjAsInAzX29mZnNldCI6LTE4MC4wLCJwM19yaWdodF9vZmZzZXQiOjQ5LjAsInAzX3lhdyI6IlN0YXRpYyIsInAzX3lhd21vZCI6IkRpc2FibGVkIiwicDNfeWF3bW9kX29mZiI6MTMwLjAsInAzX3lhd21vZF9yYW5kb20iOjEwMC4wLCJwNF9jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDRfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwNF9kZWxheV9zcGVlZCI6MjAuMCwicDRfZGVsYXlfdGlja3MiOjIwLjAsInA0X2xlZnRfb2Zmc2V0IjoxMzAuMCwicDRfb2Zmc2V0IjoxMzAuMCwicDRfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDRfeWF3IjoiU3RhdGljIiwicDRfeWF3bW9kIjoiRGlzYWJsZWQiLCJwNF95YXdtb2Rfb2ZmIjoxMzAuMCwicDRfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInBoYXNlX3R5cGUiOiJDdXN0b20iLCJwcmVzZXRfc2VsZWN0IjoiTWV0YSJ9LHsiY3VzdG9tX3BoYXNlcyI6Mi4wLCJlbmFibGUiOmZhbHNlLCJwMV9jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDFfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwMV9kZWxheV9zcGVlZCI6MjAuMCwicDFfZGVsYXlfdGlja3MiOjIwLjAsInAxX2xlZnRfb2Zmc2V0IjoxMzAuMCwicDFfb2Zmc2V0IjoxNi4wLCJwMV9yaWdodF9vZmZzZXQiOjEzMC4wLCJwMV95YXciOiJTdGF0aWMiLCJwMV95YXdtb2QiOiJDZW50ZXIiLCJwMV95YXdtb2Rfb2ZmIjotNTUuMCwicDFfeWF3bW9kX3JhbmRvbSI6MTAuMCwicDJfY29zaW5lX3JhbmRvbSI6MTAwLjAsInAyX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDJfZGVsYXlfc3BlZWQiOjE1LjAsInAyX2RlbGF5X3RpY2tzIjoyMC4wLCJwMl9sZWZ0X29mZnNldCI6LTE2LjAsInAyX29mZnNldCI6LTE1OC4wLCJwMl9yaWdodF9vZmZzZXQiOjQ5LjAsInAyX3lhdyI6IkRlbGF5ZWQgU3dpdGNoIiwicDJfeWF3bW9kIjoiRGlzYWJsZWQiLCJwMl95YXdtb2Rfb2ZmIjotMTgwLjAsInAyX3lhd21vZF9yYW5kb20iOjEwMC4wLCJwM19jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDNfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwM19kZWxheV9zcGVlZCI6MjAuMCwicDNfZGVsYXlfdGlja3MiOjIwLjAsInAzX2xlZnRfb2Zmc2V0IjoxMzAuMCwicDNfb2Zmc2V0IjoxMzAuMCwicDNfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDNfeWF3IjoiU3RhdGljIiwicDNfeWF3bW9kIjoiRGlzYWJsZWQiLCJwM195YXdtb2Rfb2ZmIjoxMzAuMCwicDNfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInA0X2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwNF9kZWxheV9sb2dpYyI6IkNvc2luZSIsInA0X2RlbGF5X3NwZWVkIjoyMC4wLCJwNF9kZWxheV90aWNrcyI6MjAuMCwicDRfbGVmdF9vZmZzZXQiOjEzMC4wLCJwNF9vZmZzZXQiOjEzMC4wLCJwNF9yaWdodF9vZmZzZXQiOjEzMC4wLCJwNF95YXciOiJTdGF0aWMiLCJwNF95YXdtb2QiOiJEaXNhYmxlZCIsInA0X3lhd21vZF9vZmYiOjEzMC4wLCJwNF95YXdtb2RfcmFuZG9tIjoxMDAuMCwicGhhc2VfdHlwZSI6IkN1c3RvbSIsInByZXNldF9zZWxlY3QiOiJNZXRhIn0seyJjdXN0b21fcGhhc2VzIjoxLjAsImVuYWJsZSI6ZmFsc2UsInAxX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwMV9kZWxheV9sb2dpYyI6IkNvc2luZSIsInAxX2RlbGF5X3NwZWVkIjoyMC4wLCJwMV9kZWxheV90aWNrcyI6MjAuMCwicDFfbGVmdF9vZmZzZXQiOjEzMC4wLCJwMV9vZmZzZXQiOi01LjAsInAxX3JpZ2h0X29mZnNldCI6MTMwLjAsInAxX3lhdyI6IlN0YXRpYyIsInAxX3lhd21vZCI6IkNlbnRlciIsInAxX3lhd21vZF9vZmYiOi0xNTguMCwicDFfeWF3bW9kX3JhbmRvbSI6MTgwLjAsInAyX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwMl9kZWxheV9sb2dpYyI6IkNvc2luZSIsInAyX2RlbGF5X3NwZWVkIjoyMC4wLCJwMl9kZWxheV90aWNrcyI6MjAuMCwicDJfbGVmdF9vZmZzZXQiOjEzMC4wLCJwMl9vZmZzZXQiOi0xODAuMCwicDJfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDJfeWF3IjoiU3RhdGljIiwicDJfeWF3bW9kIjoiRGlzYWJsZWQiLCJwMl95YXdtb2Rfb2ZmIjoxMzAuMCwicDJfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInAzX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwM19kZWxheV9sb2dpYyI6IkNvc2luZSIsInAzX2RlbGF5X3NwZWVkIjoyMC4wLCJwM19kZWxheV90aWNrcyI6MjAuMCwicDNfbGVmdF9vZmZzZXQiOjEzMC4wLCJwM19vZmZzZXQiOjEzMC4wLCJwM19yaWdodF9vZmZzZXQiOjEzMC4wLCJwM195YXciOiJTdGF0aWMiLCJwM195YXdtb2QiOiJEaXNhYmxlZCIsInAzX3lhd21vZF9vZmYiOjEzMC4wLCJwM195YXdtb2RfcmFuZG9tIjoxMDAuMCwicDRfY29zaW5lX3JhbmRvbSI6MTAwLjAsInA0X2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDRfZGVsYXlfc3BlZWQiOjIwLjAsInA0X2RlbGF5X3RpY2tzIjoyMC4wLCJwNF9sZWZ0X29mZnNldCI6MTMwLjAsInA0X29mZnNldCI6MTMwLjAsInA0X3JpZ2h0X29mZnNldCI6MTMwLjAsInA0X3lhdyI6IlN0YXRpYyIsInA0X3lhd21vZCI6IkRpc2FibGVkIiwicDRfeWF3bW9kX29mZiI6MTMwLjAsInA0X3lhd21vZF9yYW5kb20iOjEwMC4wLCJwaGFzZV90eXBlIjoiQ3VzdG9tIiwicHJlc2V0X3NlbGVjdCI6Ik1ldGEifSx7ImN1c3RvbV9waGFzZXMiOjEzMC4wLCJlbmFibGUiOmZhbHNlLCJwMV9jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDFfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwMV9kZWxheV9zcGVlZCI6MjAuMCwicDFfZGVsYXlfdGlja3MiOjIwLjAsInAxX2xlZnRfb2Zmc2V0IjoxMzAuMCwicDFfb2Zmc2V0IjoxMzAuMCwicDFfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDFfeWF3IjoiU3RhdGljIiwicDFfeWF3bW9kIjoiRGlzYWJsZWQiLCJwMV95YXdtb2Rfb2ZmIjoxMzAuMCwicDFfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInAyX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwMl9kZWxheV9sb2dpYyI6IkNvc2luZSIsInAyX2RlbGF5X3NwZWVkIjoyMC4wLCJwMl9kZWxheV90aWNrcyI6MjAuMCwicDJfbGVmdF9vZmZzZXQiOjEzMC4wLCJwMl9vZmZzZXQiOjEzMC4wLCJwMl9yaWdodF9vZmZzZXQiOjEzMC4wLCJwMl95YXciOiJTdGF0aWMiLCJwMl95YXdtb2QiOiJEaXNhYmxlZCIsInAyX3lhd21vZF9vZmYiOjEzMC4wLCJwMl95YXdtb2RfcmFuZG9tIjoxMDAuMCwicDNfY29zaW5lX3JhbmRvbSI6MTAwLjAsInAzX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDNfZGVsYXlfc3BlZWQiOjIwLjAsInAzX2RlbGF5X3RpY2tzIjoyMC4wLCJwM19sZWZ0X29mZnNldCI6MTMwLjAsInAzX29mZnNldCI6MTMwLjAsInAzX3JpZ2h0X29mZnNldCI6MTMwLjAsInAzX3lhdyI6IlN0YXRpYyIsInAzX3lhd21vZCI6IkRpc2FibGVkIiwicDNfeWF3bW9kX29mZiI6MTMwLjAsInAzX3lhd21vZF9yYW5kb20iOjEwMC4wLCJwNF9jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDRfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwNF9kZWxheV9zcGVlZCI6MjAuMCwicDRfZGVsYXlfdGlja3MiOjIwLjAsInA0X2xlZnRfb2Zmc2V0IjoxMzAuMCwicDRfb2Zmc2V0IjoxMzAuMCwicDRfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDRfeWF3IjoiU3RhdGljIiwicDRfeWF3bW9kIjoiRGlzYWJsZWQiLCJwNF95YXdtb2Rfb2ZmIjoxMzAuMCwicDRfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInBoYXNlX3R5cGUiOiJDdXN0b20iLCJwcmVzZXRfc2VsZWN0IjoiTWV0YSJ9LHsiY3VzdG9tX3BoYXNlcyI6MTMwLjAsImVuYWJsZSI6ZmFsc2UsInAxX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwMV9kZWxheV9sb2dpYyI6IkNvc2luZSIsInAxX2RlbGF5X3NwZWVkIjoyMC4wLCJwMV9kZWxheV90aWNrcyI6MjAuMCwicDFfbGVmdF9vZmZzZXQiOjEzMC4wLCJwMV9vZmZzZXQiOjEzMC4wLCJwMV9yaWdodF9vZmZzZXQiOjEzMC4wLCJwMV95YXciOiJTdGF0aWMiLCJwMV95YXdtb2QiOiJEaXNhYmxlZCIsInAxX3lhd21vZF9vZmYiOjEzMC4wLCJwMV95YXdtb2RfcmFuZG9tIjoxMDAuMCwicDJfY29zaW5lX3JhbmRvbSI6MzguMCwicDJfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwMl9kZWxheV9zcGVlZCI6MjAuMCwicDJfZGVsYXlfdGlja3MiOjIwLjAsInAyX2xlZnRfb2Zmc2V0IjoxMzAuMCwicDJfb2Zmc2V0IjotNTguMCwicDJfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDJfeWF3IjoiU3RhdGljIiwicDJfeWF3bW9kIjoiRGlzYWJsZWQiLCJwMl95YXdtb2Rfb2ZmIjoxMzAuMCwicDJfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInAzX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwM19kZWxheV9sb2dpYyI6IkNvc2luZSIsInAzX2RlbGF5X3NwZWVkIjoxMC4wLCJwM19kZWxheV90aWNrcyI6MTIuMCwicDNfbGVmdF9vZmZzZXQiOi0yNC4wLCJwM19vZmZzZXQiOi0xNjkuMCwicDNfcmlnaHRfb2Zmc2V0Ijo2NS4wLCJwM195YXciOiJTdGF0aWMiLCJwM195YXdtb2QiOiJEaXNhYmxlZCIsInAzX3lhd21vZF9vZmYiOjEzMC4wLCJwM195YXdtb2RfcmFuZG9tIjoxMDAuMCwicDRfY29zaW5lX3JhbmRvbSI6MTAuMCwicDRfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwNF9kZWxheV9zcGVlZCI6MjAuMCwicDRfZGVsYXlfdGlja3MiOjIwLjAsInA0X2xlZnRfb2Zmc2V0IjoxMzAuMCwicDRfb2Zmc2V0IjotNTUuMCwicDRfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDRfeWF3IjoiU3RhdGljIiwicDRfeWF3bW9kIjoiRGlzYWJsZWQiLCJwNF95YXdtb2Rfb2ZmIjotMTU4LjAsInA0X3lhd21vZF9yYW5kb20iOjE4MC4wLCJwaGFzZV90eXBlIjoiQ3VzdG9tIiwicHJlc2V0X3NlbGVjdCI6Ik1ldGEifSx7ImN1c3RvbV9waGFzZXMiOjIuMCwiZW5hYmxlIjpmYWxzZSwicDFfY29zaW5lX3JhbmRvbSI6MTAwLjAsInAxX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDFfZGVsYXlfc3BlZWQiOjIwLjAsInAxX2RlbGF5X3RpY2tzIjoyMC4wLCJwMV9sZWZ0X29mZnNldCI6MTMwLjAsInAxX29mZnNldCI6NS4wLCJwMV9yaWdodF9vZmZzZXQiOjEzMC4wLCJwMV95YXciOiJTdGF0aWMiLCJwMV95YXdtb2QiOiJDZW50ZXIiLCJwMV95YXdtb2Rfb2ZmIjotNTguMCwicDFfeWF3bW9kX3JhbmRvbSI6MzguMCwicDJfY29zaW5lX3JhbmRvbSI6MTAwLjAsInAyX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDJfZGVsYXlfc3BlZWQiOjEwLjAsInAyX2RlbGF5X3RpY2tzIjoxMi4wLCJwMl9sZWZ0X29mZnNldCI6LTI0LjAsInAyX29mZnNldCI6MTMwLjAsInAyX3JpZ2h0X29mZnNldCI6NjUuMCwicDJfeWF3IjoiRGVsYXllZCBTd2l0Y2giLCJwMl95YXdtb2QiOiJEaXNhYmxlZCIsInAyX3lhd21vZF9vZmYiOi0xNjkuMCwicDJfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInAzX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwM19kZWxheV9sb2dpYyI6IkNvc2luZSIsInAzX2RlbGF5X3NwZWVkIjoyMC4wLCJwM19kZWxheV90aWNrcyI6MjAuMCwicDNfbGVmdF9vZmZzZXQiOjEzMC4wLCJwM19vZmZzZXQiOjEzMC4wLCJwM19yaWdodF9vZmZzZXQiOjEzMC4wLCJwM195YXciOiJTdGF0aWMiLCJwM195YXdtb2QiOiJEaXNhYmxlZCIsInAzX3lhd21vZF9vZmYiOi01NS4wLCJwM195YXdtb2RfcmFuZG9tIjoxMC4wLCJwNF9jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDRfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwNF9kZWxheV9zcGVlZCI6MjAuMCwicDRfZGVsYXlfdGlja3MiOjIwLjAsInA0X2xlZnRfb2Zmc2V0IjoxMzAuMCwicDRfb2Zmc2V0IjotMTU4LjAsInA0X3JpZ2h0X29mZnNldCI6MTMwLjAsInA0X3lhdyI6IlN0YXRpYyIsInA0X3lhd21vZCI6IkRpc2FibGVkIiwicDRfeWF3bW9kX29mZiI6LTE4MC4wLCJwNF95YXdtb2RfcmFuZG9tIjoxMDAuMCwicGhhc2VfdHlwZSI6IkN1c3RvbSIsInByZXNldF9zZWxlY3QiOiJNZXRhIn0seyJjdXN0b21fcGhhc2VzIjo0LjAsImVuYWJsZSI6dHJ1ZSwicDFfY29zaW5lX3JhbmRvbSI6MTAwLjAsInAxX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDFfZGVsYXlfc3BlZWQiOjIwLjAsInAxX2RlbGF5X3RpY2tzIjoyMC4wLCJwMV9sZWZ0X29mZnNldCI6MTMwLjAsInAxX29mZnNldCI6MTUuMCwicDFfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDFfeWF3IjoiU3RhdGljIiwicDFfeWF3bW9kIjoiQ2VudGVyIiwicDFfeWF3bW9kX29mZiI6LTU1LjAsInAxX3lhd21vZF9yYW5kb20iOjU1LjAsInAyX2Nvc2luZV9yYW5kb20iOjUuMCwicDJfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwMl9kZWxheV9zcGVlZCI6MTUuMCwicDJfZGVsYXlfdGlja3MiOjExLjAsInAyX2xlZnRfb2Zmc2V0IjotMjEuMCwicDJfb2Zmc2V0Ijo1NS4wLCJwMl9yaWdodF9vZmZzZXQiOjQ5LjAsInAyX3lhdyI6IkRlbGF5ZWQgU3dpdGNoIiwicDJfeWF3bW9kIjoiRGlzYWJsZWQiLCJwMl95YXdtb2Rfb2ZmIjotMzMuMCwicDJfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInAzX2Nvc2luZV9yYW5kb20iOjEwLjAsInAzX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDNfZGVsYXlfc3BlZWQiOjIwLjAsInAzX2RlbGF5X3RpY2tzIjoyMC4wLCJwM19sZWZ0X29mZnNldCI6LTQuMCwicDNfb2Zmc2V0IjotNTUuMCwicDNfcmlnaHRfb2Zmc2V0IjoyNy4wLCJwM195YXciOiJMZWZ0L1JpZ2h0IiwicDNfeWF3bW9kIjoiQ2VudGVyIiwicDNfeWF3bW9kX29mZiI6LTI3LjAsInAzX3lhd21vZF9yYW5kb20iOjEyLjAsInA0X2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwNF9kZWxheV9sb2dpYyI6IkNvc2luZSIsInA0X2RlbGF5X3NwZWVkIjoyMC4wLCJwNF9kZWxheV90aWNrcyI6MjAuMCwicDRfbGVmdF9vZmZzZXQiOi0xOC4wLCJwNF9vZmZzZXQiOi0xODAuMCwicDRfcmlnaHRfb2Zmc2V0Ijo0NC4wLCJwNF95YXciOiJMZWZ0L1JpZ2h0IiwicDRfeWF3bW9kIjoiRGlzYWJsZWQiLCJwNF95YXdtb2Rfb2ZmIjoxMzAuMCwicDRfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInBoYXNlX3R5cGUiOiJDdXN0b20iLCJwcmVzZXRfc2VsZWN0IjoiTWV0YSJ9XX0sMTMzLjBd'
        cfg_system.save_config = function(id)
            notify_label:name(" \a928491FF\f<check>    \aDBDBDBFFconfiguration succesfully updated.")
            notify_label_timer:start()
            notify_label:visibility(true)
            cvar.play:call("ambient\\tones\\elev1")
            if id == 1 then return end
            local raw = all_cfg:save()
            configs_db.cfg_list[id][2] = base64.encode(json.stringify(raw))
            db.equity_configs = configs_db
        end
        
        cfg_system.update_values = function(id)
            local name = configs_db.cfg_list[id][1]
            local new_name = name..'\a'..ui.get_style("Link Active"):to_hex()..' - Active'
            for k, v in ipairs(configs_db.cfg_list) do
                configs_db.menu_list[k] = v[1]
            end
            configs_db.menu_list[id] = new_name
        end
        
        cfg_system.create_config = function(name)
            notify_label:name(" \a928491FF\f<check>    \aDBDBDBFFconfiguration succesfully created.")
            notify_label_timer:start()
            notify_label:visibility(true)
            if type(name) ~= 'string' then return end
            if name == nil or name == '' or name == ' ' then return end
            for i=#configs_db.menu_list, 1, -1 do if configs_db.menu_list[i] == name then 
                notify_label:name(" \a928491FF\f<xmark>    \aDBDBDBFFduplicated name")
                notify_label_timer:start()
                notify_label:visibility(true)
            return end end
            if #configs_db.cfg_list > 6 then 
                notify_label:name(" \a928491FF\f<xmark>    \aDBDBDBFFtoo many configs")
                notify_label_timer:start()
                notify_label:visibility(true)
                return end
            local completed = {name, ''}
            table.insert(configs_db.cfg_list, completed)
            table.insert(configs_db.menu_list, name)
            db.equity_configs = configs_db
        end
        
        cfg_system.remove_config = function(id)
            notify_label:name(" \a928491FF\f<check>    \aDBDBDBFFconfiguration succesfully deleted.")
            notify_label_timer:start()
            notify_label:visibility(true)
            if id == 1 then return end
            local item = configs_db.cfg_list[id][1]
            for i=#configs_db.cfg_list, 1, -1 do if configs_db.cfg_list[i][1] == item then table.remove(configs_db.cfg_list, i) table.remove(configs_db.menu_list, i) end end
            db.equity_configs = configs_db
        end
        
        cfg_system.load_config = function(id)
            if configs_db.cfg_list[id][2] == nil or configs_db.cfg_list[id][2] == '' then 
                print(string.format('Error[data_base[%s]]', id))
                    notify_label:name(" \a928491FF\f<xmark>    \aDBDBDBFFconfiguration is not saved.")
                    notify_label_timer:start()
                    notify_label:visibility(true)

                return end
            if id > #configs_db.cfg_list then print(string.format('Error[data_base[%s]]', id)) return end

            notify_label:name(" \a928491FF\f<check>    \aDBDBDBFFconfiguration succesfully loaded.")
            notify_label_timer:start()
            notify_label:visibility(true)
            all_cfg:load(json.parse(base64.decode(configs_db.cfg_list[id][2])))
                cvar.play:call("ambient\\tones\\elev1")
        end

        cfg_system.load_preset_config_1 = function()
            notify_label:name(" \a928491FF\f<check>    \aDBDBDBFFGodfather Preset succesfully loaded.")
            notify_label_timer:start()
            notify_label:visibility(true)
            

        --- real all-cfg local encoded_data = "W3siYW5pbXMiOlsiU3RhdGljIGxlZ3MgaW4gQWlyIiwiRm9sbG93IERpcmVjdGlvbiIsIn4iXSwiYXV0b190cCI6ZmFsc2UsImF2b2lkX2JhY2tzdGFiIjp0cnVlLCJlbmFibGVfYWEiOnRydWUsImZvcmNlX2RlZmVuc2l2ZSI6WyJTbG93bW9kZSIsIkNyb3VjaGluZyIsIkNyb3VjaCBNb3ZlIiwiSW4gQWlyIiwiQWlyIENyb3VjaCIsIn4iXSwiZnNfZGlzYWJsZXJzIjpbIlNsb3dtb2RlIiwiQ3JvdWNoaW5nIiwiQ3JvdWNoIE1vdmUiLCJJbiBBaXIiLCJBaXIgQ3JvdWNoIiwifiJdLCJtYW51YWxfeWF3IjoiRGlzYWJsZWQiLCJwcmVzZXRfbGlzdCI6MS4wLCJzYWZlX2hlYWQiOnRydWUsInN0YXRlX2NvbmRpdGlvbiI6IlN0YW5kaW5nIiwic3R5bGVfYWEiOjMuMH0seyJhc3BlY3RfcmF0aW8iOnRydWUsImZha2VfbGF0ZW5jeSI6dHJ1ZSwiaGl0Y2hhbmNlIjpmYWxzZSwibGlzdCI6MS4wLCJsb2dzIjp0cnVlLCJvdmVycmlkZV9pbmRpY2F0b3IiOnRydWUsInBlcmZvcm1hbmNlX21vZGUiOnRydWUsInJhZ2Vib3RfbG9naWMiOnRydWUsInNjb3BlX292ZXJsYXkiOmZhbHNlLCJ0b2dnbGVfc2V0dGluZ3MiOnRydWUsInZpZXdtb2RlbCI6dHJ1ZX0seyJhc3BlY3RfcmF0aW9fc2xpZGVyIjoxMzMuMCwiYmFpbV9sb2dpYyI6ZmFsc2UsImNsb3NlX2FpbWJvdCI6ZmFsc2UsImRlZmVuc2l2ZV90eXBlIjoiQWx3YXlzIE9uIiwiZGlzYWJsZSI6ZmFsc2UsImRpc2FibGVfdHAiOlsifiJdLCJkb3JtYW50X2xvZ2ljIjp0cnVlLCJmYWtlX2xhdGVuY3lfYW1vdW50IjoyMDAuMCwiaGl0X2NvbG9yIjoiIzY4RUM1NkZGIiwiaGl0Y2hhbmNlX2luX2FpciI6MzUuMCwibG9nc19ldmVudHMiOlsiQWltYm90IiwifiJdLCJsb2dzX29wdGlvbiI6WyJDb25zb2xlIiwifiJdLCJtaXNzX2NvbG9yIjoiI0VDNTY1NkZGIiwib3B0aW1pc2VfbW9kZSI6IkxvdyIsIm92ZXJyaWRlX2luZGljYXRvcl9jb2xvciI6IiNGRkZGRkZGRiIsIm92ZXJyaWRlX2luZGljYXRvcl9mb250IjoxLjAsIm92ZXJyaWRlX2luZGljYXRvcl9vcHRpb25zIjpbIkRhbWFnZSIsIn4iXSwic2NvcGVfY29sb3IiOiIjRkZGRkZGNzYiLCJzY29wZV9nYXAiOjUuMCwic2NvcGVfaW52ZXJ0ZWQiOmZhbHNlLCJzY29wZV9zaXplIjo3NS4wLCJ0ZWxlcG9ydF93ZWFwb24iOlsifiJdLCJ2aWV3bW9kZWxfZm92Ijo2ODAuMCwidmlld21vZGVsX3hvZmYiOjI1LjAsInZpZXdtb2RlbF95b2ZmIjowLjAsInZpZXdtb2RlbF96b2ZmIjotMTUuMH0seyJjb25kaXRpb25fYnVpbGRlciI6W3siYnlhdyI6dHJ1ZSwiZGVsYXlfcmFuZG9tIjowLjAsImRlbGF5X3RpY2tzIjo1LjAsImVuYWJsZSI6ZmFsc2UsImZha2VfcmFuZG9tIjoxLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0yMC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6NDMuMCwieWF3IjoiRGVsYXllZCBTd2l0Y2giLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6MTAuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMzMuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjQxLjAsInlhdyI6IkxlZnQvUmlnaHQiLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0yNS4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6NDIuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0yMy4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6NDcuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6NC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0zMC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6NDUuMCwieWF3IjoiRGVsYXllZCBTd2l0Y2giLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6NC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0zMC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6MzMuMCwieWF3IjoiRGVsYXllZCBTd2l0Y2giLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjIwLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJkZWxheV9yYW5kb20iOjAuMCwiZGVsYXlfdGlja3MiOjQuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMjcuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjQyLjAsInlhdyI6IkxlZnQvUmlnaHQiLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6NC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0xOS4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6NDcuMCwieWF3IjoiRGVsYXllZCBTd2l0Y2giLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfV0sImRlZmVuc2l2ZV9idWlsZGVyIjpbeyJjX3BpdGNoIjowLjAsImVuYWJsZSI6dHJ1ZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJTd2l0Y2giLCJ3MV9waXRjaCI6ODUuMCwidzJfcGl0Y2giOjg5LjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJTd2l0Y2giLCJ3MV9waXRjaCI6ODUuMCwidzJfcGl0Y2giOjg5LjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJOb25lIn1dfV0=" -- Continue your encoded string here
          
        local encoded_data = "W3siYW5pbXMiOlsiU3RhdGljIGxlZ3MgaW4gQWlyIiwiRm9sbG93IERpcmVjdGlvbiIsIn4iXSwiYXV0b190cCI6ZmFsc2UsImF2b2lkX2JhY2tzdGFiIjp0cnVlLCJlbmFibGVfYWEiOnRydWUsImZvcmNlX2RlZmVuc2l2ZSI6WyJTbG93bW9kZSIsIkNyb3VjaGluZyIsIkNyb3VjaCBNb3ZlIiwiSW4gQWlyIiwiQWlyIENyb3VjaCIsIn4iXSwiZnNfZGlzYWJsZXJzIjpbIlNsb3dtb2RlIiwiQ3JvdWNoaW5nIiwiQ3JvdWNoIE1vdmUiLCJJbiBBaXIiLCJBaXIgQ3JvdWNoIiwifiJdLCJtYW51YWxfeWF3IjoiRGlzYWJsZWQiLCJwcmVzZXRfbGlzdCI6MS4wLCJzYWZlX2hlYWQiOnRydWUsInN0YXRlX2NvbmRpdGlvbiI6IkZha2VsYWciLCJzdHlsZV9hYSI6My4wfSx7ImNvbmRpdGlvbl9idWlsZGVyIjpbeyJieWF3Ijp0cnVlLCJjb3NpbmVfc3BlZWRfbWFuaSI6MC4wLCJkZWxheV9sb2dpYyI6IkNvc2luZSIsImRlbGF5X21hbmkiOjAuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjowLjAsImRlbGF5X3RpY2tzIjo1LjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEuMCwiZmxpY2tfbGVmdCI6MC4wLCJmbGlja19yaWdodCI6MC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfbWFuaSI6MC4wLCJsZWZ0X29mZnNldCI6LTIwLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfbWFuaSI6MC4wLCJyaWdodF9vZmZzZXQiOjQzLjAsInlhdyI6IkxlZnQvUmlnaHQiLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9zcGVlZF9tYW5pIjowLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6MC4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjAuMCwiZGVsYXlfdGlja3MiOjEwLjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEuMCwiZmxpY2tfbGVmdCI6MC4wLCJmbGlja19yaWdodCI6MC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfbWFuaSI6MC4wLCJsZWZ0X29mZnNldCI6LTMzLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfbWFuaSI6MC4wLCJyaWdodF9vZmZzZXQiOjQxLjAsInlhdyI6IkxlZnQvUmlnaHQiLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9zcGVlZF9tYW5pIjowLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6MC4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjAuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9tYW5pIjowLjAsImxlZnRfb2Zmc2V0IjotMjUuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9tYW5pIjowLjAsInJpZ2h0X29mZnNldCI6NDIuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9zcGVlZF9tYW5pIjowLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6MC4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjAuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9tYW5pIjowLjAsImxlZnRfb2Zmc2V0IjotMjMuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9tYW5pIjowLjAsInJpZ2h0X29mZnNldCI6NDcuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9zcGVlZF9tYW5pIjowLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6MC4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjE0LjAsImRlbGF5X3RpY2tzIjo0LjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEuMCwiZmxpY2tfbGVmdCI6MC4wLCJmbGlja19yaWdodCI6MC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfbWFuaSI6MC4wLCJsZWZ0X29mZnNldCI6LTMwLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfbWFuaSI6MC4wLCJyaWdodF9vZmZzZXQiOjQ1LjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJjb3NpbmVfc3BlZWRfbWFuaSI6MC4wLCJkZWxheV9sb2dpYyI6IkNvc2luZSIsImRlbGF5X21hbmkiOjAuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjoxNC4wLCJkZWxheV90aWNrcyI6NC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X21hbmkiOjAuMCwibGVmdF9vZmZzZXQiOi0zMC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X21hbmkiOjAuMCwicmlnaHRfb2Zmc2V0IjozMy4wLCJ5YXciOiJEZWxheWVkIFN3aXRjaCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9zcGVlZF9tYW5pIjowLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6MC4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjAuMCwiZGVsYXlfdGlja3MiOjQuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9tYW5pIjowLjAsImxlZnRfb2Zmc2V0IjotMjcuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9tYW5pIjowLjAsInJpZ2h0X29mZnNldCI6NDIuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiY29zaW5lX3NwZWVkX21hbmkiOjAuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjowLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MTQuMCwiZGVsYXlfdGlja3MiOjQuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9tYW5pIjowLjAsImxlZnRfb2Zmc2V0IjotMTkuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9tYW5pIjowLjAsInJpZ2h0X29mZnNldCI6NDcuMCwieWF3IjoiRGVsYXllZCBTd2l0Y2giLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfV0sImRlZmVuc2l2ZV9idWlsZGVyIjpbeyJjX3BpdGNoIjowLjAsImVuYWJsZSI6dHJ1ZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJTd2l0Y2giLCJ3MV9waXRjaCI6ODUuMCwidzJfcGl0Y2giOjg5LjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJTd2l0Y2giLCJ3MV9waXRjaCI6ODUuMCwidzJfcGl0Y2giOjg5LjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJOb25lIn1dfV0=" -- Continue your encoded string here


            local decoded_data = base64.decode(encoded_data)  
            local config_data = json.parse(decoded_data)  
        
            aa_cfg:load(config_data)
        
            cvar.play:call("ambient\\tones\\elev1")
        end

        cfg_system.load_preset_config_2 = function()
            notify_label:name(" \a928491FF\f<check>    \aDBDBDBFFmeta Preset succesfully loaded.")
            notify_label_timer:start()
            notify_label:visibility(true)
            

             --- real all-cfg local local encoded_data = "W3siYW5pbXMiOlsiU3RhdGljIGxlZ3MgaW4gQWlyIiwiRm9sbG93IERpcmVjdGlvbiIsIn4iXSwiYXV0b190cCI6ZmFsc2UsImF2b2lkX2JhY2tzdGFiIjp0cnVlLCJlbmFibGVfYWEiOnRydWUsImZvcmNlX2RlZmVuc2l2ZSI6WyJTbG93bW9kZSIsIkNyb3VjaGluZyIsIkNyb3VjaCBNb3ZlIiwiSW4gQWlyIiwiQWlyIENyb3VjaCIsIn4iXSwiZnNfZGlzYWJsZXJzIjpbIkNyb3VjaCBNb3ZlIiwiSW4gQWlyIiwiQWlyIENyb3VjaCIsIn4iXSwibWFudWFsX3lhdyI6IkRpc2FibGVkIiwicHJlc2V0X2xpc3QiOjEuMCwic2FmZV9oZWFkIjp0cnVlLCJzdGF0ZV9jb25kaXRpb24iOiJTdGFuZGluZyIsInN0eWxlX2FhIjozLjB9LHsiYXNwZWN0X3JhdGlvIjp0cnVlLCJmYWtlX2xhdGVuY3kiOnRydWUsImhpdGNoYW5jZSI6ZmFsc2UsImxpc3QiOjIuMCwibG9ncyI6dHJ1ZSwib3ZlcnJpZGVfaW5kaWNhdG9yIjp0cnVlLCJwZXJmb3JtYW5jZV9tb2RlIjp0cnVlLCJyYWdlYm90X2xvZ2ljIjpmYWxzZSwic2NvcGVfb3ZlcmxheSI6ZmFsc2UsInRvZ2dsZV9zZXR0aW5ncyI6dHJ1ZSwidmlld21vZGVsIjp0cnVlfSx7ImFzcGVjdF9yYXRpb19zbGlkZXIiOjEzMy4wLCJiYWltX2xvZ2ljIjpmYWxzZSwiY2xvc2VfYWltYm90IjpmYWxzZSwiZGVmZW5zaXZlX3R5cGUiOiJBbHdheXMgT24iLCJkaXNhYmxlIjpmYWxzZSwiZGlzYWJsZV90cCI6WyJ+Il0sImRvcm1hbnRfbG9naWMiOmZhbHNlLCJmYWtlX2xhdGVuY3lfYW1vdW50IjoyMDAuMCwiaGl0X2NvbG9yIjoiIzY4RUM1NkZGIiwiaGl0Y2hhbmNlX2luX2FpciI6MzUuMCwibG9nc19ldmVudHMiOlsiQWltYm90IiwifiJdLCJsb2dzX29wdGlvbiI6WyJDb25zb2xlIiwifiJdLCJtaXNzX2NvbG9yIjoiI0VDNTY1NkZGIiwib3B0aW1pc2VfbW9kZSI6IkxvdyIsIm92ZXJyaWRlX2luZGljYXRvcl9jb2xvciI6IiNGRkZGRkZGRiIsIm92ZXJyaWRlX2luZGljYXRvcl9mb250IjoxLjAsIm92ZXJyaWRlX2luZGljYXRvcl9vcHRpb25zIjpbIkRhbWFnZSIsIn4iXSwic2NvcGVfY29sb3IiOiIjRkZGRkZGNzYiLCJzY29wZV9nYXAiOjUuMCwic2NvcGVfaW52ZXJ0ZWQiOmZhbHNlLCJzY29wZV9zaXplIjo3NS4wLCJ0ZWxlcG9ydF93ZWFwb24iOlsifiJdLCJ2aWV3bW9kZWxfZm92Ijo2ODAuMCwidmlld21vZGVsX3hvZmYiOjI1LjAsInZpZXdtb2RlbF95b2ZmIjowLjAsInZpZXdtb2RlbF96b2ZmIjotMTUuMH0seyJjb25kaXRpb25fYnVpbGRlciI6W3siYnlhdyI6ZmFsc2UsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6MTAuMCwiZW5hYmxlIjpmYWxzZSwiZmFrZV9yYW5kb20iOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0IjowLjAsImxlZnRfb2Zmc2V0IjowLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6MC4wLCJyaWdodF9vZmZzZXQiOjAuMCwieWF3IjoiU3RhdGljIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJkZWxheV9yYW5kb20iOjAuMCwiZGVsYXlfdGlja3MiOjEwLjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTI0LjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0Ijo0MS4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJkZWxheV9yYW5kb20iOjAuMCwiZGVsYXlfdGlja3MiOjEwLjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTI0LjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0IjozNy4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJkZWxheV9yYW5kb20iOjAuMCwiZGVsYXlfdGlja3MiOjEwLjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTIzLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0Ijo0Ny4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJkZWxheV9yYW5kb20iOjAuMCwiZGVsYXlfdGlja3MiOjEwLjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTMyLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0Ijo0Ni4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJkZWxheV9yYW5kb20iOjAuMCwiZGVsYXlfdGlja3MiOjEwLjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTIyLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0Ijo0NC4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJkZWxheV9yYW5kb20iOjAuMCwiZGVsYXlfdGlja3MiOjEwLjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTI5LjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0IjozNS4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJkZWxheV9yYW5kb20iOjAuMCwiZGVsYXlfdGlja3MiOjEwLjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTE4LjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0Ijo0NC4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH1dLCJkZWZlbnNpdmVfYnVpbGRlciI6W3siY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJOb25lIn0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6Ik5vbmUifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiTm9uZSJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOnRydWUsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjp0cnVlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6dHJ1ZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOnRydWUsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiTm9uZSJ9XX1d" -- Continue your encoded string here
        local encoded_data = "W3siYW5pbXMiOlsiU3RhdGljIGxlZ3MgaW4gQWlyIiwifiJdLCJhdXRvX3RwIjpmYWxzZSwiYXZvaWRfYmFja3N0YWIiOmZhbHNlLCJlbmFibGVfYWEiOnRydWUsImZvcmNlX2RlZmVuc2l2ZSI6WyJDcm91Y2hpbmciLCJDcm91Y2ggTW92ZSIsIn4iXSwiZnNfZGlzYWJsZXJzIjpbIkNyb3VjaCBNb3ZlIiwiSW4gQWlyIiwiQWlyIENyb3VjaCIsIn4iXSwibWFudWFsX3lhdyI6IkRpc2FibGVkIiwicHJlc2V0X2xpc3QiOjEuMCwic2FmZV9oZWFkIjp0cnVlLCJzdGF0ZV9jb25kaXRpb24iOiJGYWtlbGFnIiwic3R5bGVfYWEiOjMuMH0seyJjb25kaXRpb25fYnVpbGRlciI6W3siYnlhdyI6dHJ1ZSwiY29zaW5lX3NwZWVkX21hbmkiOjAuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjowLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X21hbmkiOjAuMCwibGVmdF9vZmZzZXQiOi0yMC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X21hbmkiOjAuMCwicmlnaHRfb2Zmc2V0Ijo0My4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJjb3NpbmVfc3BlZWRfbWFuaSI6MC4wLCJkZWxheV9sb2dpYyI6IkNvc2luZSIsImRlbGF5X21hbmkiOjAuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjowLjAsImRlbGF5X3RpY2tzIjoxMC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X21hbmkiOjAuMCwibGVmdF9vZmZzZXQiOjAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9tYW5pIjowLjAsInJpZ2h0X29mZnNldCI6MC4wLCJ5YXciOiJTdGF0aWMiLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9zcGVlZF9tYW5pIjowLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6MC4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjAuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9tYW5pIjowLjAsImxlZnRfb2Zmc2V0Ijo2LjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfbWFuaSI6MC4wLCJyaWdodF9vZmZzZXQiOjYuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkNlbnRlciIsInlhd21vZF9vZmYiOi01OC4wLCJ5YXdtb2RfcmFuZG9tIjoxNC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9zcGVlZF9tYW5pIjowLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6MC4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjAuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9tYW5pIjowLjAsImxlZnRfb2Zmc2V0IjotMjMuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9tYW5pIjowLjAsInJpZ2h0X29mZnNldCI6NDcuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9zcGVlZF9tYW5pIjowLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6MC4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjAuMCwiZGVsYXlfdGlja3MiOjguMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9tYW5pIjowLjAsImxlZnRfb2Zmc2V0Ijo1LjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfbWFuaSI6MC4wLCJyaWdodF9vZmZzZXQiOjUuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkNlbnRlciIsInlhd21vZF9vZmYiOi0zMS4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiY29zaW5lX3NwZWVkX21hbmkiOjAuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjowLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MC4wLCJkZWxheV90aWNrcyI6MTAuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9tYW5pIjowLjAsImxlZnRfb2Zmc2V0IjotMTAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9tYW5pIjowLjAsInJpZ2h0X29mZnNldCI6MzEuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9zcGVlZF9tYW5pIjowLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6MC4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjAuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9tYW5pIjowLjAsImxlZnRfb2Zmc2V0IjotMTkuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9tYW5pIjowLjAsInJpZ2h0X29mZnNldCI6MjMuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiY29zaW5lX3NwZWVkX21hbmkiOjAuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjowLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X21hbmkiOjAuMCwibGVmdF9vZmZzZXQiOi0xMC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X21hbmkiOjAuMCwicmlnaHRfb2Zmc2V0IjozMS4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiQ2VudGVyIiwieWF3bW9kX29mZiI6LTEwLjAsInlhd21vZF9yYW5kb20iOjcuMH1dLCJkZWZlbnNpdmVfYnVpbGRlciI6W3siY19waXRjaCI6MC4wLCJlbmFibGUiOnRydWUsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjo4NS4wLCJ3Ml9waXRjaCI6ODkuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjp0cnVlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6ODUuMCwidzJfcGl0Y2giOjg5LjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjp0cnVlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9XX1d" -- Continue your encoded string here


            local decoded_data = base64.decode(encoded_data)  
            local config_data = json.parse(decoded_data)  
        
            aa_cfg:load(config_data)
        
            cvar.play:call("ambient\\tones\\elev1")
        end

        cfg_system.load_preset_config_3 = function()
            notify_label:name(" \a928491FF\f<check>    \aDBDBDBFFJitter Preset succesfully loaded.")
            notify_label_timer:start()
            notify_label:visibility(true)
            
       -- real all_cfg local encoded_data = "W3siYW5pbXMiOlsiU3RhdGljIGxlZ3MgaW4gQWlyIiwifiJdLCJhdXRvX3RwIjpmYWxzZSwiYXZvaWRfYmFja3N0YWIiOmZhbHNlLCJlbmFibGVfYWEiOnRydWUsImZvcmNlX2RlZmVuc2l2ZSI6WyJDcm91Y2hpbmciLCJDcm91Y2ggTW92ZSIsIn4iXSwiZnNfZGlzYWJsZXJzIjpbIkNyb3VjaCBNb3ZlIiwiSW4gQWlyIiwiQWlyIENyb3VjaCIsIn4iXSwibWFudWFsX3lhdyI6IkRpc2FibGVkIiwicHJlc2V0X2xpc3QiOjEuMCwic2FmZV9oZWFkIjp0cnVlLCJzdGF0ZV9jb25kaXRpb24iOiJTdGFuZGluZyIsInN0eWxlX2FhIjozLjB9LHsiYXNwZWN0X3JhdGlvIjp0cnVlLCJmYWtlX2xhdGVuY3kiOnRydWUsImhpdGNoYW5jZSI6ZmFsc2UsImxpc3QiOjEuMCwibG9ncyI6dHJ1ZSwib3ZlcnJpZGVfaW5kaWNhdG9yIjp0cnVlLCJwZXJmb3JtYW5jZV9tb2RlIjp0cnVlLCJyYWdlYm90X2xvZ2ljIjp0cnVlLCJzY29wZV9vdmVybGF5IjpmYWxzZSwidG9nZ2xlX3NldHRpbmdzIjp0cnVlLCJ2aWV3bW9kZWwiOnRydWV9LHsiYXNwZWN0X3JhdGlvX3NsaWRlciI6MTMzLjAsImJhaW1fbG9naWMiOmZhbHNlLCJjbG9zZV9haW1ib3QiOmZhbHNlLCJkZWZlbnNpdmVfdHlwZSI6IkFsd2F5cyBPbiIsImRpc2FibGUiOmZhbHNlLCJkaXNhYmxlX3RwIjpbIn4iXSwiZG9ybWFudF9sb2dpYyI6dHJ1ZSwiZmFrZV9sYXRlbmN5X2Ftb3VudCI6MjAwLjAsImhpdF9jb2xvciI6IiM2OEVDNTZGRiIsImhpdGNoYW5jZV9pbl9haXIiOjM1LjAsImxvZ3NfZXZlbnRzIjpbIkFpbWJvdCIsIn4iXSwibG9nc19vcHRpb24iOlsiQ29uc29sZSIsIn4iXSwibWlzc19jb2xvciI6IiNFQzU2NTZGRiIsIm9wdGltaXNlX21vZGUiOiJMb3ciLCJvdmVycmlkZV9pbmRpY2F0b3JfY29sb3IiOiIjRkZGRkZGRkYiLCJvdmVycmlkZV9pbmRpY2F0b3JfZm9udCI6MS4wLCJvdmVycmlkZV9pbmRpY2F0b3Jfb3B0aW9ucyI6WyJEYW1hZ2UiLCJ+Il0sInNjb3BlX2NvbG9yIjoiI0ZGRkZGRjc2Iiwic2NvcGVfZ2FwIjo1LjAsInNjb3BlX2ludmVydGVkIjpmYWxzZSwic2NvcGVfc2l6ZSI6NzUuMCwidGVsZXBvcnRfd2VhcG9uIjpbIn4iXSwidmlld21vZGVsX2ZvdiI6NjgwLjAsInZpZXdtb2RlbF94b2ZmIjoyNS4wLCJ2aWV3bW9kZWxfeW9mZiI6MC4wLCJ2aWV3bW9kZWxfem9mZiI6LTE1LjB9LHsiY29uZGl0aW9uX2J1aWxkZXIiOlt7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOmZhbHNlLCJmYWtlX3JhbmRvbSI6MS4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMjAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjQzLjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJkZWxheV9yYW5kb20iOjAuMCwiZGVsYXlfdGlja3MiOjEwLjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6MC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6MC4wLCJ5YXciOiJTdGF0aWMiLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOjYuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjYuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkNlbnRlciIsInlhd21vZF9vZmYiOi01OC4wLCJ5YXdtb2RfcmFuZG9tIjoxNC4wfSx7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0yMy4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6NDcuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6OC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOjUuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjUuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkNlbnRlciIsInlhd21vZF9vZmYiOi0zMS4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiZGVsYXlfcmFuZG9tIjowLjAsImRlbGF5X3RpY2tzIjoxMC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0xMC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6MzEuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0xOS4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6MjMuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiZGVsYXlfcmFuZG9tIjowLjAsImRlbGF5X3RpY2tzIjo1LjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTEwLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0IjozMS4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiQ2VudGVyIiwieWF3bW9kX29mZiI6LTEwLjAsInlhd21vZF9yYW5kb20iOjcuMH1dLCJkZWZlbnNpdmVfYnVpbGRlciI6W3siY19waXRjaCI6MC4wLCJlbmFibGUiOnRydWUsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjo4NS4wLCJ3Ml9waXRjaCI6ODkuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjp0cnVlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6ODUuMCwidzJfcGl0Y2giOjg5LjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjp0cnVlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9XX1d" -- Continue your encoded string here
   local encoded_data = "W3siYW5pbXMiOlsiU3RhdGljIGxlZ3MgaW4gQWlyIiwifiJdLCJhdXRvX3RwIjpmYWxzZSwiYXZvaWRfYmFja3N0YWIiOmZhbHNlLCJlbmFibGVfYWEiOnRydWUsImZvcmNlX2RlZmVuc2l2ZSI6WyJDcm91Y2hpbmciLCJDcm91Y2ggTW92ZSIsIn4iXSwiZnNfZGlzYWJsZXJzIjpbIkNyb3VjaCBNb3ZlIiwiSW4gQWlyIiwiQWlyIENyb3VjaCIsIn4iXSwibWFudWFsX3lhdyI6IkRpc2FibGVkIiwicHJlc2V0X2xpc3QiOjEuMCwic2FmZV9oZWFkIjp0cnVlLCJzdGF0ZV9jb25kaXRpb24iOiJGYWtlbGFnIiwic3R5bGVfYWEiOjMuMH0seyJjb25kaXRpb25fYnVpbGRlciI6W3siYnlhdyI6dHJ1ZSwiY29zaW5lX3NwZWVkX21hbmkiOjAuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjowLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X21hbmkiOjAuMCwibGVmdF9vZmZzZXQiOi0yMC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X21hbmkiOjAuMCwicmlnaHRfb2Zmc2V0Ijo0My4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJjb3NpbmVfc3BlZWRfbWFuaSI6MC4wLCJkZWxheV9sb2dpYyI6IkNvc2luZSIsImRlbGF5X21hbmkiOjAuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjowLjAsImRlbGF5X3RpY2tzIjoxMC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X21hbmkiOjAuMCwibGVmdF9vZmZzZXQiOjAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9tYW5pIjowLjAsInJpZ2h0X29mZnNldCI6MC4wLCJ5YXciOiJTdGF0aWMiLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9zcGVlZF9tYW5pIjowLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6MC4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjAuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9tYW5pIjowLjAsImxlZnRfb2Zmc2V0Ijo2LjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfbWFuaSI6MC4wLCJyaWdodF9vZmZzZXQiOjYuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkNlbnRlciIsInlhd21vZF9vZmYiOi01OC4wLCJ5YXdtb2RfcmFuZG9tIjoxNC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9zcGVlZF9tYW5pIjowLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6MC4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjAuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9tYW5pIjowLjAsImxlZnRfb2Zmc2V0IjotMjMuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9tYW5pIjowLjAsInJpZ2h0X29mZnNldCI6NDcuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9zcGVlZF9tYW5pIjowLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6MC4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjAuMCwiZGVsYXlfdGlja3MiOjguMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9tYW5pIjowLjAsImxlZnRfb2Zmc2V0Ijo1LjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfbWFuaSI6MC4wLCJyaWdodF9vZmZzZXQiOjUuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkNlbnRlciIsInlhd21vZF9vZmYiOi0zMS4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiY29zaW5lX3NwZWVkX21hbmkiOjAuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjowLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MC4wLCJkZWxheV90aWNrcyI6MTAuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9tYW5pIjowLjAsImxlZnRfb2Zmc2V0IjotMTAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9tYW5pIjowLjAsInJpZ2h0X29mZnNldCI6MzEuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9zcGVlZF9tYW5pIjowLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6MC4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjAuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9tYW5pIjowLjAsImxlZnRfb2Zmc2V0IjotMTkuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9tYW5pIjowLjAsInJpZ2h0X29mZnNldCI6MjMuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiY29zaW5lX3NwZWVkX21hbmkiOjAuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjowLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X21hbmkiOjAuMCwibGVmdF9vZmZzZXQiOi0xMC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X21hbmkiOjAuMCwicmlnaHRfb2Zmc2V0IjozMS4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiQ2VudGVyIiwieWF3bW9kX29mZiI6LTEwLjAsInlhd21vZF9yYW5kb20iOjcuMH1dLCJkZWZlbnNpdmVfYnVpbGRlciI6W3siY19waXRjaCI6MC4wLCJlbmFibGUiOnRydWUsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjo4NS4wLCJ3Ml9waXRjaCI6ODkuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjp0cnVlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6ODUuMCwidzJfcGl0Y2giOjg5LjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjp0cnVlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9XX1d" -- Continue your encoded string here

        local decoded_data = base64.decode(encoded_data)  
        local config_data = json.parse(decoded_data)  

        aa_cfg:load(config_data)

        cvar.play:call("ambient\\tones\\elev1")
    end

    cfg_system.load_preset_config_4 = function()
        notify_label:name(" \a928491FF\f<check>    \aDBDBDBFFdelay Preset succesfully loaded.")
        notify_label_timer:start()
        notify_label:visibility(true)
        
    -- real all_cfg local encoded_data = "W3siYW5pbXMiOlsiU3RhdGljIGxlZ3MgaW4gQWlyIiwifiJdLCJhdXRvX3RwIjpmYWxzZSwiYXZvaWRfYmFja3N0YWIiOmZhbHNlLCJlbmFibGVfYWEiOnRydWUsImZvcmNlX2RlZmVuc2l2ZSI6WyJTbG93bW9kZSIsIkluIEFpciIsIkFpciBDcm91Y2giLCJ+Il0sImZzX2Rpc2FibGVycyI6WyJDcm91Y2ggTW92ZSIsIkluIEFpciIsIkFpciBDcm91Y2giLCJ+Il0sIm1hbnVhbF95YXciOiJEaXNhYmxlZCIsInByZXNldF9saXN0IjoxLjAsInNhZmVfaGVhZCI6dHJ1ZSwic3RhdGVfY29uZGl0aW9uIjoiSW4gQWlyIiwic3R5bGVfYWEiOjMuMH0seyJhc3BlY3RfcmF0aW8iOnRydWUsImZha2VfbGF0ZW5jeSI6dHJ1ZSwiaGl0Y2hhbmNlIjpmYWxzZSwibGlzdCI6MS4wLCJsb2dzIjpmYWxzZSwib3ZlcnJpZGVfaW5kaWNhdG9yIjp0cnVlLCJwZXJmb3JtYW5jZV9tb2RlIjp0cnVlLCJyYWdlYm90X2xvZ2ljIjpmYWxzZSwic2NvcGVfb3ZlcmxheSI6ZmFsc2UsInRvZ2dsZV9zZXR0aW5ncyI6dHJ1ZSwidmlld21vZGVsIjpmYWxzZX0seyJhc3BlY3RfcmF0aW9fc2xpZGVyIjoxMzMuMCwiYmFpbV9sb2dpYyI6ZmFsc2UsImNsb3NlX2FpbWJvdCI6ZmFsc2UsImRlZmVuc2l2ZV90eXBlIjoiQWx3YXlzIE9uIiwiZGlzYWJsZSI6ZmFsc2UsImRpc2FibGVfdHAiOlsifiJdLCJkb3JtYW50X2xvZ2ljIjpmYWxzZSwiZmFrZV9sYXRlbmN5X2Ftb3VudCI6MjAwLjAsImhpdF9jb2xvciI6IiM2OEVDNTZGRiIsImhpdGNoYW5jZV9pbl9haXIiOjM1LjAsImxvZ3NfZXZlbnRzIjpbIkFpbWJvdCIsIn4iXSwibG9nc19vcHRpb24iOlsiQ29uc29sZSIsIlNjcmVlbiIsIn4iXSwibWlzc19jb2xvciI6IiNFQzU2NTZGRiIsIm9wdGltaXNlX21vZGUiOiJMb3ciLCJvdmVycmlkZV9pbmRpY2F0b3JfY29sb3IiOiIjRkZGRkZGRkYiLCJvdmVycmlkZV9pbmRpY2F0b3JfZm9udCI6MS4wLCJvdmVycmlkZV9pbmRpY2F0b3Jfb3B0aW9ucyI6WyJEYW1hZ2UiLCJ+Il0sInNjb3BlX2NvbG9yIjoiI0ZGRkZGRjc2Iiwic2NvcGVfZ2FwIjo1LjAsInNjb3BlX2ludmVydGVkIjpmYWxzZSwic2NvcGVfc2l6ZSI6NzUuMCwidGVsZXBvcnRfd2VhcG9uIjpbIn4iXSwidmlld21vZGVsX2ZvdiI6NjgwLjAsInZpZXdtb2RlbF94b2ZmIjoyNS4wLCJ2aWV3bW9kZWxfeW9mZiI6MC4wLCJ2aWV3bW9kZWxfem9mZiI6LTE1LjB9LHsiY29uZGl0aW9uX2J1aWxkZXIiOlt7ImJ5YXciOmZhbHNlLCJkZWxheV9yYW5kb20iOjAuMCwiZGVsYXlfdGlja3MiOjEwLjAsImVuYWJsZSI6ZmFsc2UsImZha2VfcmFuZG9tIjoxLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6MC4wLCJsZWZ0X29mZnNldCI6MC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjAuMCwicmlnaHRfb2Zmc2V0IjowLjAsInlhdyI6IkxlZnQvUmlnaHQiLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0yNS4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6NDAuMCwieWF3IjoiRGVsYXllZCBTd2l0Y2giLCJ5YXdtb2QiOiI1LVdheSIsInlhd21vZF9vZmYiOjIwLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJkZWxheV9yYW5kb20iOjEwLjAsImRlbGF5X3RpY2tzIjo2LjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEwMC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMTguMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjQ0LjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjoyMC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiZGVsYXlfcmFuZG9tIjowLjAsImRlbGF5X3RpY2tzIjo1LjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEwLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0yMy4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6NDcuMCwieWF3IjoiRGVsYXllZCBTd2l0Y2giLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjIwLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJkZWxheV9yYW5kb20iOjAuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjU0LjAsImxlZnRfb2Zmc2V0IjotMjYuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo1NC4wLCJyaWdodF9vZmZzZXQiOjQ2LjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJkZWxheV9yYW5kb20iOjAuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMTkuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjQyLjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJkZWxheV9yYW5kb20iOjAuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6NTAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTI0LjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0Ijo0MC4wLCJ5YXciOiJEZWxheWVkIFN3aXRjaCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiZGVsYXlfcmFuZG9tIjoxMC4wLCJkZWxheV90aWNrcyI6OC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0yMC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6NDMuMCwieWF3IjoiRGVsYXllZCBTd2l0Y2giLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfV0sImRlZmVuc2l2ZV9idWlsZGVyIjpbeyJjX3BpdGNoIjowLjAsImVuYWJsZSI6dHJ1ZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJTd2l0Y2giLCJ3MV9waXRjaCI6ODUuMCwidzJfcGl0Y2giOjg5LjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In1dfV0=" -- Continue your encoded string here
  local encoded_data = "W3siYW5pbXMiOlsiU3RhdGljIGxlZ3MgaW4gQWlyIiwiRm9sbG93IERpcmVjdGlvbiIsIn4iXSwiYXV0b190cCI6ZmFsc2UsImF2b2lkX2JhY2tzdGFiIjp0cnVlLCJlbmFibGVfYWEiOnRydWUsImZvcmNlX2RlZmVuc2l2ZSI6WyJTbG93bW9kZSIsIkNyb3VjaGluZyIsIkNyb3VjaCBNb3ZlIiwiSW4gQWlyIiwiQWlyIENyb3VjaCIsIn4iXSwiZnNfZGlzYWJsZXJzIjpbIlNsb3dtb2RlIiwiQ3JvdWNoaW5nIiwiQ3JvdWNoIE1vdmUiLCJJbiBBaXIiLCJBaXIgQ3JvdWNoIiwifiJdLCJtYW51YWxfeWF3IjoiRGlzYWJsZWQiLCJwcmVzZXRfbGlzdCI6MS4wLCJzYWZlX2hlYWQiOnRydWUsInN0YXRlX2NvbmRpdGlvbiI6IkZha2VsYWciLCJzdHlsZV9hYSI6My4wfSx7ImNvbmRpdGlvbl9idWlsZGVyIjpbeyJieWF3Ijp0cnVlLCJjb3NpbmVfc3BlZWRfbWFuaSI6MC4wLCJkZWxheV9sb2dpYyI6IkNvc2luZSIsImRlbGF5X21hbmkiOjAuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjoxNi4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X21hbmkiOjAuMCwibGVmdF9vZmZzZXQiOi0yMC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X21hbmkiOjAuMCwicmlnaHRfb2Zmc2V0Ijo0My4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJjb3NpbmVfc3BlZWRfbWFuaSI6MC4wLCJkZWxheV9sb2dpYyI6IkNvc2luZSIsImRlbGF5X21hbmkiOjAuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjowLjAsImRlbGF5X3RpY2tzIjoxMC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X21hbmkiOjAuMCwibGVmdF9vZmZzZXQiOi0zMy4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X21hbmkiOjAuMCwicmlnaHRfb2Zmc2V0Ijo0MS4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJjb3NpbmVfc3BlZWRfbWFuaSI6MC4wLCJkZWxheV9sb2dpYyI6IkNvc2luZSIsImRlbGF5X21hbmkiOjAuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjoxNC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X21hbmkiOjAuMCwibGVmdF9vZmZzZXQiOi0zMy4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X21hbmkiOjAuMCwicmlnaHRfb2Zmc2V0Ijo1MC4wLCJ5YXciOiJEZWxheWVkIFN3aXRjaCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9zcGVlZF9tYW5pIjowLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6MC4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjIwLjAsImRlbGF5X3RpY2tzIjoxMC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X21hbmkiOjAuMCwibGVmdF9vZmZzZXQiOi0yMy4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X21hbmkiOjAuMCwicmlnaHRfb2Zmc2V0Ijo0Ny4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjoyMC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiY29zaW5lX3NwZWVkX21hbmkiOjAuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjowLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MTUuMCwiZGVsYXlfdGlja3MiOjQuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9tYW5pIjowLjAsImxlZnRfb2Zmc2V0IjotMzAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9tYW5pIjowLjAsInJpZ2h0X29mZnNldCI6NDUuMCwieWF3IjoiRGVsYXllZCBTd2l0Y2giLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9zcGVlZF9tYW5pIjowLjAsImRlbGF5X2xvZ2ljIjoiU2luZSIsImRlbGF5X21hbmkiOjAuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjoxNi4wLCJkZWxheV90aWNrcyI6NC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X21hbmkiOjAuMCwibGVmdF9vZmZzZXQiOi0yMS4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X21hbmkiOjAuMCwicmlnaHRfb2Zmc2V0Ijo0Mi4wLCJ5YXciOiJEZWxheWVkIFN3aXRjaCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9zcGVlZF9tYW5pIjowLjAsImRlbGF5X2xvZ2ljIjoiU2luZSIsImRlbGF5X21hbmkiOjAuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjoxNC4wLCJkZWxheV90aWNrcyI6NC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X21hbmkiOjAuMCwibGVmdF9vZmZzZXQiOi0yNy4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X21hbmkiOjAuMCwicmlnaHRfb2Zmc2V0Ijo0Mi4wLCJ5YXciOiJEZWxheWVkIFN3aXRjaCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiY29zaW5lX3NwZWVkX21hbmkiOjAuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjowLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MTIuMCwiZGVsYXlfdGlja3MiOjQuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9tYW5pIjowLjAsImxlZnRfb2Zmc2V0IjotMTkuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9tYW5pIjowLjAsInJpZ2h0X29mZnNldCI6NDcuMCwieWF3IjoiRGVsYXllZCBTd2l0Y2giLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfV0sImRlZmVuc2l2ZV9idWlsZGVyIjpbeyJjX3BpdGNoIjowLjAsImVuYWJsZSI6dHJ1ZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJTd2l0Y2giLCJ3MV9waXRjaCI6ODUuMCwidzJfcGl0Y2giOjg5LjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJTd2l0Y2giLCJ3MV9waXRjaCI6ODUuMCwidzJfcGl0Y2giOjg5LjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6dHJ1ZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJTd2l0Y2giLCJ3MV9waXRjaCI6ODUuMCwidzJfcGl0Y2giOjg5LjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjp0cnVlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IlN3aXRjaCIsIncxX3BpdGNoIjo4NS4wLCJ3Ml9waXRjaCI6ODkuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOnRydWUsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6dHJ1ZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJTd2l0Y2giLCJ3MV9waXRjaCI6ODUuMCwidzJfcGl0Y2giOjg5LjAsInlhdyI6IkRlZmF1bHQifV19XQ==" -- Continue your encoded string here

    local decoded_data = base64.decode(encoded_data)  
    local config_data = json.parse(decoded_data)  

    aa_cfg:load(config_data)

    cvar.play:call("ambient\\tones\\elev1")
end

cfg_system.load_preset_config_5 = function()
    notify_label:name(" \a928491FF\f<check>    \aDBDBDBFFslow Preset succesfully loaded.")
    notify_label_timer:start()
    notify_label:visibility(true)
    
    -- real_all_cfg local encoded_data = "W3siYW5pbXMiOlsiU3RhdGljIGxlZ3MgaW4gQWlyIiwiSml0dGVyIExlZ3MiLCJ+Il0sImF1dG9fdHAiOmZhbHNlLCJhdm9pZF9iYWNrc3RhYiI6ZmFsc2UsImVuYWJsZV9hYSI6dHJ1ZSwiZm9yY2VfZGVmZW5zaXZlIjpbIlNsb3dtb2RlIiwiSW4gQWlyIiwiQWlyIENyb3VjaCIsIn4iXSwiZnNfZGlzYWJsZXJzIjpbIkNyb3VjaCBNb3ZlIiwiSW4gQWlyIiwiQWlyIENyb3VjaCIsIn4iXSwibWFudWFsX3lhdyI6IkRpc2FibGVkIiwicHJlc2V0X2xpc3QiOjEuMCwic2FmZV9oZWFkIjp0cnVlLCJzdGF0ZV9jb25kaXRpb24iOiJTdGFuZGluZyIsInN0eWxlX2FhIjozLjB9LHsiYXNwZWN0X3JhdGlvIjp0cnVlLCJmYWtlX2xhdGVuY3kiOnRydWUsImhpdGNoYW5jZSI6ZmFsc2UsImxpc3QiOjEuMCwibG9ncyI6ZmFsc2UsIm92ZXJyaWRlX2luZGljYXRvciI6dHJ1ZSwicGVyZm9ybWFuY2VfbW9kZSI6dHJ1ZSwicmFnZWJvdF9sb2dpYyI6ZmFsc2UsInNjb3BlX292ZXJsYXkiOmZhbHNlLCJ0b2dnbGVfc2V0dGluZ3MiOnRydWUsInZpZXdtb2RlbCI6ZmFsc2V9LHsiYXNwZWN0X3JhdGlvX3NsaWRlciI6MTMzLjAsImJhaW1fbG9naWMiOmZhbHNlLCJjbG9zZV9haW1ib3QiOmZhbHNlLCJkZWZlbnNpdmVfdHlwZSI6IkFsd2F5cyBPbiIsImRpc2FibGUiOmZhbHNlLCJkaXNhYmxlX3RwIjpbIn4iXSwiZG9ybWFudF9sb2dpYyI6ZmFsc2UsImZha2VfbGF0ZW5jeV9hbW91bnQiOjIwMC4wLCJoaXRfY29sb3IiOiIjNjhFQzU2RkYiLCJoaXRjaGFuY2VfaW5fYWlyIjozNS4wLCJsb2dzX2V2ZW50cyI6WyJBaW1ib3QiLCJ+Il0sImxvZ3Nfb3B0aW9uIjpbIkNvbnNvbGUiLCJTY3JlZW4iLCJ+Il0sIm1pc3NfY29sb3IiOiIjRUM1NjU2RkYiLCJvcHRpbWlzZV9tb2RlIjoiTG93Iiwib3ZlcnJpZGVfaW5kaWNhdG9yX2NvbG9yIjoiI0ZGRkZGRkZGIiwib3ZlcnJpZGVfaW5kaWNhdG9yX2ZvbnQiOjEuMCwib3ZlcnJpZGVfaW5kaWNhdG9yX29wdGlvbnMiOlsiRGFtYWdlIiwifiJdLCJzY29wZV9jb2xvciI6IiNGRkZGRkY3NiIsInNjb3BlX2dhcCI6NS4wLCJzY29wZV9pbnZlcnRlZCI6ZmFsc2UsInNjb3BlX3NpemUiOjc1LjAsInRlbGVwb3J0X3dlYXBvbiI6WyJ+Il0sInZpZXdtb2RlbF9mb3YiOjY4MC4wLCJ2aWV3bW9kZWxfeG9mZiI6MjUuMCwidmlld21vZGVsX3lvZmYiOjAuMCwidmlld21vZGVsX3pvZmYiOi0xNS4wfSx7ImNvbmRpdGlvbl9idWlsZGVyIjpbeyJieWF3IjpmYWxzZSwiZGVsYXlfcmFuZG9tIjowLjAsImRlbGF5X3RpY2tzIjoxMC4wLCJlbmFibGUiOmZhbHNlLCJmYWtlX3JhbmRvbSI6MS4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjAuMCwibGVmdF9vZmZzZXQiOjAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0IjowLjAsInJpZ2h0X29mZnNldCI6MC4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJkZWxheV9yYW5kb20iOjAuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMjUuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjQwLjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiNS1XYXkiLCJ5YXdtb2Rfb2ZmIjoyMC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiZGVsYXlfcmFuZG9tIjowLjAsImRlbGF5X3RpY2tzIjoxMC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxMi4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMTguMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjQ0LjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjoyMC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiZGVsYXlfcmFuZG9tIjowLjAsImRlbGF5X3RpY2tzIjoxMC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxMC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMjMuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjQ3LjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjoyMC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiZGVsYXlfcmFuZG9tIjowLjAsImRlbGF5X3RpY2tzIjo2LjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo1NC4wLCJsZWZ0X29mZnNldCI6LTI2LjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6NTQuMCwicmlnaHRfb2Zmc2V0Ijo0Ni4wLCJ5YXciOiJEZWxheWVkIFN3aXRjaCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiZGVsYXlfcmFuZG9tIjowLjAsImRlbGF5X3RpY2tzIjo1LjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjExLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0xOS4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6NDMuMCwieWF3IjoiRGVsYXllZCBTd2l0Y2giLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6MTAuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MTEuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTI0LjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0Ijo0MC4wLCJ5YXciOiJEZWxheWVkIFN3aXRjaCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiZGVsYXlfcmFuZG9tIjowLjAsImRlbGF5X3RpY2tzIjoxNC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxMS4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMjAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjQ1LjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH1dLCJkZWZlbnNpdmVfYnVpbGRlciI6W3siY19waXRjaCI6MC4wLCJlbmFibGUiOnRydWUsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjotMjQuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In1dfV0=" -- Continue your encoded string here

       local encoded_data = "W3siYW5pbXMiOlsiU3RhdGljIGxlZ3MgaW4gQWlyIiwiSml0dGVyIExlZ3MiLCJ+Il0sImF1dG9fdHAiOmZhbHNlLCJhdm9pZF9iYWNrc3RhYiI6ZmFsc2UsImVuYWJsZV9hYSI6dHJ1ZSwiZm9yY2VfZGVmZW5zaXZlIjpbIlNsb3dtb2RlIiwiSW4gQWlyIiwiQWlyIENyb3VjaCIsIn4iXSwiZnNfZGlzYWJsZXJzIjpbIkNyb3VjaCBNb3ZlIiwiSW4gQWlyIiwiQWlyIENyb3VjaCIsIn4iXSwibWFudWFsX3lhdyI6IkRpc2FibGVkIiwicHJlc2V0X2xpc3QiOjEuMCwic2FmZV9oZWFkIjp0cnVlLCJzdGF0ZV9jb25kaXRpb24iOiJGYWtlbGFnIiwic3R5bGVfYWEiOjMuMH0seyJjb25kaXRpb25fYnVpbGRlciI6W3siYnlhdyI6dHJ1ZSwiY29zaW5lX3NwZWVkX21hbmkiOjAuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjowLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MC4wLCJkZWxheV90aWNrcyI6MTAuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9tYW5pIjowLjAsImxlZnRfb2Zmc2V0IjotMjAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9tYW5pIjowLjAsInJpZ2h0X29mZnNldCI6NDcuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiY29zaW5lX3NwZWVkX21hbmkiOjAuMCwiZGVsYXlfbG9naWMiOiJOb3JtYWwiLCJkZWxheV9tYW5pIjowLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X21hbmkiOjAuMCwibGVmdF9vZmZzZXQiOi0yNS4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X21hbmkiOjAuMCwicmlnaHRfb2Zmc2V0Ijo0MC4wLCJ5YXciOiJEZWxheWVkIFN3aXRjaCIsInlhd21vZCI6IjUtV2F5IiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9zcGVlZF9tYW5pIjowLjAsImRlbGF5X2xvZ2ljIjoiU2luZSIsImRlbGF5X21hbmkiOjAuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjoxMi4wLCJkZWxheV90aWNrcyI6MTAuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MTIuMCwiZmxpY2tfbGVmdCI6MC4wLCJmbGlja19yaWdodCI6MC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfbWFuaSI6MC4wLCJsZWZ0X29mZnNldCI6LTMxLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfbWFuaSI6MC4wLCJyaWdodF9vZmZzZXQiOjQ4LjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjoyMC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiY29zaW5lX3NwZWVkX21hbmkiOjAuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjowLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MTIuMCwiZGVsYXlfdGlja3MiOjEwLjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEwLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X21hbmkiOjAuMCwibGVmdF9vZmZzZXQiOi0yMy4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X21hbmkiOjAuMCwicmlnaHRfb2Zmc2V0Ijo0Ny4wLCJ5YXciOiJEZWxheWVkIFN3aXRjaCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9zcGVlZF9tYW5pIjowLjAsImRlbGF5X2xvZ2ljIjoiU2luZSIsImRlbGF5X21hbmkiOjAuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjoxMi4wLCJkZWxheV90aWNrcyI6Ni4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo1NC4wLCJsZWZ0X21hbmkiOjAuMCwibGVmdF9vZmZzZXQiOi0zMC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjU0LjAsInJpZ2h0X21hbmkiOjAuMCwicmlnaHRfb2Zmc2V0Ijo0Ni4wLCJ5YXciOiJEZWxheWVkIFN3aXRjaCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiY29zaW5lX3NwZWVkX21hbmkiOjAuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjowLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MTIuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MTEuMCwiZmxpY2tfbGVmdCI6MC4wLCJmbGlja19yaWdodCI6MC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfbWFuaSI6MC4wLCJsZWZ0X29mZnNldCI6LTE5LjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfbWFuaSI6MC4wLCJyaWdodF9vZmZzZXQiOjQzLjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJjb3NpbmVfc3BlZWRfbWFuaSI6MC4wLCJkZWxheV9sb2dpYyI6IkNvc2luZSIsImRlbGF5X21hbmkiOjAuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjoxMS4wLCJkZWxheV90aWNrcyI6MTAuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MTEuMCwiZmxpY2tfbGVmdCI6MC4wLCJmbGlja19yaWdodCI6MC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfbWFuaSI6MC4wLCJsZWZ0X29mZnNldCI6LTI0LjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfbWFuaSI6MC4wLCJyaWdodF9vZmZzZXQiOjQwLjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJjb3NpbmVfc3BlZWRfbWFuaSI6MC4wLCJkZWxheV9sb2dpYyI6IlNpbmUiLCJkZWxheV9tYW5pIjowLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6OC4wLCJkZWxheV90aWNrcyI6MTQuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MTEuMCwiZmxpY2tfbGVmdCI6MC4wLCJmbGlja19yaWdodCI6MC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfbWFuaSI6MC4wLCJsZWZ0X29mZnNldCI6LTIwLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfbWFuaSI6MC4wLCJyaWdodF9vZmZzZXQiOjQ1LjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH1dLCJkZWZlbnNpdmVfYnVpbGRlciI6W3siY19waXRjaCI6MC4wLCJlbmFibGUiOnRydWUsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjotMjQuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In1dfV0=" -- Continue your encoded string here

local decoded_data = base64.decode(encoded_data)  
local config_data = json.parse(decoded_data)  

aa_cfg:load(config_data)

cvar.play:call("ambient\\tones\\elev1")
end

cfg_system.load_preset_config_6 = function()
    notify_label:name(" \a928491FF\f<check>    \aDBDBDBFFdefast delay Preset succesfully loaded.")
    notify_label_timer:start()
    notify_label:visibility(true)
    
-- real_ all_cfg   local encoded_data = "W3siYW5pbXMiOlsiU3RhdGljIGxlZ3MgaW4gQWlyIiwifiJdLCJhdXRvX3RwIjpmYWxzZSwiYXZvaWRfYmFja3N0YWIiOmZhbHNlLCJlbmFibGVfYWEiOnRydWUsImZvcmNlX2RlZmVuc2l2ZSI6WyJTbG93bW9kZSIsIkluIEFpciIsIkFpciBDcm91Y2giLCJ+Il0sImZzX2Rpc2FibGVycyI6WyJDcm91Y2ggTW92ZSIsIkluIEFpciIsIkFpciBDcm91Y2giLCJ+Il0sIm1hbnVhbF95YXciOiJEaXNhYmxlZCIsInByZXNldF9saXN0IjoxLjAsInNhZmVfaGVhZCI6dHJ1ZSwic3RhdGVfY29uZGl0aW9uIjoiU3RhbmRpbmciLCJzdHlsZV9hYSI6My4wfSx7ImFzcGVjdF9yYXRpbyI6dHJ1ZSwiZmFrZV9sYXRlbmN5Ijp0cnVlLCJoaXRjaGFuY2UiOmZhbHNlLCJsaXN0IjoxLjAsImxvZ3MiOmZhbHNlLCJvdmVycmlkZV9pbmRpY2F0b3IiOnRydWUsInBlcmZvcm1hbmNlX21vZGUiOnRydWUsInJhZ2Vib3RfbG9naWMiOmZhbHNlLCJzY29wZV9vdmVybGF5IjpmYWxzZSwidG9nZ2xlX3NldHRpbmdzIjp0cnVlLCJ2aWV3bW9kZWwiOmZhbHNlfSx7ImFzcGVjdF9yYXRpb19zbGlkZXIiOjEzMy4wLCJiYWltX2xvZ2ljIjpmYWxzZSwiY2xvc2VfYWltYm90IjpmYWxzZSwiZGVmZW5zaXZlX3R5cGUiOiJBbHdheXMgT24iLCJkaXNhYmxlIjpmYWxzZSwiZGlzYWJsZV90cCI6WyJ+Il0sImRvcm1hbnRfbG9naWMiOmZhbHNlLCJmYWtlX2xhdGVuY3lfYW1vdW50IjoyMDAuMCwiaGl0X2NvbG9yIjoiIzY4RUM1NkZGIiwiaGl0Y2hhbmNlX2luX2FpciI6MzUuMCwibG9nc19ldmVudHMiOlsiQWltYm90IiwifiJdLCJsb2dzX29wdGlvbiI6WyJDb25zb2xlIiwiU2NyZWVuIiwifiJdLCJtaXNzX2NvbG9yIjoiI0VDNTY1NkZGIiwib3B0aW1pc2VfbW9kZSI6IkxvdyIsIm92ZXJyaWRlX2luZGljYXRvcl9jb2xvciI6IiNGRkZGRkZGRiIsIm92ZXJyaWRlX2luZGljYXRvcl9mb250IjoxLjAsIm92ZXJyaWRlX2luZGljYXRvcl9vcHRpb25zIjpbIkRhbWFnZSIsIn4iXSwic2NvcGVfY29sb3IiOiIjRkZGRkZGNzYiLCJzY29wZV9nYXAiOjUuMCwic2NvcGVfaW52ZXJ0ZWQiOmZhbHNlLCJzY29wZV9zaXplIjo3NS4wLCJ0ZWxlcG9ydF93ZWFwb24iOlsifiJdLCJ2aWV3bW9kZWxfZm92Ijo2ODAuMCwidmlld21vZGVsX3hvZmYiOjI1LjAsInZpZXdtb2RlbF95b2ZmIjowLjAsInZpZXdtb2RlbF96b2ZmIjotMTUuMH0seyJjb25kaXRpb25fYnVpbGRlciI6W3siYnlhdyI6ZmFsc2UsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6MTAuMCwiZW5hYmxlIjpmYWxzZSwiZmFrZV9yYW5kb20iOjEuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0IjowLjAsImxlZnRfb2Zmc2V0IjowLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6MC4wLCJyaWdodF9vZmZzZXQiOjAuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiZGVsYXlfcmFuZG9tIjowLjAsImRlbGF5X3RpY2tzIjo1LjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTI1LjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0Ijo0MC4wLCJ5YXciOiJEZWxheWVkIFN3aXRjaCIsInlhd21vZCI6IjUtV2F5IiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0zMC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6NDAuMCwieWF3IjoiRGVsYXllZCBTd2l0Y2giLCJ5YXdtb2QiOiI1LVdheSIsInlhd21vZF9vZmYiOjIwLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJkZWxheV9yYW5kb20iOjAuMCwiZGVsYXlfdGlja3MiOjEwLjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEwLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0zMC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6NDAuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IjUtV2F5IiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NTQuMCwibGVmdF9vZmZzZXQiOi0yNi4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjU0LjAsInJpZ2h0X29mZnNldCI6NDYuMCwieWF3IjoiRGVsYXllZCBTd2l0Y2giLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0xNy4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6NDMuMCwieWF3IjoiRGVsYXllZCBTd2l0Y2giLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6OC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxMC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMjYuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjM4LjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJkZWxheV9yYW5kb20iOjAuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMjAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjQzLjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH1dLCJkZWZlbnNpdmVfYnVpbGRlciI6W3siY19waXRjaCI6MC4wLCJlbmFibGUiOnRydWUsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOnRydWUsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6dHJ1ZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJTd2l0Y2giLCJ3MV9waXRjaCI6ODUuMCwidzJfcGl0Y2giOjg5LjAsInlhdyI6IkRlZmF1bHQifV19XQ==" -- Continue your encoded string here
local encoded_data = "W3siYW5pbXMiOlsiU3RhdGljIGxlZ3MgaW4gQWlyIiwifiJdLCJhdXRvX3RwIjpmYWxzZSwiYXZvaWRfYmFja3N0YWIiOmZhbHNlLCJlbmFibGVfYWEiOnRydWUsImZvcmNlX2RlZmVuc2l2ZSI6WyJTbG93bW9kZSIsIkluIEFpciIsIkFpciBDcm91Y2giLCJ+Il0sImZzX2Rpc2FibGVycyI6WyJDcm91Y2ggTW92ZSIsIkluIEFpciIsIkFpciBDcm91Y2giLCJ+Il0sIm1hbnVhbF95YXciOiJEaXNhYmxlZCIsInByZXNldF9saXN0IjoxLjAsInNhZmVfaGVhZCI6dHJ1ZSwic3RhdGVfY29uZGl0aW9uIjoiRmFrZWxhZyIsInN0eWxlX2FhIjozLjB9LHsiY29uZGl0aW9uX2J1aWxkZXIiOlt7ImJ5YXciOnRydWUsImNvc2luZV9zcGVlZF9tYW5pIjowLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6MC4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjAuMCwiZGVsYXlfdGlja3MiOjEwLjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEuMCwiZmxpY2tfbGVmdCI6MC4wLCJmbGlja19yaWdodCI6MC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfbWFuaSI6MC4wLCJsZWZ0X29mZnNldCI6LTE5LjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfbWFuaSI6MC4wLCJyaWdodF9vZmZzZXQiOjQ0LjAsInlhdyI6IkxlZnQvUmlnaHQiLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9zcGVlZF9tYW5pIjowLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6MC4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjEyLjAsImRlbGF5X3RpY2tzIjo1LjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEuMCwiZmxpY2tfbGVmdCI6MC4wLCJmbGlja19yaWdodCI6MC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfbWFuaSI6MC4wLCJsZWZ0X29mZnNldCI6LTI1LjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfbWFuaSI6MC4wLCJyaWdodF9vZmZzZXQiOjQwLjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjoyMC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiY29zaW5lX3NwZWVkX21hbmkiOjAuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjowLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MTYuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9tYW5pIjowLjAsImxlZnRfb2Zmc2V0IjotMzAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9tYW5pIjowLjAsInJpZ2h0X29mZnNldCI6NDAuMCwieWF3IjoiRGVsYXllZCBTd2l0Y2giLCJ5YXdtb2QiOiI1LVdheSIsInlhd21vZF9vZmYiOjIwLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJjb3NpbmVfc3BlZWRfbWFuaSI6MC4wLCJkZWxheV9sb2dpYyI6IkNvc2luZSIsImRlbGF5X21hbmkiOjAuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjowLjAsImRlbGF5X3RpY2tzIjoxMC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxMC4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9tYW5pIjowLjAsImxlZnRfb2Zmc2V0IjotMzAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9tYW5pIjowLjAsInJpZ2h0X29mZnNldCI6NDAuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IjUtV2F5IiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9zcGVlZF9tYW5pIjowLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6MC4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjE2LjAsImRlbGF5X3RpY2tzIjo1LjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEuMCwiZmxpY2tfbGVmdCI6MC4wLCJmbGlja19yaWdodCI6MC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjU0LjAsImxlZnRfbWFuaSI6MC4wLCJsZWZ0X29mZnNldCI6LTI2LjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6NTQuMCwicmlnaHRfbWFuaSI6MC4wLCJyaWdodF9vZmZzZXQiOjQ2LjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJjb3NpbmVfc3BlZWRfbWFuaSI6MC4wLCJkZWxheV9sb2dpYyI6IkNvc2luZSIsImRlbGF5X21hbmkiOjAuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjoxNi4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X21hbmkiOjAuMCwibGVmdF9vZmZzZXQiOi0xNy4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X21hbmkiOjAuMCwicmlnaHRfb2Zmc2V0Ijo0My4wLCJ5YXciOiJEZWxheWVkIFN3aXRjaCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiY29zaW5lX3NwZWVkX21hbmkiOjAuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjowLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MTYuMCwiZGVsYXlfdGlja3MiOjguMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MTAuMCwiZmxpY2tfbGVmdCI6MC4wLCJmbGlja19yaWdodCI6MC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfbWFuaSI6MC4wLCJsZWZ0X29mZnNldCI6LTI2LjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfbWFuaSI6MC4wLCJyaWdodF9vZmZzZXQiOjM4LjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJjb3NpbmVfc3BlZWRfbWFuaSI6MC4wLCJkZWxheV9sb2dpYyI6IlNpbmUiLCJkZWxheV9tYW5pIjowLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MTQuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9tYW5pIjowLjAsImxlZnRfb2Zmc2V0IjotMjAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9tYW5pIjowLjAsInJpZ2h0X29mZnNldCI6NDMuMCwieWF3IjoiRGVsYXllZCBTd2l0Y2giLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfV0sImRlZmVuc2l2ZV9idWlsZGVyIjpbeyJjX3BpdGNoIjowLjAsImVuYWJsZSI6dHJ1ZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJTd2l0Y2giLCJ3MV9waXRjaCI6ODUuMCwidzJfcGl0Y2giOjg5LjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In1dfV0=" -- Continue your encoded string here

local decoded_data = base64.decode(encoded_data)  
local config_data = json.parse(decoded_data)  

aa_cfg:load(config_data)

cvar.play:call("ambient\\tones\\elev1")
end

    cfg_system.load_preset_config_7 = function()
        notify_label:name(" \a928491FF\f<check>    \aDBDBDBFFmanipulation Preset succesfully loaded.")
        notify_label_timer:start()
        notify_label:visibility(true)
        
    -- all_cfg local encoded_data = "W3siYW5pbXMiOlsiU3RhdGljIGxlZ3MgaW4gQWlyIiwifiJdLCJhdXRvX3RwIjpmYWxzZSwiYXZvaWRfYmFja3N0YWIiOmZhbHNlLCJlbmFibGVfYWEiOnRydWUsImZvcmNlX2RlZmVuc2l2ZSI6WyJDcm91Y2hpbmciLCJDcm91Y2ggTW92ZSIsIn4iXSwiZnNfZGlzYWJsZXJzIjpbIkNyb3VjaCBNb3ZlIiwiSW4gQWlyIiwiQWlyIENyb3VjaCIsIn4iXSwibWFudWFsX3lhdyI6IkRpc2FibGVkIiwicHJlc2V0X2xpc3QiOjEuMCwic2FmZV9oZWFkIjp0cnVlLCJzdGF0ZV9jb25kaXRpb24iOiJTdGFuZGluZyIsInN0eWxlX2FhIjozLjB9LHsiYXNwZWN0X3JhdGlvIjp0cnVlLCJmYWtlX2xhdGVuY3kiOnRydWUsImhpdGNoYW5jZSI6ZmFsc2UsImxpc3QiOjEuMCwibG9ncyI6dHJ1ZSwib3ZlcnJpZGVfaW5kaWNhdG9yIjp0cnVlLCJwZXJmb3JtYW5jZV9tb2RlIjp0cnVlLCJyYWdlYm90X2xvZ2ljIjp0cnVlLCJzY29wZV9vdmVybGF5IjpmYWxzZSwidG9nZ2xlX3NldHRpbmdzIjp0cnVlLCJ2aWV3bW9kZWwiOnRydWV9LHsiYXNwZWN0X3JhdGlvX3NsaWRlciI6MTMzLjAsImJhaW1fbG9naWMiOmZhbHNlLCJjbG9zZV9haW1ib3QiOmZhbHNlLCJkZWZlbnNpdmVfdHlwZSI6IkFsd2F5cyBPbiIsImRpc2FibGUiOmZhbHNlLCJkaXNhYmxlX3RwIjpbIn4iXSwiZG9ybWFudF9sb2dpYyI6dHJ1ZSwiZmFrZV9sYXRlbmN5X2Ftb3VudCI6MjAwLjAsImhpdF9jb2xvciI6IiM2OEVDNTZGRiIsImhpdGNoYW5jZV9pbl9haXIiOjM1LjAsImxvZ3NfZXZlbnRzIjpbIkFpbWJvdCIsIn4iXSwibG9nc19vcHRpb24iOlsiQ29uc29sZSIsIn4iXSwibWlzc19jb2xvciI6IiNFQzU2NTZGRiIsIm9wdGltaXNlX21vZGUiOiJMb3ciLCJvdmVycmlkZV9pbmRpY2F0b3JfY29sb3IiOiIjRkZGRkZGRkYiLCJvdmVycmlkZV9pbmRpY2F0b3JfZm9udCI6MS4wLCJvdmVycmlkZV9pbmRpY2F0b3Jfb3B0aW9ucyI6WyJEYW1hZ2UiLCJ+Il0sInNjb3BlX2NvbG9yIjoiI0ZGRkZGRjc2Iiwic2NvcGVfZ2FwIjo1LjAsInNjb3BlX2ludmVydGVkIjpmYWxzZSwic2NvcGVfc2l6ZSI6NzUuMCwidGVsZXBvcnRfd2VhcG9uIjpbIn4iXSwidmlld21vZGVsX2ZvdiI6NjgwLjAsInZpZXdtb2RlbF94b2ZmIjoyNS4wLCJ2aWV3bW9kZWxfeW9mZiI6MC4wLCJ2aWV3bW9kZWxfem9mZiI6LTE1LjB9LHsiY29uZGl0aW9uX2J1aWxkZXIiOlt7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOmZhbHNlLCJmYWtlX3JhbmRvbSI6MS4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMjAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjQzLjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJkZWxheV9yYW5kb20iOjAuMCwiZGVsYXlfdGlja3MiOjEwLjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6MC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6MC4wLCJ5YXciOiJTdGF0aWMiLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxMDAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6Ni4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6Ni4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiQ2VudGVyIiwieWF3bW9kX29mZiI6LTU4LjAsInlhd21vZF9yYW5kb20iOjE0LjB9LHsiYnlhdyI6dHJ1ZSwiZGVsYXlfcmFuZG9tIjowLjAsImRlbGF5X3RpY2tzIjo1LjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEwMC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMjMuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjQ3LjAsInlhdyI6IkxlZnQvUmlnaHQiLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjIwLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJkZWxheV9yYW5kb20iOjAuMCwiZGVsYXlfdGlja3MiOjguMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MTAwLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOjUuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjUuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkNlbnRlciIsInlhd21vZF9vZmYiOi0zMS4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiZGVsYXlfcmFuZG9tIjowLjAsImRlbGF5X3RpY2tzIjoxMC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxMDAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTEwLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0IjozMS4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjoyMC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiZGVsYXlfcmFuZG9tIjowLjAsImRlbGF5X3RpY2tzIjo1LjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEwMC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMTkuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjIzLjAsInlhdyI6IkxlZnQvUmlnaHQiLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxMDAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTEwLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0IjozMS4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiQ2VudGVyIiwieWF3bW9kX29mZiI6LTEwLjAsInlhd21vZF9yYW5kb20iOjcuMH1dLCJkZWZlbnNpdmVfYnVpbGRlciI6W3siY19waXRjaCI6MC4wLCJlbmFibGUiOnRydWUsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjo4NS4wLCJ3Ml9waXRjaCI6ODkuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjp0cnVlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6ODUuMCwidzJfcGl0Y2giOjg5LjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjp0cnVlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9XX1d" -- Continue your encoded string here
    local encoded_data = "W3siYW5pbXMiOlsiU3RhdGljIGxlZ3MgaW4gQWlyIiwiRm9sbG93IERpcmVjdGlvbiIsIn4iXSwiYXV0b190cCI6ZmFsc2UsImF2b2lkX2JhY2tzdGFiIjp0cnVlLCJlbmFibGVfYWEiOnRydWUsImZvcmNlX2RlZmVuc2l2ZSI6WyJTbG93bW9kZSIsIkNyb3VjaGluZyIsIkNyb3VjaCBNb3ZlIiwiSW4gQWlyIiwiQWlyIENyb3VjaCIsIn4iXSwiZnNfZGlzYWJsZXJzIjpbIkNyb3VjaCBNb3ZlIiwiSW4gQWlyIiwiQWlyIENyb3VjaCIsIn4iXSwibWFudWFsX3lhdyI6IkRpc2FibGVkIiwicHJlc2V0X2xpc3QiOjEuMCwic2FmZV9oZWFkIjp0cnVlLCJzdGF0ZV9jb25kaXRpb24iOiJTbG93bW9kZSIsInN0eWxlX2FhIjozLjB9LHsiY29uZGl0aW9uX2J1aWxkZXIiOlt7ImJ5YXciOnRydWUsImNvc2luZV9yYW5kb20iOjAuMCwiY29zaW5lX3NwZWVkX21hbmkiOjIuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjoyLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6Mi4wLCJkZWxheV90aWNrcyI6MTAuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZsaWNrX3NpbmdsZSI6MC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMTkuMCwibWFuaV9tZXRob2QiOiJTdGF0aWMiLCJtYW5pcHVsYXRpb25fcmFuZG9tIjowLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0Ijo0NC4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJjb3NpbmVfcmFuZG9tIjowLjAsImNvc2luZV9zcGVlZF9tYW5pIjoyLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6Mi4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjIuMCwiZGVsYXlfdGlja3MiOjEwLjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEuMCwiZmxpY2tfbGVmdCI6MC4wLCJmbGlja19yaWdodCI6MC4wLCJmbGlja19zaW5nbGUiOjkwLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NDIuMCwibGVmdF9vZmZzZXQiOi0yNC4wLCJtYW5pX21ldGhvZCI6IlN0YXRpYyIsIm1hbmlwdWxhdGlvbl9yYW5kb20iOjguMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo0Mi4wLCJyaWdodF9vZmZzZXQiOjQxLjAsInlhdyI6IllhdyBNYW5pcHVsYXRpb24iLCJ5YXdtb2QiOiJSYW5kb20iLCJ5YXdtb2Rfb2ZmIjo4LjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJjb3NpbmVfcmFuZG9tIjowLjAsImNvc2luZV9zcGVlZF9tYW5pIjoxNi4wLCJkZWxheV9sb2dpYyI6IkNvc2luZSIsImRlbGF5X21hbmkiOjQuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjoyLjAsImRlbGF5X3RpY2tzIjoxMC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOi05LjAsImZsaWNrX3JpZ2h0Ijo0OS4wLCJmbGlja19zaW5nbGUiOjc1LjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NDIuMCwibGVmdF9vZmZzZXQiOi0yNC4wLCJtYW5pX21ldGhvZCI6IlN0YXRpYyIsIm1hbmlwdWxhdGlvbl9yYW5kb20iOjcuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo0Mi4wLCJyaWdodF9vZmZzZXQiOjM3LjAsInlhdyI6IllhdyBNYW5pcHVsYXRpb24iLCJ5YXdtb2QiOiJSYW5kb20iLCJ5YXdtb2Rfb2ZmIjo3LjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJjb3NpbmVfcmFuZG9tIjowLjAsImNvc2luZV9zcGVlZF9tYW5pIjoyLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6Mi4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjIuMCwiZGVsYXlfdGlja3MiOjEwLjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEuMCwiZmxpY2tfbGVmdCI6MC4wLCJmbGlja19yaWdodCI6MC4wLCJmbGlja19zaW5nbGUiOjg1LjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NDIuMCwibGVmdF9vZmZzZXQiOi0yMy4wLCJtYW5pX21ldGhvZCI6IlN0YXRpYyIsIm1hbmlwdWxhdGlvbl9yYW5kb20iOjYuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo0Mi4wLCJyaWdodF9vZmZzZXQiOjQ3LjAsInlhdyI6IllhdyBNYW5pcHVsYXRpb24iLCJ5YXdtb2QiOiJSYW5kb20iLCJ5YXdtb2Rfb2ZmIjo2LjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJjb3NpbmVfcmFuZG9tIjowLjAsImNvc2luZV9zcGVlZF9tYW5pIjoyLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6Mi4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjIuMCwiZGVsYXlfdGlja3MiOjEwLjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEuMCwiZmxpY2tfbGVmdCI6MC4wLCJmbGlja19yaWdodCI6MC4wLCJmbGlja19zaW5nbGUiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTMyLjAsIm1hbmlfbWV0aG9kIjoiU3RhdGljIiwibWFuaXB1bGF0aW9uX3JhbmRvbSI6MC4wLCJvZmZzZXQiOi0xMi4wLCJvZmZzZXRfcmFuZG9tIjoxMi4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6NDYuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiY29zaW5lX3JhbmRvbSI6MC4wLCJjb3NpbmVfc3BlZWRfbWFuaSI6Mi4wLCJkZWxheV9sb2dpYyI6IkNvc2luZSIsImRlbGF5X21hbmkiOjIuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjoyLjAsImRlbGF5X3RpY2tzIjoxMC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZmxpY2tfc2luZ2xlIjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0yMi4wLCJtYW5pX21ldGhvZCI6IlN0YXRpYyIsIm1hbmlwdWxhdGlvbl9yYW5kb20iOjAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjQ0LjAsInlhdyI6IkxlZnQvUmlnaHQiLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9yYW5kb20iOjAuMCwiY29zaW5lX3NwZWVkX21hbmkiOjE1LjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6NS4wLCJkZWxheV9tYW5pX21ldG9kIjoiU2luZSIsImRlbGF5X3NwZWVkIjoyLjAsImRlbGF5X3RpY2tzIjoxMC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOi05LjAsImZsaWNrX3JpZ2h0Ijo0Mi4wLCJmbGlja19zaW5nbGUiOjcwLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NDIuMCwibGVmdF9vZmZzZXQiOi0yOS4wLCJtYW5pX21ldGhvZCI6IlN0YXRpYyIsIm1hbmlwdWxhdGlvbl9yYW5kb20iOjguMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo0Mi4wLCJyaWdodF9vZmZzZXQiOjM1LjAsInlhdyI6IllhdyBNYW5pcHVsYXRpb24iLCJ5YXdtb2QiOiJSYW5kb20iLCJ5YXdtb2Rfb2ZmIjo4LjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJjb3NpbmVfcmFuZG9tIjowLjAsImNvc2luZV9zcGVlZF9tYW5pIjoxNS4wLCJkZWxheV9sb2dpYyI6IkNvc2luZSIsImRlbGF5X21hbmkiOjUuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjoyLjAsImRlbGF5X3RpY2tzIjoxMC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOi02LjAsImZsaWNrX3JpZ2h0Ijo1NS4wLCJmbGlja19zaW5nbGUiOjgwLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NDIuMCwibGVmdF9vZmZzZXQiOi0xOC4wLCJtYW5pX21ldGhvZCI6IlN0YXRpYyIsIm1hbmlwdWxhdGlvbl9yYW5kb20iOjUuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo0Mi4wLCJyaWdodF9vZmZzZXQiOjQ0LjAsInlhdyI6IllhdyBNYW5pcHVsYXRpb24iLCJ5YXdtb2QiOiJSYW5kb20iLCJ5YXdtb2Rfb2ZmIjo1LjAsInlhd21vZF9yYW5kb20iOjAuMH1dLCJkZWZlbnNpdmVfYnVpbGRlciI6W3siY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJOb25lIn0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6Ik5vbmUifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiTm9uZSJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOnRydWUsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjp0cnVlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6dHJ1ZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6Ik5vbmUifV19XQ==" -- Continue your encoded string here

    local decoded_data = base64.decode(encoded_data)  
    local config_data = json.parse(decoded_data)  

    aa_cfg:load(config_data)

    cvar.play:call("ambient\\tones\\elev1")
    end

    cfg_system.load_preset_config_8 = function()
        notify_label:name(" \a928491FF\f<check>    \aDBDBDBFFmanipulation Preset succesfully loaded.")
        notify_label_timer:start()
        notify_label:visibility(true)
        
    -- all_cfg local encoded_data = "W3siYW5pbXMiOlsiU3RhdGljIGxlZ3MgaW4gQWlyIiwifiJdLCJhdXRvX3RwIjpmYWxzZSwiYXZvaWRfYmFja3N0YWIiOmZhbHNlLCJlbmFibGVfYWEiOnRydWUsImZvcmNlX2RlZmVuc2l2ZSI6WyJDcm91Y2hpbmciLCJDcm91Y2ggTW92ZSIsIn4iXSwiZnNfZGlzYWJsZXJzIjpbIkNyb3VjaCBNb3ZlIiwiSW4gQWlyIiwiQWlyIENyb3VjaCIsIn4iXSwibWFudWFsX3lhdyI6IkRpc2FibGVkIiwicHJlc2V0X2xpc3QiOjEuMCwic2FmZV9oZWFkIjp0cnVlLCJzdGF0ZV9jb25kaXRpb24iOiJTdGFuZGluZyIsInN0eWxlX2FhIjozLjB9LHsiYXNwZWN0X3JhdGlvIjp0cnVlLCJmYWtlX2xhdGVuY3kiOnRydWUsImhpdGNoYW5jZSI6ZmFsc2UsImxpc3QiOjEuMCwibG9ncyI6dHJ1ZSwib3ZlcnJpZGVfaW5kaWNhdG9yIjp0cnVlLCJwZXJmb3JtYW5jZV9tb2RlIjp0cnVlLCJyYWdlYm90X2xvZ2ljIjp0cnVlLCJzY29wZV9vdmVybGF5IjpmYWxzZSwidG9nZ2xlX3NldHRpbmdzIjp0cnVlLCJ2aWV3bW9kZWwiOnRydWV9LHsiYXNwZWN0X3JhdGlvX3NsaWRlciI6MTMzLjAsImJhaW1fbG9naWMiOmZhbHNlLCJjbG9zZV9haW1ib3QiOmZhbHNlLCJkZWZlbnNpdmVfdHlwZSI6IkFsd2F5cyBPbiIsImRpc2FibGUiOmZhbHNlLCJkaXNhYmxlX3RwIjpbIn4iXSwiZG9ybWFudF9sb2dpYyI6dHJ1ZSwiZmFrZV9sYXRlbmN5X2Ftb3VudCI6MjAwLjAsImhpdF9jb2xvciI6IiM2OEVDNTZGRiIsImhpdGNoYW5jZV9pbl9haXIiOjM1LjAsImxvZ3NfZXZlbnRzIjpbIkFpbWJvdCIsIn4iXSwibG9nc19vcHRpb24iOlsiQ29uc29sZSIsIn4iXSwibWlzc19jb2xvciI6IiNFQzU2NTZGRiIsIm9wdGltaXNlX21vZGUiOiJMb3ciLCJvdmVycmlkZV9pbmRpY2F0b3JfY29sb3IiOiIjRkZGRkZGRkYiLCJvdmVycmlkZV9pbmRpY2F0b3JfZm9udCI6MS4wLCJvdmVycmlkZV9pbmRpY2F0b3Jfb3B0aW9ucyI6WyJEYW1hZ2UiLCJ+Il0sInNjb3BlX2NvbG9yIjoiI0ZGRkZGRjc2Iiwic2NvcGVfZ2FwIjo1LjAsInNjb3BlX2ludmVydGVkIjpmYWxzZSwic2NvcGVfc2l6ZSI6NzUuMCwidGVsZXBvcnRfd2VhcG9uIjpbIn4iXSwidmlld21vZGVsX2ZvdiI6NjgwLjAsInZpZXdtb2RlbF94b2ZmIjoyNS4wLCJ2aWV3bW9kZWxfeW9mZiI6MC4wLCJ2aWV3bW9kZWxfem9mZiI6LTE1LjB9LHsiY29uZGl0aW9uX2J1aWxkZXIiOlt7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOmZhbHNlLCJmYWtlX3JhbmRvbSI6MS4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMjAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjQzLjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJkZWxheV9yYW5kb20iOjAuMCwiZGVsYXlfdGlja3MiOjEwLjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6MC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6MC4wLCJ5YXciOiJTdGF0aWMiLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxMDAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6Ni4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6Ni4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiQ2VudGVyIiwieWF3bW9kX29mZiI6LTU4LjAsInlhd21vZF9yYW5kb20iOjE0LjB9LHsiYnlhdyI6dHJ1ZSwiZGVsYXlfcmFuZG9tIjowLjAsImRlbGF5X3RpY2tzIjo1LjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEwMC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMjMuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjQ3LjAsInlhdyI6IkxlZnQvUmlnaHQiLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjIwLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJkZWxheV9yYW5kb20iOjAuMCwiZGVsYXlfdGlja3MiOjguMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MTAwLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOjUuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjUuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IkNlbnRlciIsInlhd21vZF9vZmYiOi0zMS4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiZGVsYXlfcmFuZG9tIjowLjAsImRlbGF5X3RpY2tzIjoxMC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxMDAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTEwLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0IjozMS4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjoyMC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiZGVsYXlfcmFuZG9tIjowLjAsImRlbGF5X3RpY2tzIjo1LjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEwMC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMTkuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjIzLjAsInlhdyI6IkxlZnQvUmlnaHQiLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImRlbGF5X3JhbmRvbSI6MC4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxMDAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTEwLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0IjozMS4wLCJ5YXciOiJMZWZ0L1JpZ2h0IiwieWF3bW9kIjoiQ2VudGVyIiwieWF3bW9kX29mZiI6LTEwLjAsInlhd21vZF9yYW5kb20iOjcuMH1dLCJkZWZlbnNpdmVfYnVpbGRlciI6W3siY19waXRjaCI6MC4wLCJlbmFibGUiOnRydWUsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjo4NS4wLCJ3Ml9waXRjaCI6ODkuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjp0cnVlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6ODUuMCwidzJfcGl0Y2giOjg5LjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjp0cnVlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9XX1d" -- Continue your encoded string here
    local encoded_data = "W3siYW5pbXMiOlsiU3RhdGljIGxlZ3MgaW4gQWlyIiwifiJdLCJhdXRvX3RwIjpmYWxzZSwiYXZvaWRfYmFja3N0YWIiOmZhbHNlLCJlbmFibGVfYWEiOnRydWUsImZvcmNlX2RlZmVuc2l2ZSI6WyJTbG93bW9kZSIsIkluIEFpciIsIkFpciBDcm91Y2giLCJ+Il0sImZzX2Rpc2FibGVycyI6WyJDcm91Y2ggTW92ZSIsIkluIEFpciIsIkFpciBDcm91Y2giLCJ+Il0sIm1hbnVhbF95YXciOiJEaXNhYmxlZCIsInByZXNldF9saXN0IjoxLjAsInNhZmVfaGVhZCI6dHJ1ZSwic3RhdGVfY29uZGl0aW9uIjoiQ3JvdWNoaW5nIiwic3R5bGVfYWEiOjMuMH0seyJjb25kaXRpb25fYnVpbGRlciI6W3siYnlhdyI6dHJ1ZSwiY29zaW5lX3JhbmRvbSI6MC4wLCJjb3NpbmVfc3BlZWRfbWFuaSI6Mi4wLCJkZWxheV9sb2dpYyI6IkNvc2luZSIsImRlbGF5X21hbmkiOjIuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjoyLjAsImRlbGF5X3RpY2tzIjoxMC4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZmxpY2tfc2luZ2xlIjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0xOS4wLCJtYW5pX21ldGhvZCI6IlN0YXRpYyIsIm1hbmlwdWxhdGlvbl9yYW5kb20iOjAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJKaXR0ZXIiLCJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjQ0LjAsInlhdyI6IkxlZnQvUmlnaHQiLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9yYW5kb20iOjAuMCwiY29zaW5lX3NwZWVkX21hbmkiOjIuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjoyLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MTIuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZsaWNrX3NpbmdsZSI6MC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMjUuMCwibWFuaV9tZXRob2QiOiJTdGF0aWMiLCJtYW5pcHVsYXRpb25fcmFuZG9tIjowLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0Ijo0MC4wLCJ5YXciOiJEZWxheWVkIFN3aXRjaCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9yYW5kb20iOjAuMCwiY29zaW5lX3NwZWVkX21hbmkiOjIuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjoyLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MTYuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZsaWNrX3NpbmdsZSI6MC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjYwLjAsImxlZnRfb2Zmc2V0IjotMzAuMCwibWFuaV9tZXRob2QiOiJTdGF0aWMiLCJtYW5pcHVsYXRpb25fcmFuZG9tIjowLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsiSml0dGVyIiwifiJdLCJyaWdodF9saW1pdCI6NjAuMCwicmlnaHRfb2Zmc2V0Ijo0MC4wLCJ5YXciOiJEZWxheWVkIFN3aXRjaCIsInlhd21vZCI6IjUtV2F5IiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9yYW5kb20iOjAuMCwiY29zaW5lX3NwZWVkX21hbmkiOjIuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjoyLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6Mi4wLCJkZWxheV90aWNrcyI6MTAuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MTAuMCwiZmxpY2tfbGVmdCI6MC4wLCJmbGlja19yaWdodCI6MC4wLCJmbGlja19zaW5nbGUiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTMwLjAsIm1hbmlfbWV0aG9kIjoiU3RhdGljIiwibWFuaXB1bGF0aW9uX3JhbmRvbSI6MC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIkppdHRlciIsIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6NDAuMCwieWF3IjoiTGVmdC9SaWdodCIsInlhd21vZCI6IjUtV2F5IiwieWF3bW9kX29mZiI6MjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfSx7ImJ5YXciOnRydWUsImNvc2luZV9yYW5kb20iOjAuMCwiY29zaW5lX3NwZWVkX21hbmkiOjIuMCwiZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJkZWxheV9tYW5pIjoyLjAsImRlbGF5X21hbmlfbWV0b2QiOiJDb3NpbmUiLCJkZWxheV9zcGVlZCI6MTYuMCwiZGVsYXlfdGlja3MiOjUuMCwiZW5hYmxlIjp0cnVlLCJmYWtlX3JhbmRvbSI6MS4wLCJmbGlja19sZWZ0IjowLjAsImZsaWNrX3JpZ2h0IjowLjAsImZsaWNrX3NpbmdsZSI6MC4wLCJmcyI6Ik9mZiIsImxlZnRfbGltaXQiOjU0LjAsImxlZnRfb2Zmc2V0IjotMjYuMCwibWFuaV9tZXRob2QiOiJTdGF0aWMiLCJtYW5pcHVsYXRpb25fcmFuZG9tIjowLjAsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsIm9wdGlvbnMiOlsifiJdLCJyaWdodF9saW1pdCI6NTQuMCwicmlnaHRfb2Zmc2V0Ijo0Ni4wLCJ5YXciOiJEZWxheWVkIFN3aXRjaCIsInlhd21vZCI6IkRpc2FibGVkIiwieWF3bW9kX29mZiI6MC4wLCJ5YXdtb2RfcmFuZG9tIjowLjB9LHsiYnlhdyI6dHJ1ZSwiY29zaW5lX3JhbmRvbSI6MC4wLCJjb3NpbmVfc3BlZWRfbWFuaSI6Mi4wLCJkZWxheV9sb2dpYyI6IkNvc2luZSIsImRlbGF5X21hbmkiOjIuMCwiZGVsYXlfbWFuaV9tZXRvZCI6IkNvc2luZSIsImRlbGF5X3NwZWVkIjoxNi4wLCJkZWxheV90aWNrcyI6NS4wLCJlbmFibGUiOnRydWUsImZha2VfcmFuZG9tIjoxLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZmxpY2tfc2luZ2xlIjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0xNy4wLCJtYW5pX21ldGhvZCI6IlN0YXRpYyIsIm1hbmlwdWxhdGlvbl9yYW5kb20iOjAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjQzLjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJjb3NpbmVfcmFuZG9tIjowLjAsImNvc2luZV9zcGVlZF9tYW5pIjoyLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6Mi4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjE2LjAsImRlbGF5X3RpY2tzIjo4LjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEwLjAsImZsaWNrX2xlZnQiOjAuMCwiZmxpY2tfcmlnaHQiOjAuMCwiZmxpY2tfc2luZ2xlIjowLjAsImZzIjoiT2ZmIiwibGVmdF9saW1pdCI6NjAuMCwibGVmdF9vZmZzZXQiOi0yNi4wLCJtYW5pX21ldGhvZCI6IlN0YXRpYyIsIm1hbmlwdWxhdGlvbl9yYW5kb20iOjAuMCwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwib3B0aW9ucyI6WyJ+Il0sInJpZ2h0X2xpbWl0Ijo2MC4wLCJyaWdodF9vZmZzZXQiOjM4LjAsInlhdyI6IkRlbGF5ZWQgU3dpdGNoIiwieWF3bW9kIjoiRGlzYWJsZWQiLCJ5YXdtb2Rfb2ZmIjowLjAsInlhd21vZF9yYW5kb20iOjAuMH0seyJieWF3Ijp0cnVlLCJjb3NpbmVfcmFuZG9tIjowLjAsImNvc2luZV9zcGVlZF9tYW5pIjoyLjAsImRlbGF5X2xvZ2ljIjoiQ29zaW5lIiwiZGVsYXlfbWFuaSI6Mi4wLCJkZWxheV9tYW5pX21ldG9kIjoiQ29zaW5lIiwiZGVsYXlfc3BlZWQiOjE0LjAsImRlbGF5X3RpY2tzIjo1LjAsImVuYWJsZSI6dHJ1ZSwiZmFrZV9yYW5kb20iOjEuMCwiZmxpY2tfbGVmdCI6MC4wLCJmbGlja19yaWdodCI6MC4wLCJmbGlja19zaW5nbGUiOjAuMCwiZnMiOiJPZmYiLCJsZWZ0X2xpbWl0Ijo2MC4wLCJsZWZ0X29mZnNldCI6LTIwLjAsIm1hbmlfbWV0aG9kIjoiU3RhdGljIiwibWFuaXB1bGF0aW9uX3JhbmRvbSI6MC4wLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJvcHRpb25zIjpbIn4iXSwicmlnaHRfbGltaXQiOjYwLjAsInJpZ2h0X29mZnNldCI6NDMuMCwieWF3IjoiRGVsYXllZCBTd2l0Y2giLCJ5YXdtb2QiOiJEaXNhYmxlZCIsInlhd21vZF9vZmYiOjAuMCwieWF3bW9kX3JhbmRvbSI6MC4wfV0sImRlZmVuc2l2ZV9idWlsZGVyIjpbeyJjX3BpdGNoIjowLjAsImVuYWJsZSI6dHJ1ZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJTd2l0Y2giLCJ3MV9waXRjaCI6ODUuMCwidzJfcGl0Y2giOjg5LjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiRG93biIsIncxX3BpdGNoIjowLjAsIncyX3BpdGNoIjowLjAsInlhdyI6IkRlZmF1bHQifSx7ImNfcGl0Y2giOjAuMCwiZW5hYmxlIjpmYWxzZSwib2Zmc2V0IjowLjAsIm9mZnNldF9yYW5kb20iOjAuMCwicGl0Y2giOiJEb3duIiwidzFfcGl0Y2giOjAuMCwidzJfcGl0Y2giOjAuMCwieWF3IjoiRGVmYXVsdCJ9LHsiY19waXRjaCI6MC4wLCJlbmFibGUiOmZhbHNlLCJvZmZzZXQiOjAuMCwib2Zmc2V0X3JhbmRvbSI6MC4wLCJwaXRjaCI6IkRvd24iLCJ3MV9waXRjaCI6MC4wLCJ3Ml9waXRjaCI6MC4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In0seyJjX3BpdGNoIjowLjAsImVuYWJsZSI6ZmFsc2UsIm9mZnNldCI6MC4wLCJvZmZzZXRfcmFuZG9tIjowLjAsInBpdGNoIjoiU3dpdGNoIiwidzFfcGl0Y2giOjg1LjAsIncyX3BpdGNoIjo4OS4wLCJ5YXciOiJEZWZhdWx0In1dfV0=" -- Continue your encoded string here
    local brute_encoded_data = "W3siYW50aWJydXRlX2J1aWxkZXIiOlt7ImN1c3RvbV9waGFzZXMiOjEuMCwiZW5hYmxlIjpmYWxzZSwicDFfY29zaW5lX3JhbmRvbSI6MTAwLjAsInAxX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDFfZGVsYXlfc3BlZWQiOjIwLjAsInAxX2RlbGF5X3RpY2tzIjoyMC4wLCJwMV9sZWZ0X29mZnNldCI6MTMwLjAsInAxX29mZnNldCI6MjIuMCwicDFfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDFfeWF3IjoiU3RhdGljIiwicDFfeWF3bW9kIjoiQ2VudGVyIiwicDFfeWF3bW9kX29mZiI6LTE2OS4wLCJwMV95YXdtb2RfcmFuZG9tIjoxMDAuMCwicDJfY29zaW5lX3JhbmRvbSI6MTAwLjAsInAyX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDJfZGVsYXlfc3BlZWQiOjIwLjAsInAyX2RlbGF5X3RpY2tzIjoyMC4wLCJwMl9sZWZ0X29mZnNldCI6MTMwLjAsInAyX29mZnNldCI6MTMwLjAsInAyX3JpZ2h0X29mZnNldCI6MTMwLjAsInAyX3lhdyI6IlN0YXRpYyIsInAyX3lhd21vZCI6IkRpc2FibGVkIiwicDJfeWF3bW9kX29mZiI6LTU1LjAsInAyX3lhd21vZF9yYW5kb20iOjEwLjAsInAzX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwM19kZWxheV9sb2dpYyI6IkNvc2luZSIsInAzX2RlbGF5X3NwZWVkIjoyMC4wLCJwM19kZWxheV90aWNrcyI6MjAuMCwicDNfbGVmdF9vZmZzZXQiOjEzMC4wLCJwM19vZmZzZXQiOi0xNTguMCwicDNfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDNfeWF3IjoiU3RhdGljIiwicDNfeWF3bW9kIjoiRGlzYWJsZWQiLCJwM195YXdtb2Rfb2ZmIjotMTgwLjAsInAzX3lhd21vZF9yYW5kb20iOjEwMC4wLCJwNF9jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDRfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwNF9kZWxheV9zcGVlZCI6MTUuMCwicDRfZGVsYXlfdGlja3MiOjIwLjAsInA0X2xlZnRfb2Zmc2V0IjotMTYuMCwicDRfb2Zmc2V0IjoxMzAuMCwicDRfcmlnaHRfb2Zmc2V0Ijo0OS4wLCJwNF95YXciOiJTdGF0aWMiLCJwNF95YXdtb2QiOiJEaXNhYmxlZCIsInA0X3lhd21vZF9vZmYiOjEzMC4wLCJwNF95YXdtb2RfcmFuZG9tIjoxMDAuMCwicGhhc2VfdHlwZSI6IkN1c3RvbSIsInByZXNldF9zZWxlY3QiOiJNZXRhIn0seyJjdXN0b21fcGhhc2VzIjo0LjAsImVuYWJsZSI6ZmFsc2UsInAxX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwMV9kZWxheV9sb2dpYyI6IkNvc2luZSIsInAxX2RlbGF5X3NwZWVkIjoyMC4wLCJwMV9kZWxheV90aWNrcyI6MjAuMCwicDFfbGVmdF9vZmZzZXQiOjEzMC4wLCJwMV9vZmZzZXQiOjEzMC4wLCJwMV9yaWdodF9vZmZzZXQiOjEzMC4wLCJwMV95YXciOiJTdGF0aWMiLCJwMV95YXdtb2QiOiJEaXNhYmxlZCIsInAxX3lhd21vZF9vZmYiOjEzMC4wLCJwMV95YXdtb2RfcmFuZG9tIjoxMDAuMCwicDJfY29zaW5lX3JhbmRvbSI6MTAuMCwicDJfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwMl9kZWxheV9zcGVlZCI6MjAuMCwicDJfZGVsYXlfdGlja3MiOjIwLjAsInAyX2xlZnRfb2Zmc2V0IjoxMzAuMCwicDJfb2Zmc2V0IjotNTUuMCwicDJfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDJfeWF3IjoiU3RhdGljIiwicDJfeWF3bW9kIjoiRGlzYWJsZWQiLCJwMl95YXdtb2Rfb2ZmIjotMTU4LjAsInAyX3lhd21vZF9yYW5kb20iOjE4MC4wLCJwM19jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDNfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwM19kZWxheV9zcGVlZCI6MTUuMCwicDNfZGVsYXlfdGlja3MiOjIwLjAsInAzX2xlZnRfb2Zmc2V0IjotMTYuMCwicDNfb2Zmc2V0IjotMTgwLjAsInAzX3JpZ2h0X29mZnNldCI6NDkuMCwicDNfeWF3IjoiU3RhdGljIiwicDNfeWF3bW9kIjoiRGlzYWJsZWQiLCJwM195YXdtb2Rfb2ZmIjoxMzAuMCwicDNfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInA0X2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwNF9kZWxheV9sb2dpYyI6IkNvc2luZSIsInA0X2RlbGF5X3NwZWVkIjoyMC4wLCJwNF9kZWxheV90aWNrcyI6MjAuMCwicDRfbGVmdF9vZmZzZXQiOjEzMC4wLCJwNF9vZmZzZXQiOjEzMC4wLCJwNF9yaWdodF9vZmZzZXQiOjEzMC4wLCJwNF95YXciOiJTdGF0aWMiLCJwNF95YXdtb2QiOiJEaXNhYmxlZCIsInA0X3lhd21vZF9vZmYiOjEzMC4wLCJwNF95YXdtb2RfcmFuZG9tIjoxMDAuMCwicGhhc2VfdHlwZSI6IkN1c3RvbSIsInByZXNldF9zZWxlY3QiOiJNZXRhIn0seyJjdXN0b21fcGhhc2VzIjoyLjAsImVuYWJsZSI6ZmFsc2UsInAxX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwMV9kZWxheV9sb2dpYyI6IkNvc2luZSIsInAxX2RlbGF5X3NwZWVkIjoyMC4wLCJwMV9kZWxheV90aWNrcyI6MjAuMCwicDFfbGVmdF9vZmZzZXQiOjEzMC4wLCJwMV9vZmZzZXQiOjE2LjAsInAxX3JpZ2h0X29mZnNldCI6MTMwLjAsInAxX3lhdyI6IlN0YXRpYyIsInAxX3lhd21vZCI6IkNlbnRlciIsInAxX3lhd21vZF9vZmYiOi01NS4wLCJwMV95YXdtb2RfcmFuZG9tIjoxMC4wLCJwMl9jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDJfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwMl9kZWxheV9zcGVlZCI6MTUuMCwicDJfZGVsYXlfdGlja3MiOjIwLjAsInAyX2xlZnRfb2Zmc2V0IjotMTYuMCwicDJfb2Zmc2V0IjotMTU4LjAsInAyX3JpZ2h0X29mZnNldCI6NDkuMCwicDJfeWF3IjoiRGVsYXllZCBTd2l0Y2giLCJwMl95YXdtb2QiOiJEaXNhYmxlZCIsInAyX3lhd21vZF9vZmYiOi0xODAuMCwicDJfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInAzX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwM19kZWxheV9sb2dpYyI6IkNvc2luZSIsInAzX2RlbGF5X3NwZWVkIjoyMC4wLCJwM19kZWxheV90aWNrcyI6MjAuMCwicDNfbGVmdF9vZmZzZXQiOjEzMC4wLCJwM19vZmZzZXQiOjEzMC4wLCJwM19yaWdodF9vZmZzZXQiOjEzMC4wLCJwM195YXciOiJTdGF0aWMiLCJwM195YXdtb2QiOiJEaXNhYmxlZCIsInAzX3lhd21vZF9vZmYiOjEzMC4wLCJwM195YXdtb2RfcmFuZG9tIjoxMDAuMCwicDRfY29zaW5lX3JhbmRvbSI6MTAwLjAsInA0X2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDRfZGVsYXlfc3BlZWQiOjIwLjAsInA0X2RlbGF5X3RpY2tzIjoyMC4wLCJwNF9sZWZ0X29mZnNldCI6MTMwLjAsInA0X29mZnNldCI6MTMwLjAsInA0X3JpZ2h0X29mZnNldCI6MTMwLjAsInA0X3lhdyI6IlN0YXRpYyIsInA0X3lhd21vZCI6IkRpc2FibGVkIiwicDRfeWF3bW9kX29mZiI6MTMwLjAsInA0X3lhd21vZF9yYW5kb20iOjEwMC4wLCJwaGFzZV90eXBlIjoiQ3VzdG9tIiwicHJlc2V0X3NlbGVjdCI6Ik1ldGEifSx7ImN1c3RvbV9waGFzZXMiOjEuMCwiZW5hYmxlIjpmYWxzZSwicDFfY29zaW5lX3JhbmRvbSI6MTAwLjAsInAxX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDFfZGVsYXlfc3BlZWQiOjIwLjAsInAxX2RlbGF5X3RpY2tzIjoyMC4wLCJwMV9sZWZ0X29mZnNldCI6MTMwLjAsInAxX29mZnNldCI6LTUuMCwicDFfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDFfeWF3IjoiU3RhdGljIiwicDFfeWF3bW9kIjoiQ2VudGVyIiwicDFfeWF3bW9kX29mZiI6LTE1OC4wLCJwMV95YXdtb2RfcmFuZG9tIjoxODAuMCwicDJfY29zaW5lX3JhbmRvbSI6MTAwLjAsInAyX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDJfZGVsYXlfc3BlZWQiOjIwLjAsInAyX2RlbGF5X3RpY2tzIjoyMC4wLCJwMl9sZWZ0X29mZnNldCI6MTMwLjAsInAyX29mZnNldCI6LTE4MC4wLCJwMl9yaWdodF9vZmZzZXQiOjEzMC4wLCJwMl95YXciOiJTdGF0aWMiLCJwMl95YXdtb2QiOiJEaXNhYmxlZCIsInAyX3lhd21vZF9vZmYiOjEzMC4wLCJwMl95YXdtb2RfcmFuZG9tIjoxMDAuMCwicDNfY29zaW5lX3JhbmRvbSI6MTAwLjAsInAzX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDNfZGVsYXlfc3BlZWQiOjIwLjAsInAzX2RlbGF5X3RpY2tzIjoyMC4wLCJwM19sZWZ0X29mZnNldCI6MTMwLjAsInAzX29mZnNldCI6MTMwLjAsInAzX3JpZ2h0X29mZnNldCI6MTMwLjAsInAzX3lhdyI6IlN0YXRpYyIsInAzX3lhd21vZCI6IkRpc2FibGVkIiwicDNfeWF3bW9kX29mZiI6MTMwLjAsInAzX3lhd21vZF9yYW5kb20iOjEwMC4wLCJwNF9jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDRfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwNF9kZWxheV9zcGVlZCI6MjAuMCwicDRfZGVsYXlfdGlja3MiOjIwLjAsInA0X2xlZnRfb2Zmc2V0IjoxMzAuMCwicDRfb2Zmc2V0IjoxMzAuMCwicDRfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDRfeWF3IjoiU3RhdGljIiwicDRfeWF3bW9kIjoiRGlzYWJsZWQiLCJwNF95YXdtb2Rfb2ZmIjoxMzAuMCwicDRfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInBoYXNlX3R5cGUiOiJDdXN0b20iLCJwcmVzZXRfc2VsZWN0IjoiTWV0YSJ9LHsiY3VzdG9tX3BoYXNlcyI6MTMwLjAsImVuYWJsZSI6ZmFsc2UsInAxX2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwMV9kZWxheV9sb2dpYyI6IkNvc2luZSIsInAxX2RlbGF5X3NwZWVkIjoyMC4wLCJwMV9kZWxheV90aWNrcyI6MjAuMCwicDFfbGVmdF9vZmZzZXQiOjEzMC4wLCJwMV9vZmZzZXQiOjEzMC4wLCJwMV9yaWdodF9vZmZzZXQiOjEzMC4wLCJwMV95YXciOiJTdGF0aWMiLCJwMV95YXdtb2QiOiJEaXNhYmxlZCIsInAxX3lhd21vZF9vZmYiOjEzMC4wLCJwMV95YXdtb2RfcmFuZG9tIjoxMDAuMCwicDJfY29zaW5lX3JhbmRvbSI6MTAwLjAsInAyX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDJfZGVsYXlfc3BlZWQiOjIwLjAsInAyX2RlbGF5X3RpY2tzIjoyMC4wLCJwMl9sZWZ0X29mZnNldCI6MTMwLjAsInAyX29mZnNldCI6MTMwLjAsInAyX3JpZ2h0X29mZnNldCI6MTMwLjAsInAyX3lhdyI6IlN0YXRpYyIsInAyX3lhd21vZCI6IkRpc2FibGVkIiwicDJfeWF3bW9kX29mZiI6MTMwLjAsInAyX3lhd21vZF9yYW5kb20iOjEwMC4wLCJwM19jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDNfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwM19kZWxheV9zcGVlZCI6MjAuMCwicDNfZGVsYXlfdGlja3MiOjIwLjAsInAzX2xlZnRfb2Zmc2V0IjoxMzAuMCwicDNfb2Zmc2V0IjoxMzAuMCwicDNfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDNfeWF3IjoiU3RhdGljIiwicDNfeWF3bW9kIjoiRGlzYWJsZWQiLCJwM195YXdtb2Rfb2ZmIjoxMzAuMCwicDNfeWF3bW9kX3JhbmRvbSI6MTAwLjAsInA0X2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwNF9kZWxheV9sb2dpYyI6IkNvc2luZSIsInA0X2RlbGF5X3NwZWVkIjoyMC4wLCJwNF9kZWxheV90aWNrcyI6MjAuMCwicDRfbGVmdF9vZmZzZXQiOjEzMC4wLCJwNF9vZmZzZXQiOjEzMC4wLCJwNF9yaWdodF9vZmZzZXQiOjEzMC4wLCJwNF95YXciOiJTdGF0aWMiLCJwNF95YXdtb2QiOiJEaXNhYmxlZCIsInA0X3lhd21vZF9vZmYiOjEzMC4wLCJwNF95YXdtb2RfcmFuZG9tIjoxMDAuMCwicGhhc2VfdHlwZSI6IkN1c3RvbSIsInByZXNldF9zZWxlY3QiOiJNZXRhIn0seyJjdXN0b21fcGhhc2VzIjoxMzAuMCwiZW5hYmxlIjpmYWxzZSwicDFfY29zaW5lX3JhbmRvbSI6MTAwLjAsInAxX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDFfZGVsYXlfc3BlZWQiOjIwLjAsInAxX2RlbGF5X3RpY2tzIjoyMC4wLCJwMV9sZWZ0X29mZnNldCI6MTMwLjAsInAxX29mZnNldCI6MTMwLjAsInAxX3JpZ2h0X29mZnNldCI6MTMwLjAsInAxX3lhdyI6IlN0YXRpYyIsInAxX3lhd21vZCI6IkRpc2FibGVkIiwicDFfeWF3bW9kX29mZiI6MTMwLjAsInAxX3lhd21vZF9yYW5kb20iOjEwMC4wLCJwMl9jb3NpbmVfcmFuZG9tIjozOC4wLCJwMl9kZWxheV9sb2dpYyI6IkNvc2luZSIsInAyX2RlbGF5X3NwZWVkIjoyMC4wLCJwMl9kZWxheV90aWNrcyI6MjAuMCwicDJfbGVmdF9vZmZzZXQiOjEzMC4wLCJwMl9vZmZzZXQiOi01OC4wLCJwMl9yaWdodF9vZmZzZXQiOjEzMC4wLCJwMl95YXciOiJTdGF0aWMiLCJwMl95YXdtb2QiOiJEaXNhYmxlZCIsInAyX3lhd21vZF9vZmYiOjEzMC4wLCJwMl95YXdtb2RfcmFuZG9tIjoxMDAuMCwicDNfY29zaW5lX3JhbmRvbSI6MTAwLjAsInAzX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDNfZGVsYXlfc3BlZWQiOjEwLjAsInAzX2RlbGF5X3RpY2tzIjoxMi4wLCJwM19sZWZ0X29mZnNldCI6LTI0LjAsInAzX29mZnNldCI6LTE2OS4wLCJwM19yaWdodF9vZmZzZXQiOjY1LjAsInAzX3lhdyI6IlN0YXRpYyIsInAzX3lhd21vZCI6IkRpc2FibGVkIiwicDNfeWF3bW9kX29mZiI6MTMwLjAsInAzX3lhd21vZF9yYW5kb20iOjEwMC4wLCJwNF9jb3NpbmVfcmFuZG9tIjoxMC4wLCJwNF9kZWxheV9sb2dpYyI6IkNvc2luZSIsInA0X2RlbGF5X3NwZWVkIjoyMC4wLCJwNF9kZWxheV90aWNrcyI6MjAuMCwicDRfbGVmdF9vZmZzZXQiOjEzMC4wLCJwNF9vZmZzZXQiOi01NS4wLCJwNF9yaWdodF9vZmZzZXQiOjEzMC4wLCJwNF95YXciOiJTdGF0aWMiLCJwNF95YXdtb2QiOiJEaXNhYmxlZCIsInA0X3lhd21vZF9vZmYiOi0xNTguMCwicDRfeWF3bW9kX3JhbmRvbSI6MTgwLjAsInBoYXNlX3R5cGUiOiJDdXN0b20iLCJwcmVzZXRfc2VsZWN0IjoiTWV0YSJ9LHsiY3VzdG9tX3BoYXNlcyI6Mi4wLCJlbmFibGUiOmZhbHNlLCJwMV9jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDFfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwMV9kZWxheV9zcGVlZCI6MjAuMCwicDFfZGVsYXlfdGlja3MiOjIwLjAsInAxX2xlZnRfb2Zmc2V0IjoxMzAuMCwicDFfb2Zmc2V0Ijo1LjAsInAxX3JpZ2h0X29mZnNldCI6MTMwLjAsInAxX3lhdyI6IlN0YXRpYyIsInAxX3lhd21vZCI6IkNlbnRlciIsInAxX3lhd21vZF9vZmYiOi01OC4wLCJwMV95YXdtb2RfcmFuZG9tIjozOC4wLCJwMl9jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDJfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwMl9kZWxheV9zcGVlZCI6MTAuMCwicDJfZGVsYXlfdGlja3MiOjEyLjAsInAyX2xlZnRfb2Zmc2V0IjotMjQuMCwicDJfb2Zmc2V0IjoxMzAuMCwicDJfcmlnaHRfb2Zmc2V0Ijo2NS4wLCJwMl95YXciOiJEZWxheWVkIFN3aXRjaCIsInAyX3lhd21vZCI6IkRpc2FibGVkIiwicDJfeWF3bW9kX29mZiI6LTE2OS4wLCJwMl95YXdtb2RfcmFuZG9tIjoxMDAuMCwicDNfY29zaW5lX3JhbmRvbSI6MTAwLjAsInAzX2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDNfZGVsYXlfc3BlZWQiOjIwLjAsInAzX2RlbGF5X3RpY2tzIjoyMC4wLCJwM19sZWZ0X29mZnNldCI6MTMwLjAsInAzX29mZnNldCI6MTMwLjAsInAzX3JpZ2h0X29mZnNldCI6MTMwLjAsInAzX3lhdyI6IlN0YXRpYyIsInAzX3lhd21vZCI6IkRpc2FibGVkIiwicDNfeWF3bW9kX29mZiI6LTU1LjAsInAzX3lhd21vZF9yYW5kb20iOjEwLjAsInA0X2Nvc2luZV9yYW5kb20iOjEwMC4wLCJwNF9kZWxheV9sb2dpYyI6IkNvc2luZSIsInA0X2RlbGF5X3NwZWVkIjoyMC4wLCJwNF9kZWxheV90aWNrcyI6MjAuMCwicDRfbGVmdF9vZmZzZXQiOjEzMC4wLCJwNF9vZmZzZXQiOi0xNTguMCwicDRfcmlnaHRfb2Zmc2V0IjoxMzAuMCwicDRfeWF3IjoiU3RhdGljIiwicDRfeWF3bW9kIjoiRGlzYWJsZWQiLCJwNF95YXdtb2Rfb2ZmIjotMTgwLjAsInA0X3lhd21vZF9yYW5kb20iOjEwMC4wLCJwaGFzZV90eXBlIjoiQ3VzdG9tIiwicHJlc2V0X3NlbGVjdCI6Ik1ldGEifSx7ImN1c3RvbV9waGFzZXMiOjQuMCwiZW5hYmxlIjp0cnVlLCJwMV9jb3NpbmVfcmFuZG9tIjoxMDAuMCwicDFfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwMV9kZWxheV9zcGVlZCI6MjAuMCwicDFfZGVsYXlfdGlja3MiOjIwLjAsInAxX2xlZnRfb2Zmc2V0IjoxMzAuMCwicDFfb2Zmc2V0IjoxNS4wLCJwMV9yaWdodF9vZmZzZXQiOjEzMC4wLCJwMV95YXciOiJTdGF0aWMiLCJwMV95YXdtb2QiOiJDZW50ZXIiLCJwMV95YXdtb2Rfb2ZmIjotNTUuMCwicDFfeWF3bW9kX3JhbmRvbSI6NTUuMCwicDJfY29zaW5lX3JhbmRvbSI6NS4wLCJwMl9kZWxheV9sb2dpYyI6IkNvc2luZSIsInAyX2RlbGF5X3NwZWVkIjoxNS4wLCJwMl9kZWxheV90aWNrcyI6MTEuMCwicDJfbGVmdF9vZmZzZXQiOi0yMS4wLCJwMl9vZmZzZXQiOjU1LjAsInAyX3JpZ2h0X29mZnNldCI6NDkuMCwicDJfeWF3IjoiRGVsYXllZCBTd2l0Y2giLCJwMl95YXdtb2QiOiJEaXNhYmxlZCIsInAyX3lhd21vZF9vZmYiOi0zMy4wLCJwMl95YXdtb2RfcmFuZG9tIjoxMDAuMCwicDNfY29zaW5lX3JhbmRvbSI6MTAuMCwicDNfZGVsYXlfbG9naWMiOiJDb3NpbmUiLCJwM19kZWxheV9zcGVlZCI6MjAuMCwicDNfZGVsYXlfdGlja3MiOjIwLjAsInAzX2xlZnRfb2Zmc2V0IjotNC4wLCJwM19vZmZzZXQiOi01NS4wLCJwM19yaWdodF9vZmZzZXQiOjI3LjAsInAzX3lhdyI6IkxlZnQvUmlnaHQiLCJwM195YXdtb2QiOiJDZW50ZXIiLCJwM195YXdtb2Rfb2ZmIjotMjcuMCwicDNfeWF3bW9kX3JhbmRvbSI6MTIuMCwicDRfY29zaW5lX3JhbmRvbSI6MTAwLjAsInA0X2RlbGF5X2xvZ2ljIjoiQ29zaW5lIiwicDRfZGVsYXlfc3BlZWQiOjIwLjAsInA0X2RlbGF5X3RpY2tzIjoyMC4wLCJwNF9sZWZ0X29mZnNldCI6LTE4LjAsInA0X29mZnNldCI6LTE4MC4wLCJwNF9yaWdodF9vZmZzZXQiOjQ0LjAsInA0X3lhdyI6IkxlZnQvUmlnaHQiLCJwNF95YXdtb2QiOiJEaXNhYmxlZCIsInA0X3lhd21vZF9vZmYiOjEzMC4wLCJwNF95YXdtb2RfcmFuZG9tIjoxMDAuMCwicGhhc2VfdHlwZSI6IkN1c3RvbSIsInByZXNldF9zZWxlY3QiOiJNZXRhIn1dfV0=" -- Continue your encoded string here

    local decoded_data = base64.decode(encoded_data)  
    local brute_decoded_data = base64.decode(brute_encoded_data)  


    local config_data = json.parse(decoded_data)  
    local brute_config_data = json.parse(brute_decoded_data)  

    
    aa_cfg:load(config_data)
    brute_cfg:load(brute_config_data)

    cvar.play:call("ambient\\tones\\elev1")
    end



        configs = {
            load = groups.main3:button("\f<check> Load ", function()
                cfg_system.update_values(cfg_selector:get())
                cfg_system.load_config(cfg_selector:get())
                cfg_selector:update(configs_db.menu_list)
            end, true),

            save = groups.main3:button("\f<floppy-disk> Save", function()
                cfg_system.save_config(cfg_selector:get())
            end, true),

            remove  = groups.main3:button("\f<trash-xmark> Delete", function()
                cfg_system.remove_config(cfg_selector:get())
                cfg_selector:update(configs_db.menu_list)
            end, true),

            export = groups.main3:button("\f<share-nodes> Export", function()
                notify_label:name(" \a928491FF\f<check>    \aDBDBDBFFconfiguration exported.")
                notify_label_timer:start()
                notify_label:visibility(true)
                clipboard.set(base64.encode(json.stringify(all_cfg:save())))
                cvar.play:call("ambient\\tones\\elev1")
            end, true),

            name = groups.main4:input("Preset Name", "New Confg"),
            create = groups.main4:button("     \f<layer-group> Create New      ", function()
                cfg_system.create_config(configs.name:get())
                cfg_selector:update(configs_db.menu_list)
            end, true),

            import = groups.main4:button("   \f<download>  Import   ", function()
                notify_label:name(" \a928491FF\f<check>    \aDBDBDBFFconfiguration imported.")
                notify_label_timer:start()
                notify_label:visibility(true)
                all_cfg:load(json.parse(base64.decode(clipboard.get())))
                cvar.play:call("ambient\\tones\\elev1")
            end, true),

            export_aa = groups.aa1:button("\f<share-nodes> Export", function()
                notify_label:name(" \a928491FF\f<check>    \aDBDBDBFFconfiguration exported.")
                notify_label_timer:start()
                notify_label:visibility(true)
                clipboard.set(base64.encode(json.stringify(aa_cfg:save())))
                cvar.play:call("ambient\\tones\\elev1")
            end, true),
            import_aa = groups.aa1:button("\f<download> Import", function()
                notify_label:name(" \a928491FF\f<check>    \aDBDBDBFFconfiguration imported.")
                notify_label_timer:start()
                notify_label:visibility(true)
                aa_cfg:load(json.parse(base64.decode(clipboard.get())))
                cvar.play:call("ambient\\tones\\elev1")
            end, true),
            

            export_brute = groups.aa2:button("\f<share-nodes> Export Antibrute", function()
                notify_label:name(" \a928491FF\f<check>    \aDBDBDBFFAntibrute exported.")
                notify_label_timer:start()
                notify_label:visibility(true)
                clipboard.set(base64.encode(json.stringify(brute_cfg:save())))
                cvar.play:call("ambient\\tones\\elev1")
            end, true),

            import_brute = groups.aa2:button("\f<download> Import Antibrute", function()
                notify_label:name(" \a928491FF\f<check>    \aDBDBDBFFAntibrute imported.")
                notify_label_timer:start()
                notify_label:visibility(true)
                brute_cfg:load(json.parse(base64.decode(clipboard.get())))
                cvar.play:call("ambient\\tones\\elev1")
            end, true),

        }


    events.render(function()
        if menu_items.aa.preset_list:get() == 2 then
            cfg_system.load_preset_config_1()
        end

        if menu_items.aa.preset_list:get() == 3 then
            cfg_system.load_preset_config_2()
        end

        if menu_items.aa.preset_list:get() == 4 then
            cfg_system.load_preset_config_3()
        end
        if menu_items.aa.preset_list:get() == 5 then
            cfg_system.load_preset_config_4()
        end
        if menu_items.aa.preset_list:get() == 6 then
            cfg_system.load_preset_config_5()
        end
        if menu_items.aa.preset_list:get() == 7 then
            cfg_system.load_preset_config_6()
        end
        if menu_items.aa.preset_list:get() == 8 then
            cfg_system.load_preset_config_7()
        end
        if menu_items.aa.preset_list:get() == 9 then
            cfg_system.load_preset_config_8()
        end
        if menu_items.aa.preset_list:get() == 10 then
            menu_items.aa.preset_list:set(1)
        end
        if menu_items.aa.preset_list:get() == 11 then
            menu_items.aa.preset_list:set(1)
        end
    end)
    configs.export_brute:depend({menu_items.main.home_info, 1}, {menu_items.aa.style_aa, 3})
    configs.import_brute:depend({menu_items.main.home_info, 1}, {menu_items.aa.style_aa, 3})
    configs.export_aa:depend({menu_items.main.home_info, 1}, {menu_items.aa.style_aa, 3})
    configs.import_aa:depend({menu_items.main.home_info, 1}, {menu_items.aa.style_aa, 3})
    configs.import:depend({menu_items.main.home_info, 1})
    configs.export:depend({menu_items.main.home_info, 1})
    configs.load:depend({menu_items.main.home_info, 1})
    configs.save:depend({menu_items.main.home_info, 1})
    configs.create:depend({menu_items.main.home_info, 1})
    configs.remove:depend({menu_items.main.home_info, 1})
    configs.name:depend({menu_items.main.home_info, 1})
    cfg_selector:depend({menu_items.main.home_info, 1})
    data_transfer:depend({menu_items.main.home_info, 1})


    local clipboard = require('neverlose/clipboard')
local pui = require("neverlose/pui")

local button_used = db.d3 or 0
db.venture_used_keys = db.venture_used_keys or {}
local used_keys = db.venture_used_keys


local function convert(chars, dist, inv)
    return string.char((string.byte(chars) - 32 + (inv and -dist or dist)) % 95 + 32)
end

local function crypt(str, k, inv)
    local enc = ""
    for i = 1, #str do
        if (#str - k[5] >= i or not inv) then
            for inc = 0, 3 do
                if (i % 4 == inc) then
                    enc = enc .. convert(string.sub(str, i, i), k[inc + 1], inv)
                    break
                end
            end
        end
    end
    if not inv then
        for i = 1, k[5] do
            enc = enc .. string.char(math.random(32, 126))
        end
    end
    return enc
end

local encryption_key = {29, 58, 93, 28, 27}
local expected_message = "Live"


local key_input = groups.verify:input("Verification Key")
local verify_btn = groups.verify:button("Verify Key")

local expiration_time = 600 -- 10 minutes in seconds

verify_btn:set_callback(function()
    local encrypted_key = key_input:get()
    
    if #encrypted_key < 10 then
        common.add_notify("Error:", "Invalid key format")
        return
    end
    
    local current_time = globals.realtime
    if used_keys[encrypted_key] then
        if current_time - used_keys[encrypted_key] > expiration_time then
            used_keys[encrypted_key] = nil -- Remove expired key
            db.venture_used_keys = used_keys -- Update database
            common.add_notify("Error:", "Key expired")
            return
        else
            common.add_notify("Error:", "Key already used")
            return
        end
    end
    
    local decrypted = crypt(encrypted_key, encryption_key, true)
    
    if decrypted == expected_message then
        used_keys[encrypted_key] = current_time
        db.venture_used_keys = used_keys  -- Persist to database
        
        button_used = button_used + 1
        db.d3 = button_used
        common.add_notify("Success:", "Verification complete!")
    else
        common.add_notify("Error:", "Invalid verification key")
    end
end)


function table.count(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end



events.render(function()
    local current_time = globals.realtime
    for key, timestamp in pairs(used_keys) do
        if current_time - timestamp > expiration_time then
            used_keys[key] = nil
        end
    end
    db.venture_used_keys = used_keys
end) 
events.render(function()

            

            groups.verify:visibility(button_used == 0) 
            groups.main1:visibility(button_used == 1) 
            groups.main2:visibility(button_used == 1) 
            groups.main5:visibility(button_used == 1) 
            groups.main3:visibility(button_used == 1) 
            groups.main4:visibility(button_used == 1) 
            groups.aa1:visibility(button_used == 1) 
            groups.aa2:visibility(button_used == 1) 
            groups.aa3:visibility(button_used == 1) 
            groups.aa4:visibility(button_used == 1) 
            groups.misc1:visibility(button_used == 1)
            
end)


    --color(255, 255, 255, 255),
    -- configs.load:depend({ menu_items.select_list , 1 })
    -- configs.save:depend({ menu_items.select_list , 1 })
    -- configs.remove:depend({ menu_items.select_list , 1 })
    -- configs.export:depend({ menu_items.select_list , 1 })
    -- configs.name:depend({ menu_items.select_list , 1 })
    -- configs.create:depend({ menu_items.select_list , 1 })
    -- configs.import:depend({ menu_items.select_list , 1 })
    -- cfg_selector:depend({ menu_items.select_list , 1 })
    -- data_transfer:depend({ menu_items.select_list , 1 })
