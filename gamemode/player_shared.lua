

local meta = FindMetaTable( "Player" );

--Clientside, we can use these functions instead of LocalPlayer():GetNWINt, etc..
if( CLIENT ) then

	function GetInt( var )
	
		if( PrivateInt[var] ) then
		
			return PrivateInt[var];
		
		end
	
		return LocalPlayer():GetNWInt( var );
	
	end
	
	function GetString( var )
	
		if( PrivateString[var] ) then
		
			return PrivateString[var];
		
		end
	
		return LocalPlayer():GetNWString( var );
	
	end
	
	function GetFloat( var )
	
	
		if( PrivateFloat[var] ) then
		
			return PrivateFloat[var];
		
		end
	
		return LocalPlayer():GetNWFloat( var );
	
	end
	
	function meta:HasItem( id )
	
		if( Inventory[id] ) then return true; end
		
		return false;

	end
	
	function meta:HasWeapon( id )
	
		local weaps = self:GetWeapons();
		
		for k, v in pairs( weaps ) do
		
			if( v:GetClass() == id ) then return true; end
		
		end
		
		return false;
	
	end

end

function meta:GetRagdoll()

	local ragid;
	
	if( SERVER ) then
	
		ragid = self:GetField( "ragdoll" );
	
	else
		
		ragid = GetInt( "ragdoll" );
		
	end
	
	local ragdoll = ents.GetByIndex( ragid );
	
	return ragdoll;

end

function meta:IsRagdolled() 

	if( CLIENT ) then
	
		if( GetInt( "ragdolled" ) == 1 ) then return true; end
	
	else
	
		if( self:GetField( "ragdolled" ) == 1 ) then return true; end
	
	end
	
	return false;

end

--If the player is in the combine "defense" (metro, OW, etc..)
function meta:IsCombineDefense()

	local CombineTeams = { 2, 3, 4 }

	for k, v in pairs( CombineTeams ) do
	
		if( v == self:Team() ) then
			return true;
		end
	
	end
	
	return false;

end

--If is on the Combine side
function meta:IsCombine() 

	local CombineTeams = { 2, 3, 4, 5 }

	for k, v in pairs( CombineTeams ) do
	
		if( v == self:Team() ) then
			return true;
		end
	
	end
	
	return false;

end

function meta:HasHeavyWeapon()

	local hw = 
	{
	
		"weapon_ts_ar2",
		"weapon_ts_beanbagshotgun",
		"weapon_ts_sniper",
		"weapon_ts_beanbagshotgun"
	
	}
	
	for k, v in pairs( hw ) do
	
		if( self:HasWeapon( v ) ) then return true; end
	
	end
	
	return false;	

end


function meta:HasCombineFlag( flag )

	if( CLIENT ) then
		if( string.find( GetString( "combineflags" ), flag ) ) then return true; end
	else
		if( string.find( self:GetField( "combineflags" ), flag ) ) then return true; end
	end
	
	return false;

end

function meta:HasPlayerFlag( flag )

	if( CLIENT ) then
		if( string.find( GetString( "miscflags" ), flag ) ) then return true; end
	else
		if( string.find( self:GetField( "miscflags" ), flag ) ) then return true; end
	end
	
	return false;

end

