---------------------------Info-----------------------------------
GM.Name = "Attack on Titan"
GM.Author = "Smooth Dog and BrownZFilmZ"
GM.Email = "smooth-dawg@hotmail.com and BrownZFilmZ@gmail.com"
GM.Website = "http://xggaming.com"
------------------------------------------------------------------
// Includes
//None Yet

----------Colors---------
local clrTable = {} //Color table
clrTable["Green"] = Color(20, 150, 20, 255)
clrTable["Blue"] = Color(25, 25, 170, 255)
clrTable["Red"] = Color(150, 20, 20, 255)
-------------------------
//Teams
TEAM_TITAN_N = 1
TEAM_CORP_N = 2
TEAM_SPEC_N = TEAM_SPECTATOR
//End Teams

//Create Teams
function GM:CreateTeams()
	team.SetUp( TEAM_TITAN_N, "Titans", clrTable["Red"] ) 
	team.SetUp( TEAM_CORP_N, "Recon Corps", clrTable["Blue"] ) 
	team.SetUp( TEAM_SPEC_N, "Spectators", clrTable["Green"] ) 

	team.SetSpawnPoint(TEAM_TITAN_N, "info_player_titan")
	team.SetSpawnPoint(TEAM_CORP_N, "info_player_corps")
	team.SetSpawnPoint(TEAM_SPEC_N, "info_player_spawn")
end
//End

function GM:Initialize()
    self.BaseClass.Initialize( self )
	if SERVER then
	RunConsoleCommand("sbox_godmode", "0")
	end
end

//F1
function GM:ShowHelp( ply )
    ply:ConCommand( "team_menu" )
end
//F2
function GM:ShowTeam( ply )
	ply:ConCommand( "loadout_menu" )
end

