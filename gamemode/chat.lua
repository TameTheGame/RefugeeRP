
TS.ChatCommands = { }

function TS.AddChatCommand( cmd, callback )

	local newcmd = { }
	
	newcmd.cmd = cmd;
	newcmd.callback = callback;
	
	table.insert( TS.ChatCommands, newcmd );

end

function GM:PlayerSay( ply, text )
	

	for _, v in pairs( TS.ChatCommands ) do
	
		local command = v.cmd;
		local cmdlen = string.len( command );
		local cmdtext = string.sub( text, 0, cmdlen );

		cmdtext = string.lower( cmdtext );
		command = string.lower( command );

		if( cmdtext == command ) then
		
			local args = string.sub( text, cmdlen + 1 );
			if( args == nil ) then
				args = "";
			end

	
			local ret = v.callback( ply, args, string.sub( text, 1, cmdlen ) );
			
			ply:MakeSayGlobal( ret );
			
			return ret;
			
		end
	
	end

	if( string.sub( text, 1, 1 ) == "/" or string.sub( text, 1, 1 ) == "!" ) then
	
		ply:PrintMessage( 3, "That is not a valid command" );
		return "";
		
	else
	
		if( TS.ServerVars["alltalk"] == 1 ) then
	
			TS.DayLog( "chatlog.txt", "[LOCAL]" .. ply:LogInfo() .. ": " .. text );
			TS.TalkToRange( ply:Nick() .. ": " .. text, ply:EyePos(), TS.ServerVars["talkrange"] );
			return "";
			
		else
		
			TS.DayLog( "chatlog.txt", "[GLOBAL]" .. ply:LogInfo() .. ": " .. text );
			ply:MakeSayGlobal( text );
		
		end
		
	end
	
	ply:MakeSayGlobal( text );
	return text;

end

