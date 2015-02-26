ITEM.Name = 'Akita'
ITEM.Price = 500
ITEM.Model = 'models/captainbigbutt/vocaloid/neru_append.mdl'
ITEM.AllowedUserGroups = { "founder", "coowner", "council", "headadmin", "superadmin", "admin", "moderator", "gold", "platinum", "god" }

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
