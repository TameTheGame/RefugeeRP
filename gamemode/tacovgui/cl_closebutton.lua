
BUTTON = { }

local BUTTON = { }

function BUTTON:Init()

	self:SetSize( 25, 20 );
	
end

function BUTTON:OnCursorEntered()

	self.Highlight = true;

end

function BUTTON:OnCursorExited()

	self.Highlight = false;

end


function BUTTON:SetTarget( panel )

	self.Target = panel;
	
	self.Highlight = false;

end

function BUTTON:PerformLayout()

end

function BUTTON:Paint()

	local color = Color( 90, 90, 90, 255 );
	
	if( self.Highlight ) then
		color = Color( 50, 50, 50, 255 );
	end

	//draw.RoundedBox( 0, 2, 3, 25, 20, Color( 0, 0, 0, 255 ) );
	//draw.RoundedBox( 0, 4, 5, 12, 10, color );
	draw.DrawText( "X", "TargetID", 13, 0, Color( 255, 255, 255, 255 ), 1 );
	
	return true;

end

function BUTTON:DoClick()

	if( self.Target ) then
		if( self.Target.OnClose ) then
			self.Target:OnClose();
		end
		self.Target:SetVisible( false );
	end
	
end

vgui.Register( "TacoCloseButton", BUTTON, "Button" );