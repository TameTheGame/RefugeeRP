

ITEM.Name = "MP7";

ITEM.Weight = 2;
ITEM.Size = 0;
ITEM.Model = "models/weapons/w_smg1.mdl";
ITEM.Usable = false;

ITEM.Desc = "Gas operated, rotating bolt, with a 200 rounds/min rate of fire.";

ITEM.BlackMarket = true;
ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 1600;
ITEM.FactoryStock = 6;

ITEM.RebelCost = 8;

function ITEM:OnPickup()
	
	self.Owner:ForceGive( "weapon_ts_mp7" );

	timer.Simple( .4, self.Owner.DropOneItem, self.Owner, self.UniqueID );
	timer.Simple( .4, self.Owner.CheckInventory, self.Owner );
	
	self.Owner:SaveWeapons();
	
end
