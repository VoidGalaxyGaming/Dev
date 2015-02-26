SWEP.Category				= ""
SWEP.Author					= "Buzzofwar and roguex100"
SWEP.Contact				= "Buzzofwar and roguex100"
SWEP.Purpose				= "To make an epic battle"
SWEP.Instructions			= ""
SWEP.MuzzleAttachment		= "1" 		
SWEP.ViewModel				= ""
SWEP.WorldModel				= "models/charleville/w_charleville.mdl"
SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false

SWEP.Primary.ClipSize			= 1					// Size of a clip
SWEP.Primary.DefaultClip		= 8					// Default number of bullets in a clip
SWEP.Primary.Automatic			= false				// Automatic/Semi Auto
SWEP.Primary.Ammo				= "SMG1"	
SWEP.Primary.Damage				= 100
SWEP.Primary.Penetrate			= 10
SWEP.Primary.NumberofShots 		= 1
SWEP.Primary.Sound         		= Sound("musket/muskfire.wav")
SWEP.CooldownTimer          	= false
SWEP.HoldType 					= "ar2"  
  
function smoke(ent, speed, rate, size1, size2, length)
if SERVER then
local smoke = ents.Create("env_steam")
if ent:IsPlayer() then
	smoke:SetPos(ent:GetShootPos())
	smoke:SetKeyValue("Angles", tostring(ent:EyeAngles()))
else
	smoke:SetPos(ent:GetPos())
	smoke:SetKeyValue("Angles", tostring(Angle(0,0,0)))
end

smoke:SetKeyValue("InitialState", "1")
smoke:SetKeyValue("Speed", speed)
smoke:SetKeyValue("Rate", rate)
smoke:SetKeyValue("StartSize", size1)
smoke:SetKeyValue("EndSize", size2)
smoke:SetKeyValue("JetLength", length)
smoke:SetKeyValue("SpreadSpeed", "2")
smoke:SetKeyValue("SpawnFlags", "1")
smoke:Spawn()
smoke:Activate()
smoke:Fire("TurnOn", "", 0)
smoke:Fire("TurnOff","", 10)
smoke:Fire("kill", "", 5)
end
end

function SWEP:Initialize()  
self:SetWeaponHoldType( self.HoldType )
end 

function SWEP:PrimaryAttack()
  if (!self:IsValid()) or (!self.Owner:IsValid()) then return;end
	if self:Clip1() <= 0 then self:NpcReload()
	return end 

		self.Weapon:EmitSound(self.Primary.Sound)
	local MuzzleToggle = GetConVar( "NPC_WEP2_Muzzle_fx" )
	if MuzzleToggle:GetInt() == 1 then
		local fx 		= EffectData()
		fx:SetEntity(self.Weapon)
		fx:SetOrigin(self.Owner:GetPos())
		fx:SetNormal(self.Owner:GetAimVector())
		fx:SetAttachment(self.MuzzleAttachment)
		util.Effect("gdcw_muzzlesst",fx)
  smoke(self.Owner, "50", "13", "10", "50", "400")
	end
		self:TakePrimaryAmmo( 1 )
		
			local bullet = {} 
		bullet.Num = self.Primary.NumberofShots //The number of shots fired
		bullet.Src = self.Owner:GetShootPos() //Gets where the bullet comes from
		bullet.Dir = self.Owner:GetAimVector() //Gets where you're aiming
                //The above, sets how far the bullets spread from each other. 
		bullet.Tracer = 2 
		bullet.Force  = 2
		bullet.Spread = Vector(0,0,0)
		bullet.Damage = self.Primary.Damage 
		bullet.AmmoType = self.Primary.Ammo 
		self.Owner:FireBullets( bullet )
end

function SWEP:Reload()

end

function SWEP:NpcReload()
	if !self:IsValid() or !self.Owner:IsValid() then return; end
	self.Owner:SetSchedule(SCHED_RELOAD)

end

function SWEP:NPCShoot_Primary( ShootPos, ShootDir )
if !self:IsValid() or !self.Owner:IsValid() then return; end
 if self.CooldownTimer then return end
	self:PrimaryAttack()
	self.CooldownTimer = true
	timer.Simple(5,function()
	self.CooldownTimer = false
	end)
end