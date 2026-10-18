
ITEM.Name = "Buckshot x20 Container";

ITEM.Weight = 1;
ITEM.Size = 1;
ITEM.Model = "models/items/boxbuckshot.mdl";
ITEM.Usable = false;

ITEM.Desc = "Contains 20 Buckshot shells";

ITEM.BlackMarket = true;
ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 115;
ITEM.FactoryStock = 3;

ITEM.RebelCost = 5;

function ITEM:OnPickup()
	
	self.Owner:GiveAmmo( 20, "buckshot" );

	timer.Simple( .4, self.Owner.DropOneItem, self.Owner, self.UniqueID );
	timer.Simple( .4, self.Owner.CheckInventory, self.Owner );
	
end
