ents.AOTSPAWNS = {}

local table = table
local math = math
local pairs = pairs

function PlaceSpawns()
   local import = ents.AOTSPAWNS.CanImportEntities(game.GetMap())

   if import then
      ents.AOTSPAWNS.ProcessImportScript(game.GetMap())
   end
end

function ents.AOTSPAWNS.CanImportEntities(map)
   if not tostring(map) then return false end
   
   local fname = "aot/maps/" .. map .. "_aot.txt"

   return file.Exists(fname, "DATA")
end

local function CreateImportedEnt(entName, pos)
   if not entName or not pos then return false end

   local ent = ents.Create(entName)
   if not IsValid(ent) then return false end
   ent:SetPos(pos)
   //ent:SetAngles(ang)

   ent:Spawn()

   //ent:PhysWake()

   return true
end

function ents.AOTSPAWNS.CanAddCustomSpawns(map)--seems done
   if not tostring(map) then return false end

   local filename = "aot/maps/" .. map .. "_aot.txt"

   return file.Exists(filename, "DATA")
end

local function ImportEntities(map)--seems done
   if not ents.AOTSPAWNS.CanAddCustomSpawns(map) then return end

   local filename = "aot/maps/" .. map .. "_aot.txt"

   local textdata = file.Read(filename, "DATA")
   local lines = string.Explode("\n", textdata)
   local num = 0
   for k, line in ipairs(lines) do
         local data = string.Explode("\t", line)

         local fail = true -- pessimism

         if data[2] then
            local entName = data[1]
            local pos = nil

            local posraw = string.Explode(" ", data[2])
            pos = Vector(tonumber(posraw[1]), tonumber(posraw[2]), tonumber(posraw[3]))

            -- Some dummy ents remap to different, real entity names

            fail = not CreateImportedEnt(entName, pos)
         end

         if fail and k > 3 then
            ErrorNoHalt("Invalid line " .. k .. " in " .. filename .. "\n")
         else
            num = num + 1
         end
   end

   //MsgN("Spawned " .. num .. " entities found in script.")

   return true
end


function ents.AOTSPAWNS.ProcessImportScript(map)--seems done
   //MsgN("Weapon/ammo placement script found, attempting import...")

   local result = ImportEntities(map)
   
   if result then
      //MsgN("Weapon placement script import successful!")
   else
      ErrorNoHalt("Weapon placement script import failed!\n")
   end
end
