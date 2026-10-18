
ITEM.Name = "Backpack";

ITEM.Weight = .1;
ITEM.Size = 0;
ITEM.Model = "models/props_junk/garbage_bag001a.mdl";
ITEM.Usable = false;
ITEM.Wearable = true;

ITEM.Desc = "Use to carry more things";

ITEM.FactoryBuyable = true;
ITEM.FactoryPrice = 10;
ITEM.FactoryStock = 3;

ITEM.License = 2;

function ITEM:CanPickup( ply )

	if( ply:HasItem( "backpack" ) ) then
		ply:PrintMessage( 3, "You already have a backpack" );
		return false;
	end
	
	return true;

end

function ITEM:OnPickup()

	if( self.Owner:IsCombineDefense() ) then
		self.Owner:SetNWFloat( "inventory.MaxSize", 32 );
	else
		self.Owner:SetNWFloat( "inventory.MaxSize", 12 )
	end

end

function ITEM:OnDrop()

	if( self.Owner:IsCombineDefense() ) then
		self.Owner:SetNWFloat( "inventory.MaxSize", 32 );
	else
		self.Owner:SetNWFloat( "inventory.MaxSize", 4 )
	end
	
	

end

