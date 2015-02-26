----------------------------------------------------------------------------------------------------------------|
--Buzzofwar-- Please do not steal or copy this! I  put much effort and time into perfecting it to make it simple|
----------------------------------------------------------------------------------------------------------------|
SWEP.base 				= "weapon_base"				-- Pointless Dont Touch 
SWEP.PrintName 			= "Sabre (Red)"  						-- The Main Name Of The SWEP
SWEP.ViewModel 			= "models/sabre/v_sabre_b.mdl" 						-- What Weapon The First Person View Sees
SWEP.WorldModel		    = "models/sabre/w_sabre.mdl" 						-- What Weapon The Third Person View Sees
SWEP.HoldType 		 	= "melee" 						-- How is The SWEP held (Knife/ Melee/ Melee2)
SWEP.Author 			= "Buzzofwar" 						-- Who Created This Swep. Clearly Buzzofwar
SWEP.Category 			= "Revolutionary" 						-- What Category Under Weapons Is This SWEP Found Under
SWEP.Instructions 		= ""   						-- How To Use SWEP
SWEP.Contact 			= "Buzzofwar"  						-- Who To Contact 
SWEP.Purpose 			= "" 						-- What The Fuck Does This SWEP Do
SWEP.ViewModelFOV 		= 55						-- How Much Of The First Person View Of The SWEP Can We See
SWEP.Slot 				= 0 						-- What Slot Should This SWEP Be Under (Always subtract 1 from where you want it to be)
SWEP.SlotPos 			= 0 						-- What Slot Position Should This SWEP Be Under (Always subtract 1 from where you want it to be)
SWEP.Weight 			= 0							-- How Heavy Is The Swep
SWEP.Spawnable 			= true  					-- Is The SWEP Spawnable In The Menu
SWEP.AutoSwitchFrom 	= true 						-- Does the weapon get changed by other sweps if you pick them up
SWEP.FiresUnderwater 	= true 						-- Can We Fire This SWEP Under Water
SWEP.DrawAmmo 			= false  					-- Should We Draw How Much Ammo The SWEP Has
SWEP.DrawCrosshair 		= true 						-- Should We Draw A Cross Hair
SWEP.AutoSwitchTo 		= true 						-- when someone walks over the swep, chould i automatectly change to your swep
SWEP.ViewModelFlip 		= false						-- If The Model Should Be Fliped When You See It
SWEP.UseHands			= false						-- Use Player Model Hands
----------------------------------------------------------------------------------------------------------------|
SWEP.Primary.Automatic 			= false     		-- Do We Have To Click Or Hold DOwn The Click
SWEP.Primary.Ammo 				= "none"  			-- What Ammo Does This SWEP Use (If Melee Then Use None)   
SWEP.Primary.Damage 			= 0                 -- How Much Damage Does The SWEP Do                         
SWEP.Primary.Spread	 			= 0                 -- How Much Of A Spread Is There (Should Be Zero)
SWEP.Primary.NumberofShots 		= 0                 -- How Many Shots Come Out (should Be Zero)
SWEP.Primary.Recoil 			= 0                 -- How Much Jump After An Attack        
SWEP.Primary.ClipSize			= 0                 -- Size Of The Clip
SWEP.Primary.Delay 				= 1                 -- How longer Till Our Next Attack       
SWEP.Primary.Force 				= 0                 -- The Amount Of Impact We Do To The World 
----------------------------------------------------------------------------------------------------------------|
SWEP.Secondary.ClipSize		    = -1                -------------------------Do Not Touch-----------------------|      
SWEP.Secondary.Ammo 			= "none"			-------------------------These Lines------------------------|  
----------------------------------------------------------------------------------------------------------------|
function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	if ( SERVER ) then
    self:SetWeaponHoldType(self.HoldType)
	end
end
----------------------------------------------------------------------------------------------------------------|
function SWEP:Deploy()
self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
self.Weapon:EmitSound "sabre/draw.wav"
end
----------------------------------------------------------------------------------------------------------------|
function SWEP:Holster()
   self.Weapon:EmitSound "sabre/draw.wav"
   return true
end
----------------------------------------------------------------------------------------------------------------|
function SWEP:PrimaryAttack()
local trace = self.Owner:GetEyeTrace()
self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 then
if ( trace.Hit ) then
self.Weapon:EmitSound("sabre/hitwall.wav")
	bullet = {}
	bullet.Num    = 1
	bullet.Src    = self.Owner:GetShootPos()
	bullet.Dir    = self.Owner:GetAimVector()
	bullet.Spread = Vector(0, 0, 0)
	bullet.Tracer = 0
	bullet.Force  = 5
	bullet.Damage = 45
	self.Owner:FireBullets(bullet)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 1 )
else
	self.Weapon:EmitSound( self.wallSound )	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end
else
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	self.Weapon:EmitSound("sabre/swing.wav")
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
end	
	timer.Simple( 0.05, function()
	self.Owner:ViewPunch( Angle( 0, 15, 0 ) )
end )

	timer.Simple( 0.2, function()
	self.Owner:ViewPunch( Angle( 4, -8, 0 ) )
end )
end
----------------------------------------------------------------------------------------------------------------|
function SWEP:SecondaryAttack()
self.Weapon:EmitSound("sabre/fire.wav")
end
----------------------------------------------------------------------------------------------------------------|