local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

-- 1. Basic Structural Settings (Lines 10-15)
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- 2. Font and Appearance
config.font = wezterm.font({ family = "JetBrains Mono", weight = "Light" })
config.font_size = 12
config.color_scheme = "Catppuccin Frappe"
config.window_frame = {
	font = wezterm.font({ family = "Roboto", weight = "Bold" }),
	font_size = 12.0,
	active_titlebar_bg = "#292c3c",
	inactive_titlebar_bg = "#303446",
}

-- 3. Custom Key Bindings (Consolidated)
config.keys = {
    -- Debug Overlay Shortcut
	{ key = "L", mods = "CTRL", action = wezterm.action.ShowDebugOverlay },
    -- Split Panes Shortcuts
	{ key = "/", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal },
	{ key = "+", mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical },
	{ key = "-", mods = "CTRL|SHIFT", action = wezterm.action.SplitVertical },
}

-- 4. Tab Title Formatting Hook (Lines 21-48)
local frappe = wezterm.color.get_builtin_schemes()["catppuccin-frappe"]

function tab_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab_title(tab)
	if tab.is_active then
		return {
			{ Background = { Color = frappe.selection_bg } },
			{ Text = title },
		}
	end
	if tab.is_last_active then
		return {
			{ Background = { Color = frappe.background } },
			{ Text = title },
		}
	end
	return title
end)

-- 5. Return Config (Line 78)
return config