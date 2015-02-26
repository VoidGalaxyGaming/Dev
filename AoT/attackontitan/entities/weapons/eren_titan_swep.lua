SWEP.PrintName 		      = "Eren Titan" 
SWEP.Author 		      = "jsw0244 and fixed by BrownZFilmZ" 
SWEP.Instructions 	      = "Attack On Titan" 
SWEP.Contact 		      = "jsw0244" 
SWEP.AdminSpawnable       = true 
SWEP.Spawnable 		      = true 
SWEP.ViewModelFlip        = false
SWEP.ViewModelFOV 	      = 75
SWEP.ViewModel			  = "models/titan_gm/v_hand_v2.mdl"
SWEP.WorldModel			  = "models/weapons/w_pistol.mdl"
SWEP.AutoSwitchTo 	      = false 
SWEP.AutoSwitchFrom       = true 
SWEP.DrawAmmo             = false 
SWEP.Base                 = "weapon_base" 
SWEP.Slot 			      = 1 
SWEP.SlotPos              = 1 
SWEP.HoldType             = "normal"
SWEP.DrawCrosshair        = true 
SWEP.Weight               = 0 

SWEP.SetWeaponHoldType    = ( normal )

SWEP.Category           = "AOT - Titans"

SWEP.FiresUnderwater      = true 
SWEP.Primary.Automatic    = false
SWEP.Primary.Ammo         = ""
SWEP.Secondary.Automatic  = false
SWEP.Secondary.Ammo       = ""

local SwingSound  = Sound( "aot/gtsswing.wav" )
local SteamSound  = Sound( "aot/gtssteam.wav" )
local JumpSound   = Sound( "aot/gtsimpact.wav" )
local StepSound   = Sound( "aot/gtsfootstep.wav" )
local size = 0
local jump = false
local wall = false
local Hull=0
local HullDuck=0
local OffsetDuck=0
local Offset=0

local hang = false

hook.Add("PlayerFootstep", "GiantessFootstep", 
function ( ply, pos, foot, sound, volume, rf )
	if ply:GetStepSize()==170 then
		if SERVER then
		    ply:EmitSound( StepSound )
		    for k, v in pairs(ents.FindInSphere( ply:GetPos() + Vector(0,0,200),1000 )) do
			    local dis = (ply:GetPos() - v:GetPos()):Length()
				local maxpunch = 3 - (dis / 200)
				local minpunch = -maxpunch
                if v:IsPlayer() then
				    if v:GetActiveWeapon():IsValid() then
					    if v:GetActiveWeapon():GetClass() != "eren_titan_swep" then
				            if v:Nick() != ply:Nick() then
							    if v:IsOnGround() then
	                                v:ViewPunch(Angle(math.random(minpunch,maxpunch),math.random(minpunch,maxpunch),math.random(minpunch,maxpunch)))
					            end
							end
						end
					else
				        if v:Nick() != ply:Nick() then
						    if v:IsOnGround() then
	                            v:ViewPunch(Angle(math.random(minpunch,maxpunch),math.random(minpunch,maxpunch),math.random(minpunch,maxpunch)))
					        end
					    end
					end
			    elseif v:GetMoveType()==MOVETYPE_VPHYSICS then
					local phys = v:GetPhysicsObject()
					//phys:SetVelocity( Vector(math.random(-10,10),math.random(-10,10), 100 - ( dis / 20 ) ) )
		            //v:TakeDamage(1, ply, ply)
			    end
	        end
		end
	end
		
		return true
end)

hook.Add("PlayerStepSoundTime", "GiantessStepSoundTime",
function( ply, iType, bWalking )
	if ply:GetStepSize()==170 then
		local fStepTime = 350
		local fMaxSpeed = ply:GetMaxSpeed()
		if ( iType == STEPSOUNDTIME_NORMAL || iType == STEPSOUNDTIME_WATER_FOOT ) then
			if ( fMaxSpeed <= 100 ) then 
				fStepTime = 425
			elseif ( fMaxSpeed <= 400 ) then 
				fStepTime = 425
			else 
				fStepTime = 300
			end
		elseif ( iType == STEPSOUNDTIME_ON_LADDER ) then
			fStepTime = 450 
		elseif ( iType == STEPSOUNDTIME_WATER_KNEE ) then
			fStepTime = 600 
		end
		if ( ply:Crouching() ) then
			fStepTime = fStepTime + 50
		end
		return fStepTime
	end
end)
/*
hook.Add("GetFallDamage", "GiantessFallDamage", 
function( ply, speed )
	if ply:GetStepSize() == 170 then
		if SERVER then
		    if speed > 500 then
			    ply:EmitSound( JumpSound )
		        ply:ViewPunch( Angle( math.random(-20, 20), math.random(-15,15), math.random(-10,10) ) )
			end
		end
		if not ply:Crouching() then
			ply:DoAnimationEvent( ACT_HL2MP_IDLE )
		end
		return false
	end
end)
*/

function GiantCollide( ent1, ent2 )
 
	if ( ent1:IsPlayer() and ent2:IsPlayer() ) then
		return false
	end 
end
hook.Add( "ShouldCollide", "GiantShouldCollide", GiantCollide )

function SWEP:Deploy()
	local ply = self:GetOwner()
	if SERVER then
	    if not ply:Alive() or ply:GetStepSize() == 170 then return end
		
	    size = 5
		
		rand = math.random(0,5)
		
		if rand == 0 then 
		    jump = true 
		    ply:SetJumpPower( 800 )
	        ply:PrintMessage( HUD_PRINTCENTER , size.."m 점프 기행종" )
		else
		    ply:SetJumpPower( 0 )
	        ply:PrintMessage( HUD_PRINTCENTER , size.."m 거인" )
		end
		
		if size == 3 then
		    Hull = 210
	        HullDuck = 120
			Offset = 210
		    OffsetDuck = 120
		elseif size == 4 then
		    Hull = 260
			HullDuck = 160
			Offset = 260
		    OffsetDuck = 160
		elseif size == 5 then
		    Hull = 350
			HullDuck = 220
			Offset = 350
		    OffsetDuck = 220
		elseif size == 6 then
		    Hull = 430
			HullDuck = 250
			Offset = 430
		    OffsetDuck = 250
		elseif size == 7 then
		    Hull = 500
			HullDuck = 300
			Offset = 500
		    OffsetDuck = 300
		elseif size == 8 then
		    Hull = 540
			HullDuck = 360
			Offset = 540
		    OffsetDuck = 360
		else
		    Hull = 620
			HullDuck = 500
			Offset = 620
		    OffsetDuck = 500
		end
		ply:SetModelScale( size,1.5 )
		ply:SetViewOffset( Vector(0,0,Offset)  )
		ply:SetViewOffsetDucked( Vector(0,0,OffsetDuck ) )
		ply:SetHull( Vector(-20, -20, 0), Vector(20, 20, Hull) )
		ply:SetHullDuck( Vector(-20, -20, 0), Vector(20, 20, HullDuck) )

		size = size - 3
		
		ply:SetModel( "models/olddeath_gm/kyojin/eren_titan_form.mdl" )
		ply:DrawViewModel( true )
		ply:SetGravity( 2 )
		ply:SetCrouchedWalkSpeed( 0.6 )
	    ply:SetStepSize( 170 )
		ply:SetHealth( 50000 )
		ply:SetWalkSpeed( 400 )
		ply:SetRunSpeed( 800 )
		ply:SetAvoidPlayers( false ) 
		if ply:Alive() != nil then
		timer.Create("SuperBigMugiRun"..ply:UniqueID(), 0.6, 0, function()
			if ply:Alive() and ply:GetStepSize() == 170 then
				if ( ply:GetVelocity():Length() > 599 ) and ( ply:OnGround() ) then
				    ply:DoAnimationEvent( ACT_HL2MP_RUN_CHARGING  )  //차징
					//ply:DoAnimationEvent( ACT_HL2MP_RUN_PROTECTED )  //보호
					//ply:DoAnimationEvent( ACT_HL2MP_RUN_FAST )         //빨리달리기
				end
			else
				timer.Destroy("SuperBigMugiRun"..ply:UniqueID())
			end
		end)
		
		timer.Create("SuperBigMugiWalk"..ply:UniqueID(), 0.9, 0, function()
			if ply:Alive() and ply:GetStepSize() == 170 then
				if ply:GetVelocity():Length() < 500 and ply:GetVelocity():Length() > 399 and ply:OnGround() then
					ply:DoAnimationEvent(ACT_HL2MP_WALK)
				end
			else
				timer.Destroy("SuperBigMugiWalk"..ply:UniqueID())
			end
		end)
			
		timer.Create("SuperBigMugiCrush"..ply:UniqueID(), 0.01, 0, function()
			if ply:Alive() then
				local tracedata = {}
				local vector = 75 + ( size * 5 )
				local pos = ply:GetPos()
				tracedata.start = pos + ( Vector( 0, 0, 10 + ( 4 * size ) ) )
				tracedata.endpos = pos + ( Vector( 0, 0, -1 ) )
				tracedata.filter = ply
				tracedata.mins = Vector( -vector,-vector,-10 - ( 4 * size ) )
				tracedata.maxs = Vector( vector,vector,10 + ( 4 * size ) )
			    
				local trace = util.TraceHull(tracedata)
				if trace.Hit then
					if trace.Entity:IsPlayer() and trace.Entity:GetActiveWeapon():IsValid() then
					    if trace.Entity:GetActiveWeapon():GetClass() != "eren_titan_swep" then
						    trace.Entity:SetVelocity( ply:GetForward() * 2000 )
					        local dmg = DamageInfo()
					        dmg:SetDamage( 5000 )
					        dmg:SetAttacker( ply )
					        dmg:SetInflictor( ply )
                            dmg:SetDamageType( DMG_GENERIC )
					        trace.Entity:TakeDamageInfo( dmg )
					        ply:EmitSound( "physics/flesh/flesh_squishy_impact_hard3.wav", 100, 100 )
						end
					elseif trace.Entity:IsPlayer() and not trace.Entity:GetActiveWeapon():IsValid() then
					    local dmg = DamageInfo()
					    dmg:SetDamage(5000)
					    dmg:SetAttacker(ply)
					    dmg:SetInflictor(ply)
					    dmg:SetDamageType( DMG_GENERIC )
					    trace.Entity:TakeDamageInfo( dmg )
					    ply:EmitSound( "physics/flesh/flesh_squishy_impact_hard3.wav", 100, 100 )
					elseif trace.Entity:IsNPC() then
					    local dmg = DamageInfo()
					    dmg:SetDamage( 5000 )
					    dmg:SetAttacker( ply )
					    dmg:SetInflictor( ply )
					    dmg:SetDamageType( DMG_GENERIC )
					    trace.Entity:TakeDamageInfo( dmg )
					    ply:EmitSound( "physics/flesh/flesh_squishy_impact_hard3.wav", 100, 100 )
					else
					    if SERVER then
						    if trace.Entity:GetMoveType()==MOVETYPE_VPHYSICS then
						        local phys = trace.Entity:GetPhysicsObject()
						        phys:SetVelocity( ply:GetForward() * 2000 )
							end
				        end
					end
				end
			else
				timer.Destroy("SuperBigMugiCrush"..ply:UniqueID())
			end
		end)
		end
	end
end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:Holster()
	if ply != nil and ply:SetColor() != nil then
	local ply = self:GetOwner()
	ply:SetColor( Color( 255, 255, 255 ) )
	end
end

function SWEP:DrawWorldModel()
    return false
end

function SWEP:OnRemove()
	self:Holster()
	
	local ply = self:GetOwner()
	
	if SERVER then
		ply:EmitSound( SteamSound )	
	    ply:SetModelScale(1, 1)
	    ply:SetViewOffset(Vector(0,0,64))
	    ply:SetViewOffsetDucked(Vector(0,0,28))
	    ply:SetJumpPower(200)
	    ply:SetGravity(0)
		ply:SetStepSize(18)
	    ply:SetCrouchedWalkSpeed(0.3)
	    ply:ResetHull()
	    ply:SetWalkSpeed(200)
	    ply:SetRunSpeed(400)
		ply:Freeze( false )
	
	    local effectdata = EffectData()
	    effectdata:SetOrigin( ply:GetPos() )
	    effectdata:SetAngles( Angle(0,0,0) )
	    util.Effect( "titan_smoke", effectdata, true, true )
	end
	
end

function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:Think()
    self:NextThink(CurTime())
	if self.Owner:GetModel() == "models/player/zombie_fast.mdl" then 
	    if SERVER then 
	        self.Owner:ChatPrint("It doesn't work on this player model") 
			self.Owner:Kill() 
		end 
	end
end

function SWEP:PrimaryAttack()
    self:SendWeaponAnim( ACT_VM_HITCENTER )
	self.Owner:EmitSound( SwingSound )
    self.Owner:DrawViewModel( true )
	self.Weapon:SetNextPrimaryFire( CurTime() + 1 )
	
	local ply = self:GetOwner()
	local wep = self
	
	ply:DoAnimationEvent( ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND )
	
	timer.Simple(0.01, function()
		if SERVER then
		if not IsValid(wep) or not ply:Alive() then
			return
		end
	
		local tr = {}
		
	    self.Owner:LagCompensation(true)
		tr.start = ply:GetShootPos() - ply:GetAimVector() * 5
		tr.endpos = tr.start + ply:GetAimVector() * (280 + ( size * 20 )) 
		tr.filter = ply
		tr.mins = Vector(-50,-50,-50 - ( 5 * size ))
		tr.maxs = Vector(50,50,50 + ( 5 * size ))
		
		trace = util.TraceHull(tr)
	    
		if trace.Hit then
			ent = trace.Entity
			physobj = ent:GetPhysicsObject()
			cl = ent:GetClass()
			
			if physobj:IsValid() then
				physobj:AddVelocity(ply:GetAimVector() * 250)
			end
			
            if ent:IsPlayer() and ent:GetActiveWeapon():IsValid() then
                if ent:GetStepSize()!= 170 then
				    if SERVER then
						ent:SetVelocity(ply:GetForward() * 2000)
				        ent:TakeDamage(500,ply,ply)
				        ply:EmitSound("physics/flesh/flesh_squishy_impact_hard3.wav", 100, 100)
				    end
				end
			elseif	ent:IsPlayer() and not ent:GetActiveWeapon():IsValid() then
			    if SERVER then
					ent:SetVelocity(ply:GetForward() * 2000)
				    ent:TakeDamage(500,ply,ply)
				    ply:EmitSound("physics/flesh/flesh_squishy_impact_hard3.wav", 100, 100)
				end
            elseif ent:IsNPC() then
                if SERVER then
					ent:SetVelocity(ply:GetForward() * 2000)
				    ent:TakeDamage(500,ply,ply)
				    ply:EmitSound("physics/flesh/flesh_squishy_impact_hard3.wav", 100, 100)
				end
            else
			    if SERVER then
					ent:SetVelocity(ply:GetForward() * 2000)
				    ent:TakeDamage(500,ply,ply)
				end
				if cl == "func_breakable_surf" then
					ent:Input("Shatter", NULL, NULL, "")
					ply:EmitSound("physics/glass/glass_impact_bullet" .. math.random(1, 3) .. ".wav", 80, math.random(95, 105))
				    end
			    end			
		    end
		end
		
	    self.Owner:LagCompensation(false)
	end)
end	
  
function SWEP:SecondaryAttack()
    self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    self.Owner:DrawViewModel(true)
	self.Weapon:SetNextSecondaryFire( CurTime() + 1.5 )
end

function SWEP:Reload()
end