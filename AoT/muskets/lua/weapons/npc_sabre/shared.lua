if( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Category = "NPC_WEAPONS"
SWEP.Author			= ""

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false
SWEP.GrenadeTimer       = false
SWEP.ViewModel      = ""
SWEP.WorldModel   = "models/sabre/w_sabre.mdl"
SWEP.RunAwayTimer          = false
SWEP.Primary.Damage		= math.random(35,45)
SWEP.StealthTimer           = false
SWEP.Primary.ClipSize		= -1					-- Size of a clip
SWEP.Primary.DefaultClip	= -1					-- Default number of bullets in a clip
SWEP.Primary.Automatic		= true				-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1					-- Size of a clip
SWEP.Secondary.DefaultClip	= -1					-- Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				-- Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"
SWEP.BaseCombineHoldType    = false
SWEP.Slash = 1
SWEP.IsCombine              = false
SWEP.CooldownTimer          = false

function SWEP:PrimaryAttack()
if !self:IsValid() or !self.Owner:IsValid() then return;end 
	pos = self.Owner:GetShootPos()
	ang = self.Owner:GetAimVector()
	damagedice = math.Rand(0.9,1.50)
	pain = self.Primary.Damage * damagedice
			self.Weapon:EmitSound("sabre/swing.wav")
				if SERVER and IsValid(self.Owner) then
						local slash = {}
						slash.start = pos
						slash.endpos = pos + (ang * 70)
						slash.filter = self.Owner
						slash.mins = Vector(-5, -5, 0)
						slash.maxs = Vector(5, 5, 5)
						local slashtrace = util.TraceHull(slash)
						if slashtrace.Hit then
							targ = slashtrace.Entity
							if targ:GetClass() == self.Owner:GetClass() then return end
							if targ:IsPlayer() or targ:IsNPC() then
								self.Owner:EmitSound("sabre/hitwall.wav")								
								paininfo = DamageInfo()
								paininfo:SetDamage(pain)
								paininfo:SetDamageType(DMG_SLASH)
								paininfo:SetAttacker(self.Owner)
								paininfo:SetInflictor(self.Weapon)
						  local RandomForce = math.random(1000,10000)
								paininfo:SetDamageForce(slashtrace.Normal * RandomForce)
								if targ:IsPlayer() then
								targ:ViewPunch( Angle( -10, -20, 0 ) )
								end
							local blood = targ:GetBloodColor()	
						   local fleshimpact		= EffectData()
								fleshimpact:SetEntity(self.Weapon)
								fleshimpact:SetOrigin(slashtrace.HitPos)
								fleshimpact:SetNormal(slashtrace.HitPos)
								if blood >= 0 then
								fleshimpact:SetColor(blood)
								util.Effect("BloodImpact", fleshimpact)
								end
								
								if SERVER then targ:TakeDamageInfo(paininfo) end
							end
						end
					end
	end
				

function SWEP:IsBaseCombineHoldType()
self.BaseCombineHoldType = true
end


function SWEP:ChaseFailed()
self.FailedChase = true
end