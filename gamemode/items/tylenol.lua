
ITEM.Name = "Morphine";

ITEM.Weight = .5;
ITEM.Size = .4;
ITEM.Model = "models/props_lab/jar01a.mdl";
ITEM.Usable = true;

ITEM.Desc = "Clears up your head and makes you more conscious.";

ITEM.LastPill = 0;
ITEM.PillCount = 0;

ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 4;
ITEM.FactoryStock = 5;

ITEM.License = 3;

function ITEM:OnUse()

	self.Owner:SetNWFloat( "conscious", math.Clamp( self.Owner:GetNWFloat( "conscious" ) + 10, 0, 140 ) );
	
	if( self.LastPill == 0 or CurTime() - self.LastPill < 180 ) then
	
		self.PillCount = self.PillCount + 1;
	
	else
	
		self.PillCount = 0;
	
	end
	
	self.LastPill = CurTime();

	
	if( self.PillCount > 4 ) then
	
		self.Owner:SetNWFloat( "conscious", 0 );
		self.Owner:GoUnconscious();
		self.Owner:PrintMessage( 3, "Overdosed" );
	
	end

end
