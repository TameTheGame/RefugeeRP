
local BODY = { }

function BODY:Init()

end

function BODY:Paint()

	if( self.PaintHook ) then
	
		local scroll = 0;
		
		if( self:GetParent():GetParent().ScrollButtonBar ) then
			scroll = ( self:GetParent():GetParent().MaxScroll * self:GetParent():GetParent().ScrollButtonBar:GetScrollPercentage() );
		end
	
		self.PaintHook( self:GetParent(), scroll );
	end

end

function BODY:PerformLayout()

	if( self:GetParent():GetParent().Labels ) then

		for _, v in pairs( self:GetParent():GetParent().Labels ) do

			if( v ) then

				local x, y = v:GetPos();
				
				if( self:GetParent():GetParent().ScrollButtonBar ) then
					y = v.origy - ( self:GetParent():GetParent().MaxScroll * self:GetParent():GetParent().ScrollButtonBar:GetScrollPercentage() );
				end
				
				v:SetPos( x, y );
				
				if( not v.ConstantSize ) then
				
					v:SetSize( self:GetParent():GetParent().Body:GetWide(), self:GetParent():GetParent().Body:GetTall() );
					v:SizeToContents();
					
				end
				
			end
		
		end
		
	end
	
	if( self:GetParent():GetParent().Buttons ) then

		for _, v in pairs( self:GetParent():GetParent().Buttons ) do
			
			if( v ) then
			
				local x, y = v:GetPos();
				
				if( self:GetParent():GetParent().ScrollButtonBar ) then
					y = v.origy - ( self:GetParent():GetParent().MaxScroll * self:GetParent():GetParent().ScrollButtonBar:GetScrollPercentage() );
				end
				
				v:SetPos( x, y );
				
			end
		
		end
		
	end
	
	if( self:GetParent():GetParent().Objects ) then

		for _, v in pairs( self:GetParent():GetParent().Objects ) do

			if( v ) then

				local x, y = v:GetPos();
				
				if( self:GetParent():GetParent().ScrollButtonBar ) then
					y = v.origy - ( self:GetParent():GetParent().MaxScroll * self:GetParent():GetParent().ScrollButtonBar:GetScrollPercentage() );
				end
				
				v:SetPos( x, y );
				
			end
		
		end
		
	end

end

vgui.Register( "TacoBody", BODY, "Panel" );