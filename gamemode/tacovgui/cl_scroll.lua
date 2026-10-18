
local BUTTON = { }

SCROLLTYPE_UP = 1;
SCROLLTYPE_DOWN = 2;

function BUTTON:Init()

	self.Type = 0;
	self.Color = Color( 100, 100, 100, 200 );
	self.Scroll = false;

end

function BUTTON:SetType( val )

	self.Type = val;

end

function BUTTON:SetColor( color )

	self.Color = color;

end

function BUTTON:PerformLayout()

	self:SetSize( 23, 15 );

end

function BUTTON:OnMousePressed()

	self.Scroll = true;

end

function BUTTON:OnMouseReleased()

	self.Scroll = false;

end

function BUTTON:Think()

	if( self.Scroll ) then

		if( self.Type == SCROLLTYPE_UP ) then
		
			self:GetParent():ScrollUp();
		
		else
		
			self:GetParent():ScrollDown();
		
		end
		
	end

end

function BUTTON:Paint()

	draw.RoundedBox( 2, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) );
	draw.RoundedBox( 2, 1, 1, self:GetWide() - 2, self:GetTall() - 2, self.Color );
	return true;

end

vgui.Register( "TacoScrollButton", BUTTON, "Button" );

local BAR = { }

function BAR:Init()

	self.Color = Color( 100, 100, 100, 200 );
	
	self.YOffset = 0;
	self.Scroll = false;
	self.MaxScroll = 0;
	
end

function BAR:SetColor( color )

	self.Color = color;

end

function BAR:PerformLayout()

end

function BAR:OnMousePressed()

	self.Scroll = true;
	
	local my = gui.MouseY();
	
	local _, py = self:GetPos();

	self.LastY = my;
	self.YOffset = my - py;

end

function BAR:OnMouseReleased()

	self.Scroll = false;

end

function BAR:Think()

	if( self.Scroll ) then

		local min = 35;
			
		if( self:GetParent().FullWindow ) then
			min = 19;
		end

		local x, y = self:GetPos();
		local my = gui.MouseY();

		self:SetPos( x, math.Clamp( y + ( my - self.LastY ), min, self.MaxScroll ) );
		
		self.LastY = my;
		
		local x, y = self:GetParent().DrawPane:GetPos();
		y = -self:GetParent().MaxScroll * self:GetScrollPercentage();
		self:GetParent().DrawPane:SetPos( x, y );
		
		self:GetParent().Body:InvalidateLayout();
		
	end

end

function BAR:PerformLayout()

	self.MaxScroll = self:GetParent():GetTall() - 17 - self:GetTall();

end

function BAR:GetScrollPercentage()

	local _, y = self:GetPos();
	
	local min = 35;
		
	if( self:GetParent().FullWindow ) then
		min = 19;
	end
	
	return ( y - min ) / ( self.MaxScroll - min );

end

function BAR:Paint()

	draw.RoundedBox( 2, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) );
	draw.RoundedBox( 2, 1, 1, self:GetWide() - 2, self:GetTall() - 2, self.Color );
	
	return true;

end


vgui.Register( "TacoScrollBar", BAR, "Button" );
