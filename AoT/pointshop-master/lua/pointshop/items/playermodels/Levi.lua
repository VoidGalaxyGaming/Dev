ITEM.Name = 'Levi'
ITEM.Price = 500
ITEM.Model = 'models/player/aot/characters/levi.mdl'

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
