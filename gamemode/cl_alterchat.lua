
ChatLines = { }

local ChatLineDelay = 0;

function ShiftChatLinesUp( offset )

	offset = offset or 0;

	for k, v in pairs( ChatLines ) do

		v.y = v.y - 16 - offset;

		
	end

end

function AddChatLine( str )

	ChatLineDelay = math.Clamp( ChatLineDelay - .1, 0, 1000 );

	local newline = { }
	
	newline.x = 39;
	
	newline.r = 255;
	newline.g = 255;
	newline.b = 255;
	newline.a = 255;
	
	local n;
	
	newline.text, n = FormatLine( str, "ChatFont", ScrW() / 2 );
	newline.start = CurTime();
	
	_, newline.height = surface.GetTextSize( newline.text );
	
	local offset = ( n * 16 );
	
	newline.height = newline.height - 6;
	
	newline.y = ScrH() / 2 - 150 - offset;
	
	ShiftChatLinesUp( offset );
	
	table.insert( ChatLines, newline );

end

function msgAddLine( msg )

	timer.Simple( ChatLineDelay, AddChatLine, msg:ReadString() );

	ChatLineDelay = ChatLineDelay + .1;

end
usermessage.Hook( "AddChatLine", msgAddLine );

function DrawChatLines()

	for k, v in pairs( ChatLines ) do

		draw.DrawText( v.text, "ChatFont", v.x, v.y, Color( v.r, v.g, v.b, v.a ) );
	
	end

end

function ChatLineThink()

	for k, v in pairs( ChatLines ) do

		if( CurTime() - v.start > 10 ) then
		
			v.a = math.Clamp( v.a - 200 * FrameTime(), 0, 255 );
		
		end
		
		if( v.a <= 0 ) then
		
			ChatLines[k] = nil;

		elseif( v.y <= 30 ) then
		
			ChatLines[k] = nil;
		
		end
	
	end

end
hook.Add( "Think", "ChatLineThink", ChatLineThink );