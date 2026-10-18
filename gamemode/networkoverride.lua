--[[
local meta = FindMetaTable( "Entity" );
local pmeta = FindMetaTable( "Player" );

TS.NWDelay = 0;
TS.EachDelay = .001;

if( not TS.FuncGetNWString ) then
	TS.FuncGetNWString = meta.GetNWString;
end
function pmeta:GetNWString( var )

	if( SERVER ) then

		if( table.HasValue( TS.PlayerPrivateNWStrings, var ) ) then
		
			return self:GetField( "pvar." .. var );
		
		end
		
	elseif( PrivateString[var] ) then
	
		return PrivateString[var];
	
	end

	return TS.FuncGetNWString( var );

end

if( not TS.FuncSetNWString ) then
	TS.FuncSetNWString = meta.SetNWString;
end
function pmeta:SetNWString( var, val )

	if( CLIENT or not self:IsPlayer() ) then 
	
		return; 
	
	end

	if( table.HasValue( TS.PlayerPrivateNWStrings, var ) ) then
	
		self:SetField( "pvar." .. var, val );
	
		umsg.Start( "SendPrivateString", self );
			umsg.String( var );
			umsg.String( val );
		umsg.End();
		
		return;
	
	end
	
	local function SendNWVar( func, ply, var, val )
	
		TS.NWDelay = TS.NWDelay - TS.EachDelay;

		func( ply, var, val );
		
	end
	timer.Simple( TS.NWDelay, SendNWVar, TS.FuncSetNWString, self, var, val );
	
	TS.NWDelay = TS.NWDelay + TS.EachDelay;

end

if( not TS.FuncGetNWFloat ) then
	TS.FuncGetNWFloat = meta.GetNWFloat;
end
function pmeta:GetNWFloat( var )

	if( SERVER ) then

		if( table.HasValue( TS.PlayerPrivateNWFloats, var ) ) then
		
			return self:GetField( "pvar." .. var );
		
		end
		
	elseif( PrivateFloat[var] ) then
	
		return PrivateFloat[var];
	
	end

	return TS.FuncGetNWFloat( var );

end

if( not TS.FuncSetNWFloat ) then
	TS.FuncSetNWFloat = meta.SetNWFloat;
end
function pmeta:SetNWFloat( var, val )

	if( CLIENT or not self:IsPlayer() ) then 
	
		return; 
	
	end

	if( table.HasValue( TS.PlayerPrivateNWFloats, var ) ) then
	
		self:SetField( "pvar." .. var, val );
	
		umsg.Start( "SendPrivateFloat", self );
			umsg.String( var );
			umsg.Float( val );
		umsg.End();
		
		return;
	
	end
	
	local function SendNWVar( func, ply, var, val )
	
		TS.NWDelay = TS.NWDelay - TS.EachDelay;
	
		func( ply, var, val );
		
	end
	timer.Simple( TS.NWDelay, SendNWVar, TS.FuncSetNWFloat, self, var, val );
	
	TS.NWDelay = TS.NWDelay + TS.EachDelay;

end

if( not TS.FuncGetNWInt ) then
	TS.FuncGetNWInt = meta.GetNWInt;
end
function pmeta:GetNWInt( var )

	if( SERVER ) then

		if( table.HasValue( TS.PlayerPrivateNWInts, var ) ) then
		
			return self:GetField( "pvar." .. var );
		
		end
		
	elseif( PrivateInt[var] ) then
	
		return PrivateInt[var];
	
	end

	return TS.FuncGetNWInt( var );

end

if( not TS.FuncSetNWInt ) then
	TS.FuncSetNWInt = meta.SetNWInt;
end
function pmeta:SetNWInt( var, val )

	if( CLIENT or not self:IsPlayer() ) then 
	
		return; 
	
	end

	if( table.HasValue( TS.PlayerPrivateNWInts, var ) ) then
	
		self:SetField( "pvar." .. var, val );
	
		umsg.Start( "SendPrivateInt", self );
			umsg.String( var );
			umsg.Long( val );
		umsg.End();
		
		return;
	
	end
	
	local function SendNWVar( func, ply, var, val )
	
		TS.NWDelay = TS.NWDelay - TS.EachDelay;
	
		func( ply, var, val );
		
	end
	timer.Simple( TS.NWDelay, SendNWVar, TS.FuncSetNWInt, self, var, val );
	
	TS.NWDelay = TS.NWDelay + TS.EachDelay;

end

]]--

local meta = FindMetaTable( "Player" ) 
   
 // Return if there's nothing to add on to 
 if (!meta) then return end 
   
 local Vector_Default 	= Vector(0,0,0) 
 local Angle_Default		= Angle(0,0,0) 
   
 local NetworkVars 			= {} 
   
 local NetworkFunction 	= {} 
 local DelayedUpdates 	= {} 
   
 local NextCleanup		= CurTime() 
   
 if ( CLIENT ) then 
   
 	local function Dump() 
 	 
 		Msg("Networked Vars...\n") 
 		PrintTable( NetworkVars ) 
 		 
 	end 
 	 
 	concommand.Add( "networkvars_dump", Dump ) 
   
 end 
   
 local function AttemptToSwitchTables( Ent, EntIndex ) 
   
 	if ( NetworkVars[ EntIndex ] == nil ) then return end 
   
 	// We have an old entindex based entry! Move it over! 
 	NetworkVars[ Ent ] = NetworkVars[ EntIndex ] 
 	NetworkVars[ EntIndex ] = nil 
 	 
 end 
   
 local function CleaupNetworkVars() 
   
 	if ( NextCleanup > CurTime() ) then return end 
 	NextCleanup	= CurTime() + 2 
   
 	for k, v in pairs( NetworkVars ) do 
 	 
 		if ( type( k ) != "number" && type( k ) != "string" ) then 
 		 
 			if ( !k:IsValid() ) then 
 				NetworkVars[ k ] = nil 
 			end 
 		 
 		end 
 	 
 	end 
   
 end 
   
 local function GetNetworkTable( ent, name ) 
 	 
 	if ( CLIENT ) then 
 		CleaupNetworkVars() 
 	end 
 	 
 	if ( !NetworkVars[ ent ] ) then 
 	 
 		NetworkVars[ ent ] = {} 
 		 
 		// This is the first time this entity has been created.  
 		// Check whether we previously had an entindex based table 
 		if ( CLIENT && type( ent ) != "number" && type( ent ) != "string" ) then 
 			AttemptToSwitchTables( ent, ent:EntIndex() ) 
 		end 
 	 
 	end 
 	 
 	NetworkVars[ ent ][ name ] = NetworkVars[ ent ][ name ] or {} 
 	return NetworkVars[ ent ][ name ] 
   
 end 
   
 local function SendNetworkUpdate( VarType, Index, Key, Value, Player ) 
 	 
 	 if( not VarType ) then return; end
 	 if( not Value ) then return; end
 	 
 	umsg.Start( "RcvEntityVar_"..VarType, Player ) 
 		umsg.Short( Index ) 
 		umsg.String( Key ) 
 		umsg[ NetworkFunction[VarType].SetFunction ]( Value ) 
 	umsg.End() 
 	 
 	umsg.PoolString( Key ) 
   
 end 
   
 local function AddDelayedNetworkUpdate( VarType, Ent, Key, Value ) 
 	 
 	DelayedUpdates[ VarType ] = DelayedUpdates[ VarType ] or {} 
 	DelayedUpdates[ VarType ][Ent] = DelayedUpdates[ VarType ][Ent] or {} 
 	DelayedUpdates[ VarType ][Ent][Key] = Value 
   
 end 
   
 local function AddNetworkFunctions( name, SetFunction, GetFunction, Default ) 
   
 	NetworkFunction[ name ] = {} 
 	NetworkFunction[ name ].SetFunction = SetFunction 
 	NetworkFunction[ name ].GetFunction = GetFunction 
 	 
 	// SetNetworkedBlah 
 	meta[ "SetNetworked" .. name ] = function ( self, key, value, urgent ) 
 	 
 		key = tostring(key) 
 	 
 		// The same - don't waste our time. 
 		if ( value == GetNetworkTable( self, name )[ tostring(key) ] ) then return end 
 		 
 		// Clients can set this too, but they should only really be setting it 
 		// when they expect the exact same result coming over the wire (ie prediction) 
 		GetNetworkTable( self, name )[key] = value 
 			 
 		if ( SERVER ) then 
 		 
 			local Index = self:EntIndex() 
 			if (Index <= 0) then return end 
 		 
 			if ( urgent ) then 
 				SendNetworkUpdate( name, Index, key, value ) 
 			else 
 				AddDelayedNetworkUpdate( name, Index, key, value ) 
 			end 
 			 
 		end 
 		 
 	end 
 	 
 	meta[ "SetNW" .. name ] = meta[ "SetNetworked" .. name ] 
 	 
 	// GetNetworkedBlah 
 	meta[ "GetNetworked" .. name ] = function ( self, key, default ) 
 	 
 		key = tostring(key) 
 	 
 		local out = GetNetworkTable( self, name )[ key ] 
 		if ( out != nil ) then return out end 
 		if ( default == nil ) then return Default end 
 		return default 
 		 
 	end 
 	 
 	meta[ "GetNW" .. name ] = meta[ "GetNetworked" .. name ] 
 	 
 	 
 	meta[ "GetNetworked" .. name .. "Table" ] = function ( self ) 
 		return GetNetworkTable( self, name ) 
 	end 
 	 
 	 
 	// SetGlobalBlah 
 	_G[ "SetGlobal"..name ] = function ( key, value, urgent )  
   
 		key = tostring(key) 
 	 
 		if ( value == GetNetworkTable( "G", name )[key] ) then return end 
 		GetNetworkTable( "G", name )[key] = value 
 			 
 		if ( SERVER ) then 
 			if ( urgent ) then 
 				SendNetworkUpdate( name, -1, key, value ) 
 			else 
 				AddDelayedNetworkUpdate( name, -1, key, value ) 
 			end 
 		end 
 		 
 	end 
 	 
 	meta[ "GetGlobal" .. name .. "Table" ] = function ( self ) 
 		return GetNetworkTable( "G", name ) 
 	end 
 	 
 	// GetGlobalBlah 
 	_G[ "GetGlobal"..name ] = function ( key )  
   
 		key = tostring(key) 
 	 
 		local out = GetNetworkTable( "G", name )[key] 
 		if ( out != nil ) then return out end 
 		 
 		return Default 
 		 
 	end 
 	 
 	 
 	if ( SERVER ) then 
 		// Pool the name of the function.  
 		// Makes it send a number representing the string rather than the string itself. 
 		// Only do this with strings that you send quite a bit and always stay the same. 
 		umsg.PoolString( "RcvEntityVar_"..name ) 
 	end 
 	 
 	// Client Receive Function 
 	if ( CLIENT ) then 
 	 
 		local function RecvFunc( m ) 
 		 
 			local EntIndex 	= m:ReadShort() 
 			local Key		= m:ReadString() 
 			local Value		= m[GetFunction]( m ) 
 			 
 			local IndexKey 
 			 
 			if ( EntIndex <= 0 ) then  
 			 
 				IndexKey = "G"  
 				 
 			else 
 			 
 				IndexKey = Entity( EntIndex ) 
 				 
 				// No entity yet - store using entindex 
 				if ( IndexKey == NULL ) then IndexKey = EntIndex end 
 				 
 			end 
 			 
 			GetNetworkTable( IndexKey, name )[Key] = Value	 
 			 
 			//Msg("RECV: "..EntIndex.." | "..tostring(IndexKey).." - "..tostring(Key).." - "..tostring(Value).."\n"); 
 			 
 		end 
 		 
 		usermessage.Hook( "RcvEntityVar_"..name, RecvFunc ) 
 	 
 	end 
   
 end 
   
 AddNetworkFunctions( "Vector", 	"Vector", 	"ReadVector", 	Vector_Default ) 
 AddNetworkFunctions( "Angle", 	"Angle", 	"ReadAngle", 	Angle_Default ) 
 AddNetworkFunctions( "Float", 	"Float", 	"ReadFloat", 	0 ) 
 AddNetworkFunctions( "Int", 	"Short", 	"ReadShort", 	0 ) 
 AddNetworkFunctions( "Entity", 	"Entity", 	"ReadEntity", 	NULL ) 
 AddNetworkFunctions( "Bool", 	"Bool", 	"ReadBool", 	false ) 
 AddNetworkFunctions( "String", 	"String", 	"ReadString", 	"" ) 
   
 /////////////////////////////////////////////////////////////////////////////////////////////// 
 /////////////////////////////////////////////////////////////////////////////////////////////// 
 // Send a networkvar staggered to avoid sending too much in one tick 
 /////////////////////////////////////////////////////////////////////////////////////////////// 
 /////////////////////////////////////////////////////////////////////////////////////////////// 
 local function StaggeredNetworkUpdate( Type, Index, Key, Value, ply ) 
   
 	SendNetworkUpdate( Type, Index , Key, Value, ply ) 
   
 end 
   
 /////////////////////////////////////////////////////////////////////////////////////////////// 
 /////////////////////////////////////////////////////////////////////////////////////////////// 
 // Send a full update to player that have just joined the server 
 /////////////////////////////////////////////////////////////////////////////////////////////// 
 /////////////////////////////////////////////////////////////////////////////////////////////// 
 local function FullUpdateEntityNetworkVars( ply ) 
   
 	for Ent, EntTable in pairs(NetworkVars) do 
 	 
 		for Type, TypeTable in pairs(EntTable) do 
 		 
 			for Key, Value in pairs(TypeTable) do 
 			 
 				local Index = Ent 
 				 
 				if ( type(Ent) != "string" ) then 
 					Index = Ent:EntIndex() 
 				end 
 			 
 				SendNetworkUpdate( Type, Index , Key, Value, ply ) 
 				
 			end 
 		end 
   
 	end 
   
   
 end 
   
 hook.Add( "PlayerInitialSpawn", "FullUpdateEntityNetworkVars", FullUpdateEntityNetworkVars ) 
   
 /////////////////////////////////////////////////////////////////////////////////////////////// 
 /////////////////////////////////////////////////////////////////////////////////////////////// 
   
   
 /////////////////////////////////////////////////////////////////////////////////////////////// 
 /////////////////////////////////////////////////////////////////////////////////////////////// 
 // We want our networked vars to save don't we? Yeah - we do - stupid. 
 /////////////////////////////////////////////////////////////////////////////////////////////// 
 /////////////////////////////////////////////////////////////////////////////////////////////// 
 local function Save( save ) 
   
 	// Remove baggage 
 	for k, v in pairs(NetworkVars) do 
 		if ( k == NULL ) then 
 			NetworkVars[k] = nil 
 		end 
 	end 
 	 
 	//PrintTable(NetworkVars) 
 	saverestore.WriteTable( NetworkVars, save ) 
   
 end 
   
 local function Restore( restore ) 
   
 	NetworkVars = saverestore.ReadTable( restore ) 
 	//PrintTable(NetworkVars) 
   
 end 
   
 saverestore.AddSaveHook( "EntityNetworkedVars", Save ) 
 saverestore.AddRestoreHook( "EntityNetworkedVars", Restore ) 
   
   
 /////////////////////////////////////////////////////////////////////////////////////////////// 
 /////////////////////////////////////////////////////////////////////////////////////////////// 
 // We update the vars periodically instead of on demand, because we're not made of bandwidth 
 // Do you think it grows on trees or something? You'll see. You'll find out when you get your 
 // own job and you come home every night and the fire is on full blast. 
 /////////////////////////////////////////////////////////////////////////////////////////////// 
 /////////////////////////////////////////////////////////////////////////////////////////////// 
 local function NetworkVarsSend() 
   
 	for VarType, a in pairs(DelayedUpdates) do 
 	 
 		for Index, b in pairs(a) do 
 		 
 			for Key, Value in pairs(b) do 
 			 
 				SendNetworkUpdate( VarType, Index, Key, Value ) 
 				 
 			end 
 			 
 		end 
 		 
 	end 
 	 
 	// Clear the sent entries 
 	DelayedUpdates = {} 
   
 end 
  timer.Remove( "NetworkVarsSend" );
 timer.Create( "NetworkVarsSend", 0.4, 0, NetworkVarsSend ) 
   
   
 /////////////////////////////////////////////////////////////////////////////////////////////// 
 // Listen out for dead entities so we can remove their vars 
 /////////////////////////////////////////////////////////////////////////////////////////////// 
 local function NetworkVarsCleanup( ent ) 
   
 	if ( SERVER ) then 
 		NetworkVars[ ent ] = nil 
 	end 
   
 end 
   
 hook.Add( "EntityRemoved", "NetworkVarsCleanup", NetworkVarsCleanup )  
 
