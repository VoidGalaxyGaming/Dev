function EFFECT:Init( data )
	local numparticles = 80
	local Pos = data:GetOrigin()
    local ang = data:GetAngles()
	local Firedelay = 0.1
	local emitter = ParticleEmitter( Pos )
	local owner = LocalPlayer()
	local ply   = LocalPlayer()
		for i=0, numparticles do
			timer.Simple( Firedelay*i , function()
				if IsValid(emitter) then
				local particle = emitter:Add( "particle/particle_noisesphere", Pos + VectorRand() * 20 )
					  particle:SetGravity( Vector(0,0,0) )
					  particle:SetVelocity( Vector(0,0,150) )
					  particle:SetDieTime( 8 - (i*0.05) )
					  particle:SetLifeTime( 0 )
					  particle:SetStartAlpha( 250 )
					  particle:SetEndAlpha( 0 )
					  particle:SetStartSize( 15 )
					  particle:SetEndSize( 600 - ( i * 5 ) )
					  particle:SetRoll( 0 )
					  particle:SetRollDelta( 0 )
					  particle:SetColor( 255, 255, 255 )
				end
			end)
		end
			
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()	
end