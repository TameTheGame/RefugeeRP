
ActionMenuOn = false;
ActionMenuTarget = nil;
ActionMenuOptions = { }

ActionMenuCreateTime = 0;
ActionMenuChosen = -1;

ActionMenuCursor = true;

ActionMenuWidth = 0;

function RenderActionMenu()

	if( ActionMenuOn ) then
	
		local mx, my;
		mx = ScrW() / 2;
		my = ScrH() / 2;
	
		local a = math.Clamp( 255 * ( ( CurTime() - ActionMenuCreateTime ) / .6 ), 0, 255 );
		
		local orix, oriy;
		local w, h;
		
		if( ActionMenuTarget:IsPlayer() ) then

			local vec = ( ActionMenuTarget:GetPos() + Vector( 0, 0, 58 ) ):ToScreen();
			orix = vec.x - 60;
			oriy = vec.y;	
		
		else

			local vec = ActionMenuTarget:GetPos():ToScreen();
			orix = vec.x - 50;
			oriy = vec.y - 100;	
		
		end
		
		w = 150;
		h = 20 + #ActionMenuOptions * 20;

		draw.RoundedBox( 4, orix, oriy, ActionMenuWidth + 13, h, Color( 60, 60, 60, math.Clamp( a, 0, 180 ) ) );
		draw.DrawText( "Action Menu", "ChatFont", orix + 5, oriy + 5, Color( 255, 255, 255, a ) );
	
		local chose = false;
	
		for n = 1, #ActionMenuOptions do
		
			local desc = ActionMenuOptions[n].Desc;
			
			local curx = orix + 4;
			local cury = oriy + 20 + ( 20 * ( n - 1 ) );
			local curw = 142;
			local curh = 18;
			
			local color = Color( 0, 0, 0, math.Clamp( a, 0, 180 ) );
			
			if( my >= cury and my <= cury + curh ) then
				if( mx >= curx and mx <= curx + curw ) then
					color = Color( 0, 0, 150, math.Clamp( a, 0, 180 ) );
					ActionMenuChosen = n;
					chose = true;
				end
			end
				
			draw.RoundedBox( 4, curx, cury, ActionMenuWidth + 5, curh, color );
			draw.DrawText( desc, "ChatFont", orix + 6, oriy + 22 + ( 20 * ( n - 1 ) ), Color( 255, 255, 255, a ) );
			
		end
		
		if( not chose ) then
			ActionMenuChosen = -1;
		end
		
		ActionMenuCursor = false;
		
		if( my >= oriy and my <= oriy + h ) then
			if( mx >= orix and mx <= orix + w ) then
				draw.DrawText( "o", "TargetID", mx, my - 15, Color( 255, 255, 255, 255 ), 1, 1 );
				ActionMenuCursor = true;
			end
		end
	
	end

end
hook.Add( "HUDPaint", "RenderActionMenu", RenderActionMenu );



function msgToggleActionMenu( msg )

	ActionMenuOn = !ActionMenuOn;
	
	ActionMenuTarget = nil;
	ActionMenuOptions = { }
	ActionMenuCreateTime = CurTime();
	
	ActionMenuChosen = -1;
	
	if( ActionMenuOn and msg ) then
	
		ActionMenuTarget = msg:ReadEntity();
		
		local numopt = msg:ReadShort();
		
		local longesttext = 0;
		local tindex = 0;
		
		for n = 1, numopt do
		
			local desc = msg:ReadString();
			local cmd = msg:ReadString();
		
			local newopt = { }
			newopt.Desc = desc;
			newopt.Cmd = cmd;
			
			surface.SetFont( "ChatFont" );
			local size = surface.GetTextSize( desc );
			
			if( size > longesttext ) then
			
				longesttext = size;
				ActionMenuWidth = size;
			
			end
			
			table.insert( ActionMenuOptions, newopt );
		
		end
	
	end

end
usermessage.Hook( "ToggleActionMenu", msgToggleActionMenu );