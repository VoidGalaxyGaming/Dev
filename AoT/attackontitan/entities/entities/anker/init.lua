AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')
if (SERVER) then
resource.AddFile( "sound/aot/wire.mp3" )
resource.AddFile( "sound/aot/wire_hit.mp3" )
resource.AddFile( "sound/aot/wire_move.mp3" )
resource.AddFile( "sound/aot/wire_shoot.wav" )
end

local WireHit    = Sound("aot/wire_hit.wav")

function ENT:Initialize()
	self.Entity:SetNetworkedBool("Colide", false)
	self.Entity:SetNetworkedBool("Sound", false)
	self.Entity:SetVar("weld",false)
	self.Entity:SetVar("moveweld",false)
	self.target = nil
	
	local bone   = self.Owner:LookupBone("ValveBiped.Bip01_Head1")
    local pl     = self.Entity:GetOwner()
    local aimvec = pl:GetAimVector()
    self.aimAng = self.Entity:GetAngles()
	
	self.Entity.Team = self.Owner:Team()
	self.Entity:SetModel( "models/weapons/w_missile_launch.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetAngles( self.Entity:GetAngles() )
	self.Entity:SetPos( self.Entity:GetPos() )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	self.Entity:GetPhysicsObject():EnableGravity( true )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetParent( self.Entity )
	self.Entity:SetModelScale( 1, 0 )
	self.Entity:SetColor(Color(0, 0, 0, 0))
	self.Entity:SetRenderMode( RENDERMODE_TRANSALPHA )

	local phys = self.Entity:GetPhysicsObject()
	phys:ApplyForceCenter( aimvec * 50000 )
	
	local phys = self.Entity:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:EnableGravity(false)
		phys:SetMass(1)
		phys:EnableCollisions(true)
	end
end

function ENT:Think()
	local phys = self.Entity:GetPhysicsObject()
	
    if self.Entity:WaterLevel() != 0 then
 	    self.Entity:Remove()
    end
	
	if !self.Entity:GetVar("weld") then
	self.Entity:SetAngles( self.aimAng )
	phys:ApplyForceCenter( self.aimAng:Forward() * 50000 )
	end
	if self.Entity:GetVar("moveweld") then
	    if self.target:IsNPC() or self.target:IsPlayer() then
		    if IsValid( self.target ) then
			    if self.target:Health() <= 0 then self.Entity:Remove() end
			    self.Entity:SetPos( (self.target:GetPos() + self.distance) )
	            self.Entity:SetAngles( self.Entity:GetAngles() )
			else
			    self.Entity:Remove()
			end
	    else
		    if IsValid( self.target ) then
	            self.Entity:SetPos( (self.target:GetPos() + self.distance) )
	            self.Entity:SetAngles( self.Entity:GetAngles() )
			else
			    self.Entity:Remove()
		    end
		end
	end
end

function ENT:PhysicsCollide( data, phys )
	local hitEnt = data.HitEntity
	
	self.Entity:SetVar("weld",true)
	
	self.Entity:EmitSound( WireHit )
	
	if hitEnt:IsWorld() then
       self.Entity:SetVar("moveweld",false)
	else
       self.Entity:SetVar("moveweld",true)
	   self.target = hitEnt
	end
	
	if !self.Entity:GetVar("moveweld") then
	   self.Entity:SetPos( data.HitPos - data.HitNormal * -0.5 )
	   self.Entity:SetAngles( self.Entity:GetAngles() )
	   self.Entity:GetPhysicsObject():EnableMotion(false)
	else
	   self.Entity:SetPos( data.HitPos - data.HitNormal * -1 )
	   self.Entity:SetAngles( self.Entity:GetAngles() )
	   self.Entity:GetPhysicsObject():EnableMotion(false)
	   self.distance = self.Entity:GetPos() - self.target:GetPos()
	end	
	
	self.Entity:SetNetworkedBool("Colide", true)
	self.Entity:SetNetworkedBool("Sound", true)
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WORLD )
	
	function self:PhysicsCollide() end
end

function ENT:OnRemove()
	self.Entity:SetNetworkedBool("Colide", false)
	self.Entity:SetNetworkedBool("Sound", false)
	self.Entity:SetVar("weld",false)
	self.Entity:SetVar("moveweld",false)
	self.target = nil
end