
if( CharacterCreatePanel ) then
	CharacterCreatePanel:Remove();
end

CharacterCreatePanel = nil;
ChosenModel = "";

function SetChosenModel( mdl )

	if( CharacterCreatePanel.ModelIcon ) then
		CharacterCreatePanel.ModelIcon:Remove();
		CharacterCreatePanel.ModelIcon = nil;
	end
	
	CharacterCreatePanel.ModelIcon = vgui.Create( "SpawnIcon", CharacterCreatePanel );
	CharacterCreatePanel.ModelIcon:SetPos( 125, 250 );
	CharacterCreatePanel.ModelIcon:SetSize( 64, 64 );
	CharacterCreatePanel.ModelIcon:SetModel( mdl );
	ChosenModel = mdl;

end

function CreateModelWindow()
if( ValidEntity( LocalPlayer() ) ) then
	if( CharacterCreatePanel.ModelWindow ) then
	
		CharacterCreatePanel.ModelWindow:Remove();
		CharacterCreatePanel.ModelWindow = nil;
	
	end

	CharacterCreatePanel.ModelWindow = vgui.Create( "TacoPanel" );
	CharacterCreatePanel.ModelWindow:SetPos( ScrW() / 2 - 150, ScrH() / 2 - 200 );
	CharacterCreatePanel.ModelWindow:SetSize( 300, 400 );
	CharacterCreatePanel.ModelWindow:SetColor( Color( 60, 60, 60, 255 ) );
	CharacterCreatePanel.ModelWindow:SetTitle( "Model Selection" );	
	CharacterCreatePanel.ModelWindow:MakePopup();
	
	CharacterCreatePanel.ModelWindow:AddLabel( "Male", "TargetID", 5, 5, Color( 255, 255, 255, 255 ) );
	
	local x = 5;
	local y = 60;
	
	for n = 1, 18 do
	
		local spawnicon = vgui.Create( "SpawnIcon", CharacterCreatePanel.ModelWindow );
		spawnicon:SetPos( x, y );
		spawnicon:SetSize( 64, 64 );
		spawnicon:SetModel( Models[n] );
		CharacterCreatePanel.ModelWindow:AddObject( spawnicon, x, y );
		
		spawnicon.Model = n;
		
		spawnicon:SetCommand( "!" );
		
		spawnicon.DoClick = function( self )
		
			SetChosenModel( Models[self.Model] );
		
		end
		
		x = x + 66;
		
		if( x >= 256 ) then
		
			x = 5;
			y = y + 66;
		
		end
		
	end
	
	
	y = y + 60;
	
	CharacterCreatePanel.ModelWindow:AddLabel( "Female", "TargetID", 5, y, Color( 255, 255, 255, 255 ) );	
	
	x = 5;
	y = y + 55;
	
	for n = 19, 29 do
	
		local spawnicon = vgui.Create( "SpawnIcon", CharacterCreatePanel.ModelWindow );
		spawnicon:SetPos( x, y );
		spawnicon:SetSize( 64, 64 );
		spawnicon:SetModel( Models[n] );
		CharacterCreatePanel.ModelWindow:AddObject( spawnicon, x, y );

		spawnicon.Model = n;

		
		spawnicon:SetCommand( "!" );
		
		spawnicon.DoClick = function( self )
		
			SetChosenModel( Models[self.Model] );
		
		end

		x = x + 66;
		
		if( x >= 256 ) then
		
			x = 5;
			y = y + 66;
		
		end
		
	end
	
	CharacterCreatePanel.ModelWindow:SetMaxScroll( 260 );
	CharacterCreatePanel.ModelWindow:AddScrollBar();
end
end

local function DrawCharacterCreate()
if( ValidEntity( LocalPlayer() ) ) then
	draw.DrawText( "Strength", "DefaultSmall", 10, 320, Color( 255, 255, 255, 255 ) );
	draw.RoundedBox( 2, 10, 330, 150, 20, Color( 0, 0, 0, 255 ) );
	draw.RoundedBox( 2, 11, 331, math.Clamp( 148 * ( GetFloat( "stat.Strength" ) / 100 ), 2, 148 ), 18, Color( 0, 200, 0, 255 ) );

	draw.DrawText( "Endurance", "DefaultSmall", 10, 350, Color( 255, 255, 255, 255 ) );
	draw.RoundedBox( 2, 10, 360, 150, 20, Color( 0, 0, 0, 255 ) );
	draw.RoundedBox( 2, 11, 361, math.Clamp( 148 * ( GetFloat( "stat.Endurance" ) / 100 ), 2, 148 ), 18, Color( 0, 200, 0, 255 ) );

	draw.DrawText( "Speed", "DefaultSmall", 10, 380, Color( 255, 255, 255, 255 ) );
	draw.RoundedBox( 2, 10, 390, 150, 20, Color( 0, 0, 0, 255 ) );
	draw.RoundedBox( 2, 11, 391, math.Clamp( 148 * ( GetFloat( "stat.Speed" ) / 100 ), 2, 148 ), 18, Color( 0, 200, 0, 255 ) );

	draw.DrawText( "Sprint", "DefaultSmall", 170, 320, Color( 255, 255, 255, 255 ) );
	draw.RoundedBox( 2, 170, 330, 150, 20, Color( 0, 0, 0, 255 ) );
	draw.RoundedBox( 2, 171, 331, math.Clamp( 148 * ( GetFloat( "stat.Sprint" ) / 100 ), 2, 148 ), 18, Color( 0, 200, 0, 255 ) );

	draw.DrawText( "Aim", "DefaultSmall", 170, 350, Color( 255, 255, 255, 255 ) );
	draw.RoundedBox( 2, 170, 360, 150, 20, Color( 0, 0, 0, 255 ) );
	draw.RoundedBox( 2, 171, 361, math.Clamp( 148 * ( GetFloat( "stat.Aim" ) / 100 ), 2, 148 ), 18, Color( 0, 0, 180, 255 ) );

	draw.DrawText( "Medic", "DefaultSmall", 170, 380, Color( 255, 255, 255, 255 ) );
	draw.RoundedBox( 2, 170, 390, 150, 20, Color( 0, 0, 0, 255 ) );
	draw.RoundedBox( 2, 171, 391, math.Clamp( 148 * ( GetFloat( "stat.Medic" ) / 100 ), 2, 148 ), 18, Color( 0, 0, 180, 255 ) );

	draw.DrawText( "Sneak/Acrobatics", "DefaultSmall", 330, 320, Color( 255, 255, 255, 255 ) );
	draw.RoundedBox( 2, 330, 330, 150, 20, Color( 0, 0, 0, 255 ) );
	draw.RoundedBox( 2, 331, 331, math.Clamp( 148 * ( GetFloat( "stat.Sneak" ) / 100 ), 2, 148 ), 18, Color( 0, 0, 180, 255 ) );
end
end

local function SetNameFrame()
if( ValidEntity( LocalPlayer() ) ) then
	if( CharacterCreatePanel.NameFrame ) then
		CharacterCreatePanel.NameFrame:Remove();
		CharacterCreatePanel.NameFrame = nil;
	end

	local function SetName( pnl, val )
	
		surface.SetFont( "TargetID" );
	
		CharacterCreatePanel.NameLabel:SetText( val );
		CharacterCreatePanel.NameLabel:SetSize( surface.GetTextSize( val ), 25 );
		CharacterCreatePanel.NameFrame:Remove();
		CharacterCreatePanel.NameFrame = nil;
		
	end
	
	CharacterCreatePanel.NameFrame = vgui.Create( "TacoFrame" );
	CharacterCreatePanel.NameFrame:SetTitle( "Set Character Name" );
	CharacterCreatePanel.NameFrame:SetColor( Color( 30, 30, 30, 255 ) );
	CharacterCreatePanel.NameFrame:SetPos( ScrW() / 2 - 50, ScrH() / 2 - 45 );
	CharacterCreatePanel.NameFrame:SetSize( 160, 90 );
	CharacterCreatePanel.NameFrame:AddLabel( "Your RP Name:", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
	CharacterCreatePanel.NameFrame.Entry = CharacterCreatePanel.NameFrame:AddEntry( SetName, 5, 55, 100 );
	CharacterCreatePanel.NameFrame:SetVisible( true );
end
end

local function SetAgeFrame()
if( ValidEntity( LocalPlayer() ) ) then
	if( CharacterCreatePanel.AgeFrame ) then
		CharacterCreatePanel.AgeFrame:Remove();
		CharacterCreatePanel.AgeFrame = nil;
	end

	local function SetAge( pnl, val )
	
		if( tonumber( val ) and tonumber( val ) >= 16 and tonumber( val ) <= 65 ) then
	
			surface.SetFont( "TargetID" );
		
			CharacterCreatePanel.AgeLabel:SetText( val );
			CharacterCreatePanel.AgeLabel:SetSize( surface.GetTextSize( val ), 25 );
			CharacterCreatePanel.AgeFrame:Remove();
			CharacterCreatePanel.AgeFrame = nil;
			
		else
		
			local warn = vgui.Create( "TacoFrame" );
			warn:SetTitle( "Not valid" );
			warn:SetColor( Color( 30, 30, 30, 255 ) );
			warn:SetPos( ScrW() / 2 - 50, ScrH() / 2 - 45 );
			warn:SetSize( 160, 90 );
			warn:AddLabel( "Age must be between 16 and 65", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
			warn:SetVisible( true );
		
		end
		
	end
	
	CharacterCreatePanel.AgeFrame = vgui.Create( "TacoFrame" );
	CharacterCreatePanel.AgeFrame:SetTitle( "Set Character Age" );
	CharacterCreatePanel.AgeFrame:SetColor( Color( 30, 30, 30, 255 ) );
	CharacterCreatePanel.AgeFrame:SetPos( ScrW() / 2 - 50, ScrH() / 2 - 45 );
	CharacterCreatePanel.AgeFrame:SetSize( 160, 90 );
	CharacterCreatePanel.AgeFrame:AddLabel( "Age:", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
	CharacterCreatePanel.AgeFrame.Entry = CharacterCreatePanel.AgeFrame:AddEntry( SetAge, 5, 55, 100 );
	CharacterCreatePanel.AgeFrame:SetVisible( true );
 end
end

local function SetRaceFrame()
if( ValidEntity( LocalPlayer() ) ) then
	if( CharacterCreatePanel.RaceFrame ) then
		CharacterCreatePanel.RaceFrame:Remove();
		CharacterCreatePanel.RaceFrame = nil;
	end

	local function SetRace( pnl, val )
	
		surface.SetFont( "TargetID" );
	
		CharacterCreatePanel.RaceLabel:SetText( val );
		CharacterCreatePanel.RaceLabel:SetSize( surface.GetTextSize( val ), 25 );
		CharacterCreatePanel.RaceFrame:Remove();
		CharacterCreatePanel.RaceFrame = nil;
		
	end
	
	CharacterCreatePanel.RaceFrame = vgui.Create( "TacoFrame" );
	CharacterCreatePanel.RaceFrame:SetTitle( "Set Character Race" );
	CharacterCreatePanel.RaceFrame:SetColor( Color( 30, 30, 30, 255 ) );
	CharacterCreatePanel.RaceFrame:SetPos( ScrW() / 2 - 50, ScrH() / 2 - 45 );
	CharacterCreatePanel.RaceFrame:SetSize( 160, 90 );
	CharacterCreatePanel.RaceFrame:AddLabel( "Race:", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
	CharacterCreatePanel.RaceFrame.Entry = CharacterCreatePanel.RaceFrame:AddEntry( SetRace, 5, 55, 100 );
	CharacterCreatePanel.RaceFrame:SetVisible( true );
 end
end

local function SetDescFrame()
if( ValidEntity( LocalPlayer() ) ) then
	if( CharacterCreatePanel.DescFrame ) then
		CharacterCreatePanel.DescFrame:Remove();
		CharacterCreatePanel.DescFrame = nil;
	end

	local function SetDesc( pnl, val )
	
		if( string.len( CharacterCreatePanel.DescFrame.Entry:GetValue() ) <= 100 ) then
	
			surface.SetFont( "TargetID" );

			CharacterCreatePanel:RemoveLabel( CharacterCreatePanel.DescLabel );
			CharacterCreatePanel.DescLabel = CharacterCreatePanel:AddLabel( FormatLine( string.gsub(  CharacterCreatePanel.DescFrame.Entry:GetValue(), "\n", "" ), "TargetID", ScrW() * .6 - 200 ), "TargetID", 5, 120, Color( 255, 255, 255, 255 ) );
		
			CharacterCreatePanel.DescFrame:Remove();
			CharacterCreatePanel.DescFrame = nil;
			
			
		else
		
			local warn = vgui.Create( "TacoFrame" );
			warn:SetTitle( string.len( CharacterCreatePanel.DescFrame.Entry:GetValue() ) .. " characters long" );
			warn:SetColor( Color( 30, 30, 30, 255 ) );
			warn:SetPos( ScrW() / 2 - 50, ScrH() / 2 - 45 );
			warn:SetSize( 190, 90 );
			warn:AddLabel( "Description must be under 100 characters", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
			warn:SetVisible( true );
		
		end
		
	end
	
	CharacterCreatePanel.DescFrame = vgui.Create( "TacoFrame" );
	CharacterCreatePanel.DescFrame:SetTitle( "Set Character Description" );
	CharacterCreatePanel.DescFrame:SetColor( Color( 30, 30, 30, 255 ) );
	CharacterCreatePanel.DescFrame:SetPos( ScrW() / 2 - 100, ScrH() / 2 - 117 );
	CharacterCreatePanel.DescFrame:SetSize( 200, 235 );
	CharacterCreatePanel.DescFrame:AddLabel( "Description (must be under 101 characters):", "DefaultSmall", 5, -70, Color( 255, 255, 255, 255 ) );
	CharacterCreatePanel.DescFrame.Entry = CharacterCreatePanel.DescFrame:AddMultilineEntry( SetDesc, 5, 60, 170, 130 );
	CharacterCreatePanel.DescFrame:SetVisible( true );

	local but = vgui.Create( "TacoButton", CharacterCreatePanel.DescFrame );
	but:SetText( "Done" );
	but:SetPos( 5, 200 );
	but:SetSize( 50, 15 );
	but:SetRoundness( 0 );
	but:SetCallback( SetDesc );
 end 
end

PointsLeft = 15;
MaxPoints = 0;

local function SetStatsWindow()
if( ValidEntity( LocalPlayer() ) ) then
	local function AddStat( but )
	
		local name = but.Stat;
		
		LocalPlayer():ConCommand( "rp_addstat " .. GetString( "UniqueID" ) .. " " .. name .. "\n" );
		
	
	end

	local function SubtractStat( but )
	
		local name = but.Stat;

		LocalPlayer():ConCommand( "rp_subtractstat " .. GetString( "UniqueID" ) .. " " ..name .. "\n" );
	
	end

	local function StatPaint()
	
		draw.DrawText( "Strength: " .. math.ceil( GetFloat( "stat.Strength" ) ), "DefaultSmall", 70, 50, Color( 255, 255, 255, 255 ) );
		draw.RoundedBox( 2, 70, 60, 150, 10, Color( 0, 0, 0, 255 ) );
		draw.RoundedBox( 2, 71, 61, math.Clamp( 148 * ( GetFloat( "stat.Strength" ) / 100 ), 2, 148 ), 8, Color( 0, 200, 0, 255 ) );
		
		draw.DrawText( "Endurance: " .. math.ceil( GetFloat( "stat.Endurance" ) ), "DefaultSmall", 70, 80, Color( 255, 255, 255, 255 ) );
		draw.RoundedBox( 2, 70, 90, 150, 10, Color( 0, 0, 0, 255 ) );
		draw.RoundedBox( 2, 71, 91, math.Clamp( 148 * ( GetFloat( "stat.Endurance" ) / 100 ), 2, 148 ), 8, Color( 0, 200, 0, 255 ) );
	
		draw.DrawText( "Speed: " .. math.ceil( GetFloat( "stat.Speed" ) ), "DefaultSmall", 70, 110, Color( 255, 255, 255, 255 ) );
		draw.RoundedBox( 2, 70, 120, 150, 10, Color( 0, 0, 0, 255 ) );
		draw.RoundedBox( 2, 71, 121, math.Clamp( 148 * ( GetFloat( "stat.Speed" ) / 100 ), 2, 148 ), 8, Color( 0, 200, 0, 255 ) );
	
		draw.DrawText( "Sprint: " .. math.ceil( GetFloat( "stat.Sprint" ) ), "DefaultSmall", 70, 140, Color( 255, 255, 255, 255 ) );
		draw.RoundedBox( 2, 70, 150, 150, 10, Color( 0, 0, 0, 255 ) );
		draw.RoundedBox( 2, 71, 151, math.Clamp( 148 * ( GetFloat( "stat.Sprint" ) / 100 ), 2, 148 ), 8, Color( 0, 200, 0, 255 ) );
	
		draw.DrawText( "Aim: " .. math.ceil( GetFloat( "stat.Aim" ) ), "DefaultSmall", 70, 170, Color( 255, 255, 255, 255 ) );
		draw.RoundedBox( 2, 70, 180, 150, 10, Color( 0, 0, 0, 255 ) );
		draw.RoundedBox( 2, 71, 181, math.Clamp( 148 * ( GetFloat( "stat.Aim" ) / 100 ), 2, 148 ), 8, Color( 0, 0, 180, 255 ) );
	
		draw.DrawText( "Medic: " .. math.ceil( GetFloat( "stat.Medic" ) ), "DefaultSmall", 70, 200, Color( 255, 255, 255, 255 ) );
		draw.RoundedBox( 2, 70, 210, 150, 10, Color( 0, 0, 0, 255 ) );
		draw.RoundedBox( 2, 71, 211, math.Clamp( 148 * ( GetFloat( "stat.Medic" ) / 100 ), 2, 148 ), 8, Color( 0, 0, 180, 255 ) );
	
		draw.DrawText( "Sneak/Acrobatics: " .. math.ceil( GetFloat( "stat.Sneak" ) ), "DefaultSmall", 70, 230, Color( 255, 255, 255, 255 ) );
		draw.RoundedBox( 2, 70, 240, 150, 10, Color( 0, 0, 0, 255 ) );
		draw.RoundedBox( 2, 71, 241, math.Clamp( 148 * ( GetFloat( "stat.Sneak" ) / 100 ), 2, 148 ), 8, Color( 0, 0, 180, 255 ) );

		draw.DrawText( "Extra Stat Points: " .. GetFloat( "StatPointsRemaining" ), "DefaultSmall", 70, 260, Color( 255, 255, 255, 255 ) );
		draw.RoundedBox( 2, 70, 270, 150, 10, Color( 0, 0, 0, 255 ) );
		draw.RoundedBox( 2, 71, 271, math.Clamp( 148 * ( GetFloat( "StatPointsRemaining" ) / MaxPoints ), 2, 148 ), 8, Color( 0, 0, 180, 255 ) );

	
	end

	MaxPoints = GetFloat( "stat.Strength" ) + GetFloat( "stat.Endurance" ) + GetFloat( "stat.Speed" )
				+ GetFloat( "stat.Sprint" ) + GetFloat( "stat.Aim" ) + GetFloat( "stat.Medic" ) + GetFloat( "stat.Sneak" ) + 15;

	if( CharacterCreatePanel.StatWindow ) then
	
		CharacterCreatePanel.StatWindow:Remove();
		CharacterCreatePanel.StatWindow = nil;
	
	end

	CharacterCreatePanel.StatWindow = vgui.Create( "TacoPanel" );
	CharacterCreatePanel.StatWindow:SetPos( ScrW() / 2 - 150, ScrH() / 2 - 200 );
	CharacterCreatePanel.StatWindow:SetSize( 300, 400 );
	CharacterCreatePanel.StatWindow:SetColor( Color( 60, 60, 60, 255 ) );
	CharacterCreatePanel.StatWindow:SetTitle( "Stat Edit" );	
	CharacterCreatePanel.StatWindow:SetPaintHook( StatPaint );
	CharacterCreatePanel.StatWindow:MakePopup();
	
	local but = CharacterCreatePanel.StatWindow:AddButton( "<", 50, 57, 15, 15 );
	but.Stat = "Strength";
	but:SetCallback( SubtractStat );
	local but = CharacterCreatePanel.StatWindow:AddButton( ">", 225, 57, 15, 15 );
	but.Stat = "Strength";
	but:SetCallback( AddStat );
	
	local but = CharacterCreatePanel.StatWindow:AddButton( "<", 50, 87, 15, 15 );
	but.Stat = "Endurance";
	but:SetCallback( SubtractStat );
	local but = CharacterCreatePanel.StatWindow:AddButton( ">", 225, 87, 15, 15 );
	but.Stat = "Endurance";
	but:SetCallback( AddStat );
	
	local but = CharacterCreatePanel.StatWindow:AddButton( "<", 50, 117, 15, 15 );
	but.Stat = "Speed";
	but:SetCallback( SubtractStat );
	local but = CharacterCreatePanel.StatWindow:AddButton( ">", 225, 117, 15, 15 );
	but.Stat = "Speed";
	but:SetCallback( AddStat );
	
	local but = CharacterCreatePanel.StatWindow:AddButton( "<", 50, 147, 15, 15 );
	but.Stat = "Sprint";
	but:SetCallback( SubtractStat );
	local but = CharacterCreatePanel.StatWindow:AddButton( ">", 225, 147, 15, 15 );
	but.Stat = "Sprint";
	but:SetCallback( AddStat );
	
	local but = CharacterCreatePanel.StatWindow:AddButton( "<", 50, 177, 15, 15 );
	but.Stat = "Aim";
	but:SetCallback( SubtractStat );
	local but = CharacterCreatePanel.StatWindow:AddButton( ">", 225, 177, 15, 15 );
	but.Stat = "Aim";
	but:SetCallback( AddStat );
	
	local but = CharacterCreatePanel.StatWindow:AddButton( "<", 50, 207, 15, 15 );
	but.Stat = "Medic";
	but:SetCallback( SubtractStat );
	local but = CharacterCreatePanel.StatWindow:AddButton( ">", 225, 207, 15, 15 );
	but.Stat = "Medic";
	but:SetCallback( AddStat );
	
	local but = CharacterCreatePanel.StatWindow:AddButton( "<", 50, 237, 15, 15 );
	but.Stat = "Sneak";
	but:SetCallback( SubtractStat );
	local but = CharacterCreatePanel.StatWindow:AddButton( ">", 225, 237, 15, 15 );
	but.Stat = "Sneak";
	but:SetCallback( AddStat );
 end
end

local function FinishCreation()
if( ValidEntity( LocalPlayer() ) ) then
	local name = CharacterCreatePanel.NameLabel:GetValue();
	
	if( string.len( string.gsub( name, " ", "" ) ) <= 4 ) then
	
		local warn = vgui.Create( "TacoFrame" );
		warn:SetTitle( "Name length" );
		warn:SetColor( Color( 30, 30, 30, 255 ) );
		warn:SetPos( ScrW() / 2 - 50, ScrH() / 2 - 45 );
		warn:SetSize( 180, 90 );
		warn:AddLabel( "Name must be atleast 5 characters.", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
		warn:SetVisible( true );
		return;
	
	end
	
	if( not CharacterCreatePanel.ModelIcon ) then
	
		local warn = vgui.Create( "TacoFrame" );
		warn:SetTitle( "Model required" );
		warn:SetColor( Color( 30, 30, 30, 255 ) );
		warn:SetPos( ScrW() / 2 - 50, ScrH() / 2 - 45 );
		warn:SetSize( 160, 90 );
		warn:AddLabel( "Pick your player model.", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
		warn:SetVisible( true );
		return;
	
	end
	
	LocalPlayer():ConCommand( "setname " .. string.gsub( name, "\"", "'" ) .. "\n" );
	LocalPlayer():ConCommand( "rp_setage " .. GetString( "UniqueID" ) .. " " .. CharacterCreatePanel.AgeLabel:GetValue() .. "\n" );
	LocalPlayer():ConCommand( "rp_setrace " .. GetString( "UniqueID" ) .. " \"" .. string.gsub( CharacterCreatePanel.RaceLabel:GetValue(), "\"", "'" ) .. "\"\n" );
	LocalPlayer():ConCommand( "rp_setmodel " .. GetString( "UniqueID" ) .. " " .. ChosenModel .. "\n" );
	LocalPlayer():ConCommand( "rp_setdesc " .. GetString( "UniqueID" ) .. " \"" .. string.gsub( string.gsub( CharacterCreatePanel.DescLabel:GetValue(), "\"", "'" ), "\n", "" ) .. "\"\n" );
	timer.Simple( .5, LocalPlayer().ConCommand, LocalPlayer(), "rp_finishcreate " .. GetString( "UniqueID" ) .. "\n" );

	if( CharacterCreatePanel.ModelWindow ) then
		CharacterCreatePanel.ModelWindow:Remove();
	end

	if( CharacterCreatePanel.StatWindow ) then
		CharacterCreatePanel.StatWindow:Remove();
	end

	local function RemoveCharacterCreatePanel()
		
		CharacterCreatePanel:Remove();
		CharacterCreatePanel = nil;
		
		if( CharacterSelectPanel ) then
			CharacterSelectPanel:Remove();
			CharacterSelectPanel = nil;
		end
		
	end

	RemoveCharacterCreatePanel();

	gui.EnableScreenClicker( false );
	end
end

function CreateCharacterWindow()
if( ValidEntity( LocalPlayer() ) ) then
	PointsLeft = 15;
	
	if( CharacterCreatePanel ) then
		CharacterCreatePanel:Remove();
	end
	
	CharacterCreatePanel = vgui.Create( "TacoPanel" );
	CharacterCreatePanel:SetPos( ScrW() * .2, ScrH() * .2 );
	CharacterCreatePanel:SetSize( ScrW() * .6, ScrH() * .6 );
	CharacterCreatePanel:SetColor( Color( 60, 60, 60, 255 ) );
	CharacterCreatePanel:EnableCloseButton( false );
	CharacterCreatePanel:EnableDragging( false );
	CharacterCreatePanel:SetTitle( "Character Creation" );
	
	CharacterCreatePanel:SetKeyboardInputEnabled( true );
	CharacterCreatePanel:MakePopup();
	
	CharacterCreatePanel:AddLabel( FormatLine( "Not creating a character with a valid serious roleplay name (First, and last name minimum) or using an idiotic/celebrity name will get you banned permanently.", "Default", ScrW() * .6 - 100 ),
									"Default", 2, 2, Color( 255, 0, 0, 255 )  );

	gui.EnableScreenClicker( true );
	
	CharacterCreatePanel:AddLabel( "Character Name: ", "TargetID", 5, 40, Color( 255, 255, 255, 255 ) );
	CharacterCreatePanel.NameLabel = CharacterCreatePanel:AddLabel( "?", "TargetID", 140, 40, Color( 255, 255, 255, 255 ) );
	local but = CharacterCreatePanel:AddButton( "Change Name", ScrW() * .6 - 160, 50, 100, 15 );
	but:SetRoundness( 0 );
	but:SetCallback( SetNameFrame );
	
	CharacterCreatePanel:AddLabel( "Age (Optional): ", "TargetID", 5, 60, Color( 255, 255, 255, 255 ) );
	CharacterCreatePanel.AgeLabel = CharacterCreatePanel:AddLabel( "?", "TargetID", 125, 60, Color( 255, 255, 255, 255 ) );
	local but = CharacterCreatePanel:AddButton( "Change Age", ScrW() * .6 - 160, 70, 100, 15 );
	but:SetRoundness( 0 );
	but:SetCallback( SetAgeFrame );
	
	CharacterCreatePanel:AddLabel( "Race (Optional): ", "TargetID", 5, 80, Color( 255, 255, 255, 255 ) );
	CharacterCreatePanel.RaceLabel = CharacterCreatePanel:AddLabel( "?", "TargetID", 132, 80, Color( 255, 255, 255, 255 ) );
	local but = CharacterCreatePanel:AddButton( "Change Race", ScrW() * .6 - 160, 90, 100, 15 );
	but:SetRoundness( 0 );
	but:SetCallback( SetRaceFrame );
	
	CharacterCreatePanel:AddLabel( "Description (Optional): ", "TargetID", 5, 100, Color( 255, 255, 255, 255 ) );
	CharacterCreatePanel.DescLabel = CharacterCreatePanel:AddLabel( "?", "TargetID", 5, 120, Color( 255, 255, 255, 255 ) );
	local but = CharacterCreatePanel:AddButton( "Change Desc.", ScrW() * .6 - 160, 110, 100, 15 );
	but:SetRoundness( 0 );
	but:SetCallback( SetDescFrame );
	
	CharacterCreatePanel:AddLabel( "Your Look: ", "TargetID", 5, 210, Color( 255, 255, 255, 255 ) );
	local but = CharacterCreatePanel:AddButton( "Change model", ScrW() * .6 - 160, 220, 100, 15 );
	but:SetRoundness( 0 );
	but:SetCallback( CreateModelWindow );
	
	CharacterCreatePanel:AddLabel( "Your Stats: ", "TargetID", 5, 290, Color( 255, 255, 255, 255 ) );
	local but = CharacterCreatePanel:AddButton( "Change stats", ScrW() * .6 - 160, 300, 100, 15 );
	but:SetRoundness( 0 );
	but:SetCallback( SetStatsWindow );
	
	local but = CharacterCreatePanel:AddButton( "OK! I'm Done", ScrW() * .6 - 160, ScrH() * .6 - 45, 100, 15 );
	but:SetRoundness( 0 );
	but:SetCallback( FinishCreation );
	
	CharacterCreatePanel:SetPaintHook( DrawCharacterCreate );
	
	gui.EnableScreenClicker( true );

end
end
usermessage.Hook( "CreateCharacterMenu", CreateCharacterWindow );

function CreateCharacterChooseMenu( msg )
if( ValidEntity( LocalPlayer() ) ) then
	local n = msg:ReadShort();
	local savelist = { }
	
	for j = 1, n do
		
		local savename = msg:ReadString();
		
		if( string.len( savename ) > 3 ) then
	
			table.insert( savelist, savename );
		
		end
		
	end
	
	local function CharacterSelectPanelPaint()

		CharacterSelectPanel:EnableCloseButton( false );
	
	end
	
	if( CharacterSelectPanel ) then
		CharacterSelectPanel:Remove();
	end
	
	CharacterSelectPanel = vgui.Create( "TacoPanel" );
	CharacterSelectPanel:SetPos( ScrW() * .8, ScrH() * .2 );
	CharacterSelectPanel:SetSize( ScrW() * .2, ScrH() * .6 );
	CharacterSelectPanel:SetColor( Color( 60, 60, 60, 255 ) );
	CharacterSelectPanel:SetPaintHook( CharacterSelectPanelPaint );
	CharacterSelectPanel:EnableCloseButton( false );
	CharacterSelectPanel:SetTitle( "Character Selection" );	
	CharacterSelectPanel:MakePopup();
	
	surface.SetFont( "DefaultSmall" );
	
	local function SetCharacter( but )
	
		local name = but.Character;
		LocalPlayer():ConCommand( "rp_choosechar \"" .. name .. "\"\n" );
	
		if( CharacterCreatePanel ) then
		
			if( CharacterCreatePanel.ModelWindow ) then
				CharacterCreatePanel.ModelWindow:Remove();
			end
		
			if( CharacterCreatePanel.StatWindow ) then
				CharacterCreatePanel.StatWindow:Remove();
			end
		
			CharacterCreatePanel:Remove();
			CharacterCreatePanel = nil;
		end
		
		CharacterSelectPanel:Remove();
		CharacterSelectPanel = nil;
		
		gui.EnableScreenClicker( false );
	
	end
	
	for k, v in pairs( savelist ) do
	
		local but = CharacterSelectPanel:AddButton( v, 2, ( k - 1 ) * 20 + 5, surface.GetTextSize( v ) + 20, 15 );
		but:SetRoundness( 0 );
		but.Character = v;
		but:SetCallback( SetCharacter );
		
	end
	end
end
usermessage.Hook( "CreateCharacterChooseMenu", CreateCharacterChooseMenu );