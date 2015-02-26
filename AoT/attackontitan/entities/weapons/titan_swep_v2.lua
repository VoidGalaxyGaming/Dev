SWEP.PrintName 		      = "Titan V2" 
SWEP.Author 		      = "jsw0244 and fixed by BrownZFilmZ" 
SWEP.Instructions 	      = "Attack On Titan" 
SWEP.Contact 		      = "jsw0244" 
SWEP.AdminSpawnable       = true 
SWEP.Spawnable 		      = true 
SWEP.ViewModelFlip        = false
SWEP.ViewModelFOV 	      = 75
SWEP.ViewModel			  = "models/titan/v_hand_v2.mdl"
SWEP.WorldModel			  = "models/weapons/w_pistol.mdl"
SWEP.AutoSwitchTo 	      = false 
SWEP.AutoSwitchFrom       = true 
SWEP.DrawAmmo             = false 
SWEP.Base                 = "weapon_base" 
SWEP.Slot 			      = 1 
SWEP.SlotPos              = 1 
SWEP.HoldType             = "melee"
SWEP.DrawCrosshair        = false
SWEP.Weight               = 0 

SWEP.SetWeaponHoldType    = ( melee )

SWEP.Category           = "AOT - Titans"

SWEP.FiresUnderwater      = true 
SWEP.Primary.Automatic    = true
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

local TitanModel = {}
TitanModel[1] = ( "models/player/titan/titana/titana_00" )
TitanModel[2] =  ( "models/player/titan/titanb/titanb_00" )
TitanModel[3] = ( "models/player/titan/titanc/titanc_00" )
TitanModel[4] = ( "models/player/titan/titankyo/titankyo_00" )

local hang = false

hook.Add("PlayerFootstep", "GiantessFootstep", 
function ( ply, pos, foot, sound, volume, rf )
	if ply:GetStepSize()==170 then
		if SERVER then
		    ply:EmitSound( StepSound, 30, 100 )
		    for k, v in pairs(ents.FindInSphere( ply:GetPos() + Vector(0,0,200),1000 )) do
			    local dis = (ply:GetPos() - v:GetPos()):Length()
				local maxpunch = 3 - (dis / 200)
				local minpunch = -maxpunch
                if v:IsPlayer() then
				    if v:GetActiveWeapon():IsValid() then
					    if v:GetActiveWeapon():GetClass() != "titan_swep_v2" then
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
			    ply:EmitSound( JumpSound, 30, 100 )
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
		return true
end
hook.Add( "ShouldCollide", "GiantShouldCollide", GiantCollide )

function SWEP:Deploy()
	local ply = self:GetOwner()
if IsValid(ply) then
	if SERVER then
		size = math.random(4,9)
		//size = 4
		
		local PickModel = math.random(1,4)
		
	    if not ply:Alive() or ply:GetStepSize() == 170 then return end
		util.PrecacheModel(TitanModel[PickModel])
		ply:SetModel(TitanModel[PickModel] .. size .. ".mdl")
		ply:DrawViewModel( true )
		ply:SetGravity( 2 )
		ply:SetCrouchedWalkSpeed( 0.6 )
	    ply:SetStepSize( 170 )
		ply:SetHealth( 100 )
		ply:ResetHull()
		ply:SetAvoidPlayers( false ) 
		
		local rand = math.random(0,1)
		
		//ply:SetModelScale(size, 1.5)
		ply:SetViewOffset( Vector(0,0,64 * size) )
		ply:SetViewOffsetDucked( Vector(0,0,64 * size) )
		//ply:SetViewOffsetDucked( Vector(0,0,28 * size ) )
		ply:SetHull( Vector(-16 * size, -16 * size, 0), Vector(16 * size, 16 * size, 72 * size))
		ply:SetHullDuck( Vector(-16 * size, -16 * size, 0), Vector(16 * size, 16 * size, 72 * size))
		//ply:SetHullDuck( Vector(-16 * size, -16 * size, 0), Vector(16 * size, 16 * size, 36 * size))
		
        if size == 5 then
		local whatab = math.random(1,2)
		timer.Simple(0.5, function()
			if whatab == 1 then
				if ply:Team() == TEAM_TITAN_N then
					timer.Simple(0.5, function() ply:ChatPrint("You are a Abnormal Jumper Titan!") ply:PrintMessage( HUD_PRINTCENTER , "You are a Abnormal Jumper Titan!" ) end)
					ply:SetHealth( 100 )
					ply:SetWalkSpeed( 550 )
					ply:SetRunSpeed( 650 )
					ply:SetJumpPower( 1700 )
				end
			elseif whatab == 2 then
				if ply:Team() == TEAM_TITAN_N then
					timer.Simple(0.5, function() ply:ChatPrint("You are a Abnormal Runner Titan!") ply:PrintMessage( HUD_PRINTCENTER , "You are a Abnormal Runner Titan!" ) end)
					ply:SetHealth( 100 )
					ply:SetWalkSpeed( 550 )
					ply:SetRunSpeed( 1100 )
					ply:SetJumpPower( 400 )
				end
			end
		end)
		else
			ply:SetWalkSpeed( 550 )
			ply:SetRunSpeed( 650 )
			ply:SetJumpPower( 400 )
		end

		if size == 3 then 
		    jump = true 
		else
		    --ply:SetJumpPower( 500 )
			--ply:SetRunSpeed( 600 )
		end
		
		size = size - 3
		
		if ply:Alive() != nil then
		timer.Create("SuperBigMugiRun"..ply:UniqueID(), 0.6, 0, function()
		if IsValid(ply) then
			if ply:Alive() and ply:Team() == 1 then
				if ( ply:GetVelocity():Length() > 599 ) and ( ply:OnGround() ) then
				    //ply:DoAnimationEvent( ACT_HL2MP_RUN_CHARGING  )  //차징
					//ply:DoAnimationEvent( ACT_HL2MP_RUN_PROTECTED )  //보호
					ply:DoAnimationEvent( ACT_HL2MP_RUN )         //빨리달리기
				end
			else
				timer.Destroy("SuperBigMugiRun"..ply:UniqueID())
			end
		end
		end)
		
		timer.Create("SuperBigMugiWalk"..ply:UniqueID(), 0.9, 0, function()
		if IsValid(ply) then
			if ply:Alive() and ply:Team() == 1 then
				if ply:GetVelocity():Length() < 500 and ply:GetVelocity():Length() > 399 and ply:OnGround() then
					ply:DoAnimationEvent(ACT_HL2MP_WALK)
				end
			else
				timer.Destroy("SuperBigMugiWalk"..ply:UniqueID())
			end
		end
		end)
			
		timer.Create("SuperBigMugiCrush"..ply:UniqueID(), 0.01, 0, function()
		if IsValid(ply) and ply:IsOnGround() then
			if ply:Alive() and ply:Team() == 1 then
				local titanDamage = math.random(75,95)
				
				local tracedata = {}
				local vector = 75 + ( size * 5 )
				local pos = ply:GetPos()
				tracedata.start = pos + ( Vector( 0, 0, 10 + ( 4 * size ) ) )
				tracedata.endpos = pos + ( Vector( 0, 0, -1 ) )
				tracedata.filter = ply
				tracedata.mins = Vector( -vector,-vector,-10 - ( 4 * size ) )
				tracedata.maxs = Vector( vector,vector,8 + ( 4 * size ) )
			    
				local trace = util.TraceHull(tracedata)
				if trace.Hit then
					if trace.Entity:IsPlayer() and trace.Entity:GetActiveWeapon():IsValid() then
					    if trace.Entity:GetActiveWeapon():GetClass() != "titan_swep_v2" then
						    trace.Entity:SetVelocity( ply:GetForward() * 2000 )
					        local dmg = DamageInfo()
					        dmg:SetDamage( titanDamage )
					        dmg:SetAttacker( ply )
					        dmg:SetInflictor( ply )
                            dmg:SetDamageType( DMG_GENERIC )
					        trace.Entity:TakeDamageInfo( dmg )
					        ply:EmitSound( "physics/flesh/flesh_squishy_impact_hard3.wav", 30, 100 )
						end
					elseif trace.Entity:IsPlayer() and not trace.Entity:GetActiveWeapon():IsValid() then
					    local dmg = DamageInfo()
					    dmg:SetDamage(titanDamage)
					    dmg:SetAttacker(ply)
					    dmg:SetInflictor(ply)
					    dmg:SetDamageType( DMG_GENERIC )
					    trace.Entity:TakeDamageInfo( dmg )
					    ply:EmitSound( "physics/flesh/flesh_squishy_impact_hard3.wav", 30, 100 )
					elseif trace.Entity:IsNPC() then
					    local dmg = DamageInfo()
					    dmg:SetDamage( titanDamage )
					    dmg:SetAttacker( ply )
					    dmg:SetInflictor( ply )
					    dmg:SetDamageType( DMG_GENERIC )
					    trace.Entity:TakeDamageInfo( dmg )
					    ply:EmitSound( "physics/flesh/flesh_squishy_impact_hard3.wav", 30, 100 )
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
			end
		end)
		end
	end
end
end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:Holster()
	if ply != nil and ply:SetColor() != nil then
	local ply = self:GetOwner()
	//ply:SetColor( Color( 255, 255, 255 ) )
	end
end

function SWEP:DrawWorldModel()
    return false
end

function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:Think()
if SERVER then 
	if self.Owner:Team() != nil then
	if self.Owner:Team() != 1 then
			self:Remove()
		end
	end
end
	if self:GetModelScale(Vector(1, 1, 1)) then
		self:Deploy()
	end
    self:NextThink(CurTime())
	if self.Owner:GetModel() == "models/player/zombie_fast.mdl" then 
	    if SERVER then 
	        self.Owner:ChatPrint("It doesn't work on this player model") 
			self.Owner:Kill() 
		end 
	end
end

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()
	
	// This if statement prevents titans from attacking while moving.
	--if ply:KeyDown(IN_RUN)  or
		--ply:KeyDown(IN_FORWARD) or
		--ply:KeyDown(IN_BACK) or
		--ply:KeyDown(IN_MOVELEFT) or
		--ply:KeyDown(IN_MOVERIGHT) then
	--return //this means it skips everything below
	--end
	
    self:SendWeaponAnim( ACT_VM_HITCENTER )
	self.Owner:EmitSound( SwingSound, 30, 100 )
    self.Owner:DrawViewModel( true )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.8 )
	
	local wep = self
	local TitanDamage = math.random(27,43)
	
	local attackSide = math.random(1,3)
	
	if attackSide == 1 then
		ply:DoAnimationEvent( ACT_MELEE_ATTACK_SWING )
	elseif attackSide == 2 then
		ply:DoAnimationEvent( ACT_MELEE_ATTACK1 )
	elseif attackSide == 3 then
		ply:DoAnimationEvent( ACT_MELEE_ATTACK2 )
	end
	
	timer.Simple(0.01, function()
		if SERVER then
		if not IsValid(wep) or not ply:Alive() then
			return
		end
	
		local tr = {}
		
	    self.Owner:LagCompensation(true)
		
		tr.start = ply:GetShootPos()
		tr.endpos = tr.start + ply:GetAimVector() * (350 + ( (size + 3 ) * 25 ))
		//tr.start = ply:GetShootPos() - ply:GetAimVector() * 3
		//tr.endpos = tr.start + ply:GetAimVector() * (350 + ( size * 25 )) 
		tr.filter = ply
		tr.mins = Vector(-50,-50,-50 - ( 5 * (size +3)))
		tr.maxs = Vector(50,50,50 + ( 5 * (size + 3 )))
		
		trace = util.TraceHull(tr)
	    
		if trace.Hit then
			ent = trace.Entity
			physobj = ent:GetPhysicsObject()
			cl = ent:GetClass()
			
			if physobj:IsValid() then
				physobj:AddVelocity(ply:GetAimVector() * 250)
			end
			
			if ent:IsPlayer() and ent:GetActiveWeapon():GetClass() == "3d_maneuver_gear_c" then
				ent:GetActiveWeapon():RemoveAnker()
			elseif ent:IsPlayer() and ent:GetActiveWeapon():GetClass() == "3d_maneuver_gear_expert_c" then
				ent:GetActiveWeapon():LeftAnkerRemove()
				ent:GetActiveWeapon():RightAnkerRemove()
			end
			
            if ent:IsPlayer() and ent:GetActiveWeapon():IsValid() then
                if ent:GetStepSize()!= 170 then
				    if SERVER then
						local PreHealth = ent:Health()
						ent:SetVelocity(ply:GetForward() * 2000)
						local dmg = DamageInfo()
					    dmg:SetDamage( TitanDamage )
						dmg:ScaleDamage(1)
					    dmg:SetAttacker( ply )
					    dmg:SetInflictor( ply )
					    dmg:SetDamageType( DMG_GENERIC )
					    ent:TakeDamageInfo( dmg )
						print(PreHealth)
						print(ent:Health())
						print(TitanDamage)
						if PreHealth - TitanDamage != ent:Health() then
							ent:SetHealth(ent:Health() - (TitanDamage-(PreHealth-ent:Health())))
						end
						if ent:Health() <= 0 then
							local dmg = DamageInfo()
							dmg:SetDamage( 1 )
							dmg:ScaleDamage( 1 )
							dmg:SetAttacker( ply )
							dmg:SetInflictor( ply )
							dmg:SetDamageType( DMG_GENERIC )
							ent:TakeDamageInfo( dmg )
						end
						ent:ChatPrint("You took " .. TitanDamage .. " HP of Damage." .. "You have " .. ent:Health() .. " HP")
						ply:ChatPrint("You inflicted " .. TitanDamage .. " HP of Damage." .. "He has " .. ent:Health() .. " HP")
				        ply:EmitSound("physics/flesh/flesh_squishy_impact_hard3.wav", 30, 100)
				    end
				end
			elseif	ent:IsPlayer() and not ent:GetActiveWeapon():IsValid() then
			    if SERVER then
					ent:SetVelocity(ply:GetForward() * 2000)
						local dmg = DamageInfo()
					    dmg:SetDamage( TitanDamage )
						dmg:ScaleDamage(1)
					    dmg:SetAttacker( ply )
					    dmg:SetInflictor( ply )
					    dmg:SetDamageType( DMG_GENERIC )
					    ent:TakeDamageInfo( dmg )
						if OldHealth - TitanDamage != ent:Health() then
							ent:SetHealth(TitanDamage-(OldHealth-ent:Health()))
						end
						if ent:Health() <= 0 then
							local dmg = DamageInfo()
							dmg:SetDamage( 1 )
							dmg:ScaleDamage( 1 )
							dmg:SetAttacker( ply )
							dmg:SetInflictor( ply )
							dmg:SetDamageType( DMG_GENERIC )
							ent:TakeDamageInfo( dmg )
						end
					ent:ChatPrint("You took " .. TitanDamage .. " HP of Damage." .. "You have " .. ent:Health() .. " HP")
					ply:ChatPrint("You inflicted " .. TitanDamage .. " HP of Damage." .. "He has " .. ent:Health() .. " HP")
				    ply:EmitSound("physics/flesh/flesh_squishy_impact_hard3.wav", 30, 100)
				end
            elseif ent:IsNPC() then
                if SERVER then
					ent:SetVelocity(ply:GetForward() * 2000)
				    ent:TakeDamage(500,ply,ply)
				    ply:EmitSound("physics/flesh/flesh_squishy_impact_hard3.wav", 30, 100)
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
	end)
	self.Owner:LagCompensation(false)
end	
  
function SWEP:SecondaryAttack()
    self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    self.Owner:DrawViewModel(true)
	self.Weapon:SetNextSecondaryFire( CurTime() + 1.5 )
end

function SWEP:Reload()
end

function SWEP:OnRemove()
	self:Holster()
	
	local ply = self:GetOwner()
	
	if SERVER then
		--ply:EmitSound( SteamSound, 30, 100 )	
	    ply:SetModelScale(1, 1)
	    ply:SetViewOffset(Vector(0,0,64))
	    ply:SetViewOffsetDucked(Vector(0,0,28))
	    --ply:SetJumpPower(200)
	    ply:SetGravity(0)
		ply:SetStepSize(18)
	    ply:SetCrouchedWalkSpeed(0.3)
	    ply:ResetHull()
		ply:Freeze( false )
	
	    local effectdata = EffectData()
	    effectdata:SetOrigin( ply:GetPos() )
	    effectdata:SetAngles( Angle(0,0,0) )
	    util.Effect( "titan_smoke", effectdata, true, true )
	end
end