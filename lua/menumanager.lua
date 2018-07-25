if not _G.IGWSC then
	_G.IGWSC = _G.IGWSC or {}
	IGWSC._path = ModPath
	IGWSC.settings_path = SavePath .. "IGWSC.txt"
end

function IGWSC:Reset()
	self.settings = {
		dropin_text_value = string.upper(managers.localization:text("debug_loading_level")),
		join_text_value = managers.localization:text("menu_waiting_is_joining"),
		ready_text_value = managers.localization:text("menu_waiting_is_ready"),
		unready_text_value = managers.localization:text("menu_waiting_is_not_ready"),
		color =
		{
			dropin =
			{
				r = 255,
				g = 255,
				b = 153
			},
			join =
			{
				r = 153,
				g = 255,
				b = 255
			},
			ready =
			{
				r = 102,
				g = 255,
				b = 102
			},
			unready =
			{
				r = 255,
				g = 51,
				b = 51
			}
		}
	}
end

local ColorUnpack = function(type)
	return IGWSC.settings.color[type].r, IGWSC.settings.color[type].g, IGWSC.settings.color[type].b
end

function IGWSC:Save()
	local file = io.open(self.settings_path, "w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

function IGWSC:Load()
	local GetTableName = function(table_name)
		for k, _ in pairs(self.settings.color) do
			if k == table_name then
          		return k
    		end
		end
  		return nil
	end

	self:Reset()
	local file = io.open(self.settings_path, "r")
	if file then
		for k, v in pairs(json.decode(file:read('*all')) or {}) do
			if type(v) == "table" then
				if k == "color" then
					for i, j in pairs(v) do
						table_name = GetTableName(i)
						if table_name then
							self.settings.color[table_name].r = j.r
							self.settings.color[table_name].g = j.g
							self.settings.color[table_name].b = j.b
						end
					end
				end
			else
				self.settings[k] = v
			end
		end
		file:close()
	end
end

function IGWSC:Update()
	local menu_items = MenuHelper:GetMenu("igwsc_menu"):items()
	for k, v in pairs(self.settings.color) do
		self:SetColorValues(menu_items, k, v)
	end
end

function IGWSC:SetColorValues(menu_items, which, values)	
	self:SetItemsValue(menu_items, {[which .. "_r"] = true}, values.r)
	self:SetItemsValue(menu_items, {[which .. "_g"] = true}, values.g)
	self:SetItemsValue(menu_items, {[which .. "_b"] = true}, values.b)
end

function IGWSC:SetItemsValue(item, items_table, value) --Original function taken from BLT and rewritten to fulfill mod needs
	if type(items_table) ~= "table" then
		local s = tostring(items_table)
		items_table = {}
		items_table[s] = true
	end
	for _, v in pairs(item) do --Only sets value!
		if items_table[v:name()] and v.set_value then
			if v:type() == "toggle" then
				v:set_value(value and "on" or "off")
			else
				v:set_value(value)
			end
		end
	end
end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_IGWSC", function( loc )
	-- Thanks to Lobby Player Info mod and WolfHUD mod for checking the language and load the language
	if file.DirectoryExists(IGWSC._path .. "loc/") then
		local custom_language
		for _, mod in pairs(BLT and BLT.Mods:Mods() or {}) do
			if mod:GetName() == "ChnMod (Patch)" and mod:IsEnabled() then
				custom_language = "chinese"
				break
			elseif mod:GetName() == "PAYDAY 2 THAI LANGUAGE Mod" and mod:IsEnabled() then
				custom_language = "thai"
				break
			end			
		end
		if custom_language then
			loc:load_localization_file(IGWSC._path .. "loc/" .. custom_language ..".json")
		else
			for _, filename in pairs(file.GetFiles(IGWSC._path .. "loc/")) do
				local str = filename:match('^(.*).json$')
				if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
					loc:load_localization_file(IGWSC._path .. "loc/" .. filename)
					break
				end
			end
		end
	end
	loc:load_localization_file(IGWSC._path .. "loc/english.json", false)
end)

Hooks:Add( "MenuManagerInitialize", "MenuManagerInitialize_IGWSC", function( menu_manager )
	MenuCallbackHandler.callback_dropin_text_input = function(self, item)
		IGWSC.settings.dropin_text_value = item:value()
	end

	MenuCallbackHandler.callback_dropin_r = function(self, item)
		IGWSC.settings.color.dropin.r = math.floor(item:value())
		IGWSC:UpdateColor(IGWSC._dropin_color_bmp, "dropin")
	end

	MenuCallbackHandler.callback_dropin_g = function(self, item)
		IGWSC.settings.color.dropin.g = item:value()
		IGWSC:UpdateColor(IGWSC._dropin_color_bmp, "dropin")
	end

	MenuCallbackHandler.callback_dropin_b = function(self, item)
		IGWSC.settings.color.dropin.b = item:value()
		IGWSC:UpdateColor(IGWSC._dropin_color_bmp, "dropin")
	end

	MenuCallbackHandler.callback_join_text_input = function(self, item)
		IGWSC.settings.join_text_value = item:value()
	end

	MenuCallbackHandler.callback_join_r = function(self, item)
		IGWSC.settings.color.join.r = math.floor(item:value())
		IGWSC:UpdateColor(IGWSC._join_color_bmp, "join")
	end

	MenuCallbackHandler.callback_join_g = function(self, item)
		IGWSC.settings.color.join.g = item:value()
		IGWSC:UpdateColor(IGWSC._join_color_bmp, "join")
	end

	MenuCallbackHandler.callback_join_b = function(self, item)
		IGWSC.settings.color.join.b = item:value()
		IGWSC:UpdateColor(IGWSC._join_color_bmp, "join")
	end

	MenuCallbackHandler.callback_ready_text_input = function(self, item)
		IGWSC.settings.ready_text_value = item:value()
	end

	MenuCallbackHandler.callback_ready_r = function(self, item)
		IGWSC.settings.color.ready.r = math.floor(item:value())
		IGWSC:UpdateColor(IGWSC._ready_color_bmp, "ready")
	end

	MenuCallbackHandler.callback_ready_g = function(self, item)
		IGWSC.settings.color.ready.g = item:value()
		IGWSC:UpdateColor(IGWSC._ready_color_bmp, "ready")
	end

	MenuCallbackHandler.callback_ready_b = function(self, item)
		IGWSC.settings.color.ready.b = item:value()
		IGWSC:UpdateColor(IGWSC._ready_color_bmp, "ready")
	end

	MenuCallbackHandler.callback_unready_text_input = function(self, item)
		IGWSC.settings.unready_text_value = item:value()
	end

	MenuCallbackHandler.callback_unready_r = function(self, item)
		IGWSC.settings.color.unready.r = math.floor(item:value())
		IGWSC:UpdateColor(IGWSC._unready_color_bmp, "unready")
	end

	MenuCallbackHandler.callback_unready_g = function(self, item)
		IGWSC.settings.color.unready.g = item:value()
		IGWSC:UpdateColor(IGWSC._unready_color_bmp, "unready")
	end

	MenuCallbackHandler.callback_unready_b = function(self, item)
		IGWSC.settings.color.unready.b = item:value()
		IGWSC:UpdateColor(IGWSC._unready_color_bmp, "unready")
	end

	MenuCallbackHandler.igwsc_save = function(this, item)
		IGWSC:Save()
	end

	MenuCallbackHandler.callback_igwsc_reset = function(self, item)
		MenuHelper:ResetItemsToDefaultValue(item, {["dropin_text_input"] = true}, string.upper(managers.localization:text("debug_loading_level")))
		MenuHelper:ResetItemsToDefaultValue(item, {["join_text_input"] = true}, managers.localization:text("menu_waiting_is_joining"))
		MenuHelper:ResetItemsToDefaultValue(item, {["ready_text_input"] = true}, managers.localization:text("menu_waiting_is_ready"))
		MenuHelper:ResetItemsToDefaultValue(item, {["unready_text_input"] = true}, managers.localization:text("menu_waiting_is_not_ready"))
		MenuHelper:ResetItemsToDefaultValue(item, {["dropin_r"] = true, ["dropin_g"] = true, ["join_g"] = true, ["join_b"] = true, ["ready_g"] = true, ["unready_r"] = true}, 255)
		MenuHelper:ResetItemsToDefaultValue(item, {["dropin_b"] = true, ["join_r"] = true}, 153)
		MenuHelper:ResetItemsToDefaultValue(item, {["ready_r"] = true, ["ready_b"] = true}, 102)
		MenuHelper:ResetItemsToDefaultValue(item, {["unready_g"] = true, ["unready_b"] = true}, 51)
	end

	MenuCallbackHandler.IGWSCChangedFocus = function(node, focus)
		if focus then
			IGWSC:CreatePanel()
			IGWSC:CreateBitmaps()
			if not updated then
				IGWSC:Update()
				updated = true
			end
		else
			IGWSC:DestroyPanel()
		end
	end

	IGWSC:Load()	
	MenuHelper:LoadFromJsonFile(IGWSC._path .. "menu/options.txt", IGWSC, IGWSC.settings)
end )

function IGWSC:CreateBitmap(color, x, y)
	local bmp = self._panel:bitmap({
		h = 48,
		w = 48,
		valign = 'center',
		halign = 'center',
		visible = true,
		color = color,
		layer = tweak_data.gui.MENU_LAYER - 50,
		blend_mode = 'normal'
	})
	bmp:set_right(self._panel:right() - self._panel:w() * (0.35 + x))
	bmp:set_top(self._panel:h() * y)
	return bmp
end

function IGWSC:CreateBitmaps()
	if alive(self._panel) and not self._assault_box_bmp then
		self._dropin_color_bmp = self:CreateBitmap(self:GetColor("dropin"), 0.02, 0.12)
		self._join_color_bmp = self:CreateBitmap(self:GetColor("join"), 0.02, 0.315)
		self._ready_color_bmp = self:CreateBitmap(self:GetColor("ready"), 0.02, 0.51)
		self._unready_color_bmp = self:CreateBitmap(self:GetColor("unready"), 0.02, 0.705)
	end
end

function IGWSC:CreatePanel()
	if self._panel or not managers.menu_component then
		return
	end
	self._panel = managers.menu_component._ws:panel():panel()
end

function IGWSC:DestroyPanel()
	if not alive(self._panel) then
		return
	end
	self._panel:clear()
	self._dropin_color_bmp = nil
	self._join_color_bmp = nil
	self._ready_color_bmp = nil
	self._unready_color_bmp = nil
	self._panel:parent():remove(self._panel)
	self._panel = nil
end

function IGWSC:GetColor(type)
	return Color(255, ColorUnpack(type)) / 255
end

function IGWSC:UpdateColor(bmp, type)
	if alive(self._panel) and alive(bmp) then
		bmp:set_color(self:GetColor(type))
	end
end