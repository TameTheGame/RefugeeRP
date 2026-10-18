
ITEM.Name = "Pistol Rounds x30 Container";

ITEM.Weight = 1;
ITEM.Size = 1;
ITEM.Model = "models/items/boxsrounds.mdl";
ITEM.Usable = false;

ITEM.Desc = "Contains 30 pistol rounds";

ITEM.BlackMarket = true;
ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 85;
ITEM.FactoryStock = 3;

ITEM.RebelCost = 3;

function ITEM:OnPickup()
	
	self.Owner:GiveAmmo( 30, "pistol" );

	timer.Simple( .4, self.Owner.DropOneItem, self.Owner, self.UniqueID );
	timer.Simple( .4, self.Owner.CheckInventory, self.Owner );
	
end
