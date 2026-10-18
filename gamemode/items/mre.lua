ITEM.Name = "MRE (Meal Ready to Eat)";

ITEM.Weight = .5;
ITEM.Size = 1;
ITEM.Model = "models/props_junk/garbage_takeoutcarton001a.mdl";
ITEM.Usable = true;

ITEM.Desc = "A self-contained, individual field ration in lightweight packaging";

ITEM.BlackMarket = false;
ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 30;
ITEM.FactoryStock = 5;

ITEM.License = 1;

function ITEM:OnUse()

	self.Owner:SetHealth( math.Clamp( self.Owner:Health() + 50, 0, self.Owner:GetNWInt( "MaxHealth" ) ) );

end
