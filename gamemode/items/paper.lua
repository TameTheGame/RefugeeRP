
ITEM.Name = "Paper";

ITEM.Weight = .5;
ITEM.Size = 2;

--IF YOU PLAN TO CHANGE THIS MODEL, THERES OTHER PLACES IN THE SCRIPT YOU WILL NEED TO CHANGE ALSO.  DO A SEARCH FOR "models/props_c17/paper01.mdl"!
ITEM.Model = "models/props_c17/paper01.mdl";
ITEM.Usable = false;

ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 5;
ITEM.FactoryStock = 10;

ITEM.License = 2;

ITEM.Desc = "Used to write messages. (Use /write)";

function ITEM:PostSpawn( ent )

	
	
end


