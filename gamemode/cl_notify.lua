
Notify = { }

local NotifyQueue = 0;

local function LowerQueue()

	NotifyQueue = math.Clamp( NotifyQueue - .1, 0, 1000 );

end

function msgAddNotify( msg )

	local str = msg:ReadString();
	local len = msg:ReadShort();
	local red = msg:ReadBool();
	
	timer.Simple( NotifyQueue, AddNotify, str, len, red );
	timer.Simple( NotifyQueue, LowerQueue );
	
	NotifyQueue = NotifyQueue + .1;

end
usermessage.Hook( "AddNotify", msgAddNotify );

function DrawNotify()

	for k, v in pairs( Notify ) do
	
		local color = Color( 255, 255, 255, v.fade );
		local rcolor =  Color( 60, 60, 60, v.fade );
		
		if( v.red ) then
		
			color = Color( 255, 10, 10, v.fade );
			rcolor = Color( 0, 0, 0, v.fade );
	
		end
		
		if( ChristmasMod ) then
	
			color = Color( 0, 180, 0, v.fade );
			rcolor = Color( 230, 230, 230, v.fade );
		
		end
	
		draw.RoundedBox( 4, v.x, v.y, v.w, 30, rcolor );
		
		--draw.DrawText( v.text, "TargetID", v.x + 9, v.y + 6, Color( 0, 0, 0, v.fade ), 0 );
		draw.DrawText( v.text, "TargetID", v.x + 7, v.y + 4, color, 0 );
	
	end

end

function AddNotify( str, len, red )

	local notify = { }
	
	notify.text = str;
	notify.killtime = CurTime() + len;
	
	surface.SetFont( "TargetID" );
	
	local w, h = surface.GetTextSize( str );
	local x = ScrW() * .85;
	
	notify.w = w + 20;	
	
	local xoffset = ScrW() - ( x + w ) + 15;
	
	if( xoffset > 0 ) then xoffset = 0; end
	
	notify.x = ScrW() * .75 + xoffset;
	notify.y = ScrH() * .7;
	notify.ydest = ScrH() * .65;
	
	notify.red = red;
	
	notify.fade = 0;
	notify.fadein = false;
	
	ShiftAllNotify();
	
	table.insert( Notify, notify );

end

function ShiftAllNotify()

	for k, v in pairs( Notify ) do
	
		v.ydest = v.ydest - 40;
	
	end

end

function NotifyThink()

	for k, v in pairs( Notify ) do
	
		if( v.y > v.ydest ) then
		
			v.y = math.Clamp( v.y - FrameTime() * 200, v.ydest, ScrH() );
		
		end
		
		if( not v.fadein ) then
		
			v.fade = math.Clamp( v.fade + FrameTime() * 400, 0, 220 );
			
			if( v.fade >= 220 ) then
			
				v.fadein = true;
			
			end
		
		else
		
			if( CurTime() >= v.killtime ) then
			
				v.fade = math.Clamp( v.fade - FrameTime() * 240, 0, 220 );
			
			end
			
			if( v.fade <= 0 ) then
		
				Notify[k] = nil;
		
			end
		
		end
		
	end

end
hook.Add( "Think", "NotifyThink", NotifyThink );