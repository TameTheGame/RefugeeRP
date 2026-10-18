
if( LetterEditorPanel ) then
	LetterEditorPanel:Remove();
end

if( LetterPanel ) then
	LetterPanel:Remove();
end

LetterPanel = nil;
LetterEditorPanel = nil;

function CreateLetterEditor()

	LetterEditorPanel = vgui.Create( "TacoFrame" );
	LetterEditorPanel:SetPos( ScrW() * .33, ScrH() * .33 );
	LetterEditorPanel:SetSize( ScrW() * .33, ScrH() * .33 + 30 );
	LetterEditorPanel:SetColor( Color( 20, 20, 20, 200 ) );
	LetterEditorPanel:SetTitle( "Letter Editor" );
	LetterEditorPanel:SetKeyboardInputEnabled( true );
	LetterEditorPanel:MakePopup();
	
	local function FinishLetter( panel )
	
		local letter = string.gsub( LetterEditorPanel.Entry:GetValue(), "\n", "=n" );
		
		if( string.len( letter ) > 255 ) then
					
			local warn = vgui.Create( "TacoFrame" );
			warn:SetTitle( string.len( letter ) .. " characters long" );
			warn:SetColor( Color( 100, 100, 100, 255 ) );
			warn:SetPos( ScrW() / 2 - 100, ScrH() / 2 - 45 );
			warn:SetSize( 200, 90 );
			warn:AddLabel( "Letter must be under 255 characters", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
			warn:SetVisible( true );
			return;
		
		end
		
		local len = string.len( letter );
		local pass = 0;
		
		LocalPlayer():ConCommand( "sl\n" );
		
		while( len > 0 ) do
		
			local subletter = string.sub( letter, pass * 252, ( pass + 1 ) * 251 );
			len = len - math.Clamp( string.len( letter ), 0, 251 );
		
			pass = pass + 1;
			
			LocalPlayer():ConCommand( "wl " .. subletter .. "\n" );
		
		end
	
		LocalPlayer():ConCommand( "fl\n" );
		LetterEditorPanel:Remove();
		LetterEditorPanel = nil;
		
	end
	
	local but = vgui.Create( "TacoButton", LetterEditorPanel );
	but:SetPos( ScrW() * .33 - 100, ScrH() * .33 - 10 );
	but:SetSize( 80, 25 );
	but:SetCallback( FinishLetter );
	but:SetMouseInputEnabled( true );
	but:SetVisible( true );
	but:SetText( "Done" );
	but:SetRoundness( 2 );
	
	LetterEditorPanel.Entry = LetterEditorPanel:AddMultilineEntry( FinishLetter, 10, 30, ScrW() * .33 - 20, ScrH() * .33 - 50 );
	
	
end

function msgCreateLetterEditor( msg )

	if( LetterEditorPanel ) then
		LetterEditorPanel:Remove();
		LetterEditorPanel = nil;
	end

	CreateLetterEditor();
	
	LetterEditorPanel.Entry:SetText( msg:ReadString() );
	LetterEditorPanel:SetVisible( true );

end
usermessage.Hook( "msgCreateLetterEditor", msgCreateLetterEditor );

surface.CreateFont( "akbar", 20, 500, true, false, "AckBarWriting" );

CanPickupLetter = false;
LetterEnt = 0;

function LetterThink()

	if( CanPickupLetter and LetterEnt:IsValid() and LetterPanel and LetterPanel:IsVisible() ) then
	
		if( LocalPlayer():EyePos():Distance( LetterEnt:GetPos() ) > 110 ) then
		
			gui.EnableScreenClicker( false );
			LetterPanel:SetVisible( false );			
		
		end
	
	end

end
hook.Add( "Think", "LetterThink", LetterThink );

function CreateLetter( msg, canpickup )

	CanPickupLetter = canpickup;

	gui.EnableScreenClicker( true );
	
	local function CloseLetter()
	
		gui.EnableScreenClicker( false );
		LetterPanel:SetVisible( false );
	
	end
	
	local function TakeLetter()
	
		LocalPlayer():ConCommand( "rp_takeletter\n" );
		
		gui.EnableScreenClicker( false );
		LetterPanel:SetVisible( false );
	
	end

	LetterPanel = vgui.Create( "TacoPanel" );
	LetterPanel:SetPos( ScrW() * .25, ScrH() * .2 );
	LetterPanel:SetSize( ScrW() * .5, ScrH() * .6 );
	LetterPanel:SetColor( Color( 255, 255, 255, 200 ) );
	timer.Simple( .05, LetterPanel.EnableCloseButton, LetterPanel, false );
	LetterPanel:EnableTitle( false );

	if( canpickup ) then
		local but = LetterPanel:AddButton( "Take Letter", 10, 5, 80, 20 );
		but:SetColor( Color( 200, 200, 200, 255 ) );
		but:SetTextColor( Color( 0, 0, 0, 255 ) );
		but:SetHighlightColor( Color( 160, 160, 160, 255 ) );
		but:SetCallback( TakeLetter );
	else
		LetterPanel:MakePopup();
	end
	
	local but = LetterPanel:AddButton( "Close", 100, 5, 80, 20 );
	but:SetColor( Color( 200, 200, 200, 255 ) );
	but:SetTextColor( Color( 0, 0, 0, 255 ) );
	but:SetHighlightColor( Color( 160, 160, 160, 255 ) );
	but:SetCallback( CloseLetter );	
	
	LetterPanel.MessagePanel = vgui.Create( "TacoPanel", LetterPanel );
	LetterPanel.MessagePanel:SetOutlineWidth( 0 );
	LetterPanel.MessagePanel:TurnIntoChild();
	LetterPanel.MessagePanel:SetPos( 10, 45 );
	LetterPanel.MessagePanel:SetSize( LetterPanel:GetWide() - 20, LetterPanel:GetTall() - 45 );
	LetterPanel.MessagePanel:SetColor( Color( 255, 255, 255, 0 ) );
	
	local fmsg = FormatLine( msg, "AckBarWriting", LetterPanel.MessagePanel:GetWide() - 20 - 40 );
	surface.SetFont( "AckBarWriting" );
	local w, h = surface.GetTextSize( fmsg );
	
	local scrollamt = math.Clamp( h - LetterPanel.MessagePanel:GetTall(), 0, 10000 );
	
	if( scrollamt > 0 ) then
		
		LetterPanel.MessagePanel:SetMaxScroll( scrollamt + 25 );
		LetterPanel.MessagePanel:AddScrollBar();
		LetterPanel.MessagePanel:SetScrollColor( Color( 200, 200, 200, 200 ) );
		
	end
	
	LetterPanel.MessagePanel:AddLabel( fmsg, "AckBarWriting", 10, 10, Color( 0, 0, 0, 255 ) );

	LastLetterY = h + 10;

end

function msgDisplayLetter( msg )

	local canpickup = msg:ReadBool();
	
	CrntPieces = 0;
	WholeLetterMsg = "";
	
	if( canpickup ) then
	
		LetterEnt = msg:ReadEntity();
	
	end
	
	if( LetterPanel ) then
		LetterPanel:Remove();
		LetterPanel = nil;
	end

	CanPickupLetter = canpickup;

	--CreateLetter( letter, canpickup );

end
usermessage.Hook( "DisplayLetter", msgDisplayLetter );

CrntPieces = 0;

WholeLetterMsg = "";

LastLetterY = 0;

function msgLetterPiece( msg )

	CrntPieces = CrntPieces + 1;
	
	local piece = msg:ReadString();
	
	WholeLetterMsg = WholeLetterMsg .. piece;

	if( CrntPieces == 1 ) then
		CreateLetter( WholeLetterMsg, CanPickupLetter );
	else
	
		local fmsg = FormatLine( piece, "AckBarWriting", LetterPanel.MessagePanel:GetWide() - 20 - 40 );
		surface.SetFont( "AckBarWriting" );
		local w, h = surface.GetTextSize( fmsg );
		
		local scrollamt = math.Clamp( h - LetterPanel.MessagePanel:GetTall(), 0, 10000 );
		
		if( scrollamt > 0 ) then
			
			LetterPanel.MessagePanel:SetMaxScroll( scrollamt + 25 );
			
		end
		
		LetterPanel.MessagePanel:AddLabel( fmsg, "AckBarWriting", 10, LastLetterY, Color( 0, 0, 0, 255 ) );
	
		LastLetterY = LastLetterY + h;
	
	end

end
usermessage.Hook( "SendLetterPiece", msgLetterPiece );