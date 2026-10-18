ITEM.Name = "Banana";

ITEM.Weight = .5;
ITEM.Size = 1;
ITEM.Model = "models/props/cs_italy/bananna.mdl";
ITEM.Usable = true;

ITEM.Desc = "A banana";

ITEM.BlackMarket = false;
ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 6;
ITEM.FactoryStock = 1;

ITEM.License = 1;

function ITEM:OnUse()

	self.Owner:SetHealth( math.Clamp( self.Owner:Health() + 32, 0, self.Owner:GetNWInt( "MaxHealth" ) ) );
	self.Owner:AddMaxStamina( 30 );

end
