local superblt = false
for _, mod in pairs(BLT and BLT.Mods:Mods() or {}) do
	if mod:GetName() == "SuperBLT" and mod:IsEnabled() then
		superblt = true
		break
	end			
end
if superblt == false then
	if UpdateThisMod then
		UpdateThisMod:Add({
			mod_id = 'InGameWaitingStatusColor',
			data = {
				modworkshop_id = 19670
			}
		})
	end

end