include('shared.lua')

local wire = Material("cable/cable")

function ENT:Initialize()	
	self.Size = 0
	self.MainStart = self.Entity:GetPos()
	self.MainEnd = self:GetEndPos()
	self.dAng = (self.MainEnd - self.MainStart):Angle()
	self.speed = 10000
	self.startTime = CurTime()
	self.endTime = CurTime() + self.speed
	self.dt = -1
end

function ENT:Think()
	self.Entity:SetRenderBoundsWS( self:GetEndPos() , self.Entity:GetPos(), Vector()*8 )
end

function ENT:Draw()
	self.Entity:DrawMainBeam()
end

function ENT:DrawMainBeam()
	local bone = self.Owner:LookupBone("ValveBiped.Bip01_Spine")
	if (bone) then
		position, angles = self.Owner:GetBonePosition( bone )
	end
	local End = position + (angles:Up() * 8) + (angles:Forward() * 0) + (angles:Right() * 0)
	local StartPos = self.Entity:GetPos()
	local StartAngle = self.Entity:GetAngles()
	local Start = StartPos + (StartAngle:Up() * 0) + (StartAngle:Forward() * -7.8) + (StartAngle:Right() * -0)
	
	render.SetMaterial( wire )
	render.DrawBeam( Start , End , 0.5, 0.5, 1, Color( 255, 255, 255, 255 ) ) 
end
