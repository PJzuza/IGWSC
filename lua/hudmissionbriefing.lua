IGWSC:Load()

function HUDMissionBriefing:set_slot_ready(peer, peer_id)
	print("set_slot_ready( peer, peer_id )", peer, peer_id)
	local slot = self._ready_slot_panel:child("slot_" .. tostring(peer_id))
	if not slot or not alive(slot) then
		return
	end
	slot:child("status"):set_text(IGWSC.settings.ready_text_value)
	slot:child("status"):set_color(Color(IGWSC.settings.ready_color_value))
end

function HUDMissionBriefing:set_slot_not_ready(peer, peer_id)
	print("set_slot_not_ready( peer, peer_id )", peer, peer_id)
	local slot = self._ready_slot_panel:child("slot_" .. tostring(peer_id))
	if not slot or not alive(slot) then
		return
	end
	slot:child("status"):set_text(IGWSC.settings.unready_text_value)
	slot:child("status"):set_color(Color(IGWSC.settings.unready_color_value))
end