
local TITLE = { }

function TITLE:Init()

	self.MoveTitle = false;
	self.XOffset = 0;
	self.YOffset = 0;
	
end

function TITLE:Think()

	if( self.MoveTitle ) then

		local mx = gui.MouseX();
		local my = gui.MouseY();
	
		self:GetParent():SetPos( mx - self.XOffset, my - self.YOffset );
		
	end

end

function TITLE:OnMousePressed()

	self.MoveTitle = true;
	
	local mx = gui.MouseX();
	local my = gui.MouseY();
	
	local px, py = self:GetParent():GetPos();
	
	self.XOffset = mx - px;
	self.YOffset = my - py;

end

function TITLE:Paint()

	return true;

end

function TITLE:OnMouseReleased()

	self.MoveTitle = false;

end

vgui.Register( "TacoTitleLabel", TITLE, "Button" );