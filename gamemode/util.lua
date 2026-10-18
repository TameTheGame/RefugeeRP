
function TS.DebugFile( text )

	Msg( text .. "\n" );

	if( TS_DEBUG_MODE ) then
	
		file.Write( "TacoScript/debug.txt", ( file.Read( "TacoScript/debug.txt" ) or "" ) .. TS.GetLogFormatDate() .. text .. "\r\n" );
	
	end

end

--Send something into the player's console.  This checks if the player is console or an ingame player.
function TS.SendConsole( ply, text )

	if( ply:EntIndex() == 0 ) then
	
		Msg( text .. "\n" );
	
	else
	
		ply:PrintMessage( 2, text );
	
	end

end

function TS.Notify( ply, msg, len, red )

	if( red == nil ) then
		red = false;
	end

	umsg.Start( "AddNotify", ply );
		umsg.String( msg );
		umsg.Short( len );
		umsg.Bool( red );
	umsg.End();	

end

function TS.NotifyAll( msg, len, red )

	if( red == nil ) then
		red = false;
	end

	local rec = RecipientFilter();
	rec:AddAllPlayers();

	umsg.Start( "AddNotify", rec );
		umsg.String( msg );
		umsg.Short( len );
		umsg.Bool( red );
	umsg.End();

end

--Creates third person camera object
function TS.CreateThirdPersonCamera()

	if( true ) then return; end

	if( not TS.ThirdPersonCam ) then
		TS.ThirdPersonCam = { }
	end

	for i = 1, MaxPlayers() do

		if( TS.ThirdPersonCam[i] and TS.ThirdPersonCam[i]:IsValid() ) then
			TS.ThirdPersonCam[i]:Remove();
		end
	
		TS.ThirdPersonCam[i] = ents.Create( "gmod_cameraprop" );
		TS.ThirdPersonCam[i]:SetNoDraw( true );
		TS.ThirdPersonCam[i]:SetAngles( Angle( 0, 0, 0 ) );
		TS.ThirdPersonCam[i]:SetPos( Vector( 0, 0, 0 ) );
		TS.ThirdPersonCam[i]:Spawn();
	
	end

end

--Send chat to a range
--str: What to say
--pos: Vector position
--size: Radius
function TS.TalkToRange( str, pos, size )

	local entvec = ents.FindInSphere( pos, size );
	
	for k, v in pairs( entvec ) do
	
		if( v:IsPlayer() and v:Alive() and v:GetField( "isko" ) == 0 ) then
		
			v:PrintMessage( 3, str );
		
		end
	
	end

end

function TS.GetWeaponName( class )

	return weapons.Get( class ).PrintName;

end

function TS.GetLogFormatDate()

	local month = os.date( "%m" );
	local day = os.date( "%d" );
	local hour = os.date( "%H" );
	local min = os.date( "%M" );

	return month .. "/" .. day .. "[" .. hour .. ":" .. min .. "]";

end

function TS.ClockBasedName()

	local time = tonumber( os.date( "%H" ) );

	local endmark = "am";

	if( time > 12 ) then
	
		time = time - 12;
		endmark = "pm";
	
	end

	if( time >= 0 and time < 3 ) then
	
		return "1-3" .. endmark;
	
	elseif( time >= 3 and time < 6 ) then
	
		return "3-6" .. endmark;
	
	elseif( time >= 6 and time < 9 ) then
	
		return "6-9" .. endmark;
	
	elseif( time >= 9 and time <= 12 ) then
	
		return "9-12" .. endmark;

	end

end

--Logs into a day log folder
function TS.DayLog( filedir, content )

	local month = os.date( "%m" );
	local day = os.date( "%d" );
	local year = os.date( "%Y" );

	local curdate = month .. "-" .. day .. "-" .. year;

	filedir = "TacoScript/logs/daylogs/" .. curdate .. "/" .. string.gsub( filedir, ".txt", "" ) .. TS.ClockBasedName() .. ".txt";

	local old = file.Read( filedir ) or "";
	
	file.Write( filedir, old .. "\r\n" .. TS.GetLogFormatDate() .. content );
	

end

--Logs into the log folder
function TS.Log( filedir, content )

	filedir = "TacoScript/logs/" .. filedir;

	local old = file.Read( filedir ) or "";
	
	file.Write( filedir, old .. "\r\n" .. TS.GetLogFormatDate() .. content );

end
