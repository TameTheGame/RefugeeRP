
local FRAME = { }

function FRAME:Init()

	self.Title = "";
	self.Labels = { }
	self.Entries = { }
	
	self:SetMouseInputEnabled( true );
	
	self.Color = Color( 60, 60, 60, 255 );
	
	self:MakePopup();

end

function FRAME:SetColor( color ) 

	self.Color = color;

end

function FRAME:AddLabel( text, font, x, y, color )

	surface.SetFont( font );

	local newlabel = vgui.Create( "Label", self );
	newlabel:SetFont( font );
	newlabel:SetText( text );
	newlabel.origx = x;
	newlabel.origy = y;
	newlabel:SetPos( x, y );
	newlabel:SetSize( surface.GetTextSize( text ), self:GetTall() );
	newlabel.r = color.r;
	newlabel.g = color.g;
	newlabel.b = color.b;
	newlabel.a = color.a;
	newlabel.ID = #self.Labels + 1;
	table.insert( self.Labels, newlabel );
	
	self:InvalidateLayout();

	return newlabel;

end

function FRAME:AddEntry( cb, x, y, w )

	local newentry = vgui.Create( "TacoEntry", self );
	
	newentry.origx = x;
	newentry.origy = y;
	
	newentry:SetPos( x, y );
	newentry:SetSize( w, 23 );
	
	newentry:SetCallback( cb );
	
	newentry.ID = #self.Entries + 1;
	table.insert( self.Entries, newentry );	
	
	self:InvalidateLayout();
	
	return newentry;

end

function FRAME:AddMultilineEntry( cb, x, y, w, h )

	local newentry = vgui.Create( "TacoEntry", self );
	
	newentry.origx = x;
	newentry.origy = y;
	
	newentry:SetPos( x, y );
	newentry:SetSize( w, h );
	
	newentry:SetCallback( cb );
	newentry:SetMultiline( true );
	newentry.Multiline = true;
	
	newentry.ID = #self.Entries + 1;
	table.insert( self.Entries, newentry );	
	
	self:InvalidateLayout();
	
	return newentry;

end

function FRAME:RemoveLabel( label )

	for k, v in pairs( self.Labels ) do
	
		if( v.ID == label.ID ) then
		
			self.Labels[k]:Remove();
			self.Labels[k] = nil;
			break;
		
		end
	
	end

end

function FRAME:SetTitle( str )

	self.Title = str;

end

function FRAME:PerformLayout()

	for _, v in pairs( self.Labels ) do
	
		v:SetPos( v.origx, v.origy );
	
	end
	
	for _, v in pairs( self.Entries ) do
	
		v:SetPos( v.origx, v.origy );
	
	end

end

function FRAME:ApplySchemeSettings()

	for _, v in pairs( self.Labels ) do
		
		v:SetFGColor( v.r, v.g, v.b, v.a );
	
	end

end


function FRAME:Paint()

	draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), self.Color );
	draw.DrawText( self.Title, "DefaultSmall", 25, 8, Color( 255, 255, 255, 255 ) );

	return true;

end

vgui.Register( "TacoFrame", FRAME, "Frame" );