
local BUTTONLABEL = { }

function BUTTONLABEL:Init()

	self.TextFont = "TacoButtonFont";
	
	self:SetFont( self.TextFont );
	self:SetText( "" );
	
end


function BUTTONLABEL:OnCursorEntered()

	self:GetParent().Highlighted = true;

end

function BUTTONLABEL:OnCursorExited()

	self:GetParent().Highlighted = false;

end

function BUTTONLABEL:PerformLayout()

	surface.SetFont( self.TextFont );
	local xoffset, yoffset = surface.GetTextSize( self:GetValue() );
	xoffset = xoffset / 2;
	yoffset = yoffset / 2;

	self:SetPos( ( self:GetParent():GetWide() / 2 ) - xoffset, self:GetParent():GetTall() / 2 - yoffset );
	self:SetSize( self:GetParent():GetWide(), self:GetParent():GetTall() );
	self:SizeToContents();

end

vgui.Register( "TacoButtonLabel", BUTTONLABEL, "Label" );

local BUTTON = { }

surface.CreateFont( "ChatFont", 12, 500, true, false, "TacoButtonFont" );

function BUTTON:Init()
	
	self.TextLabel = vgui.Create( "TacoButtonLabel", self );
	self.TextLabel:SetMouseInputEnabled( false );
	
	self.Color = Color( 90, 90, 90, 255 );
	self.OutlineColor = Color( 0, 0, 0, 255 );
	self.HighlightColor = Color( 60, 60, 60, 255 );
	self.Outline = true;
	
	self.Round = 4;
	
	self.PaintHook = nil;
	
	self.Highlighted = false;
	
	self.TextColor = Color( 255, 255, 255, 255 );
	
	self.ThreeD = false;
	
end

function BUTTON:Set3D( threed ) 

	self.ThreeD = threed;	

end

function BUTTON:SetRoundness( amt )

	self.Round = amt;
	
end

function BUTTON:OnCursorEntered()

	self.Highlighted = true;

end

function BUTTON:OnCursorExited()

	self.Highlighted = false;

end

function BUTTON:SetPaintHook( func )

	self.PaintHook = func;

end

function BUTTON:OnMousePressed()

	if( self.Callback ) then
		self.Callback( self );
	end

end

function BUTTON:SetHighlightColor( color )

	self.HighlightColor = color;

end

function BUTTON:SetText( str )

	self.TextLabel:SetText( str );

end

function BUTTON:SetTextFont( font )

	self.TextLabel.TextFont = font;
	self.TextLabel:SetFont( self.TextFont );
	self.TextLabel:InvalidateLayout();

end

function BUTTON:SetTextColor( color )

	self.TextColor = color;
	self:InvalidateLayout();

end

function BUTTON:ApplySchemeSettings()

	self.TextLabel:SetFGColor( self.TextColor );

end

function BUTTON:SetColor( color )

	self.Color = color;

end

function BUTTON:EnableOutline( val )

	self.Outline = var;

end

function BUTTON:SetOutlineColor( color )

	self.OutlineColor = color;

end


function BUTTON:SetButtonText( text )

	self.TextLabel:SetText( text );
	self.TextLabel:InvalidateLayout();

end

function BUTTON:SetCallback( func )

	self.Callback = func;

end

function BUTTON:PerformLayout()



end

function BUTTON:Paint()

	if( not self.PaintHook or not self.PaintHook( self ) ) then

		local w = self:GetWide();
		local h = self:GetTall();
		
		local color = self.Color;
		
		if( self.Highlighted ) then
			color = self.HighlightColor;
		end
		
		if( self.ThreeD ) then
			
			draw.RoundedBox( self.Round, 1, 1, w + 1, h + 1, Color( 0, 0, 0, 255 ) );
		
		end
		
		if( not self.Outline ) then
			draw.RoundedBox( self.Round, 0, 0, w, h, color );
		else
			draw.RoundedBox( self.Round, 0, 0, w, h, self.OutlineColor );
			draw.RoundedBox( self.Round, 1, 1, w - 2, h - 2, color );
		end
		
	end
	
	return true;

end

vgui.Register( "TacoButton", BUTTON, "Button" );