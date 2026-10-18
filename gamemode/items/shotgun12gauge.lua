

ITEM.Name = "SPAS 12-Gauge Shotgun";

ITEM.Weight = 1;
ITEM.Size = 0;
ITEM.Model = "models/weapons/w_shotgun.mdl";
ITEM.Usable = false;

ITEM.Desc = "Weaponry";

ITEM.BlackMarket = true;
ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 825;
ITEM.FactoryStock = 6;

ITEM.RebelCost = 10;

function ITEM:OnPickup()
	
	self.Owner:ForceGive( "weapon_ts_12gauge" );

	timer.Simple( .4, self.Owner.DropOneItem, self.Owner, self.UniqueID );
	timer.Simple( .4, self.Owner.CheckInventory, self.Owner );
	
	self.Owner:SaveWeapons();
	
end
