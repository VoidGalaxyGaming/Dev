local ply = FindMetaTable("Player") //Defines the local player

aot_teams = {} //Defines the variable

aot_teams[TEAM_TITAN_N] = {name = "Titans", var = "TEAM_TITAN_N", color = Vector( 1.0, .2, .2 ), loadoutType = {"titan_swep_v2"} }
aot_teams[TEAM_CORP_N] = {name = "Recon Corps", var = "TEAM_CORP_N", color = Vector( .2, .2, 1.0 ), loadoutType = {"3d_maneuver_gear_c","3d_maneuver_gear_expert_c"} }
aot_teams[TEAM_SPEC_N] = {name = "Spectator", var = "TEAM_SPEC_N", color = Vector( 1, .2, 1.0 ), loadoutType = {"NoWeapon"} }
function ply:SetGamemodeTeam( n )
	if not aot_teams[n] then return end
	
	self:SetTeam( n )
	
	self:SetPlayerColor( aot_teams[n].color )
	
	self:GiveGamemodeWeapons()
	
	return true
end

function ply:GiveGamemodeWeapons()
	local n = self:Team()
	if self.OldTeam == nil then self.OldTeam = 0 end
	if self.OldTeam != self:Team() then self:SetPData("LoadoutNumber", 1) end
	self.OldTeam = self:Team()
	self:StripWeapons()
	if self:GetPData("LoadoutNumber", 0) == 0 then self:SetPData("LoadoutNumber", 1) end
	local loadout = tonumber(self:GetPData("LoadoutNumber", 0))
	
	if not aot_teams[n] then return end
		for k, wep in pairs(aot_teams[n].loadoutType) do
			if k == loadout and wep != "NoWeapon" then
			self:Give(wep)
			end
		end

end

function ply:PickRandomModel()
	local GroupNumber = math.random(1,3)
	local GenderNumber = math.random(1,2)
	local Gender = {}
	Gender[1] = "Male_0"
	Gender[2] = "Female_0"
	local GenderClass = nil
	local ModelLocation = "models/player/Group0"
	if GenderNumber == 1 then
		GenderClass = math.random(1,9)
	elseif GenderNumber == 2 then
		GenderClass = math.random(1,6)
	end
	if GroupNumber == 1 or GroupNumber == 3 then
		self:SetModel(ModelLocation .. GroupNumber .. "/" .. Gender[GenderNumber] .. GenderClass .. ".mdl")
	else
		self:SetModel(ModelLocation .. 3 .. "/" .. Gender[GenderNumber] .. GenderClass .. ".mdl")
	end
end

//Team Selection 
-- Called when player picks a team, or when the game gives it one.
net.Receive( "TeamSelect", function( length, client )
local Team = net.ReadString()
	if Team == "TEAM_TITAN" then
		TEAM_TITAN(client)
	elseif Team == "TEAM_CORP" then
		TEAM_CORP(client)
	end
end )
//End Team Selection

//Loadout
-- Called when player picks a loadout.
net.Receive( "LoadoutNumber", function( length, client )
    local loadoutNumber = net.ReadDouble()
	client:SetPData("LoadoutNumber", loadoutNumber)
	client:GiveGamemodeWeapons()
end)
//Loadout End

