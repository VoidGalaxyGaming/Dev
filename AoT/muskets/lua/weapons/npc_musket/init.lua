AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "ai_translations.lua" )
include('shared.lua')

SWEP.Weight				= 30		// Decides whether we should switch from/to this
SWEP.AutoSwitchTo			= true		// Auto switch to  we pick it up
SWEP.AutoSwitchFrom			= true		// Auto switch from  you pick up a better weapon

function SWEP:Initialize()
	self:SetWeaponHoldType("ar2")
	
	if self.Owner:GetClass() == "npc_metropolice" then
	self:SetWeaponHoldType("ar2")
	end
	
	if self.Owner:GetClass() == "npc_citizen" then
	self.Weapon.Owner:Fire( "DisableWeaponPickup" )
	end
	
	if GetConVar("Squad_Weps"):GetInt() == 1 then
	self:SquadAssignment()
	end
	
	if self.Owner:GetClass() == "npc_combine_s" then
	self:Proficiency()	
	hook.Add( "Think", self, self.onThink )
	end
	if GetConVar("NPC_Grenades"):GetInt() == 1 then
	if self.Weapon.Owner:LookupSequence("grenThrow") == nil then return end
		local seq = self.Weapon.Owner:LookupSequence("grenThrow") 
				if self.Weapon.Owner:GetSequenceName(seq) == "grenThrow" then
					self.Weapon.Owner:SetKeyValue("NumGrenades", "5") 
					end
				end
				
			if GetConVar("NPC_Manhacks"):GetInt() == 1 then
		if self.Weapon.Owner:LookupSequence("deploy") == nil then return end
		local manhackseq = self.Weapon.Owner:LookupSequence("deploy") 
				if self.Weapon.Owner:GetSequenceName(manhackseq) == "deploy" then
					self.Weapon.Owner:SetKeyValue("Manhacks", "2") 
					end
				end
			end

function SWEP:onThink()
self:NextFire()
	end
	
function SWEP:NextFire()
	if !self:IsValid() or !self.Owner:IsValid() then return; end

	if self.Owner:GetActivity() == 16 then
		self:NPCShoot_Primary( ShootPos, ShootDir )
			hook.Remove("Think", self)
			
	timer.Simple(1, function()
		hook.Add("Think", self, self.NextFire)
		end)
	end
end

function SWEP:Proficiency()
timer.Simple(0.5, function()
	if !self:IsValid() or !self.Owner:IsValid() then return; end
self.Owner:SetCurrentWeaponProficiency(4)
	end)
end

function SWEP:SquadAssignment()
	local Squad_Num = GetConVar( "Squad_Num" )

if self.Owner:GetClass() == "npc_citizen" then
	if Squad_Num:GetInt() == 1 then
	self.Weapon.Owner:SetKeyValue( "SquadName", "Rebel1" )
	end
	if Squad_Num:GetInt() == 2 then
	self.Weapon.Owner:SetKeyValue( "SquadName", "Rebel2" )
	end
	if Squad_Num:GetInt() == 3 then
	self.Weapon.Owner:SetKeyValue( "SquadName", "Rebel3" )
	end
	if Squad_Num:GetInt() == 4 then
	self.Weapon.Owner:SetKeyValue( "SquadName", "Rebel4" )
	end
	if Squad_Num:GetInt() == 5 then
	self.Weapon.Owner:SetKeyValue( "SquadName", "Rebel5" )
	end
	if Squad_Num:GetInt() == 6 then
	self.Weapon.Owner:SetKeyValue( "SquadName", "Rebel6" )
	end
	if Squad_Num:GetInt() == 7 then
	self.Weapon.Owner:SetKeyValue( "SquadName", "Rebel7" )
	end
	if Squad_Num:GetInt() == 8 then
	self.Weapon.Owner:SetKeyValue( "SquadName", "Rebel8" )
	end
	if Squad_Num:GetInt() == 9 then
	self.Weapon.Owner:SetKeyValue( "SquadName", "Rebel9" )
	end
	if Squad_Num:GetInt() == 10 then
	self.Weapon.Owner:SetKeyValue( "SquadName", "Rebel10" )
	end
end
if self.Owner:GetClass() == "npc_combine_s" or self.Owner:GetClass() == "npc_metropolice" then
	if Squad_Num:GetInt() == 1 then
	self.Weapon.Owner:SetKeyValue( "SquadName", "Combine1" )
	end
	if Squad_Num:GetInt() == 2 then
	self.Weapon.Owner:SetKeyValue( "SquadName", "Combine2" )
	end
	if Squad_Num:GetInt() == 3 then
	self.Weapon.Owner:SetKeyValue( "SquadName", "Combine3" )
	end
	if Squad_Num:GetInt() == 4 then
	self.Weapon.Owner:SetKeyValue( "SquadName", "Combine4" )
	end
	if Squad_Num:GetInt() == 5 then
	self.Weapon.Owner:SetKeyValue( "SquadName", "Combine5" )
	end
	if Squad_Num:GetInt() == 6 then
	self.Weapon.Owner:SetKeyValue( "SquadName", "Combine6" )
	end
	if Squad_Num:GetInt() == 7 then
	self.Weapon.Owner:SetKeyValue( "SquadName", "Combine7" )
	end
	if Squad_Num:GetInt() == 8 then
	self.Weapon.Owner:SetKeyValue( "SquadName", "Combine8" )
	end
	if Squad_Num:GetInt() == 9 then
	self.Weapon.Owner:SetKeyValue( "SquadName", "Combine9" )
	end
	if Squad_Num:GetInt() == 10 then
	self.Weapon.Owner:SetKeyValue( "SquadName", "Combine10" )
	end
end
end

AccessorFunc( SWEP, "fNPCMinBurst",                 "NPCMinBurst" )
AccessorFunc( SWEP, "fNPCMaxBurst",                 "NPCMaxBurst" )
AccessorFunc( SWEP, "fNPCFireRate",                 "NPCFireRate" )
AccessorFunc( SWEP, "fNPCMinRestTime",         "NPCMinRest" )
AccessorFunc( SWEP, "fNPCMaxRestTime",         "NPCMaxRest" )

function SWEP:OnDrop()
	self:Remove()
end