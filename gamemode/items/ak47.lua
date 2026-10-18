

ITEM.Name = "AK47";

ITEM.Weight = 2;
ITEM.Size = 0;
ITEM.Model = "models/weapons/w_rif_ak47.mdl";
ITEM.Usable = false;

ITEM.Desc = "Gas-operated, rotating bolt, 600 rounds/min rate of fire.";

ITEM.BlackMarket = true;
ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 1700;
ITEM.FactoryStock = 6;

ITEM.RebelCost = 20;

function ITEM:OnPickup()
	
	self.Owner:ForceGive( "weapon_ts_ak47" );

	timer.Simple( .4, self.Owner.DropOneItem, self.Owner, self.UniqueID );
	timer.Simple( .4, self.Owner.CheckInventory, self.Owner );
	
	self.Owner:SaveWeapons();
	
end
