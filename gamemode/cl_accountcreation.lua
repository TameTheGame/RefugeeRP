
if( HAWindow ) then

	HAWindow:Remove();

end

if( HAbrowser ) then

	HAbrowser:Remove();

end

HAWindow = nil;
HAbrowser = nil;

AccountCreation = false;

function msgHandleAccountCreation()
if( ValidEntity( LocalPlayer() ) ) then
	AccountCreation = true;
	
	gui.EnableScreenClicker( true );
	
	local function Register( but )
	
		if( string.len( HAWindow.UserNameBox:GetValue() ) < 3 ) then
		
			local warn = vgui.Create( "TacoFrame" );
			warn:SetTitle( "Cannot Continue" );
			warn:SetColor( Color( 30, 30, 30, 255 ) );
			warn:SetPos( ScrW() / 2 - 100, ScrH() / 2 - 45 );
			warn:SetSize( 200, 90 );
			warn:AddLabel( "Your username is too short.\nAtleast 6 characters.", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
			warn:SetVisible( true );
			warn:MakePopup();
			return;
			
		end
		
		if( string.len( HAWindow.UserNameBox:GetValue() ) > 16 ) then
		
			local warn = vgui.Create( "TacoFrame" );
			warn:SetTitle( "Cannot Continue" );
			warn:SetColor( Color( 30, 30, 30, 255 ) );
			warn:SetPos( ScrW() / 2 - 100, ScrH() / 2 - 45 );
			warn:SetSize( 200, 90 );
			warn:AddLabel( "Your username is too long.", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
			warn:SetVisible( true );
			warn:MakePopup();
			return;
			
		end		

		if( string.len( HAWindow.PasswordBox:GetValue() ) < 6 ) then
		
			local warn = vgui.Create( "TacoFrame" );
			warn:SetTitle( "Cannot Continue" );
			warn:SetColor( Color( 30, 30, 30, 255 ) );
			warn:SetPos( ScrW() / 2 - 100, ScrH() / 2 - 45 );
			warn:SetSize( 200, 90 );
			warn:AddLabel( "Your password is too short.\nAtleast 6 characters.", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
			warn:SetVisible( true );
			warn:MakePopup();
			return;
			
		end
		
		if( string.len( HAWindow.PasswordBox:GetValue() ) > 32 ) then
		
			local warn = vgui.Create( "TacoFrame" );
			warn:SetTitle( "Cannot Continue" );
			warn:SetColor( Color( 30, 30, 30, 255 ) );
			warn:SetPos( ScrW() / 2 - 100, ScrH() / 2 - 45 );
			warn:SetSize( 200, 90 );
			warn:AddLabel( "Your password is too long.", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
			warn:SetVisible( true );
			warn:MakePopup();
			return;
		end		
	
		if( HAWindow.PasswordBox:GetValue() ~= HAWindow.PasswordBox2:GetValue() ) then
		
			local warn = vgui.Create( "TacoFrame" );
			warn:SetTitle( "Cannot Continue" );
			warn:SetColor( Color( 30, 30, 30, 255 ) );
			warn:SetPos( ScrW() / 2 - 100, ScrH() / 2 - 45 );
			warn:SetSize( 200, 90 );
			warn:AddLabel( "Passwords are not the same.", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
			warn:SetVisible( true );
			warn:MakePopup();
			return;
			
		end
		
		LocalPlayer():ConCommand( "rp_endaccountcreation \"" .. HAWindow.UserNameBox:GetValue() .. "\" \"" .. HAWindow.PasswordBox:GetValue() .. "\"\n" );
	
	end
	
	HAWindow = vgui.Create( "TacoFrame" );
	HAWindow:SetPos( ScrW() / 2 - 150, .4 * ScrH() );
	HAWindow:SetSize( 300, 250 );
	HAWindow:SetTitle( "Register" );
	HAWindow:SetVisible( true );
	--timer.Simple( .1, HAWindow.EnableCloseButton, HAWindow, false );
	
	--HAWindow:AddLabel( ".", "DefaultSmall", 5, -80, Color( 255, 255, 255, 255 ) );
	
	local function CustomInput( panel ) 
	
		if( string.len( panel:GetValue() ) > 32 ) then
		
			panel:SetText( string.sub( panel:GetValue(), 1, 32 ) );
		
		end
	
		local str = panel:GetValue();
		
		if( panel.Censored ) then
			str = string.rep( "*", string.len( panel:GetValue() ) );
		end
		
		draw.RoundedBox( 4, 0, 0, panel:GetWide(), panel:GetTall(), Color( 90, 90, 90, 255 ) );
		draw.DrawText( str, "Default", 5, 5, Color( 255, 255, 255, 255 ) );
		return true;
	
	end

	HAWindow:AddLabel( "Username", "DefaultSmall", 5, -55, Color( 255, 255, 255, 255 ) );

	HAWindow.UserNameBox = HAWindow:AddEntry( function() end, 5, 80, 290 );
	HAWindow.UserNameBox:SetPaintFunction( CustomInput );

	HAWindow:AddLabel( "Password", "DefaultSmall", 5, -12, Color( 255, 255, 255, 255 ) );

	HAWindow.PasswordBox = HAWindow:AddEntry( function() end, 5, 120, 290 );
	HAWindow.PasswordBox:SetPaintFunction( CustomInput );
	HAWindow.PasswordBox.Censored = true;

	HAWindow:AddLabel( "Verify password", "DefaultSmall", 5, 28, Color( 255, 255, 255, 255 ) );
	
	HAWindow.PasswordBox2 = HAWindow:AddEntry( function() end, 5, 160, 290 );
	HAWindow.PasswordBox2:SetPaintFunction( CustomInput );
	HAWindow.PasswordBox2.Censored = true;
	
	HAWindow.ContinueButton = vgui.Create( "TacoButton", HAWindow );
	HAWindow.ContinueButton:SetText( "Login/Register" );
	HAWindow.ContinueButton:SetPos( 185, 200 );
	HAWindow.ContinueButton:SetSize( 140, 20 );
	HAWindow.ContinueButton:SetRoundness( 0 );
	HAWindow.ContinueButton:SetCallback( Register );
 end
end
usermessage.Hook( "HandleAccountCreation", msgHandleAccountCreation );

local function msgEndAccountCreate()

	AccountCreation = false;

	if( HAWindow ) then
	
		HAWindow:SetVisible( false );
	
	end
	
	if( HAbrowser ) then
	
		HAbrowser:Remove();
	
	end
	
	gui.EnableScreenClicker( false );

end
usermessage.Hook( "EndAccountCreate", msgEndAccountCreate );

local function msgDuplicateAccount()
if( ValidEntity( LocalPlayer() ) ) then
		local warn = vgui.Create( "TacoFrame" );
		warn:SetTitle( "Cannot Continue" );
		warn:SetColor( Color( 30, 30, 30, 255 ) );
		warn:SetPos( ScrW() / 2 - 100, ScrH() / 2 - 45 );
		warn:SetSize( 200, 90 );
		warn:AddLabel( "Username already taken.\nIf logging in, supply correct password.", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
		warn:SetVisible( true );
		warn:MakePopup();
end
end
usermessage.Hook( "DuplicateAccount", msgDuplicateAccount );