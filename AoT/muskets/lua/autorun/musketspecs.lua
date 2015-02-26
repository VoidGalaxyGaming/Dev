

if CLIENT or game.SinglePlayer() then

if GetConVar("NPC_WEP2_Muzzle_fx") == nil then
CreateClientConVar("NPC_WEP2_Muzzle_fx", "1", false, false)
print("Client NPC_WEP2_Muzzle_fx Con Var Created")
end

if GetConVar("Squad_Weps") == nil then
CreateClientConVar( "Squad_Weps", 0, false, true)
print("Client Squad_Weps Con Var Created")
end

if GetConVar("Squad_Num") == nil then
CreateClientConVar( "Squad_Num", 1, false, true)
print("Client Squad_Num Con Var Created")
end

if GetConVar("NPC_Grenades") == nil then
CreateClientConVar( "NPC_Grenades", 1, false, true)
print("Client NPC_Grenades Con Var Created")
end

if GetConVar("NPC_Manhacks") == nil then
CreateClientConVar( "NPC_Manhacks", 0, false, true )
print("Client NPC_Manhacks Con Var Created")
end
end