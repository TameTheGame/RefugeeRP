

ITEM.Name = "MP5K";

ITEM.Weight = 2;
ITEM.Size = 0;
ITEM.Model = "models/weapons/w_smg_mp5.mdl";
ITEM.Usable = false;

ITEM.Desc = "Roller-delayed blowback, closed bolt, 800 rounds/min rate of fire.";

ITEM.BlackMarket = true;
ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 1200;
ITEM.FactoryStock = 6;

ITEM.RebelCost = 7;

function ITEM:OnPickup()
	
	self.Owner:ForceGive( "weapon_ts_mp5k" );

	timer.Simple( .4, self.Owner.DropOneItem, self.Owner, self.UniqueID );
	timer.Simple( .4, self.Owner.CheckInventory, self.Owner );
	
	self.Owner:SaveWeapons();
	
end
