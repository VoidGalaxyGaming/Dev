AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "ai_translations.lua" )
SWEP.testtimer = false
include('shared.lua')
SWEP.IsCloaked              = false
SWEP.Weight				= 30		// Decides whether we should switch from/to this
SWEP.AutoSwitchTo			= true		// Auto switch to  we pick it up
SWEP.AutoSwitchFrom			= true		// Auto switch from  you pick up a better weapon
SWEP.timer = false
SWEP.NextFireTimer          = false
SWEP.FailedBlinkTimer       = false
function SWEP:Initialize()
	self:SetWeaponHoldType("melee")

	if self.Owner:GetClass() == "npc_metropolice" then
	self:SetWeaponHoldType("smg")
    end
	
	self.Owner:Fire( "GagEnable" ) 
	
	if self.Owner:GetClass() == "npc_citizen" then
	self.Weapon.Owner:Fire( "DisableWeaponPickup" )
	end
	 
	self:Proficiency()
	self.Weapon.Owner:SetKeyValue( "spawnflags", "256" )
	if self.Owner:GetClass() == "npc_combine_s" then
		if self.Weapon.Owner:LookupSequence("grenThrow") == nil then return end
		local seq = self.Weapon.Owner:LookupSequence("grenThrow") 
				if self.Weapon.Owner:GetSequenceName(seq) == "grenThrow" then
						self:SetWeaponHoldType("pistol")
						self:IsBaseCombineHoldType()
						else
						self:SetWeaponHoldType("shotgun")
					end
	end
	hook.Add( "Think", self, self.onThink )
end

function SWEP:onThink()
if !IsValid(self) or !IsValid(self.Owner) then return; end
self.Owner:ClearCondition(13)
self.Owner:ClearCondition(17)
self.Owner:ClearCondition(18)
self.Owner:ClearCondition(20)
self.Owner:ClearCondition(48)
self.Owner:ClearCondition(42)

if self.NextFireTimer == false and self.Owner:GetEnemy() then
self:NextFire()
end
	end
	
function SWEP:NextFire()
	if !self:IsValid() or !self.Owner:IsValid() then return; end
	if self.Owner:IsCurrentSchedule(SCHED_CHASE_ENEMY) then return end
	self.NextFireTimer = true
		self:Chase_Enemy()
	local randomtimer = math.Rand(0.6, 1)			
	timer.Simple(randomtimer, function()
	self.NextFireTimer = false
		end)
	end

function SWEP:Proficiency()
timer.Simple(0.5, function()
if !self:IsValid() or !self.Owner:IsValid() then return; end
 self.Owner:SetCurrentWeaponProficiency(4)
 self.Owner:CapabilitiesRemove( CAP_WEAPON_MELEE_ATTACK1 )
 self.Owner:CapabilitiesRemove( CAP_INNATE_MELEE_ATTACK1 )
 self.Owner:SetHealth(150)

	end)
end

function SWEP:GetCapabilities()
	return bit.bor( CAP_WEAPON_MELEE_ATTACK1 )
end

function SWEP:Chase_Enemy()
if !self:IsValid() or !self.Owner:IsValid() then return;end 	
if self.Owner:GetEnemy():GetPos():Distance(self:GetPos()) > 70 then
self.Owner:SetSchedule( SCHED_CHASE_ENEMY )
end
	if self.CooldownTimer == false and self.Owner:GetEnemy():GetPos():Distance(self:GetPos()) <= 85 then

	self.Owner:SetSchedule( SCHED_MELEE_ATTACK1 )
	self:NPCShoot_Primary( ShootPos, ShootDir )

	end
end
			
function SWEP:NPCShoot_Primary( ShootPos, ShootDir )
if !self:IsValid() or !self.Owner:IsValid() then return;end 
if !self.Owner:GetEnemy() then return end
self.CooldownTimer = true
local seqtimer = 0.4
if self.Owner:GetClass() == "npc_alyx" then
seqtimer = 0.8
end

timer.Simple(seqtimer, function()
if !self:IsValid() or !self.Owner:IsValid() then return;end 
if self.Owner:IsCurrentSchedule( SCHED_MELEE_ATTACK1 ) then
	self:PrimaryAttack()
		end
self.CooldownTimer = false		
	end)
end


AccessorFunc( SWEP, "fNPCMinBurst",                 "NPCMinBurst" )
AccessorFunc( SWEP, "fNPCMaxBurst",                 "NPCMaxBurst" )
AccessorFunc( SWEP, "fNPCFireRate",                 "NPCFireRate" )
AccessorFunc( SWEP, "fNPCMinRestTime",         "NPCMinRest" )
AccessorFunc( SWEP, "fNPCMaxRestTime",         "NPCMaxRest" )

function SWEP:OnDrop()
	local droppedprop = ents.Create( "prop_physics" )
	droppedprop:SetModel( "models/sabre/w_sabre.mdl" )
	droppedprop:SetPos( self:GetPos() )
	droppedprop:SetAngles( self:GetAngles() )
	droppedprop:SetKeyValue( "spawnflags", 4 + 512 )
	droppedprop:Fire("DisablePhyscannonPickup")
	
	self:Remove()
	droppedprop:Spawn()
end

function SWEP:CloakCheck()
self.IsCloaked = true
end

function SWEP:NotCloaked()
self.IsCloaked = false
end