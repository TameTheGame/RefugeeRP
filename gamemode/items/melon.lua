ITEM.Name = "Melon";

ITEM.Weight = 3;
ITEM.Size = 3;
ITEM.Model = "models/props_junk/watermelon01.mdl";
ITEM.Usable = true;

ITEM.Desc = "A watermelon";

ITEM.BlackMarket = false;
ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 6;
ITEM.FactoryStock = 1;

ITEM.License = 1;

function ITEM:OnUse()

	self.Owner:SetHealth( math.Clamp( self.Owner:Health() + 32, 0, self.Owner:GetNWInt( "MaxHealth" ) ) );
	self.Owner:AddMaxStamina( 30 );

end
