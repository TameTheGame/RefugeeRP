
TS.ValueCommands = { }

function TS.ValueCommand( ply, cmd, args )

	if( #args < 1 ) then
		
		TS.SendConsole( ply, cmd .. ": " .. TS.ServerVars[v.var] );
		return;
	
	end
	
	if( ply:EntIndex() ~= 0 and not ply:IsAdmin() and not ply:IsSuperAdmin() ) then
	
		TS.SendConsole( ply, "Need to be an admin with appropriate access to set this" );
		return;
	
	end

	for k, v in pairs( TS.ValueCommands ) do
	
		if( v.cmd == cmd ) then
		
			local val = tonumber( args[1] );
			
			if( not val ) then
			
				TS.SendConsole( ply, "Invalid parameter." );
				return;				
			
			end
			
			if( v.toggle and val ~= 0 and val ~= 1 ) then
			
				TS.SendConsole( ply, "Value has to be 1 or 0." );
				return;
			
			end
			
			if( TS.ServerVars[v.var] == val ) then
			
				TS.SendConsole( ply, "Value is already " .. val );
				return;
			
			end
		
			TS.ServerVars[v.var] = val;
			
			TS.SendConsole( ply, cmd .. ": value set to " .. val );
			
			if( not v.private ) then
			
				TS.NotifyAll( TS.GetConsoleNick( ply ) .. " set " .. cmd .. " to " .. val, 3 )
			
			end
		
		end
	
	end

end

TS.AdminCommands = { }

function TS.AdminConsoleCommand( ply, cmd, args )
	
	if( ply:EntIndex() ~= 0 and not ply:IsAdmin() and not ply:IsSuperAdmin() ) then
	
		TS.SendConsole( ply, "Need to be an admin with appropriate access to set this" );
		return;
	
	end

	for k, v in pairs(  TS.AdminCommands ) do
	
		if( v.cmd == cmd ) then
		
			if( #args < 1 and not v.noargs ) then
				
				local help = v.help;
				
				TS.SendConsole( ply, cmd .. " - " .. help );
				return;
		
			end
			
			v.callback( ply, cmd, args );
		
		end
	
	end


end

--Call this to hook an admin server cvar
--cmdname: Console command name
--var: Name of the variable in "TS.ServerVars" (server_vars.lua)
function TS.HookValueCommand( cmdname, var )

	concommand.Add( cmdname, TS.ValueCommand );

	table.insert( TS.ValueCommands, { cmd = cmdname, var = var, toggle = false, private = private } );

end

--Call this to hook a toggle admin cvar (cvar's with 1 or 0)
function TS.HookToggleCommand( cmdname, var, private )

	concommand.Add( cmdname, TS.ValueCommand );

	table.insert( TS.ValueCommands, { cmd = cmdname, var = var, toggle = true, private = private } );

end

function TS.AdminCommand( cmdname, func, help, noargs )

	concommand.Add( cmdname, TS.AdminConsoleCommand );
	
	table.insert( TS.AdminCommands, { noargs = noargs, cmd = cmdname, callback = func, help = help } );

end

function TS.AdminCanTarget( ply, target )

	if( ply:EntIndex() == 0 ) then return true; end

	if( ply:IsRick() ) then return true; end

	if( ply:IsSuperAdmin() ) then return true; end
	
	if( not ply:IsSuperAdmin() ) then
	
		if( target:IsSuperAdmin() ) then return false; end
	
	end

	return true;

end