playerTeamColor = team.GetColor(1)
function GM:ScoreboardShow()
	GAMEMODE.ShowScoreboard = true
	gui.EnableScreenClicker(true)
		-- Custom Fonts --
		surface.CreateFont( "BrownZCustomFont1", {
		font = "Arial",
		size = 19				,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
		} )
		surface.CreateFont( "BrownZTitleSize1", {
		font = "Arial",
		size = 25,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
		} )
		surface.SetFont( "BrownZTitleSize1" )
		surface.CreateFont( "BrownZTitleSize2", {
		font = "Arial",
		size = 30,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
		} )
		surface.SetFont( "BrownZTitleSize2" )
		-- End --
end

function GM:ScoreboardHide()
	GAMEMODE.ShowScoreboard = false
	gui.EnableScreenClicker(false)
end

function GM:GetTeamScoreInfo()

	local TeamInfo = {}
	
	for id,pl in pairs( player.GetAll() ) do
	
		local _team = pl:Team()
		local _frags = pl:Frags()
		local _deaths = pl:Deaths()
		local _ping = pl:Ping()
		
		if (not TeamInfo[_team]) then
			TeamInfo[_team] = {}
			TeamInfo[_team].TeamName = team.GetName( _team )
			TeamInfo[_team].Color = team.GetColor( _team )
			TeamInfo[_team].Players = {}
		end		
		
	local PlayerInfo = {}
	PlayerInfo.Frags = _frags
	PlayerInfo.Deaths = _deaths
	PlayerInfo.Score = _frags - _deaths
	PlayerInfo.Ping = _ping
	PlayerInfo.Name = pl:Nick()
	PlayerInfo.PlayerObj = pl
		
		local insertPos = #TeamInfo[_team].Players + 1
		for idx,info in pairs(TeamInfo[_team].Players) do
			if (PlayerInfo.Frags > info.Frags) then
				insertPos = idx
				break
			elseif (PlayerInfo.Frags == info.Frags) then
				if (PlayerInfo.Deaths < info.Deaths) then
					insertPos = idx
					break
				elseif (PlayerInfo.Deaths == info.Deaths) then
					if (PlayerInfo.Name < info.Name) then
						insertPos = idx
						break
					end
				end
			end
		end
		
		table.insert(TeamInfo[_team].Players, insertPos, PlayerInfo)
	end
	
	return TeamInfo
end

function GM:HUDDrawScoreBoard()

	if (!GAMEMODE.ShowScoreboard) then return end
	
	if (GAMEMODE.ScoreDesign == nil) then
	
		GAMEMODE.ScoreDesign = {}
		GAMEMODE.ScoreDesign.HeaderY = 0
		GAMEMODE.ScoreDesign.Height = ScrH() / 2
	
	end
	
	local alpha = 200

	local ScoreboardInfo = self:GetTeamScoreInfo()
	
	local xOffset = ScrW() / 10
	local yOffset = 32
	local scrWidth = ScrW()
	local scrHeight = ScrH() - 64
	local boardWidth = scrWidth - (2* xOffset)
	local boardHeight = scrHeight
	local colWidth = 75
	
	boardWidth = math.Clamp( boardWidth, 400, 1450 )
	boardHeight = GAMEMODE.ScoreDesign.Height
	
	xOffset = (ScrW() - boardWidth) / 2.0
	yOffset = (ScrH() - boardHeight) / 2.0
	yOffset = yOffset - ScrH() / 4.0
	yOffset = math.Clamp( yOffset, 32, ScrH() )
	
	// Background
	LocalPlayerColor = team.GetColor(LocalPlayer():Team())
	surface.SetDrawColor( LocalPlayerColor.r, LocalPlayerColor.g, LocalPlayerColor.b, 100 )
	surface.DrawRect( xOffset, yOffset, boardWidth, GAMEMODE.ScoreDesign.HeaderY)
	surface.SetDrawColor( 0, 0, 0, 175 )
	surface.DrawRect( xOffset, yOffset+GAMEMODE.ScoreDesign.HeaderY, boardWidth, boardHeight-GAMEMODE.ScoreDesign.HeaderY)
	// Outline
	surface.SetDrawColor( 0, 0, 0, 150 )
	surface.DrawOutlinedRect( xOffset, yOffset, boardWidth, boardHeight )
	surface.SetDrawColor( 0, 0, 0, 100 )
	surface.DrawOutlinedRect( xOffset-1, yOffset-1, boardWidth+2, boardHeight+2 )
	
	-- Counts all players on the server.
	local Players = player.GetAll()
	local PlayersNumber = table.Count( Players )
	local MaxPlayersCount = game.MaxPlayers( )

	local TotalPlayers = "Total player(s): " .. PlayersNumber .. "/" .. MaxPlayersCount
	local hostname = GetHostName()
	
	// Hostname
	surface.SetTextColor( 255, 255, 255, 255 )
	
	if ( string.len(hostname) > 32 ) then
		surface.SetFont( "BrownZTitleSize2" )
	else
		surface.SetFont( "BrownZTitleSize1" )
	end
	
	local txWidth, txHeight = surface.GetTextSize( hostname )
	local y = yOffset + 15
	surface.SetTextPos(xOffset + (boardWidth / 2) - (txWidth/2), y)
	surface.DrawText( hostname )
	
	y = y + txHeight + 2
	
	surface.SetTextColor( 200, 200, 200, 255 )
	surface.SetFont( "Trebuchet18" )
	local txWidth, txHeight = surface.GetTextSize( TotalPlayers )
	surface.SetTextPos(xOffset + (boardWidth / 2) - (txWidth/2), y)
	surface.DrawText( TotalPlayers )
	
	y = y + txHeight + 4
	GAMEMODE.ScoreDesign.HeaderY = y - yOffset
	
	surface.SetDrawColor( 0, 0, 0, 150 )
	surface.DrawRect( xOffset, y-1, boardWidth, 1)
	
	surface.SetDrawColor( 150, 150, 150, 30 )
	surface.DrawRect( xOffset + boardWidth - (colWidth*1), y, colWidth, boardHeight-y+yOffset )
	
	surface.SetDrawColor( 150, 150, 150, 30 )
	surface.DrawRect( xOffset + boardWidth - (colWidth*3), y, colWidth, boardHeight-y+yOffset )
	
	
	surface.SetFont( "Trebuchet18" )
	local txWidth, txHeight = surface.GetTextSize( "W" )
	
	surface.SetDrawColor( 0, 0, 0, 100 )
	surface.DrawRect( xOffset, y, boardWidth, txHeight + 6 )

	y = y + 2
	
	surface.SetTextPos( xOffset + 16,								y)	surface.DrawText("#Name")
	surface.SetTextPos( xOffset + boardWidth - (colWidth*3) + 8,	y)	surface.DrawText("#Score")
	surface.SetTextPos( xOffset + boardWidth - (colWidth*2) + 8,	y)	surface.DrawText("#Deaths")
	surface.SetTextPos( xOffset + boardWidth - (colWidth*1) + 8,	y)	surface.DrawText("#Ping")
	
	y = y + txHeight + 4

	local yPosition = y
	for team,info in pairs(ScoreboardInfo) do
		
		local teamText = info.TeamName .. " - " .. #info.Players .. " player(s)"
	
		surface.SetFont( "BrownZCustomFont1" )
		surface.SetTextColor( 255, 255, 255, 255 )
		
		txWidth, txHeight = surface.GetTextSize( teamText )
		surface.SetDrawColor( info.Color.r, info.Color.g, info.Color.b, 100 )
		surface.DrawRect( xOffset+1, yPosition, boardWidth-2, txHeight + 4)
		yPosition = yPosition + 2
		surface.SetTextPos( xOffset + boardWidth/2 - txWidth/2, yPosition )
		surface.DrawText( teamText )
		yPosition = yPosition + 2
						

		
		yPosition = yPosition + txHeight + 2
		
		for index,plinfo in pairs(info.Players) do
		
			surface.SetFont( "Trebuchet18" )
			surface.SetTextColor( 200, 200, 200, 200 )
			surface.SetTextPos( xOffset + 16, yPosition )
			txWidth, txHeight = surface.GetTextSize( plinfo.Name )
			
			if (plinfo.PlayerObj == LocalPlayer()) then
			    surface.SetDrawColor( 200, 200, 200, 50 )
				surface.DrawRect( xOffset+1, yPosition, boardWidth - 2, txHeight + 2)
				surface.SetTextColor( info.Color.r, info.Color.g, info.Color.b, 255 )
			end
			
			
			local px, py = xOffset + 16, yPosition
			local textcolor = Color( 255, 255, 255, alpha )
			local shadowcolor = Color( 0, 0, 0, alpha * 0.8 )
			
			draw.SimpleText( plinfo.Name, "Trebuchet18", px+1, py+1, shadowcolor )
			draw.SimpleText( plinfo.Name, "Trebuchet18", px, py, textcolor )
			
			px = xOffset + boardWidth - (colWidth*3) + 8			
			draw.SimpleText( plinfo.Frags, "Trebuchet18", px+1, py+1, shadowcolor )
			draw.SimpleText( plinfo.Frags, "Trebuchet18", px, py, textcolor )
			
			px = xOffset + boardWidth - (colWidth*2) + 8			
			draw.SimpleText( plinfo.Deaths, "Trebuchet18", px+1, py+1, shadowcolor )
			draw.SimpleText( plinfo.Deaths, "Trebuchet18", px, py, textcolor )
			
			px = xOffset + boardWidth - (colWidth*1) + 8			
			draw.SimpleText( plinfo.Ping, "Trebuchet18", px+1, py+1, shadowcolor )
			draw.SimpleText( plinfo.Ping, "Trebuchet18", px, py, textcolor )
			
			//surface.DrawText( plinfo.Name )
			//surface.SetTextPos( xOffset + 16 + 2, yPosition + 2 )
			//surface.SetTextColor( 0, 0, 0, 200 )
			//surface.DrawText( plinfo.Name )

			//surface.SetTextPos( xOffset + boardWidth - (colWidth*3) + 8, yPosition )
			//surface.DrawText( plinfo.Frags )

			//surface.SetTextPos( xOffset + boardWidth - (colWidth*2) + 8, yPosition )
			//surface.DrawText( plinfo.Deaths )

			//surface.SetTextPos( xOffset + boardWidth - (colWidth*1) + 8, yPosition )
			//surface.DrawText( plinfo.Ping )

			yPosition = yPosition + txHeight + 3
		end
	end
	
	yPosition = yPosition + 8
	
	GAMEMODE.ScoreDesign.Height = (GAMEMODE.ScoreDesign.Height * 2) + (yPosition-yOffset)
	GAMEMODE.ScoreDesign.Height = GAMEMODE.ScoreDesign.Height / 3
	
end

net.Receive( "MutePlayer", function( length )
    local ply = net.ReadEntity()
	ply:SetMuted(true)
	LocalPlayer():ChatPrint(ply:GetName() .. " has been muted.")
end)

net.Receive( "UnMutePlayer", function( length )
    local ply = net.ReadEntity()
	ply:SetMuted(false)
	LocalPlayer():ChatPrint(ply:GetName() .. " has been unmuted.")
end)