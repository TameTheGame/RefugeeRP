

ITEM.Name = "Vodka";

ITEM.Weight = .5;
ITEM.Size = 1;
ITEM.Model = "models/props_junk/garbage_glassbottle002a.mdl";
ITEM.Usable = true;

ITEM.Desc = "A bottle of Vodka";

ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 50;
ITEM.FactoryStock = 10;

ITEM.License = 1;


function ITEM:OnUse()

	self.Owner:SetHealth( math.Clamp( self.Owner:Health() + 20, 0, self.Owner:GetNWInt( "MaxHealth" ) ) );
	self.Owner:SetNWInt( "sprint", math.Clamp( self.Owner:GetNWInt( "sprint" ) + 25, 0, 100 ) );
	self.Owner:AddMaxStamina( 25 );

end
