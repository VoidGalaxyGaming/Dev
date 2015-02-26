----------------------------------------------------------------------------------------------------------------|
--Buzzofwar-- Please do not steal or copy this! I  put much effort and time into perfecting it to make it simple|
----------------------------------------------------------------------------------------------------------------|

//General Settings \\
SWEP.Author 			= "Buzzofwar"                           -- Your name.
SWEP.Contact 			= "Buzzofwar"                     		-- How Pepole chould contact you.
SWEP.base 				= "weapon_base"							-- What base should the swep be based on.
SWEP.ViewModel 			= "models/weapons/v_longpattern.mdl" 									-- The viewModel, the model you se when you are holding it.
SWEP.WorldModel 		= "models/longpattern/w_longpattern_nobayo.mdl"   									-- The worlmodel, The model yu when it's down on the ground.
SWEP.HoldType 			= "ar2"                            		-- How the swep is hold Pistol smg greanade melee.
SWEP.PrintName 			= "LongPattern(Blue)"                         			-- your sweps name.
SWEP.Category 			= "Revolutionary"                					-- Make your own catogory for the swep.
SWEP.Instructions 		= ""              						-- How do pepole use your swep.
SWEP.Purpose 			= ""          							-- What is the purpose with this.
SWEP.AdminSpawnable 	= true                          		-- Is the swep spawnable for admin.
SWEP.ViewModelFlip 		= false									-- If the model should be fliped when you see it.
SWEP.UseHands			= false									-- Weather the player model should use its hands.
SWEP.AutoSwitchTo 		= true                           		-- when someone walks over the swep, chould i automatectly change to your swep.
SWEP.Spawnable 			= true                               	-- Can everybody spawn this swep.
SWEP.AutoSwitchFrom 	= true                         			-- Does the weapon get changed by other sweps if you pick them up.
SWEP.FiresUnderwater 	= false                       			-- Does your swep fire under water.
SWEP.DrawCrosshair 		= true                           		-- Do you want it to have a crosshair.
SWEP.DrawAmmo 			= true                                 	-- Does the ammo show up when you are using it.
SWEP.ViewModelFOV 		= 65                      		-- How much of the weapon do u see.
SWEP.Weight 			= 0                                   	-- Chose the weight of the Swep.
SWEP.SlotPos 			= 0                                    	-- Deside wich slot you want your swep do be in.
SWEP.Slot 				= 0                                     -- Deside wich slot you want your swep do be in.
SWEP.SwayScale			= 0										-- The Sway.
SWEP.BobScale			= 0										-- The amount of bob there should be.
//General settings\\
--------------------------------------------------------------------------------|
SWEP.Base						= "weapon_base"
SWEP.Primary.Ammo         		= "357"
SWEP.Primary.Sound 				= "longpattern/longpattern1.wav"     
SWEP.Primary.TakeAmmo 			= 1
SWEP.Primary.Recoil				= 5
SWEP.Primary.Spread 			= 0 
SWEP.Primary.Damage				= 500
SWEP.Primary.ClipSize			= 1
SWEP.Primary.DefaultClip		= 12
SWEP.Primary.NumberofShots 		= 1
SWEP.Primary.Delay 				= 1
SWEP.Primary.Force 				= 2
SWEP.Primary.Automatic   		= false							
SWEP.Primary.BulletShot 		= true
--------------------------------------------------------------------------------|
SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Delay 			= 1
SWEP.Secondary.Ammo				= "none"
SWEP.Secondary.Damage				= 100
--------------------------------------------------------------------------------|
SWEP.IronSightsPos 		= Vector (-7.5, 90, 6.5)
SWEP.IronSightsAng 		= Vector (0, .2, 0)
SWEP.RunArmOffset 		= Vector (0, 0, 5.5)
SWEP.RunArmAngle 		= Vector (-35, -3, 0)					-- Dont change this.
--------------------------------------------------------------------------------|
function SWEP:Initialize()  
self:SetWeaponHoldType( self.HoldType )
----

end 

--------------------------------------------------------------------------------|
function SWEP:SetupDataTables()  
	self:DTVar("Bool", 0, "Holsted")
	self:DTVar("Bool", 1, "Ironsights")
	self:DTVar("Bool", 2, "Scope")
	self:DTVar("Bool", 3, "Mode")
end 
--------------------------------------------------------------------------------|
function SWEP:Precache()
	util.PrecacheSound(self.Primary.Sound)
	util.PrecacheModel(self.ViewModel)
	util.PrecacheModel(self.WorldModel)
end
--------------------------------------------------------------------------------|
function SWEP:Think()	
end
--------------------------------------------------------------------------------|
function smoke(ent, speed, rate, size1, size2, length)
if SERVER then
local smoke = ents.Create("env_stream")
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
--------------------------------------------------------------------------------|
function SWEP:PrimaryAttack()

   if ( !self:CanPrimaryAttack() ) then return
    end
    local tr = self.Owner:GetEyeTrace();
   if ( self.Primary.BulletShot ) then
  smoke(self.Owner, "50", "13", "10", "50", "100")
	local bullet = {} 
		bullet.Num = self.Primary.NumberofShots //The number of shots fired
		bullet.Src = self.Owner:GetShootPos() //Gets where the bullet comes from
		bullet.Dir = self.Owner:GetAimVector() //Gets where you're aiming
		bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
		bullet.Tracer = 1 
		bullet.Force = self.Primary.Force 
		bullet.Damage = self.Primary.Damage 
		bullet.AmmoType = self.Primary.Ammo 
		self.Owner:FireBullets( bullet );
	end
	
	local rnda = self.Primary.Recoil * -1 
	local rndb = self.Primary.Recoil * math.random(-1, 1) 
		self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
		self:ShootEffects()
		self.Weapon:MuzzleFlash()	
		self:EmitSound(Sound(self.Primary.Sound)) 
		self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) ) 
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:SetAnimation( PLAYER_ATTACK1 );
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end
--------------------------------------------------------------------------------|
local IRONSIGHT_TIME = 0.2
--------------------------------------------------------------------------------|
function SWEP:GetViewModelPosition(pos, ang)

	local bIron = self.Weapon:GetDTBool(1)	
	local DashDelta = 0
	
	if (self.Owner:KeyDown(IN_SPEED) or self.Weapon:GetDTBool(0)) then
	if (!self.DashStartTime) then
		self.DashStartTime = CurTime()
	end
		
		DashDelta = math.Clamp(((CurTime() - self.DashStartTime) / 0.1) ^ 1.2, 0, 1)
	else
	if (self.DashStartTime) then
		self.DashEndTime = CurTime()
	end
	
	if (self.DashEndTime) then
		DashDelta = math.Clamp(((CurTime() - self.DashEndTime) / 0.1) ^ 1.2, 0, 1)
		DashDelta = 1 - DashDelta
	if (DashDelta == 0) then self.DashEndTime = nil end
	end
	
		self.DashStartTime = nil
	end
	
	if (DashDelta) then
		local Down = ang:Up() * -1
		local Right = ang:Right()
		local Forward = ang:Forward()
		local bUseVector = false
		
	if(!self.RunArmAngle.pitch) then
		bUseVector = true
	end
		
	if (bUseVector == true) then
		ang:RotateAroundAxis(ang:Right(), self.RunArmAngle.x * DashDelta)
		ang:RotateAroundAxis(ang:Up(), self.RunArmAngle.y * DashDelta)
		ang:RotateAroundAxis(ang:Forward(), self.RunArmAngle.z * DashDelta)
			
		pos = pos + self.RunArmOffset.x * ang:Right() * DashDelta 
		pos = pos + self.RunArmOffset.y * ang:Forward() * DashDelta 
		pos = pos + self.RunArmOffset.z * ang:Up() * DashDelta 
	else
		ang:RotateAroundAxis(Right, elf.RunArmAngle.pitch * DashDelta)
		ang:RotateAroundAxis(Down, self.RunArmAngle.yaw * DashDelta)
		ang:RotateAroundAxis(Forward, self.RunArmAngle.roll * DashDelta)

		pos = pos + (Down * self.RunArmOffset.x + Forward * self.RunArmOffset.y + Right * self.RunArmOffset.z) * DashDelta			
	end
		
	if (self.DashEndTime) then
	return pos, ang
	end
	end

	if (bIron != self.bLastIron) then
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
		
	end
	
	local fIronTime = self.fIronTime or 0

	if (!bIron && fIronTime < CurTime() - IRONSIGHT_TIME) then 
		return pos, ang
	end
	
	local Mul = 1.0
	
	if (fIronTime > CurTime() - IRONSIGHT_TIME) then
		Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)

	if (!bIron) then Mul = 1 - Mul end
	end
	
	if (self.IronSightsAng) then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(), 	self.IronSightsAng.x * Mul)
		ang:RotateAroundAxis(ang:Up(), 	self.IronSightsAng.y * Mul)
		ang:RotateAroundAxis(ang:Forward(), self.IronSightsAng.z * Mul)
	end	
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()	
	pos = pos + self.IronSightsPos.x * Right * Mul
	pos = pos + self.IronSightsPos.y * Forward * Mul
	pos = pos + self.IronSightsPos.z * Up * Mul
	return pos, ang
end
--------------------------------------------------------------------------------|
function SWEP:SetIronsights(b)

	if (self.Owner) then
		if (b) then
			if (SERVER) then
				self.Owner:SetFOV(30, 0.2)
			end

			if self.AllowIdleAnimation then
				if self.Weapon:GetDTBool(3) and self.Type == 2 then
					self.Weapon:SendWeaponAnim(ACT_VM_IDLE_SILENCED)
				else
					self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
				end

				self.Owner:GetViewModel():SetPlaybackRate(0)
			end

			self.Owner:EmitSound("npc/combine_soldier/gear4.wav")
		else
			if (SERVER) then
				self.Owner:SetFOV(0, 0.2)
			end

			if self.AllowPlaybackRate and self.AllowIdleAnimation then
				self.Owner:GetViewModel():SetPlaybackRate(1)
			end	

			self.Owner:EmitSound("npc/combine_soldier/gear4.wav")
		end
	end

	if (self.Weapon) then
		self.Weapon:SetDTBool(1, b)
	end
end
--------------------------------------------------------------------------------|
SWEP.NextSecondaryAttack = 0
--------------------------------------------------------------------------------|
function SWEP:SecondaryAttack()
	if self.Owner:IsNPC() then return end
	if not IsFirstTimePredicted() then return end

	if (self.Owner:KeyDown(IN_USE) and (self.Mode)) then // Mode
		bMode = !self.Weapon:GetDTBool(3)
		self:SetMode(bMode)
		self:SetIronsights(false)

		self.Weapon:SetNextPrimaryFire(CurTime() + self.data.Delay)
		self.Weapon:SetNextSecondaryFire(CurTime() + self.data.Delay)

		return
	end

	if (!self.IronSightsPos) or (self.Owner:KeyDown(IN_SPEED) or self.Weapon:GetDTBool(0)) then return end
	
	// Not pressing Use + Right click? Ironsights
	bIronsights = !self.Weapon:GetDTBool(1)
	self:SetIronsights(bIronsights)

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.2)
end
--------------------------------------------------------------------------------|
function SWEP:Deploy()
   self.Weapon:SendWeaponAnim(ACT_VM_DRAW);
   self.Weapon:EmitSound ""
   return true
end
--------------------------------------------------------------------------------|
function SWEP:Holster()
	timer.Create( "UniqueName2", 0, 1, function() if (not IsValid(self)) then timer.Destroy("UniqueName1") return; end
 self.Owner:SetWalkSpeed( 250 ) end )
	timer.Create( "UniqueName1", 0, 1, function() if (not IsValid(self)) then timer.Destroy("UniqueName2") return; end
 self.Owner:SetRunSpeed( 500 ) end )
	self.Weapon:EmitSound ""
   return true
   
end
--------------------------------------------------------------------------------|
function SWEP:Reload()
	self:SetNextPrimaryFire( CurTime() + 1.8)
	if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then return end
	if ( self.Weapon:Clip1() < self.Primary.ClipSize && self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
		self.Weapon:SetNetworkedBool( "reloading", true )
		self.Weapon:SetVar( "reloadtimer", CurTime() + 0.6 )
		self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
		self.Weapon:EmitSound("longpattern/reload.wav")
end
end
--------------------------------------------------------------------------------|
local Time = CurTime()
--------------------------------------------------------------------------------|
function SWEP:Reload()
	if ( self.Weapon:Ammo1() <= 0 ) then return end
	if ( self.Weapon:Clip1() >= self.Primary.ClipSize ) then return end
	if (CurTime() < Time + 0.5) then return end 
		self:EmitSound("longpattern/reload.wav")
	Time = CurTime()
	
	self.Owner:SetWalkSpeed(20)
	self.Owner:SetRunSpeed(20)
	timer.Create( "UniqueName2", 7, 1, function() if (not IsValid(self)) then timer.Destroy("UniqueName1") return; end
 self.Owner:SetWalkSpeed( 250 ) end )
	timer.Create( "UniqueName1", 7, 1, function() if (not IsValid(self)) then timer.Destroy("UniqueName2") return; end
 self.Owner:SetRunSpeed( 500 ) end )
	
	self.Owner:SetAnimation(PLAYER_RELOAD)
	self.Weapon:DefaultReload(ACT_VM_RELOAD)
end 
--------------------------------------------------------------------------------|
function SWEP:OnDrop()
return true
end
--------------------------------------------------------------------------------|
function SWEP:OnRemove()
end
--------------------------------------------------------------------------------|