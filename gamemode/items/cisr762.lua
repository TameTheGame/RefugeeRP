

ITEM.Name = "Combine CISR-762";

ITEM.Weight = 3;
ITEM.Size = 0;
ITEM.Model = "models/weapons/w_msg90.mdl";
ITEM.Usable = false;

ITEM.Desc = "Combine sniper";

ITEM.BlackMarket = true;
ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 50000;
ITEM.FactoryStock = 4;

ITEM.RebelCost = 90;

function ITEM:OnPickup()
	
	self.Owner:ForceGive( "weapon_ts_combinesniper" );

	timer.Simple( .4, self.Owner.DropOneItem, self.Owner, self.UniqueID );
	timer.Simple( .4, self.Owner.CheckInventory, self.Owner );
	
	timer.Simple( 1, self.Owner.SaveInfo, self.Owner );
	
end
