
STATUS_BLEED = 0;

local meta = FindMetaTable( "Player" );

--Set bleeding damage (per 3 seconds)
function meta:SetBleedAmount( amt )

	self:SetField( "bleedwound", amt );

end

function meta:GetBleedAmount()

	return self:GetField( "bleedwound" );

end

--Makes player bleed
function meta:MakeBleed()

	self:AddStatus( STATUS_BLEED );
	self:SetNWInt( "isbleeding", 1 );
	
	
end

--Stops bleeding
function meta:StopBleed()

	self:RemoveStatus( STATUS_BLEED );
	self:SetNWInt( "isbleeding", 0 );
	self:SetNWInt( "bleedwound", 0 );

end

function meta:IsBleeding()

	if( self:HasStatus( STATUS_BLEED ) ) then return true; end
	
	return false;

end

--Returns true if player has no status
function meta:HasNoStatus()

	if( #self:GetTable().status < 1 ) then return true; end
	
	return false;

end

--Checks if player has a status
function meta:HasStatus( status )

	if( table.HasValue( self:GetTable().status, status ) ) then return true; end
	
	return false;

end

--Add status to player
function meta:AddStatus( status )

	self:InsertIntoField( "status", status );

end

--Remove status from player
function meta:RemoveStatus( status )

	self:RemoveFromField( "status", status );

end
