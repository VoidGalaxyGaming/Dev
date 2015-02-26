function EFFECT:Init( data )
	local NumParticles = 5
	local firedelay    = 0.1
	local Pos = data:GetOrigin()
    local ang = data:GetAngles()
	local emitter = ParticleEmitter( Pos )
	local owner = LocalPlayer()
if IsValid(emitter) then
	local particle = emitter:Add( "particle/particle_noisesphere", Pos + VectorRand() * 2)
		local bone = owner:LookupBone("ValveBiped.Bip01_Pelvis")
	    if (bone) then
	    local BonePos, BoneAngles = owner:GetBonePosition( bone )
	    end
		if IsValid(angles) and owner:IsAlive() then
		    ang:RotateAroundAxis(angles:Forward(), -120)
		    ang:RotateAroundAxis(angles:Up(), 0)
	        local vel = particle:GetVelocity()
			      ang = ang:Up()
		for i=0, NumParticles do
		particle:SetVelocity( Vector(0,0,0) )
		if IsValid(angles) then particle:SetAngles( angles ) end
		particle:SetGravity( Vector(0,0,0) )
		particle:SetDieTime( 1.5 )
		particle:SetLifeTime( 0 )
		particle:SetStartAlpha( 250 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 8 )
		particle:SetEndSize( 30 )
		particle:SetRoll( 0 )
		particle:SetRollDelta( 0 )
		particle:SetColor( 255, 255, 255 )	
		end
		end
end
	/*for i=0, NumParticles do
		timer.Simple( firedelay*i , function()
			local particle = emitter:Add( "particle/particle_noisesphere", owner:GetPos() + VectorRand() * 2 )
				  particle:SetGravity( Vector(0,0,-5) )
				  particle:SetVelocity( Vector(0,0,0) )
				  particle:SetDieTime( 1.5 )
				  particle:SetLifeTime( 0 )
				  particle:SetStartAlpha( 250 )
				  particle:SetEndAlpha( 0 )
				  particle:SetStartSize( 10 )
				  particle:SetEndSize( 15 )
			  	  particle:SetRoll( 0 )
				  particle:SetRollDelta( 0 )
				  particle:SetColor( 255, 255, 255 )
		end)
	end*/
end

function EFFECT:Think( )
	//return false
end

function EFFECT:Render()	
end


