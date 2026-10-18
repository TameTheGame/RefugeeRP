


ITEM.Name = "Bottled Water";

ITEM.Weight = 1;
ITEM.Size = 1;
ITEM.Model = "models/props/cs_office/Water_bottle.mdl";
ITEM.Usable = true;

ITEM.Desc = "8fl. ounces of water";

ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 10;
ITEM.FactoryStock = 10;

ITEM.License = 1;

ITEM.CanMix = true;

function ITEM:OnUse()

	self.Owner:SetHealth( math.Clamp( self.Owner:Health() + 10, 0, self.Owner:GetNWInt( "MaxHealth" ) ) );
	self.Owner:SetNWInt( "sprint", math.Clamp( self.Owner:GetNWInt( "sprint" ) + 15, 0, 100 ) );
	self.Owner:AddMaxStamina( 20 );
	
end
