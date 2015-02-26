if (SERVER) then
	AddCSLuaFile("shared.lua")
	AddCSLuaFile("cl_init.lua")
end

SWEP.PrintName		    = "3dmg_test2"
SWEP.Author			    = "jsw0244 and modified by BrownZFilmZ"
SWEP.Slot			    = 1
SWEP.SlotPos		    = 1
SWEP.Instructions 	    = "Attack On Titan"
SWEP.Purpose            = ""
SWEP.Icon 				= "vgui/entities/3dgear"
SWEP.Spawnable          = true
SWEP.AdminSpawnable     = true 
SWEP.ViewModelFlip      = false
SWEP.ViewModelFOV 	    = 65
SWEP.ViewModel 		    = "models/super_hard_blade/v_super_hard_blade.mdl" 
SWEP.WorldModel 	    = "models/weapons/w_crowbar.mdl" 
SWEP.AutoSwitchTo 	    = false 
SWEP.AutoSwitchFrom     = true
SWEP.DrawCrosshair      = true 
SWEP.DrawAmmo           = false
SWEP.HoldType           = "knife"

SWEP.SetWeaponHoldType = ( knife )

SWEP.Category           = "Attack On Titan"

SWEP.ShowViewModel      = true
SWEP.ShowWorldModel     = false
SWEP.ViewModelBoneMods  = {}
SWEP.FiresUnderwater    = true 
SWEP.Primary.Automatic  = false
SWEP.Primary.Ammo       = ""
SWEP.Secondary.Automatic= false
SWEP.Secondary.Ammo     = ""


SWEP.WElements = {
	["left_cutter"] = { type = "Model", model = "models/olddeath/w_snk_sword.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1, -0.5, -2), angle = Angle(91.023, -101.25, -5.114), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["right_cutter"] = { type = "Model", model = "models/olddeath/w_snk_sword.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.273, 0.455, 2.273), angle = Angle(-72.614, -168.75, -31.705), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["3d_maneuver"] = { type = "Model", model = "models/aot/3dgear.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(0, 0, -3), angle = Angle(90, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
 
local speed      = 1500
local wire       = Material('cable/cable')
local WireMove   = Sound("aot/wire_move.wav")
local WireShoot  = Sound("aot/wire_shoot.wav")
local KnifeShink = Sound("weapons/blades/hitwall.wav")
local KnifeStab  = Sound("aot/slash.wav")
local WireBoost = Sound("aot/wire.wav")

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	self:SetVar("leftcan", false)
	self:SetVar("rightcan", false)
	self:SetVar("leftanker", false)
	self:SetVar("rightanker", false)
	
	if CLIENT then
	
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements) 
		self:CreateModels(self.WElements) 
		
		if IsValid(self.Owner) then
			if (self.Owner:GetModel()=="models/error.mdl") then
				self.Owner:PrintMessage( HUD_PRINTTALK  , "Your player model is an error, please change your model before continuing." )
				self:Remove()
			end
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					vm:SetColor(Color(255,255,255,1))
					vm:SetMaterial("Debug/hsv")			
				end
			end
		end
		
	end

end

function SWEP:Holster()
	self:SetVar("leftcan", false)
	self:SetVar("rightcan", false)
	self:SetVar("leftanker", false)
	self:SetVar("rightanker", false)
	self:SetVar("both", false)
	self:LeftAnkerRemove()
	self:RightAnkerRemove()
	
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
	return true
end

function SWEP:OnRemove()
	self:Holster()
end

local LASER = Material('cable/redlaser')

if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		local vm = self.Owner:GetViewModel()
		
		if !IsValid(vm) then return end
		
		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then
			
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
	
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
	
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end
	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v)
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
end

function SWEP:Deploy()
    local ply = self:GetOwner()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self.Weapon:SetNextPrimaryFire(CurTime() + 0)
	self.Weapon:SetNextSecondaryFire(CurTime() + 0)
	self:SetVar("leftcan", true)
	self:SetVar("rightcan", true)
	self:SetVar("leftanker", false)
	self:SetVar("rightanker", false)
	self:SetVar("both", false)
	
	ply:SetWalkSpeed( 300 )
	ply:SetRunSpeed( 650 )
	
	return true
end

function SWEP:RemoveLeftAnker() 
    if self:GetVar( "left" ) then
	    self.left:Remove()
		self.Wire:Remove()
	end
end 

function SWEP:LeftAnkerRemove()
	if IsValid( self.left )   then  self.left:Remove()   end
	if IsValid( self.Wire )   then  self.Wire:Remove()   end
end

function SWEP:RightAnkerRemove()
	if IsValid( self.right )  then  self.right:Remove()  end
	if IsValid( self.Wire2 )  then  self.Wire2:Remove()  end
end

function SWEP:Reload()
	if self.Owner:KeyPressed(IN_RELOAD) and not self.Owner:GetEyeTrace().HitSky then
		if not self:GetVar("both") then
			if self:GetVar("rightcan") and self:GetVar("leftcan") then
				self:SetVar( "rightcan", false )
				self:SetVar( "leftcan", false )
				self:SetVar("both", true)
				self:ShootRightAnker()
				self:ShootLeftAnker()
			elseif self:GetVar("rightcan") then
				self:SetVar( "rightcan", false )
				self:SetVar("both", true)
				self:ShootRightAnker()
			elseif self:GetVar("leftcan") then
				self:SetVar( "leftcan", false )
				self:SetVar("both", true)
				self:ShootLeftAnker()
			end
		elseif self:GetVar("both") then
			if not self:GetVar("rightcan") and not self:GetVar("leftcan") then
				self:SetVar( "rightcan", true )
				self:SetVar( "leftcan", true )
				self:SetVar("both", false)
				self:RightAnkerRemove()
				self:LeftAnkerRemove()
			elseif not self:GetVar("rightcan") then
				self:SetVar( "rightcan", true )
				self:SetVar("both", false)
				self:RightAnkerRemove()
			elseif not self:GetVar("leftcan") then
				self:SetVar( "leftcan", true )
				self:SetVar("both", false)
				self:LeftAnkerRemove()
			end
		end
	end	
end
   
function SWEP:Think()
	if !self:GetVar( "leftanker" ) then
        self:LeftAnkerRemove()
	end
	if !self:GetVar( "rightanker" ) then
        self:RightAnkerRemove()
	end
	
	if IsValid( self.left ) then	
	    local AnkerPos   = self.left:GetPos()
	    local AnkerAngle = self.left:GetAngles()
	    local LeftWire   = AnkerPos + (AnkerAngle:Up() * 0) + (AnkerAngle:Forward() * -0) + (AnkerAngle:Right() * -0)
 	    self.Wire:SetPos ( LeftWire )
	else
	    self:SetVar( "leftanker" , false )
	end
	if IsValid( self.right ) then	
		local AnkerPos   = self.right:GetPos()
	    local AnkerAngle = self.right:GetAngles()
	    local RightWire   = AnkerPos + (AnkerAngle:Up() * 0) + (AnkerAngle:Forward() * -0) + (AnkerAngle:Right() * -0)
 	    self.Wire2:SetPos ( RightWire )
	else
	    self:SetVar( "rightanker", false )
	end
	
	if self:GetVar( "leftanker" ) && self:GetVar( "rightanker" ) then
	    if not IsValid( self.left ) then
	        self:SetVar( "leftanker" , false )
	        self:LeftAnkerRemove()
		end
		if not IsValid( self.right) then
	        self:SetVar( "rightanker" , false )
	        self:RightAnkerRemove()
		end
	    
		if self.left:GetNetworkedBool("Colide") && self.right:GetNetworkedBool("Colide") then
	        local AnkerPos   = (self.left:GetPos() + self.right:GetPos())/2
	        local AnkerAngle = self.left:GetAngles()
		    local positiongap = AnkerPos + (AnkerAngle:Up() * 0) + (AnkerAngle:Forward() * 0) + (AnkerAngle:Right() * 0)
		    local markpoint = (positiongap - self.Owner:GetPos()):GetNormalized()
		    local Distance = positiongap:Distance( self.Owner:GetPos() ) 
            local bone = self.Owner:LookupBone("ValveBiped.Bip01_Spine")
		    local position, angles = self.Owner:GetBonePosition( bone )
	        local effectPos = position + (angles:Up() * 5) + (angles:Forward() * -5) + (angles:Right() * 10)
	        local effectdata = EffectData()
		
		    if Distance > 20 then
				if self:GetOwner():KeyPressed(IN_SPEED) and speed!=2000 then
	                speed = 2000
					self.Owner:EmitSound(WireBoost)
	            else
	                speed = 1500 
	            end
	            self.Owner:SetLocalVelocity( markpoint * speed )
			    effectdata:SetOrigin( effectPos )
		        effectdata:SetAngles( angles )
	            //util.Effect( "Smoke", effectdata, true, true )
			        
		    else
		        self.Owner:SetLocalVelocity( ((positiongap) - self.Owner:GetPos()) * 50 )
		    end
		   
		    if self.left:GetNetworkedBool("Sound") then
                self.Owner:EmitSound( WireMove )
		        self.left:SetNetworkedBool("Sound",false) 
            end  
	    end
		return
	end
	if self:GetVar( "leftanker" ) then 
	    if not IsValid( self.left ) then
	        self:SetVar( "leftanker" , false )
	        self:LeftAnkerRemove()
		end
	    
		if self.left:GetNetworkedBool("Colide") then
	        local AnkerPos   = self.left:GetPos()
	        local AnkerAngle = self.left:GetAngles()
		    local positiongap = AnkerPos + (AnkerAngle:Up() * -40) + (AnkerAngle:Forward() * -30) + (AnkerAngle:Right() * -0)
		    local markpoint = (positiongap - self.Owner:GetPos()):GetNormalized()
		    local Distance = positiongap:Distance( self.Owner:GetPos() ) 
            local bone = self.Owner:LookupBone("ValveBiped.Bip01_Spine")
		    local position, angles = self.Owner:GetBonePosition( bone )
			
	        local effectPos = position + (angles:Up() * 5) + (angles:Forward() * -5) + (angles:Right() * 10)
	        local effectdata = EffectData()
		
		    if Distance > 50 then
				if self:GetOwner():KeyDown(IN_SPEED) then
	                speed = 2250
	            else
	                speed = 2000 
	            end
	            self.Owner:SetLocalVelocity( markpoint * speed )
			    effectdata:SetOrigin( effectPos )
		        effectdata:SetAngles( angles )
	            //util.Effect( "Smoke", effectdata, true, true )
			        
		    else
		        self.Owner:SetLocalVelocity( ((positiongap + (self.left:GetForward() * -30)) - self.Owner:GetPos()) * 50 )
		    end
		   
		    if self.left:GetNetworkedBool("Sound") then
                self.Owner:EmitSound( WireMove )
		        self.left:SetNetworkedBool("Sound",false) 
            end  
	    end
	elseif self:GetVar( "rightanker" ) then
	    if not IsValid( self.right ) then
	        self:SetVar( "rightanker" , false )
	        self:RightAnkerRemove()
		end
	    
		if self.right:GetNetworkedBool("Colide") then
	        local AnkerPos   = self.right:GetPos()
	        local AnkerAngle = self.right:GetAngles()
		    local positiongap = AnkerPos + (AnkerAngle:Up() * -40) + (AnkerAngle:Forward() * -30) + (AnkerAngle:Right() * -0)
		    local markpoint = (positiongap - self.Owner:GetPos()):GetNormalized()
		    local Distance = positiongap:Distance( self.Owner:GetPos() ) 
            local bone = self.Owner:LookupBone("ValveBiped.Bip01_Spine")
		    local position, angles = self.Owner:GetBonePosition( bone )
	        local effectPos = position + (angles:Up() * 5) + (angles:Forward() * -5) + (angles:Right() * 10)
	        local effectdata = EffectData()
		
		    if Distance > 50 then
				if self:GetOwner():KeyDown(IN_SPEED) then
	                speed = 2250
	            else
	                speed = 2000 
	            end
	            self.Owner:SetLocalVelocity( markpoint * speed )
			    effectdata:SetOrigin( effectPos )
		        effectdata:SetAngles( angles )
	            //util.Effect( "Smoke", effectdata, true, true )
			        
		    else
		        self.Owner:SetLocalVelocity( ((positiongap + (self.right:GetForward() * -30)) - self.Owner:GetPos()) * 50 )
		    end
		   
		    if self.right:GetNetworkedBool("Sound") then
                self.Owner:EmitSound( WireMove )
		        self.right:SetNetworkedBool("Sound",false) 
            end  
	    end
	end
end 
  
function SWEP:ShootLeftAnker() 
    if SERVER then
	    if !self:GetVar( "leftanker" ) then
		self.Owner:EmitSound( WireShoot )
		
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_Head1")
		
		self.left = ents.Create( "anker" )
	    self.left:SetPhysicsAttacker( self.Owner )
	    self.left:SetAngles( self.Owner:EyeAngles() )
	    self.left:SetOwner( self.Owner )
		
		if (bone) then
		    local position, angles = self.Owner:GetBonePosition(bone)
		    self.left:SetPos( position + (angles:Up() * -20) + (angles:Forward() * -0) + (angles:Right() * 0) )
	    end
		
        self.Wire = ents.Create( "xg_wire" )	
	    self.Wire:SetAngles( self.left:GetAngles() )
 	    self.Wire:SetPos( self.left:GetPos() )
	    self.Wire:SetOwner( self.Owner )
		
		self.left:Spawn()
	    self.Wire:Spawn()
		self:SetVar( "leftanker" , true )
		else
		self.left:Remove()
		self.Wire:Remove()
		self:SetVar( "leftanker" , false )
		end
	end
end

function SWEP:ShootRightAnker() 
    if SERVER then
	    if !self:GetVar( "rightanker" ) then
		self.Owner:EmitSound( WireShoot )
		
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_Head1")
		
		self.right = ents.Create( "anker" )
	    self.right:SetPhysicsAttacker( self.Owner )
	    self.right:SetAngles( self.Owner:EyeAngles() )
	    self.right:SetOwner( self.Owner )
		
		if (bone) then
		    local position, angles = self.Owner:GetBonePosition(bone)
		    self.right:SetPos( position + (angles:Up() * 20) + (angles:Forward() * -0) + (angles:Right() * 0) )
	    end
		
        self.Wire2 = ents.Create( "xg_wire2" )	
	    self.Wire2:SetAngles( self.right:GetAngles() )
 	    self.Wire2:SetPos( self.right:GetPos() )
	    self.Wire2:SetOwner( self.Owner )
		
		self.right:Spawn()
	    self.Wire2:Spawn()
		self:SetVar( "rightanker" , true )
		else
		self.right:Remove()
		self.Wire2:Remove()
		self:SetVar( "rightanker" , false )
		end
	end
end
 
function SWEP:PrimaryAttack()
	if self.Owner:KeyDown(IN_USE) and not self.Owner:GetEyeTrace().HitSky then
		if self:GetVar("leftcan") then
			self:SetVar( "leftcan", false )
			self:ShootLeftAnker()
			self:SetVar( "both", true )
		elseif not self:GetVar("leftcan") then
			self:SetVar( "leftcan", true )
			self:LeftAnkerRemove()
			self:SetVar( "both", false )
		end
	end
	if self:CanPrimaryAttack() and self.Owner:IsPlayer() then
		if SERVER then 
		if self.Owner:KeyDown(IN_USE) or self.Owner:KeyDown(IN_RELOAD) then return end
		end
		if CLIENT then
		if LocalPlayer():KeyDown(IN_USE) or LocalPlayer():KeyDown(IN_RELOAD) then return end
		end
			self:SendAnim()
			self.Weapon:SetNextPrimaryFire( CurTime() + 1.5 )
			self.Weapon:SetNextSecondaryFire( self.Weapon:GetNextSecondaryFire() + 1.5 )
			self:SetWeaponHoldType( "melee" )
			timer.Simple(0.1, function() 
				if not IsValid(self) or not self.Owner:Alive() then return end self.Weapon:EmitSound( "weapons/iceaxe/iceaxe_swing1.wav" ) self.Weapon:PrimarySlash() self.Owner:SetAnimation( PLAYER_ATTACK1 ) end )
			timer.Simple(0.35, function() 
				if not IsValid(self) or not self.Owner:Alive() then return end self.Weapon:EmitSound( "weapons/iceaxe/iceaxe_swing1.wav" ) self.Weapon:PrimarySlash() end)
			timer.Simple(0.5, function() if not IsValid(self) or not self.Owner:Alive() then return end self:SetWeaponHoldType( "knife" ) end)
		end
end 
 
function SWEP:SecondaryAttack()	
	if self.Owner:KeyDown(IN_USE) and  not self.Owner:GetEyeTrace().HitSky then
		if self:GetVar("rightcan") then
			self:SetVar( "rightcan", false )
			self:ShootRightAnker()
			self:SetVar( "both", true )
		elseif not self:GetVar("rightcan") then
			self:SetVar( "rightcan", true )
			self:RightAnkerRemove()
			self:SetVar( "both", false )
		end
	end
    if self:CanSecondaryAttack() and self.Owner:IsPlayer() then
		if SERVER then 
		if self.Owner:KeyDown(IN_USE) then return end
		end
		if CLIENT then
		if LocalPlayer():KeyDown(IN_USE) then return end
		end
			self.Weapon:SetNextSecondaryFire( CurTime() + 2.5 )
			self.Weapon:SetNextPrimaryFire( CurTime() + 2.5 )
			local Angles = self.Owner:GetAngles()
			
			self:SendAnim()
			for i = 0, 360, 10 do
				if i % 10 == 0 then self.Weapon:EmitSound( KnifeStab ) end
				timer.Simple( 0.001 * i, function() 
					if not IsValid(self) or not self.Owner:Alive() then return end
					self.Owner:SetEyeAngles( Angle(0,Angles.y + i,0) ) self.Weapon:Rolling()
				end )
			end
		end
end

function SWEP:SendAnim()
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
end

function SWEP:PrimarySlash()
	if not self.Owner:KeyDown(IN_USE) or not self.Owner:KeyDown(IN_RELOAD) then
		pos = self.Owner:GetShootPos()
		ang = self.Owner:GetAimVector()
		pain = 50
		self.Owner:LagCompensation(true)
		if IsValid(self.Owner) and IsValid(self.Weapon) then
			if self.Owner:Alive() then
				local slash = {}
				slash.start = pos
				slash.endpos = pos + (ang * 150)
				slash.filter = self.Owner
				slash.mins = Vector(-15, -15, 0)
				slash.maxs = Vector(15, 15, 5)
				local slashtrace = util.TraceHull(slash)
				if slashtrace.Hit then
					targ = slashtrace.Entity
					if targ:IsPlayer() then
						if IsValid( targ:GetActiveWeapon() ) then
							if targ:GetActiveWeapon():GetClass() == "titan_swep" 			or
								targ:GetActiveWeapon():GetClass() == "titan_swep_ab_test" 	or
								targ:GetActiveWeapon():GetClass() == "eren_titan_swep" 		or	
								targ:GetActiveWeapon():GetClass() == "titan_swep_v2" 		then
								local bullet = {}
								bullet.Attacker = self.Owner
								bullet.Num      = 3
								bullet.Src      = self.Owner:GetShootPos()
								bullet.Dir      = self.Owner:GetAimVector()
								bullet.Spread   = Vector(0, 0, 0)
								bullet.Tracer   = 0
								bullet.Force    = 35000
								bullet.Damage   = 0
								if targ:GetAngles().y - 80 < self.Owner:GetAngles().y 
									and targ:GetAngles().y + 80 > self.Owner:GetAngles().y then
								bullet.Damage = 50
								end
								self.Owner:FireBullets(bullet) 
							elseif targ:GetActiveWeapon():GetClass() != "3d_maneuver_gear_c" and
								   targ:GetActiveWeapon():GetClass() != "3d_maneuver_gear_expert_c" then
								paininfo = DamageInfo()
								paininfo:SetDamage(pain)
								paininfo:SetDamageType(DMG_SLASH)
								paininfo:SetAttacker(self.Owner)
								paininfo:SetInflictor(self.Weapon)
								paininfo:SetDamageForce(slashtrace.Normal *35000)
								if SERVER then targ:TakeDamageInfo(paininfo) end
							end
						else
						paininfo = DamageInfo()
						paininfo:SetDamage(pain)
						paininfo:SetDamageType(DMG_SLASH)
						paininfo:SetAttacker(self.Owner)
						paininfo:SetInflictor(self.Weapon)
						paininfo:SetDamageForce(slashtrace.Normal *35000)
						if SERVER then targ:TakeDamageInfo(paininfo) end
						end
						self.Weapon:EmitSound( KnifeStab )
					else
						paininfo = DamageInfo()
						paininfo:SetDamage(pain)
						paininfo:SetDamageType(DMG_SLASH)
						paininfo:SetAttacker(self.Owner)
						paininfo:SetInflictor(self.Weapon)
						paininfo:SetDamageForce(slashtrace.Normal *1000)
						self.Weapon:EmitSound( KnifeStab )
						look = self.Owner:GetEyeTrace()
						util.Decal("ManhackCut", look.HitPos + look.HitNormal, look.HitPos - look.HitNormal )
						if SERVER then targ:TakeDamageInfo(paininfo) end
					end
				end
			end 
		end
		self.Owner:LagCompensation(false)
	end
end


function SWEP:Rolling()
	if not self.Owner:KeyDown(IN_USE) or not self.Owner:KeyDown(IN_RELOAD) then
		pos = self.Owner:GetShootPos()
		ang = self.Owner:GetAimVector()
		pain = 75
		self.Owner:LagCompensation(true)
		if IsValid(self.Owner) and IsValid(self.Weapon) then
			if self.Owner:Alive() then
				local slash = {}
				slash.start = pos
				slash.endpos = pos + (ang * 100)
				slash.filter = self.Owner
				slash.mins = Vector(0, 0, -10)
				slash.maxs = Vector(0, 0, 10)
				local slashtrace = util.TraceHull(slash)
				if slashtrace.Hit then
					targ = slashtrace.Entity
					if targ:IsPlayer() then
						if IsValid( targ:GetActiveWeapon() ) then
							if targ:GetActiveWeapon():GetClass() == "titan_swep" 			or
								targ:GetActiveWeapon():GetClass() == "titan_swep_ab_test" 	or
								targ:GetActiveWeapon():GetClass() == "eren_titan_swep" 		or	
								targ:GetActiveWeapon():GetClass() == "titan_swep_v2" 		then
								local bullet = {}
								bullet.Attacker = self.Owner
								bullet.Num      = 2
								bullet.Src      = self.Owner:GetShootPos()
								bullet.Dir      = self.Owner:GetAimVector()
								bullet.Spread   = Vector(0, 0, 0)
								bullet.Tracer   = 0
								bullet.Force    = 35000
								bullet.Damage   = 0
								if targ:GetAngles().y - 80 < self.Owner:GetAngles().y 
									and targ:GetAngles().y + 80 > self.Owner:GetAngles().y then
								bullet.Damage = 50
								end
								self.Owner:FireBullets(bullet) 
							elseif targ:GetActiveWeapon():GetClass() != "3d_maneuver_gear_c" and
								   targ:GetActiveWeapon():GetClass() != "3d_maneuver_gear_expert_c" then
								paininfo = DamageInfo()
								paininfo:SetDamage(pain)
								paininfo:SetDamageType(DMG_SLASH)
								paininfo:SetAttacker(self.Owner)
								paininfo:SetInflictor(self.Weapon)
								paininfo:SetDamageForce(slashtrace.Normal *35000)
								if SERVER then targ:TakeDamageInfo(paininfo) end
							end
						else
						paininfo = DamageInfo()
						paininfo:SetDamage(pain)
						paininfo:SetDamageType(DMG_SLASH)
						paininfo:SetAttacker(self.Owner)
						paininfo:SetInflictor(self.Weapon)
						paininfo:SetDamageForce(slashtrace.Normal *35000)
						if SERVER then targ:TakeDamageInfo(paininfo) end
						end
						self.Weapon:EmitSound( KnifeStab )
					else
						paininfo = DamageInfo()
						paininfo:SetDamage(pain)
						paininfo:SetDamageType(DMG_SLASH)
						paininfo:SetAttacker(self.Owner)
						paininfo:SetInflictor(self.Weapon)
						paininfo:SetDamageForce(slashtrace.Normal *1000)
						self.Weapon:EmitSound( KnifeStab )
						if SERVER then targ:TakeDamageInfo(paininfo) end
					end
				end
			end 
		end
		self.Owner:LagCompensation(false)
	end
end
/*
local function GearGetFallDamage2( ply, speed )
    if ply:GetActiveWeapon():IsValid() then
	    if ply:GetActiveWeapon():GetClass() == "3d_maneuver_gear_expert" or 
		   ply:GetActiveWeapon():GetClass() == "3d_maneuver_gear" then
		    return false
	    end
	end
end*/
hook.Add("GetFallDamage", "GearGetFallDamage2", GearGetFallDamage2)