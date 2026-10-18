
--Handles door ownership
function GM:ShowSpare2( ply )

	local trace = { }
	trace.start = ply:EyePos();
	trace.endpos = trace.start + 120 * ply:GetAimVector();
	trace.filter = ply;
	
	local tr = util.TraceLine( trace );
	
	if( ValidEntity( tr.Entity ) and tr.Entity:IsOwnable() ) then
	
		if( tr.Entity:IsVehicle() ) then
			
			if( tr.Entity:HasNoOwners() ) then
				
				TS.Notify( ply, "Owned vehicle", 4 );
				tr.Entity:OwnDoor( ply );
				
			elseif( tr.Entity:OwnsDoor( ply ) ) then
				
				TS.Notify( ply, "Unowned vehicle", 4 );
				tr.Entity:UnownDoor( ply );
				
			else
				
				TS.Notify( ply, "You don't own this!", 4 );
				
			end
				
			return;
			
		end
	
		if( not tr.Entity:OwnsDoor( ply ) ) then
		
			local dstate = tr.Entity:GetNWInt( "doorstate" ) or 0;
			Msg( dstate .. "\n" );
			if( dstate == 0 or ( ( dstate == 3 or dstate == 1 or door == 6 ) and ply:IsCombine() ) ) then
		
				if( tr.Entity:HasNoOwners() ) then
				
					local price = tr.Entity:GetNWFloat( "doorprice" );
					
					if( not tr.Entity:GetNWBool( "formatteddoor" ) or GetGlobalInt( "PropertyPaying" ) == 0 ) then
						price = 50;
					end
				
					if( ply:CanAfford( price ) ) then
					
						tr.Entity:OwnDoor( ply );
					
						if( not tr.Entity:GetNWString( "buildingname" ) or
							tr.Entity:GetNWString( "buildingname" ) == "-1" or
							tr.Entity:GetNWString( "buildingname" ) == " " or
							tr.Entity:GetNWString( "buildingname" ) == "" ) then
							
							TS.Notify( ply, "Owned door", 4 );
							
						else
						
							if( TS.DoorGroups[tr.Entity:GetNWString( "doorparent" )] ) then
						
								TS.Notify( ply, "Owned property: '" .. tr.Entity:GetNWString( "doorparent" ) .. "' for " .. price .. " credits", 4 );
								tr.Entity:OwnProperty( ply );
							
							end
						end
						ply:TakeMoney( price );
						ply:SaveField( "charTokens", ply:GetNWFloat( "money" ) );
						

						
					else
						TS.Notify( ply, "Cannot afford this", 4 );
					end
				else
					TS.Notify( ply, "Someone already owns this", 4 );
				end
				
			else
			
				TS.Notify( ply, "You cannot own this", 4 );
			
			end
			
		else
		
			tr.Entity:UnownDoor( ply );
			tr.Entity:SetNWString( "doorname", tr.Entity:GetTable().OrigName );
			
			if( tr.Entity:GetNWString( "buildingname" ) == "-1" or
				tr.Entity:GetNWString( "buildingname" ) == " " or
				tr.Entity:GetNWString( "buildingname" ) == "" ) then

				TS.Notify( ply, "Unowned door", 4 );
							
			else
						
				if( TS.DoorGroups[tr.Entity:GetNWString( "doorparent" )] ) then
						
					TS.Notify( ply, "Unowned property: '" .. tr.Entity:GetNWString( "doorparent" ) .. "'", 4 );
						
					for k, v in pairs( TS.DoorGroups[tr.Entity:GetNWString( "doorparent" )] ) do
						
						if( v:OwnsDoor( ply ) ) then		
							v:SetNWString( "doorname", v:GetTable().OrigName );
							v:UnownDoor( ply );
						end
								
					end
							
				end
			end
		
		end
	
	end

end
concommand.Add( "gm_showspare2", TS.F4 );

local meta = FindMetaTable( "Player" );

function meta:UnownallDoors()

	if( not self:GetTable().Owned ) then return; end

	for k, v in pairs( self:GetTable().Owned ) do
	
		v:UnownDoor( self );
	
	end

end

--Bunch of meta functions regarding door ownership
local meta = FindMetaTable( "Entity" );

--Returns true if the ply owns the door
function meta:OwnsDoor( ply )

	if( self:GetNWInt( "Owned" ) == 1 ) then
	
		if( self:GetTable().MainOwner == ply ) then
		
			return true;
		
		else
		
			if( self:GetTable().Owners == nil ) then self:GetTable().Owners = { }; end
		
			for k, v in pairs( self:GetTable().Owners ) do
			
				if( v == ply ) then
				
					return true;
					
				end
			
			end
		
		end	
	
	end
	
	return false;

end

--Gets ply to own the door
function meta:OwnDoor( ply ) 


	if( self:GetTable().MainOwner == nil ) then
		self:GetTable().MainOwner = ply;
		self:GetTable().MainOwnerSteamID = ply:SteamID();
	else
		if( self:GetTable().Owners == nil ) then self:GetTable().Owners = { }; end
		if( self:GetTable().OwnersBySteamID == nil ) then self:GetTable().OwnersBySteamID = { }; end
		 
		self:GetTable().OwnersBySteamID[#self:GetTable().Owners + 1] = ply:SteamID();
		self:GetTable().Owners[#self:GetTable().Owners + 1] = ply;
		
		
	end
	
							
	local checktime = CurTime() + 360;

	Msg( sql.Query( "INSERT INTO `rtrp_doors` ( `SteamID`, `id`, `CheckTime`, `SessionID` ) VALUES ( '" .. ply:SteamID() .. "', '" .. self:GetNWInt( "doorid" ) .. "', '" .. checktime .. "', '" .. TS.CrntSessionID .. "' )" ) );
	PrintTable( sql.Query( "SELECT *  FROM  `rtrp_doors`" ) );
	
	table.insert( ply:GetTable().Owned, self );
	
	self:SetNWInt( "Owned", 1 );

end

function meta:OwnsAnyOfProperty( ply )

	local propertylist = { }
	
	table.insert( propertylist, self:GetNWString( "doorparent" ) );

	if( TS.DoorGroups[self:GetNWString( "doorparent" )] ) then

		for k, v in pairs( TS.DoorGroups[self:GetNWString( "doorparent" )] ) do
									
			if( not table.HasValue( propertylist, v:GetNWString( "doorparent" ) ) ) then
			
				table.insert( propertylist, v:GetNWString( "doorparent" ) );
			
			end
									
		end
	
	end

	for _, v in pairs( propertylist ) do
	
		if( TS.DoorGroups[v] ) then
	
			for _, m in pairs( TS.DoorGroups[v] ) do
										
				if( m:OwnsDoor( ply ) ) then
				
					return true;
					
				end
									
			end
		end
	
		
	end
	
	return false;

end

function meta:OwnsProperty( ply )

	local propertylist = { }
	
	table.insert( propertylist, self:GetNWString( "doorparent" ) );

	if( TS.DoorGroups[self:GetNWString( "doorparent" )] ) then

		for k, v in pairs( TS.DoorGroups[self:GetNWString( "doorparent" )] ) do
									
			if( not table.HasValue( propertylist, v:GetNWString( "doorparent" ) ) ) then
			
				table.insert( propertylist, v:GetNWString( "doorparent" ) );
			
			end
									
		end
		
	end
	
	for _, v in pairs( propertylist ) do
	
		if( TS.DoorGroups[v] ) then
	
			for _, m in pairs( TS.DoorGroups[v] ) do
										
				if( not m:OwnsDoor( ply ) ) then
				
					return false;
					
				end
									
			end
		end
	
		
	end
	
	return true;

end

--Gets ply to own the entire property
function meta:OwnProperty( ply )

	local propertylist = { }
	
	table.insert( propertylist, self:GetNWString( "doorparent" ) );

	for k, v in pairs( TS.DoorGroups[self:GetNWString( "doorparent" )] ) do
								
		if( not table.HasValue( propertylist, v:GetNWString( "doorparent" ) ) ) then
		
			table.insert( propertylist, v:GetNWString( "doorparent" ) );
		
		end
								
	end

	for _, v in pairs( propertylist ) do
	
		if( TS.DoorGroups[v] ) then
	
			for _, m in pairs( TS.DoorGroups[v] ) do
										
				if( not m:OwnsDoor( ply ) ) then
					m:OwnDoor( ply );
				end
										
			end
		end
	
		
	end


end

function meta:GetDoorOwnersList()

	local tbl = { }
	
	for k, v in pairs( self:GetTable().Owners ) do
	
		table.insert( tbl, v );
	
	end
	
	table.insert( tbl, self:GetTable().MainOwner );
	
	return tbl;

end

function meta:UnownProperty( ply )

	local propertylist = { }
	
	table.insert( propertylist, self:GetNWString( "doorparent" ) );

	for k, v in pairs( TS.DoorGroups[self:GetNWString( "doorparent" )] ) do
								
		if( not table.HasValue( propertylist, v:GetNWString( "doorparent" ) ) ) then
		
			table.insert( propertylist, v:GetNWString( "doorparent" ) );
		
		end
								
	end

	for _, v in pairs( propertylist ) do
	
		if( TS.DoorGroups[v] ) then
	
			for _, m in pairs( TS.DoorGroups[v] ) do
										
				if( m:OwnsDoor( ply ) ) then
					m:UnownDoor( ply );
				end
										
			end
		end
	
		
	end


end

--Gets ply to unown the door
function meta:UnownDoor( ply )

	if( self:GetTable().MainOwner == ply ) then
	
		self:GetTable().MainOwner = nil;
		self:GetTable().MainOwnerSteamID = nil;
	
	else
	
		if( self:GetTable().Owners == nil ) then self:GetTable().Owners = { }; end
		if( self:GetTable().OwnersBySteamID == nil ) then self:GetTable().OwnersBySteamID = { }; end
		
		for k, v in pairs( self:GetTable().Owners ) do
		
			if( v == ply ) then
			
				self:GetTable().Owners[k] = nil;
				self:GetTable().OwnersBySteamID[k] = nil;
				return;
			
			end
		
		end
	
	end
	
							
	local checktime = CurTime() + 360;

	sql.Query( "DELETE FROM `rtrp_doors` WHERE `id` = '" .. self:GetNWInt( "doorid" ) .. "'" );
						
	for k, v in pairs( ply:GetTable().Owned ) do
	
		if( v == self ) then
		
			ply:GetTable().Owned[k] = nil;
			break;
		
		end
	
	end
	
	if( self:HasNoOwners() ) then
	
		self:SetNWInt( "Owned", 0 );
	
	end

end

--Returns true if the door has no owners
function meta:HasNoOwners()

	if( self:GetTable().MainOwner == nil ) then
	
		if( self:GetTable().Owners == nil ) then return true; end
	
		local nvalid = 0;
		
		for k, v in pairs( self:GetTable().Owners ) do
		
			if( v:IsValid() ) then
			
				nvalid = nvalid + 1;
			
			end
		
		end
		
		if( nvalid == 0 ) then return true; end
	
	end

	return false;

end