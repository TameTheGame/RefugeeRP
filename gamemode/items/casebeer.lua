

ITEM.Name = "A Case of Beer";

ITEM.Weight = 4;
ITEM.Size = 5;
ITEM.Model = "models/props/cs_militia/caseofbeer01.mdl";
ITEM.Usable = true;

ITEM.Desc = "Alcoholic beverage";

ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 150;
ITEM.FactoryStock = 1;

ITEM.License = 1;


function ITEM:OnUse()

	self.Owner:SetHealth( math.Clamp( self.Owner:Health() + 20, 0, self.Owner:GetNWInt( "MaxHealth" ) ) );
	self.Owner:SetNWInt( "sprint", math.Clamp( self.Owner:GetNWInt( "sprint" ) + 25, 0, 100 ) );
	self.Owner:AddMaxStamina( 25 );

end
