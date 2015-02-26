smooth = 0 -- Setting up the variable that will get smoothed.
smooth2 = 0 -- Setting up the variable that will get smoothed.
	
hook.Add("HUDPaint", "HealthBar", function()
//version
draw.DrawText("[www.voidgalaxy.org] | Gamemode by BrownZFilmZ, and Smooth Dog; Modiefied by Sith and |BP| Lord Ptolemy", "Default", ScrW() / 2, ScrH() - 40, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)

local TeamColor = team.GetColor(LocalPlayer():Team())
TeamColor.a = 150 //forces the alpha color to change to this number

/*----------------------------------------------
	Part of HUD that is not the health bar
----------------------------------------------*/

-- Box surrounding Player icon
	draw.RoundedBox(
		4,
		-4,
		-4,
		80,
		80,
		TeamColor
	)

-- Player icon background	
	draw.RoundedBox(
		4,
		5,
		5,
		64,
		64,
		Color( 255, 255, 255, 255 )
	)

-- Backdrop for health bar
	draw.RoundedBox(
		0,
		76,
		0,
		259,
		30,
		TeamColor
	)	

-- Actual Player icon
	if !DermaShown then
		PlayerIcon = vgui.Create( "DModelPanel" )
		PlayerIcon:SetSize( 64, 64 )
		PlayerIcon:SetPos(5, 5)
		PlayerIcon:SetLookAt( Vector( 0, 0, 65 ) )
		PlayerIcon:SetCamPos( Vector( 14, 0	, 64 ) )
		PlayerIcon:SetAmbientLight( Vector( 00, 00, 00 ))
		PlayerIcon:SetModel( LocalPlayer():GetModel() )
		function PlayerIcon:LayoutEntity( Entity ) return end -- Stops model from rotating

		DermaShown = true
	end
	PlayerIcon:SetModel( LocalPlayer():GetModel() or "models/props_junk/watermelon01.mdl" )

/*----------------------------------------------
                  Health bar <3
----------------------------------------------*/

	local ply = LocalPlayer()

	local health = math.Clamp(ply:Health(), 0, 100)	-- clamps the health to [0, 100] meaning it will not go above 100 or below 0
	smooth = math.Approach(smooth, health, 50*FrameTime())		-- smooth the health value, this looks a lot better than just using the raw health value.
									-- You should use FrameTime() for things like this so it will look smooth even if your FPS is low.
 
	local red = (1 - smooth/100)^(1/2) * 255	-- Create a linear equation for the red value, as health drops red increases.
	local grn = (smooth/110)^(1/2) * 255		-- same for green, as health drops green decreases.
	local blu = (smooth/200)^2 * 255		-- and for blue
 
	local col = Color(red, grn, blu) -- create a single color object with the values.
 
	local h, w = 15, 250
    local hpos, wpos = 5, 75
 
	local equation = (w-8)*(smooth/100)+8 -- this equation is so the bar will shrink as you lose health.
 
	draw.RoundedBox(
		4,
		wpos,
		hpos,
		w + 4,
		h + 4,
		Color( 30, 30, 30 )
	)
 
	draw.RoundedBox(
		4,
		wpos + 2,
		hpos + 2,
		equation,
		h,
		col
	)
	
-- Other Player Bar --
local OtherPlayer = LocalPlayer():GetEyeTrace().Entity
//	print(OtherPlayer)
/*----------------------------------------------
	Part of HUD that is not the health bar
----------------------------------------------*/
if LastPlayer == nil then 
	LastPlayer = OtherPlayer
	PlayerIcon2 = nil
end
if LastPlayer != OtherPlayer then
	if OtherPlayer:IsPlayer() and PlayerIcon2 == nil then
		-- Actual Player icon
		PlayerIcon2 = vgui.Create( "DModelPanel")
		PlayerIcon2:SetSize( 64, 64 )
		PlayerIcon2:SetPos( ScrW() - 69, 5 )
		PlayerIcon2:SetLookAt( Vector( 0, 0, 65 ) )
		PlayerIcon2:SetCamPos( Vector( 14, 0, 64 ) )
		PlayerIcon2:SetAmbientLight( Vector( 00, 00, 00 ))
		PlayerIcon2:SetModel( OtherPlayer:GetModel() )
		function PlayerIcon2:LayoutEntity( Entity ) return end -- Stops model from rotating
		-- End --
	end
	LastPlayer = OtherPlayer
end

if IsValid(PlayerIcon2) and OtherPlayer:IsPlayer() == false then
	PlayerIcon2:Remove()
	PlayerIcon2 = nil
end
if OtherPlayer:IsPlayer() then
	local TeamColor2 = team.GetColor(OtherPlayer:Team())
	TeamColor2.a = 150 //forces the alpha color to change to this number
	-- Box surrounding Player icon
	draw.RoundedBox(
		4,
		ScrW() - 76,
		-4 , 
		80,
		80,
		TeamColor2
	)
	-- End --
	-- Player icon background	
	draw.RoundedBox(
		4,
		ScrW() - 69,
		5,
		64,
		64,
		Color( 255, 255, 255, 255 )
	)
	-- End --
	-- Backdrop for health bar
	draw.RoundedBox(
		0,
		ScrW() - 335,
		0,
		259,
		30,
		TeamColor2
	)
	-- End --
	-- Target ID (Player Name) --
	local ShowOtherName = {}
	ShowOtherName.pos = {}
	ShowOtherName.pos[1] = ScrW() - 200 -- x pos
	ShowOtherName.pos[2] = 55 -- y pos
	ShowOtherName.color = TeamColor2 -- color
	ShowOtherName.color.a = 255 -- alpha color
	ShowOtherName.text = OtherPlayer:GetName() -- Text
	ShowOtherName.font = "ChatFont" -- Font
	ShowOtherName.xalign = TEXT_ALIGN_CENTER -- Horizontal Alignment
	ShowOtherName.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
	draw.Text( ShowOtherName )
	-- End --
end
	-- Health Bar --
	if OtherPlayer:IsPlayer() then
		local health2 = math.Clamp(OtherPlayer:Health(), 0, 100)	-- clamps the health to [0, 100] meaning it will not go above 100 or below 0
		smooth2 = math.Approach(smooth2, health2, 50*FrameTime())		-- smooth the health value, this looks a lot better than just using the raw health value.
										-- You should use FrameTime() for things like this so it will look smooth even if your FPS is low.
	 
		local red = (1 - smooth2/100)^(1/2) * 255	-- Create a linear equation for the red value, as health drops red increases.
		local grn = (smooth2/110)^(1/2) * 255		-- same for green, as health drops green decreases.
		local blu = (smooth2/200)^2 * 255		-- and for blue
	 
		local col = Color(red, grn, blu) -- create a single color object with the values.
	 
		local h, w = 15, 250
		local hpos, wpos = 5, ScrW() - 329
	 
		local equation = (w-8)*(smooth2/100)+8 -- this equation is so the bar will shrink as you lose health.
	 
		draw.RoundedBox(
			4,
			wpos,
			hpos,
			w + 4,
			h + 4,
			Color( 30, 30, 30 )
		)
	 
		draw.RoundedBox(
			4,
			wpos + 2,
			hpos + 2,
			equation,
			h,
			col
		)
	end
	-- End Health Bar --
end)

//local struc = {}
//struc.pos = {}
//struc.pos[1] = 100 -- x pos
//struc.pos[2] = 200 -- y pos
//struc.color = Color(255,0,0,255) -- Red
//struc.text = "Hello World" -- Text
//struc.font = "DefaultFixed" -- Font
//struc.xalign = TEXT_ALIGN_CENTER -- Horizontal Alignment
//struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
//draw.Text( struc )

local tohide = { -- This is a table where the keys are the HUD items to hide
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudWeaponSelection"] = true
}
local function HUDShouldDraw(name) -- This is a local function because all functions should be local unless another file needs to run it
	if (tohide[name]) then     -- If the HUD name is a key in the table
		return false;      -- Return false.
	end
end
hook.Add( "HUDShouldDraw", "HUDShouldDraw", HUDShouldDraw )