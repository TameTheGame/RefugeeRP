local LINKLABEL = { }

function LINKLABEL:Init()

	self.TextFont = "TacoButtonFont";
	
	self.TextColor = Color( 255, 255, 255, 255 );
	self.HoverColor = Color( 60, 60, 200, 255 );
	
	self.Highlighted = false;
	
	self.Label = vgui.Create( "Label", self );
	self.Label:SetFont( self.TextFont );
	self.Label:SetText( "" );
	self.Label:SetMouseInputEnabled( false );

end

function LINKLABEL:SetTextColor( color )

	self.TextColor = color;
	
	self:InvalidateLayout();

end

function LINKLABEL:SetHoverColor( color )

	self.HoverColor = color;
	
	self:InvalidateLayout();

end

function LINKLABEL:SetLinkText( text )

	self.Text = text;
	
	surface.SetFont( self.TextFont );
	local w, h = surface.GetTextSize( self.Text );
	
	self:SetSize( w, h );
	self.Label:SetSize( w, h );
	
	self.Label:SetText( text );

end

function LINKLABEL:SetLinkFont( font )

	self.TextFont = font;
	
	self.Label:SetFont( self.TextFont );
	
end

function LINKLABEL:SetCallback( cb )

	self.Callback = cb;

end

function LINKLABEL:OnMousePressed()

	if( self.Callback ) then
		self.Callback( self );
	end

end

function LINKLABEL:OnCursorEntered()

	self.Highlighted = true;
	self:ApplySchemeSettings();

end

function LINKLABEL:OnCursorExited()

	self.Highlighted = false;
	self:ApplySchemeSettings();

end

function LINKLABEL:PerformLayout()

	self.Label:SetPos( 0, 0 );

end

function LINKLABEL:ApplySchemeSettings()

	if( self.Highlighted ) then
		self.Label:SetFGColor( self.HoverColor );
	else
		self.Label:SetFGColor( self.TextColor );
	end

end

function LINKLABEL:Paint()

	return true;

end

vgui.Register( "TacoLink", LINKLABEL, "Button" );