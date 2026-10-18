
ITEM.Name = "SMG Rounds x45 Container";

ITEM.Weight = 2;
ITEM.Size = 2;
ITEM.Model = "models/items/boxmrounds.mdl";
ITEM.Usable = false;

ITEM.Desc = "Contains 45 SMG rounds";

ITEM.BlackMarket = true;
ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 100;
ITEM.FactoryStock = 3;

ITEM.RebelCost = 4;

function ITEM:OnPickup()
	
	self.Owner:GiveAmmo( 45, "smg1" );

	timer.Simple( .4, self.Owner.DropOneItem, self.Owner, self.UniqueID );
	timer.Simple( .4, self.Owner.CheckInventory, self.Owner );
	
end
