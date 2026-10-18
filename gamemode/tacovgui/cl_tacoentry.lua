
ENTRY = { }

function ENTRY:Init()

end

function ENTRY:SetCallback( func )

	self.Callback = func;

end

function ENTRY:OnKeyCodePressed( code )

	if( self.Multiline ) then return; end

	if( code == 64 ) then
		if( self.Callback ) then
			self.Callback( self, self:GetValue() );
		end
	end

end

vgui.Register( "TacoEntry", ENTRY, "TextEntry" );