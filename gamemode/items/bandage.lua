

ITEM.Name = "Bandage";

ITEM.Weight = .2;
ITEM.Size = .6;
ITEM.Model = "models/props/cs_office/paper_towels.mdl";
ITEM.Usable = false;

ITEM.Desc = "Patch up wounds";

ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 4;
ITEM.FactoryStock = 15;

ITEM.License = 3;

function ITEM:OnUse()

	if( self.Owner:IsBleeding() ) then

		if( self.Owner:GetNWInt( "bleedwound" ) > 0 ) then
		
			local wound = self.Owner:GetNWInt( "bleedwound" );
			local amt = 0;
			
			amt = 5 * ( self.Owner:GetNWFloat( "stat.Medic" ) / 80 );
		
			self.Owner:SetNWInt( "bleedwound", math.Clamp( wound - amt, 0, 100 ) );
		
			if( ( wound - amt ) <= 0 ) then
			
				self.Owner:StopBleed();
			
			end
		
		end
		
	else
		
		self.Owner:PrintMessage( 3, "You're not bleeding" );
		
	end
	
end
