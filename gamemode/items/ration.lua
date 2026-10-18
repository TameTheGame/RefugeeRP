
ITEM.Name = "Supply Crate";

ITEM.Weight = 1;
ITEM.Size = 1;
ITEM.Model = "models/Items/item_item_crate.mdl";
ITEM.Usable = true;

ITEM.BlackMarket = true;
ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 100;
ITEM.FactoryStock = 6;

ITEM.RebelCost = 2;

ITEM.Desc = "A supply crate containing food, water, and 50 credits.";


function ITEM:OnPickup()
	
	if( self.Owner:IsCombineDefense() ) then
		
		SetGlobalInt( "CombineRations", GetGlobalInt( "CombineRations" ) + 1 );
		timer.Simple( .4, self.Owner.DropOneItem, self.Owner, self.UniqueID );
		timer.Simple( .4, self.Owner.CheckInventory, self.Owner );
		
	end
	
end

function ITEM:OnUse()

	self.Owner:SetNWFloat( "money", self.Owner:GetNWFloat( "money" ) + 50 );
	self.Owner:SetHealth( math.Clamp( self.Owner:Health() + 5, 0, self.Owner:GetNWInt( "MaxHealth" ) ) );
	self.Owner:AddMaxStamina( 70 );

end
