AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("vgui/cl_hud.lua")
AddCSLuaFile("cl_menu.lua")
AddCSLuaFile("vgui/cl_scoreboard.lua")

include("shared.lua")
include("player.lua")
include("spawn_replace.lua")

function GM:Initialize()
	timer.Simple(0.01, PlaceSpawns)
	RunConsoleCommand("sbox_godmode", "0")
end

function GM:PlayerConnect( name, ip )
    print("Player " .. name .. " has joined the game.")
	
end

function GM:PlayerInitialSpawn( ply )
    print("Player " .. ply:Nick() .. " has spawned.")
	if ply:SteamID() == "STEAM_0:1:46849397" then
		PrintMessage( HUD_PRINTCENTER , "The Owner " .. ply:Nick() .. " has joined the server!" )
	end
	ply:SetPData("LoadoutNumber", 1)
	ply:ConCommand( "spectate" )
	ply:ConCommand( "team_menu" )
	ply:Spawn()
end

function GM:CanPlayerSuicide( ply )
    local Sweg = math.random( 2 )
    if Sweg == 1 then
        ply:PrintMessage( HUD_PRINTCENTER , "You're a Noob!" )
    elseif Sweg == 2 then
        ply:PrintMessage( HUD_PRINTCENTER , "You don't need to kill yourself." )
    end
    return false;
end

//Team Configuration
function TEAM_TITAN( ply )
	if ply:Team() != TEAM_TITAN_N then
		ply:SetTeam( TEAM_TITAN_N ) //Make the player join team Recon Corps 
		ply:Spawn()
	end
	ply:GodDisable()
	//ply:SetModel( "models/olddeath/kyojin/kyojin.mdl" )
	ply:SetPlayerColor( Vector( 1, .2, .2 ) )
	if !ply:Alive() then
		ply:Spawn()
	end
end 
 
function TEAM_CORP( ply )
	if ply:Team() != TEAM_CORP_N then
		ply:SetTeam( TEAM_CORP_N ) //Make the player join team Recon Corps 
		ply:Spawn()
	end
	//ply:SetModel("models/player/odessa.mdl")
	ply:PickRandomModel()
	ply:GodDisable()
	ply:SetHealth(100)
	if !ply:Alive() then
		ply:Spawn()
	end
	ply:SetHealth(100)
	ply:SetModelScale( 1, 0 )
	ply:SetPlayerColor( Vector(.9, .8, .7) )
	ply:SetHull(Vector(-16, -16, 0), Vector(16, 16, 72))
	ply:SetHullDuck( Vector(-16, -16, 0), Vector( 16, 16, 36))
	ply:SetViewOffset( Vector(0, 0, 64) )
	ply:SetViewOffsetDucked( Vector(0, 0, 32) )
	ply:ResetHull()
	ply:SetWalkSpeed( 300 )
	ply:SetJumpPower( 400 )
	ply:SetRunSpeed( 650 )
	local theyspecial = math.random(1,10)
		timer.Simple(0.5, function()
			if theyspecial == 3 then
				if ply:Team() == TEAM_CORP_N then
					timer.Simple(0.5, function() ply:ChatPrint("You are the corrupt Military Police murder the Survey Corps!") ply:PrintMessage( HUD_PRINTCENTER , "You are the corrupt Military Police murder the Survey Corps!" ) end)
					ply:Give("weapon_muskeblue")
					ply:SelectWeapon("weapon_muskeblue")
					ply:SetRunSpeed( 550 )
				end
			elseif theyspecial == 7 then
				if ply:Team() == TEAM_CORP_N then
					timer.Simple(0.5, function() ply:ChatPrint("You are the Garrison, help protect your fellow Survey Corps from the Military Police.") ply:PrintMessage( HUD_PRINTCENTER , "You are the Garrison, help protect your fellow Survey Corps from the Military Police." ) end)
					ply:Give("weapon_sabreblue")
					ply:SelectWeapon("weapon_sabreblue")
					ply:SetRunSpeed( 700 )
					ply:SetHealth( 150 )
				end
			else
				if ply:Team() == TEAM_CORP_N then
					timer.Simple(0.5, function() ply:ChatPrint("You are a Scout, kill titans, don't die or you get taxed!") ply:PrintMessage( HUD_PRINTCENTER , "You are a Scout, kill titans, don't die or you get taxed!" ) end)
					ply:Give("3d_maneuver_gear_c")
					ply:SelectWeapon("3d_maneuver_gear_c")
				end
			end
		end)
end 
 
function TEAM_SPEC( ply )
	if ply:Team() != TEAM_SPEC_N then
		ply:SetTeam( TEAM_SPEC_N )
		ply:Spawn()
	end
	ply:SetHealth(100)
	ply:GodEnable()
	ply:SetModel("models/crow.mdl")
	if !ply:Alive() then
		ply:Spawn()
	end
	ply:SetMoveType(MOVETYPE_NOCLIP)
	ply:SetCollisionGroup(COLLISION_GROUP_WORLD)
end
//End Team Configuration

// Initializes all the commands, or networked vars
	util.AddNetworkString( "TeamSelect" )
	util.AddNetworkString( "LoadoutNumber" ) -- Add it before adding net.Recieve
	util.AddNetworkString( "MutePlayer" )
	util.AddNetworkString( "UnMutePlayer" )
	concommand.Add( "spectate", TEAM_SPEC )
// Ends Here

function GM:PlayerSpawn( ply )
	ply:RemoveAllAmmo()
	ply:GiveGamemodeWeapons()
	ply:SetArmor( 100 )

	local oldhands = ply:GetHands()
	if ( IsValid( oldhands ) ) then oldhands:Remove() end

	local hands = ents.Create( "gmod_hands" )
	if ( IsValid( hands ) ) then
		ply:SetHands( hands )
		hands:SetOwner( ply )

		-- Which hands should we use?
		local cl_playermodel = ply:GetInfo( "cl_playermodel" )
		local info = player_manager.TranslatePlayerHands( cl_playermodel )
		if ( info ) then
			hands:SetModel( info.model )
			hands:SetSkin( info.skin )
			hands:SetBodyGroups( info.body )
		end

		-- Attach them to the viewmodel
		local vm = ply:GetViewModel( 0 )
		hands:AttachToViewmodel( vm )

		vm:DeleteOnRemove( hands )
		ply:DeleteOnRemove( hands )

		hands:Spawn()
 	end
	-- Setup Team Info.
	if ply:Team() == 1 then
		TEAM_TITAN(ply)
	elseif ply:Team() == 2 then
		TEAM_CORP(ply)
	elseif ply:Team() == TEAM_SPECTATOR  then
		TEAM_SPEC(ply)
	end 
end

function GM:PlayerDeath( ply, inflictor, attacker )

	-- Don't spawn for at least 2 seconds
	ply.NextSpawnTime = CurTime() + 2
	ply.DeathTime = CurTime()
	
	if ( IsValid( attacker ) && attacker:GetClass() == "trigger_hurt" ) then 
		attacker = ply 
	end
	
	if ( IsValid( attacker ) && attacker:IsVehicle() && IsValid( attacker:GetDriver() ) ) then
		attacker = attacker:GetDriver()
	end

	if ( !IsValid( inflictor ) && IsValid( attacker ) ) then
		inflictor = attacker
	end

	-- Convert the inflictor to the weapon that they're holding if we can.
	-- This can be right or wrong with NPCs since combine can be holding a 
	-- pistol but kill you by hitting you with their arm.
	if ( IsValid( inflictor ) && inflictor == attacker && ( inflictor:IsPlayer() || inflictor:IsNPC() ) ) then
	
		inflictor = inflictor:GetActiveWeapon()
		if ( !IsValid( inflictor ) ) then inflictor = attacker end
	end

	if ( attacker == ply ) then
	
		net.Start( "PlayerKilledSelf" )
			net.WriteEntity( ply )
		net.Broadcast()
		
		MsgAll( attacker:Nick() .. " suicided!\n" )
		
	return end

	if ( attacker:IsPlayer() ) then
	
		net.Start( "PlayerKilledByPlayer" )
		
			net.WriteEntity( ply )
			net.WriteString( inflictor:GetClass() )
			net.WriteEntity( attacker )
		
		net.Broadcast()
		
		MsgAll( attacker:Nick() .. " killed " .. ply:Nick() .. " using " .. inflictor:GetClass() .. "\n" )
		ply:EmitSound( "Sosad.mp3", 100, 100 )
		local howmanypoints = math.random(1,4)
			attacker:PS_GivePoints( howmanypoints )
		if howmanypoints == 1 then
			attacker:ChatPrint(" You received " .. howmanypoints .. " point for that kill.")
		elseif howmanypoints >= 2 then
			attacker:ChatPrint(" You received " .. howmanypoints .. " points for that kill.")
		end
		
	
	--net.Start( "PlayerKilled" )
	
		--net.WriteEntity( ply )
		--net.WriteString( inflictor:GetClass() )
		--net.WriteString( attacker:GetClass() )

	--net.Broadcast()
	
	MsgAll( ply:Nick() .. " was killed by " .. attacker:GetClass() .. "\n" )
	
	end
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	if ply:Team(TEAM_TITAN_N) then
		//ply:SetModel("models/humans/Group03m/Male_01.mdl")
	end

	ply:CreateRagdoll()
	
	ply:AddDeaths( 1 )
	
	if ( attacker:IsValid() && attacker:IsPlayer() ) then
	
		if ( attacker == ply ) then
			attacker:AddFrags( -1 )
		else
			attacker:AddFrags( 1 )
		end
		
	end
	
end

function GM:PlayerSelectSpawn( ply )
local default = ents.FindByClass("info_player_start")
local titan = ents.FindByClass("info_player_titan")
local corp = ents.FindByClass("info_player_corps")
local spectator = ents.FindByClass("info_player_spectator")
local mapIsAOT = ( string.find( string.lower( game.GetMap() ), "aot_" )) 

 local et = ents.AOTSPAWNS
local import = et.CanImportEntities(game.GetMap())

local random_default = math.random(#default)
local random_titan = math.random(#titan)
local random_corp = math.random(#corp)
local random_spectator = math.random(#spectator)

	if mapIsAOT or import then
		if ply:Team() == TEAM_TITAN_N then
		return titan[random_titan]
		elseif ply:Team() == TEAM_CORP_N then
		return corp[random_corp]
		elseif ply:Team() == TEAM_SPEC_N then
		return spectator[random_spectator]
		end
	else
		return default[random_default]
	end
end

function GM:PlayerAuthed( ply, steamID, uniqueID )
    print("Player: " .. ply:Nick() .. " has been authenticated.")
end

function GM:GetFallDamage( ply, speed )

	if ply:Team() ~= 1 then return end
 
	return ( speed / 8 )
 
end

//Start Damage Modifiers
function GM:EntityTakeDamage( ent, dmginfo)
	local attacker = dmginfo:GetAttacker()
	//Corps slow down player
		if ent:IsPlayer() then
			if (ent:Team(TEAM_CORP_N) and ent:Health() <= 100 and ent:Health() > 10) then
				ent:SetWalkSpeed( 3 * ent:Health() ) //Gamemode Default 300
				ent:SetRunSpeed( 6.5 * ent:Health() ) //Gamemode Default 650
			end
		end
	//end
	if dmginfo != nil then
	//if ent:IsPlayer() then
	//print( ent:GetActiveWeapon():GetClass() )
	//end
		if ent:IsPlayer() and ent:GetActiveWeapon():IsValid() and dmginfo:IsFallDamage()  then
			if ent:GetActiveWeapon():GetClass() == "3d_maneuver_gear_expert_c" or 
			   ent:GetActiveWeapon():GetClass() == "3d_maneuver_gear_c"        or 
			   ent:GetActiveWeapon():GetClass() == "titan_swep"                or
			   ent:GetActiveWeapon():GetClass() == "weapon_muskeblue"          or
			   ent:GetActiveWeapon():GetClass() == "weapon_sabreblue"          or
			   ent:GetActiveWeapon():GetClass() == "eren_titan_swep"           or
			   ent:GetActiveWeapon():GetClass() == "titan_swep_ab_test" 	   or		   
			   ent:GetActiveWeapon():GetClass() == "titan_swep_v2"         	   then
				dmginfo:ScaleDamage(0)
			else
				dmginfo:ScaleDamage(1)
			end
		end
		if attacker:IsPlayer() then
			if attacker:GetStepSize() == 170 and ent:GetName() == "AOT_Breakable_Wall_Titan" then
				dmginfo:ScaleDamage(0.2)
				attacker:PrintMessage(HUD_PRINTCONSOLE, "The wall's HP is at " .. tostring(ent:Health() - 100) .. " HP")
				if ent:Health() - 100 == 0 then 
					for k,v in pairs(player.GetAll()) do
						v:PrintMessage(HUD_PRINTTALK, attacker:GetName() .. " has destroyed a wall")
					end
				end
			elseif ent:GetName() == "AOT_Breakable_Wall_Titan" then
				dmginfo:ScaleDamage(0)
				attacker:PrintMessage(HUD_PRINTCONSOLE, "You cannot break this wall.")
			end
		elseif ent:GetName() == "AOT_Breakable_Wall_Titan" then
			dmginfo:ScaleDamage(0)
		end
	end
end

function GM:PlayerShouldTakeDamage(victim, attacker)
	if ( cvars.Bool( "sbox_godmode", false ) ) then return false end
	if not IsValid( victim:GetActiveWeapon() ) then return true end
	if victim:GetStepSize() == 170 then 
	    if attacker:IsNPC() then return false end
	    if not attacker:IsPlayer() then return false end
		if not IsValid( attacker:GetActiveWeapon() ) then return false end
		if attacker:GetActiveWeapon():GetClass() == "3d_maneuver_gear_c" 
		or attacker:GetActiveWeapon():GetClass() == "3d_maneuver_gear_expert_c" then
			return true
		else
			return false
		end
	else
	    return true
	end
	return true
end

function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)
		//print( "                         ") -- All of these are meant for debugging
    local attacker = dmginfo:GetAttacker()
	if dmginfo:GetAttacker() != nil then
		//print("Attacked by " .. tostring(attacker:GetName()))
	end
		//print( attacker:GetActiveWeapon():GetClass() )
	if attacker:IsPlayer() and attacker:GetActiveWeapon():IsValid() then
		//print( "stopped here 1")
		//print( attacker:GetActiveWeapon():GetClass() )
		if attacker:GetActiveWeapon():GetClass() == "3d_maneuver_gear_c" 
			or attacker:GetActiveWeapon():GetClass() == "3d_maneuver_gear_expert_c" 
			or attacker:GetActiveWeapon():GetClass() == "weapon_sabreblue" then
			//print( "stopped here 2")
			if (ply:GetStepSize() == 170 and hitgroup == 1) then
			//print(hitgroup)
				dmginfo:SetDamage(10)
				dmginfo:ScaleDamage( 10000 )
			elseif ply:GetStepSize() == 170 then
				dmginfo:SetDamage( 0 )
				//print( attacker:GetActiveWeapon():GetClass() .. " no damage")
			end
		//print( "stopped here 3d")
		end
	end
end
//End Damage Modifiers
 
hook.Add("PlayerSay", "MutePlayers", function(ply, text, public)
	cvar = string.Explode(" ", text)
	if ( cvar[1] == "/mute" ) and cvar[2] != nil then
		for k, v in pairs(player.GetAll()) do
			if v != ply and string.match(string.lower(v:GetName()), string.lower(cvar[2])) then			
				net.Start("MutePlayer")
				net.WriteEntity(v)
				net.Send(ply)
				return false
			elseif string.match(string.lower(ply:GetName()), string.lower(cvar[2])) then
				ply:ChatPrint("You are trying to mute yourself.")
				return false
			end
		end
		ply:ChatPrint("The player with the nickname " .. cvar[2] .. " was not found.")
		return false
	elseif ( cvar[1] == "/unmute" ) and cvar[2] != nil then
		for k, v in pairs(player.GetAll()) do
			if v != ply and string.match(string.lower(v:GetName()), string.lower(cvar[2])) then
				net.Start("UnMutePlayer")
				net.WriteEntity(v)
				net.Send(ply)
				return false
			elseif string.match(string.lower(ply:GetName()), string.lower(cvar[2])) then
				ply:ChatPrint("You are trying to unmute yourself.")
				return false
			end
		end
		ply:ChatPrint("The player with the nickname " .. cvar[2] .. " was not found.")
		return false
	elseif cvar[2] == nil and ( cvar[1] ==  "/mute" ) then
		ply:ChatPrint("Please add a name after /mute.")
		return false
	elseif cvar[2] == nil and ( cvar[1] == "/unmute" ) then
		ply:ChatPrint("Please add a name after /unmute.")
		return false
	elseif cvar[1] == "/kill" then
		umsg.Start("PlayerSuicideAOT",ply)
		umsg.End()
		return false
	end
end)



