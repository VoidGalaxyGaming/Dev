include("shared.lua")

include("vgui/cl_hud.lua")
include("cl_menu.lua")
include("vgui/cl_scoreboard.lua")

function GM:PostDrawViewModel( vm, ply, weapon )
	if ( weapon.UseHands || !weapon:IsScripted() ) then

		local hands = LocalPlayer():GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end

	end
end

function PlayerSuicide(data)
	RunConsoleCommand("kill")
end

usermessage.Hook("PlayerSuicideAOT",PlayerSuicide)


