ITEM.Name = "Vitamin Water";

ITEM.Weight = 1;
ITEM.Size = 1;
ITEM.Model = "models/props_junk/garbage_glassbottle002a.mdl";
ITEM.Usable = true;

ITEM.Desc = "Water including electrolytes and Vitamin B. Increases stamina and speed temporarily.";

ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 30;
ITEM.FactoryStock = 2;

ITEM.LastSoda = 0;
ITEM.SodaCount = 0;

ITEM.SupplyLicense = 1;

ITEM.License = 1;

function ITEM:OnUse()

	if( CurTime() - self.LastSoda > 180 ) then
		
		self.SodaCount = 0;
		
	end

	self.SodaCount = self.SodaCount + 1;
	
	if( self.SodaCount <= 4 ) then

		self.Owner:SetHealth( math.Clamp( self.Owner:Health() + 15, 0, self.Owner:GetNWInt( "MaxHealth" ) ) );
		self.Owner:SetNWInt( "sprint", math.Clamp( self.Owner:GetNWInt( "sprint" ) + 20, 0, 100 ) );
		self.Owner:TempStatBoost( "Speed", 3, 60 );
		
	else
	
		self.Owner:TempStatBoost( "Sprint", -5, 60 );
	
	end
	
	self.LastSoda = CurTime();
	
	self.Owner:AddMaxStamina( 22 );
	
end
