ITEM.Name = 'Snipars'
ITEM.Price = 1000
ITEM.Model = 'models/player/snipars.mdl'
ITEM.AllowedUserGroups = { "founder", "supporter" }

function ITEM:OnEquip(ply)
        if ply:Team() == TEAM_CORP_N then
                ply:SetModel(self.Model)
        end
end
 
function ITEM:PlayerSpawn(ply)
        if ply:Team() == TEAM_CORP_N then
                ply:SetModel(self.Model)
        elseif ply:Team() == TEAM_TITAN_N then
                --ply:StripWeapons()
                --ply:GiveGamemodeWeapons()
        elseif ply:Team() == TEAM_SPEC_N then
                ply:SetModel("models/crow.mdl")
        end
end
 
function ITEM:OnHolster(ply)
        if ply:Team() == TEAM_CORP_N then
                ply:PickRandomModel()
        elseif ply:Team() == TEAM_TITAN_N then
                --ply:StripWeapons()
                --ply:GiveGamemodeWeapons()
        elseif ply:Team() == TEAM_SPEC_N then
                ply:SetModel("models/crow.mdl")
        end
end
 
function ITEM:PlayerSetModel(ply)
        ply:SetModel(self.Model)
end
