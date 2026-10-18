
include( "cl_button.lua" );
include( "cl_closebutton.lua" );
include( "cl_titlelabel.lua" );
include( "cl_body.lua" );
include( "cl_scroll.lua" );
include( "cl_tacoentry.lua" );
include( "cl_tacoframe.lua" );
include( "cl_link.lua" );

local PANEL = { }

surface.CreateFont( "TargetID", 14, 500, true, false, "PanelTitle" );

function PANEL:Init()

	self.TitleBarText = "TacoScript";
	self.HasTitleBar = true;
	self.TitleBarFontColor = Color( 255, 255, 255, 255 );
	self.TitleBarBGColor = Color( 20, 20, 20, 255 );
	 
	 if( self.TitleLabel ) then
	 	self.TitleLabel:Remove();
	 end
	 
	self.TitleLabel = vgui.Create( "Label", self );
	self.TitleLabel:SetFont( "PanelTitle" );
	self.TitleLabel:SetText( self.TitleBarText );
	
	if( self.TitleMover ) then
		self.TitleMover:Remover();
	end
	
	self.TitleMover = vgui.Create( "TacoTitleLabel", self );	
	
	self.CanClose = true;
	
	if( self.CloseButton ) then
		self.CloseButton:Remove();
	end
	
	self.CloseButton = vgui.Create( "TacoCloseButton", self );
	self.CloseButton:SetTarget( self );

	self.BGColor = Color( 60, 60, 60, 255 );
	
	if( self.Content ) then
		self.Content:Remove();
	end
	
	if( self.DrawPane ) then
		self.DrawPane:Remove();
	end
	
	if( self.Body ) then
		self.Body:Remove();
	end
	
	self.Content = vgui.Create( "TacoBody", self );
	self.DrawPane = vgui.Create( "TacoBody", self.Content );
	self.Body = vgui.Create( "TacoBody", self.Content );
	
	self.Labels = { }
	self.Buttons = { }
	self.Objects = { }
	
	self.ScrollAmt = 0;
	self.MaxScroll = -1;
	
	self.FullWindow = false;
	
	self.CloseEvent = nil;
	
	self.OutlineWidth = 2;
	
	self.HasCloseButton = self.HasCloseButton or true;
	
	self.Roundness = 8;

end

function PANEL:SetRoundness( amt )

	self.Roundness = amt;

end

function PANEL:TurnIntoChild()

	self:EnableTitle( false );
	self:EnableCloseButton( false );
	self:EnableDragging( false );
	self:EnableFullWindow( true );	

end

function PANEL:Reset()

	if( self.ScrollButtonBar ) then
		self.ScrollButtonBar:Remove();
		self.ScrollButtonBar = nil;
	end
	
	if( self.ScrollButtonUp ) then
		self.ScrollButtonUp:Remove();
		self.ScrollButtonUp = nil;
	end
	
	if( self.ScrollButtonDown ) then
		self.ScrollButtonDown:Remove();
		self.ScrollButtonDown = nil;
	end
	
	for k, v in pairs( self.Labels ) do
		v:Remove();
		self.Labels[k] = nil;
	end
		
	for k, v in pairs( self.Buttons ) do
		v:Remove();
		self.Buttons[k] = nil;
	end
	
	self:Init();
	self:InvalidateLayout();

end

function PANEL:SetCloseEvent( func )

	self.CloseEvent = func;

end

function PANEL:OnClose()

	if( self.CloseEvent ) then
		self.CloseEvent();
	end

end

function PANEL:EnableFullWindow( val )

	self.FullWindow = val;
	self:InvalidateLayout();

end

function PANEL:SetMaxScroll( max )

	if( max ~= self.MaxScroll ) then

		self.MaxScroll = max;
		
		if( max == 0 ) then
	
			if( self.ScrollButtonBar ) then
			
				if( self.ScrollButtonBar:IsVisible() ) then
			
					self.ScrollButtonBar:SetVisible( false );
					self.ScrollButtonUp:SetVisible( false );
					self.ScrollButtonDown:SetVisible( false );
				
				end
			
			end 
			
	
		elseif( self.ScrollButtonBar and not self.ScrollButtonBar:IsVisible() ) then
		
			self.ScrollButtonBar:SetVisible( true );
			self.ScrollButtonUp:SetVisible( true );
			self.ScrollButtonDown:SetVisible( true );
		
		end
	
		self:InvalidateLayout();
		
	end

end

function PANEL:OnMouseWheeled( delta )

	if( self.ScrollButtonBar ) then

		local min = 35;
		
		if( self.FullWindow ) then
			min = 19;
		end
		
		local x, y = self.ScrollButtonBar:GetPos();
		self.ScrollButtonBar:SetPos( x, math.Clamp( y - delta * 50, min, self.ScrollButtonBar.MaxScroll ) );
	
		local x, y = self.DrawPane:GetPos();
		y = -self.MaxScroll * self.ScrollButtonBar:GetScrollPercentage();
		self.DrawPane:SetPos( x, y );
	
		self.Body:InvalidateLayout();
		
	end

end

function PANEL:GetScrollAmount()

	return -self.MaxScroll * self.ScrollButtonBar:GetScrollPercentage();

end

function PANEL:ScrollUp()

	local min = 35;
		
	if( self.FullWindow ) then
		min = 19;
	end

	local x, y = self.ScrollButtonBar:GetPos();
	self.ScrollButtonBar:SetPos( x, math.Clamp( y - 400 * FrameTime(), min, self.ScrollButtonBar.MaxScroll ) );

	local x, y = self.DrawPane:GetPos();
	y = -self.MaxScroll * self.ScrollButtonBar:GetScrollPercentage();
	self.DrawPane:SetPos( x, y );

	self.Body:InvalidateLayout();

end

function PANEL:ScrollDown()

	local min = 35;
		
	if( self.FullWindow ) then
		min = 19;
	end

	local x, y = self.ScrollButtonBar:GetPos();
	self.ScrollButtonBar:SetPos( x, math.Clamp( y + 400 * FrameTime(), min, self.ScrollButtonBar.MaxScroll ) );

	local x, y = self.DrawPane:GetPos();
	y = -self.MaxScroll * self.ScrollButtonBar:GetScrollPercentage();
	self.DrawPane:SetPos( x, y );

	self.Body:InvalidateLayout();
	
end

function PANEL:AddScrollBar()

	self.ScrollButtonUp = vgui.Create( "TacoScrollButton", self );
	self.ScrollButtonUp:SetType( SCROLLTYPE_UP );

	self.ScrollButtonDown = vgui.Create( "TacoScrollButton", self );
	
	self.ScrollButtonDown:SetType( SCROLLTYPE_DOWN );
	
	self.ScrollButtonBar = vgui.Create( "TacoScrollBar", self );
	
	self:InvalidateLayout();

end

function PANEL:SetTitleBarColor( font, bar )
	
 	self.TitleBarFontColor = font;
	self.TitleLabel:SetFGColor( self.TitleBarFontColor.r, self.TitleBarFontColor.g, self.TitleBarFontColor.b, self.TitleBarFontColor.a );

	self.TitleBarBGColor = bar;

end

function PANEL:SetScrollColor( color )

	self.ScrollButtonUp:SetColor( color );
	self.ScrollButtonDown:SetColor( color );
	self.ScrollButtonBar:SetColor( color );

end

function PANEL:AddLabel( text, font, x, y, color, constantsize )

	local newlabel = vgui.Create( "Label", self.Body );
	newlabel:SetFont( font );
	newlabel:SetText( text );
	newlabel:SetPos( x, y );
	newlabel:SetSize( self.Body:GetWide(), self.Body:GetTall() );
	newlabel.r = color.r;
	newlabel.g = color.g;
	newlabel.b = color.b;
	newlabel.a = color.a;
	newlabel.origy = y;
	newlabel.ConstantSize = constantsize;
	newlabel.ID = #self.Labels + 1;
	table.insert( self.Labels, newlabel );
	
	self:InvalidateLayout();

	return newlabel;

end

function PANEL:RemoveLabel( label )

	for k, v in pairs( self.Labels ) do
	
		if( v.ID == label.ID ) then
		
			self.Labels[k]:Remove();
			self.Labels[k] = nil;
			break;
		
		end
	
	end

end

function PANEL:RemoveObject( obj )

	for k, v in pairs( self.Objects ) do
	
		if( v.ID == obj.ID ) then
		
			self.Objects[k]:Remove();
			self.Objects[k] = nil;
			break;
		
		end
	
	end

end

function PANEL:AddObject( obj, x, y )

	obj.origx = x;
	obj.origy = y;
	
	obj.ID = #self.Objects + 1;
	
	table.insert( self.Objects, obj );
	
	self:InvalidateLayout();
	
	return obj;

end

function PANEL:AddButton( text, x, y, w, h )

	local newbutton = vgui.Create( "TacoButton", self.Body );
	newbutton:SetText( text );
	newbutton:SetPos( x, y );
	newbutton:SetSize( w, h );
	newbutton.origy = y;
	newbutton.ID = #self.Buttons + 1;
	
	table.insert( self.Buttons, newbutton );
	
	self:InvalidateLayout();

	return newbutton;

end

function PANEL:RemoveButton( but )

	for k, v in pairs( self.Buttons ) do
	
		if( v.ID == but.ID ) then
		
			self.Buttons[k]:Remove();
			self.Buttons[k] = nil;
			break;
		
		end
	
	end

end

function PANEL:SetColor( color )

	self.BGColor = color;

end

function PANEL:EnableTitle( val )

	self.HasTitleBar = val;
	self.TitleLabel:SetVisible( val );

end

function PANEL:EnableDragging( val )

	self.CanClose = val;
	self.TitleMover:SetVisible( val );

end

function PANEL:EnableCloseButton( val )

	self.CloseButton:SetVisible( val );
	self.HasCloseButton = val;

end

function PANEL:SetTitle( title )

	self.TitleBarText = title;
	self.TitleLabel:SetText( self.TitleBarText );
	
	self:InvalidateLayout();

end

function PANEL:SetPaintHook( func )

	self.DrawPane.PaintHook = func;

end

function PANEL:SetOutlineWidth( w )

	self.OutlineWidth = w;

end

function PANEL:SetDrawHook( hook )

	self.DrawHook = hook;

end

function PANEL:Paint()

	local w = self:GetWide();
	local h = self:GetTall();
	
	if( self.OutlineWidth > 0 ) then
		draw.RoundedBox( self.Roundness, 0, 0, w, h, Color( 0, 0, 0, 200 ) );
	end
	
	draw.RoundedBox( self.Roundness, self.OutlineWidth, self.OutlineWidth, w - self.OutlineWidth * 2, h - self.OutlineWidth * 2, self.BGColor );
	
	if( self.HasTitleBar ) then

		draw.RoundedBox( 4, 2, 2, w - 4, 18, Color( self.TitleBarBGColor.r, self.TitleBarBGColor.g, self.TitleBarBGColor.b, self.TitleBarBGColor.a ) );
		
	end
	
	if( self.DrawHook ) then
	
		self.DrawHook( self );
		
	end
	
end

function PANEL:PerformLayout()

	self.TitleMover:SetPos( 0, 0 );
	self.TitleMover:SetSize( self:GetWide() - 35, 18 );

	self.TitleLabel:SizeToContents();
	self.TitleLabel:SetPos( 4, 2 );
	self.TitleLabel:SetSize( self:GetWide() - 35, 18 );
	
	self.TitleLabel:SetVisible( self.HasTitleBar );
	
	self.CloseButton:SetVisible( self.HasCloseButton );
	
	local bodyh = self:GetTall() - 23;
	
	if( not self.FullWindow ) then
		self.Content:SetPos( 2, 21 );
	else
		self.Content:SetPos( 2, 2 );
		bodyh = self:GetTall() - 4;
	end
	
	self.Content:SetSize( self:GetWide() - 30, bodyh );
	
	self.DrawPane:SetPos( 0, 0 );
	self.DrawPane:SetSize( self:GetWide() - 30, 10000 );
	
	self.Body:SetPos( 0, 0 );
	self.Body:SetSize( self:GetWide() - 30, bodyh );
	
	self.Body:InvalidateLayout();
	
	self.CloseButton:SetPos( self:GetWide() - 26, 0 );
	self.CloseButton:SetVisible( self.CanClose );
	
	if( not self.FullWindow and self.ScrollButtonBar and self.ScrollButtonDown and self.ScrollButtonUp ) then
		self.ScrollButtonBar:SetPos( self:GetWide() - 25, 35 );
		self.ScrollButtonDown:SetPos( self:GetWide() - 25, self:GetTall() - 17 );
		self.ScrollButtonUp:SetPos( self:GetWide() - 25, 20 );
	elseif( self.ScrollButtonBar and self.ScrollButtonDown and self.ScrollButtonUp  ) then
		self.ScrollButtonUp:SetPos( self:GetWide() - 25, 4 );
		self.ScrollButtonDown:SetPos( self:GetWide() - 25, self:GetTall() - 17 );
		self.ScrollButtonBar:SetPos( self:GetWide() - 25, 19 );
	end
	
	if( self.ScrollButtonBar ) then
		self.ScrollButtonBar:SetSize( 23, math.Clamp( self.Body:GetTall() - 29 - self.MaxScroll, 10, 600 ) );
	end

	
end

function PANEL:ApplySchemeSettings()

	self.TitleLabel:SetFGColor( self.TitleBarFontColor.r, self.TitleBarFontColor.g, self.TitleBarFontColor.b, self.TitleBarFontColor.a );

	for _, v in pairs( self.Labels ) do
		
		v:SetFGColor( v.r, v.g, v.b, v.a );
	
	end

end


vgui.Register( "TacoPanel", PANEL, "Panel" );