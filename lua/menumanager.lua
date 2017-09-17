_G.IGWSC = _G.IGWSC or {}
IGWSC._path = ModPath
IGWSC.settings_path = SavePath .. "IGWSC.txt"

function IGWSC:Reset()
	self.settings = {
		dropin_text_value = "LOADING",
		dropin_color_value = "FFFF99",
		join_text_value = "JOINING",
		join_color_value = "99FFFF",
		ready_text_value = "READY",
		ready_color_value = "66FF66",
		unready_text_value = "NOT READY",
		unready_color_value = "FF3333"
	}
end

function IGWSC:Save()
	local file = io.open( self.settings_path, "w+" )
	if file then
		file:write( json.encode( self.settings ) )
		file:close()
	end
end

function IGWSC:Load()
	local file = io.open( self.settings_path, "r" )
	if file then
		self.settings = json.decode( file:read("*all") )
		file:close()
	else
		IGWSC:Reset()
		IGWSC:Save()
	end
end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_IGWSC", function( loc )
	loc:load_localization_file( IGWSC._path .. "loc/en.txt")
end)

Hooks:Add( "MenuManagerInitialize", "MenuManagerInitialize_IGWSC", function( menu_manager )

	MenuCallbackHandler.callback_dropin_text_input = function(self, item)
		IGWSC.settings.dropin_text_value = item:value()
		IGWSC:Save()
	end
	MenuCallbackHandler.callback_dropin_color_input = function(self, item)
		IGWSC.settings.dropin_color_value = item:value()
		IGWSC:Save()
	end
	MenuCallbackHandler.callback_join_text_input = function(self, item)
		IGWSC.settings.join_text_value = item:value()
		IGWSC:Save()
	end
	MenuCallbackHandler.callback_join_color_input = function(self, item)
		IGWSC.settings.join_color_value = item:value()
		IGWSC:Save()
	end
	MenuCallbackHandler.callback_ready_text_input = function(self, item)
		IGWSC.settings.ready_text_value = item:value()
		IGWSC:Save()
	end
	MenuCallbackHandler.callback_ready_color_input = function(self, item)
		IGWSC.settings.ready_color_value = item:value()
		IGWSC:Save()
	end
	MenuCallbackHandler.callback_unready_text_input = function(self, item)
		IGWSC.settings.unready_text_value = item:value()
		IGWSC:Save()
	end
	MenuCallbackHandler.callback_unready_color_input = function(self, item)
		IGWSC.settings.unready_color_value = item:value()
		IGWSC:Save()
	end

	MenuCallbackHandler.callback_igwsc_reset = function(self, item)
		IGWSC:Reset()
		MenuHelper:ResetItemsToDefaultValue(item, {["dropin_text_input"] = true}, IGWSC.settings.join_text_value)
		MenuHelper:ResetItemsToDefaultValue(item, {["dropin_color_input"] = true}, IGWSC.settings.join_color_value)
		MenuHelper:ResetItemsToDefaultValue(item, {["join_text_input"] = true}, IGWSC.settings.join_text_value)
		MenuHelper:ResetItemsToDefaultValue(item, {["join_color_input"] = true}, IGWSC.settings.join_color_value)
		MenuHelper:ResetItemsToDefaultValue(item, {["ready_text_input"] = true}, IGWSC.settings.ready_text_value)
		MenuHelper:ResetItemsToDefaultValue(item, {["ready_color_input"] = true}, IGWSC.settings.ready_color_value)
		MenuHelper:ResetItemsToDefaultValue(item, {["unready_text_input"] = true}, IGWSC.settings.unready_text_value)
		MenuHelper:ResetItemsToDefaultValue(item, {["unready_color_input"] = true}, IGWSC.settings.unready_color_value)
		IGWSC:Save()
	end

	IGWSC:Load()	
	MenuHelper:LoadFromJsonFile( IGWSC._path .. "menu/options.txt", IGWSC, IGWSC.settings )

end )

IGWSC:Load()