

ITEM.Name = "HK P46";

ITEM.Weight = 1;
ITEM.Size = 0;
ITEM.Model = "models/weapons/w_pist_glock18.mdl";
ITEM.Usable = false;

ITEM.Desc = "Human weaponry";

ITEM.BlackMarket = true;
ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 400;
ITEM.FactoryStock = 4;

ITEM.RebelCost = 5;

function ITEM:OnPickup()
	
	self.Owner:ForceGive( "weapon_ts_hkp46" );

	timer.Simple( .4, self.Owner.DropOneItem, self.Owner, self.UniqueID );
	timer.Simple( .4, self.Owner.CheckInventory, self.Owner );
	
	self.Owner:SaveWeapons();
	
end
