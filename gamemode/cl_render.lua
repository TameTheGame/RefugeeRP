
function DrawOutlinedBar( thickness, x, y, w, h, clr )

	draw.RoundedBox( 2, x, y, w, h, Color( 0, 0, 0, 200 ) );
	draw.RoundedBox( 2, x + thickness, y + thickness, w - thickness * 2, h - thickness * 2, clr );

end

function DrawOutlinedMeter( amt, thickness, x, y, w, h, clr )

	draw.RoundedBox( 2, x, y, w, h, Color( 0, 0, 0, 200 ) );
	
	if( amt > .01 ) then
		draw.RoundedBox( 2, x + thickness, y + thickness, ( w - thickness * 2 ) * amt, h - thickness * 2, clr );
	end

end

function msgDamageFlash( msg )

	local r = msg:ReadShort();
	local g = msg:ReadShort();
	local b = msg:ReadShort();
	local a = msg:ReadShort();
	local stay = msg:ReadFloat();

	AddFadingRect( 0, 0, ScrW(), ScrH(), 0, Color( r, g, b, a ), stay, 1500, false )	

end
usermessage.Hook( "DamageFlash", msgDamageFlash );

function msgDoBlurHit( msg )

	local delay = msg:ReadFloat();
	
	local function DisableBlurHit()
	
		BlurredHit = false;
	
	end
	
	BlurredHit = true;
	
	timer.Simple( delay, DisableBlurHit );

end
usermessage.Hook( "DoBlurHit", msgDoBlurHit );