
ITEM.Name = "The Metro Informer";

ITEM.Weight = .5;
ITEM.Size = 2;

--IF YOU PLAN TO CHANGE THIS MODEL, THERES OTHER PLACES IN THE SCRIPT YOU WILL NEED TO CHANGE ALSO.  DO A SEARCH FOR "models/props_c17/paper01.mdl"!
ITEM.Model = "models/props_junk/garbage_newspaper001a.mdl";
ITEM.Usable = true;

ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 0;
ITEM.FactoryStock = 10;

ITEM.License = 3;

ITEM.Desc = "Read The Metro Informer";

function ITEM:OnUse()

	umsg.Start( "ShowNewspaper", self.Owner );
	umsg.End();
	
	self.Owner:GiveItem( "newspaper" );
	
end



