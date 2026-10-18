

ITEM.Name = "NRD Standard Issue Pistol";

ITEM.Weight = 1;
ITEM.Size = 0;
ITEM.Model = "models/weapons/w_pistol.mdl";
ITEM.Usable = false;

ITEM.Desc = "A standard 9mm issed pistol.";

ITEM.BlackMarket = true;
ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 525;
ITEM.FactoryStock = 3;

ITEM.RebelCost = 6;

function ITEM:OnPickup()
	
	self.Owner:ForceGive( "weapon_ts_pistol" );

	timer.Simple( .4, self.Owner.DropOneItem, self.Owner, self.UniqueID );
	timer.Simple( .4, self.Owner.CheckInventory, self.Owner );
	
end
