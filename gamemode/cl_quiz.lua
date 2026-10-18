
local questions = 
{

	{ "Is this server HL2 or Post-Apocalyptic themed roleplay?", "HL2", "Post-Apocalyptic" },
	{ "Can it be fun to roleplay without a toolgun?", "Yes", "No" },
	{ "Do you like to deathmatch in roleplay?", "Yes", "No" },
	{ "Can it be fun to roleplay without gun fighting?", "Yes", "No" },
	{ "Are you fine with using a first-and-last roleplay name?", "Yes", "No" },
	{ "What is OOC?", "Out-Of-Context", "Out-Of-Character" },

}

local answers = { }

if( QuestionPanel ) then

	QuestionPanel:Remove();

end

QuestionPanel = nil;

function msgEndQuiz()

	QuestionPanel:Remove();

end
usermessage.Hook( "EndQuiz", msgEndQuiz );

function msgIncorrect()

	local warn = vgui.Create( "TacoFrame" );
	warn:SetTitle( "Cannot Continue" );
	warn:SetColor( Color( 30, 30, 30, 255 ) );
	warn:SetPos( ScrW() / 2 - 100, ScrH() / 2 - 45 );
	warn:SetSize( 200, 90 );
	warn:AddLabel( "Incorrect answer(s).", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
	warn:SetVisible( true );
	warn:MakePopup();
	return;
				

end
usermessage.Hook( "IncorrectQuiz", msgIncorrect );

function msgCreateQuestionPanel()
if( ValidEntity( LocalPlayer() ) ) then
	gui.EnableScreenClicker( true );

	QuestionPanel = vgui.Create( "TacoPanel" );
	timer.Simple( .5, QuestionPanel.EnableCloseButton, QuestionPanel, false );
	QuestionPanel:SetTitle( "Questions" );
	QuestionPanel:SetPos( ScrW() * .15, ScrH() * .15 );
	QuestionPanel:SetSize( ScrW() * .7, ScrH() * .7 );
	QuestionPanel:MakePopup();
	
	local h = 10;
	surface.SetFont( "DefaultSmall" );
	
	for k, v in pairs( questions ) do
		
		local xw, xh = surface.GetTextSize( FormatLine( v[1], "DefaultSmall", QuestionPanel:GetWide() * .55 ) );
		h = h + xh + 10;
		
		local function Answer( but )
		
			but:SetColor( Color( 30, 30, 180, 255 ) );
			but.OtherButton:SetColor( Color( 90, 90, 90, 255 ) );
			
			answers[but.QID] = but.opt;
		
		end
		
		QuestionPanel:AddLabel( FormatLine( v[1], "DefaultSmall", QuestionPanel:GetWide() * .55 ), "DefaultSmall", 10, h, Color( 255, 255, 255, 255 ) );
		
		local but1 = QuestionPanel:AddButton( v[2], QuestionPanel:GetWide() * .62, h, surface.GetTextSize( v[2] ) + 20, 16 );
		local but2 = QuestionPanel:AddButton( v[3], QuestionPanel:GetWide() * .62 + surface.GetTextSize( v[2] ) + 40, h, surface.GetTextSize( v[3] ) + 20, 16 );
		but1:SetRoundness( 0 );
		but2:SetRoundness( 0 );
		
		but1.QID = k;
		but1.opt = 1;
		but1.OtherButton = but2;
		but1:SetCallback( Answer );
		
		but2.QID = k;
		but2.opt = 2;
		but2.OtherButton = but1;
		but2:SetCallback( Answer );
		
	end
	
	local function CheckQuiz()
	
		local n = 0;
		
		for k, v in pairs( answers ) do
		
			n = n + 1;
		
		end
		
		if( n < #questions ) then
			
			local warn = vgui.Create( "TacoFrame" );
			warn:SetTitle( "Cannot Continue" );
			warn:SetColor( Color( 30, 30, 30, 255 ) );
			warn:SetPos( ScrW() / 2 - 100, ScrH() / 2 - 45 );
			warn:SetSize( 200, 90 );
			warn:AddLabel( "Answer all the questions.", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
			warn:SetVisible( true );
			warn:MakePopup();
			return;
			
		end
	
		local argstr = "";
		
		for k, v in pairs( answers ) do
		
			argstr = argstr .. " " .. v;
		
		end
	
		LocalPlayer():ConCommand( "rp_checkquiz " .. argstr .. "\n" );
	
	end
	
	local cont = QuestionPanel:AddButton( "Continue", QuestionPanel:GetWide() * .62, h + 25, 200, 16 );
	cont:SetCallback( CheckQuiz );
end
end
usermessage.Hook( "CreateQuestionPanel", msgCreateQuestionPanel );