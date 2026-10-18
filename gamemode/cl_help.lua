
if( HelpMenuParent ) then
	HelpMenuParent:Remove();
end

if( HelpMenuContent ) then
	HelpMenuContent:Remove();
end	

if( HelpMenuSide ) then
	HelpMenuSide:Remove();
end	

HelpMenuParent = nil;
HelpMenuContent = nil;
HelpMenuSide = nil;

HelpMenuVisible = false;



function ShowHelp()
if( ValidEntity( LocalPlayer() ) ) then
	HelpMenuVisible = !HelpMenuVisible;
	
	gui.EnableScreenClicker( HelpMenuVisible );
	
	if( HelpMenuVisible ) then
	
		if( not HelpMenuParent ) then
			CreateHelpMenu();
		end
		
		HelpMenuParent:SetVisible( true );
	
	elseif( HelpMenuParent ) then
	
		HelpMenuParent:SetVisible( false );
	
	end
end
end
usermessage.Hook( "ShowHelpMenu", ShowHelp );

local function HelpParentPaint()
if( ValidEntity( LocalPlayer() ) ) then
	if( not ChristmasMod ) then

		draw.DrawText( "Real Time Roleplay", "GModToolName", 2, 2, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "Real Time Roleplay", "GModToolName", 8, 8, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "Real Time Roleplay", "GModToolName", 8, 2, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "Real Time Roleplay", "GModToolName", 2, 8, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "Real Time Roleplay", "GModToolName", 8, 5, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "Real Time Roleplay", "GModToolName", 5, 8, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "Real Time Roleplay", "GModToolName", 5, 5, Color( 255, 255, 255, 255 ) );
	
	else
	
		draw.DrawText( "Happy Holidays!", "GmodToolName", 2, 2, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "Happy Holidays!", "GmodToolName", 8, 8, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "Happy Holidays!", "GmodToolName", 8, 2, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "Happy Holidays!", "GmodToolName", 2, 8, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "Happy Holidays!", "GmodToolName", 8, 5, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "Happy Holidays!", "GmodToolName", 5, 8, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "Happy Holidays!", "GmodToolName", 5, 5, Color( 255, 255, 255, 255 ) );
	
	end
	
	if( ChristmasMod ) then

		surface.SetFont( "GModToolName" );
		local w = surface.GetTextSize( "Happy Holidays!" );
	
		draw.DrawText( "bitch.", "GmodToolSubtitle", w + 22, 19, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "bitch.", "GmodToolSubtitle", w + 28, 25, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "bitch.", "GmodToolSubtitle", w + 28, 19, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "bitch.", "GmodToolSubtitle", w + 22, 25, Color( 0, 0, 0, 128 ) );
		draw.DrawText("bitch.", "GmodToolSubtitle", w + 28, 22, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "bitch.", "GmodToolSubtitle", w + 25, 25, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "bitch.", "GmodToolSubtitle", w + 25, 22, Color( 255, 255, 255, 255 ) );
	
	else
	
		surface.SetFont( "GModToolName" );
		local w = surface.GetTextSize( "TacoScript" );
	
		draw.DrawText( "A Post-Apocalyptic Roleplaying Community", "GModToolSubtitle", w + 162, 19, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "A Post-Apocalyptic Roleplaying Community", "GModToolSubtitle", w + 168, 25, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "A Post-Apocalyptic Roleplaying Community", "GModToolSubtitle", w + 168, 19, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "A Post-Apocalyptic Roleplaying Community", "GModToolSubtitle", w + 162, 25, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "A Post-Apocalyptic Roleplaying Community", "GModToolSubtitle", w + 168, 22, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "A Post-Apocalyptic Roleplaying Community", "GModToolSubtitle", w + 165, 25, Color( 0, 0, 0, 128 ) );
		draw.DrawText( "A Post-Apocalyptic Roleplaying Community", "GModToolSubtitle", w + 165, 22, Color( 255, 255, 255, 255 ) );

	end
end
end

function CreateHelpMenu()
if( ValidEntity( LocalPlayer() ) ) then
	local function close()
	
		ShowHelp();
	
	end

	HelpMenuParent = vgui.Create( "TacoPanel" );
	HelpMenuParent:SetPos( 50, 50 );
	HelpMenuParent:SetSize( ScrW() - 100, ScrH() - 100 );
	HelpMenuParent:SetTitle( "TacoScript Help" );
	HelpMenuParent:SetPaintHook( HelpParentPaint );
	HelpMenuParent:SetCloseEvent( close );
	
	HelpMenuParent.HeaderTall = 80;
	HelpMenuParent.ColWidth = HelpMenuParent:GetWide() * .14;
	HelpMenuParent.Col2Width = HelpMenuParent:GetWide() - HelpMenuParent.ColWidth;
	
	HelpMenuSide = vgui.Create( "TacoPanel", HelpMenuParent );
	HelpMenuSide:SetPos( 0, HelpMenuParent.HeaderTall );
	HelpMenuSide:SetSize( HelpMenuParent.ColWidth + 20, HelpMenuParent:GetTall() );
	HelpMenuSide:SetColor( Color( 30, 30, 30, 255 ) );
	HelpMenuSide:EnableTitle( false );
	HelpMenuSide:EnableCloseButton( false );
	HelpMenuSide:EnableDragging( false );
	HelpMenuSide:EnableFullWindow( true );
	
	CreateHelpContents();
	
	local link = vgui.Create( "TacoLink", HelpMenuSide );
	link:SetPos( 10, 15 );
	link:SetLinkFont( "Default" );
	link:SetLinkText( "Backstory" );
	link.ID = 0;
	link:SetCallback( SetContents );

	local link = vgui.Create( "TacoLink", HelpMenuSide );
	link:SetPos( 10, 30 );
	link:SetLinkFont( "Default" );
	link:SetLinkText( "Rules" );
	link.ID = 1;
	link:SetCallback( SetContents );

	local link = vgui.Create( "TacoLink", HelpMenuSide );
	link:SetPos( 10, 45 );
	link:SetLinkFont( "Default" );
	link:SetLinkText( "Chat Commands" );
	link.ID = 2;
	link:SetCallback( SetContents );
	
	local link = vgui.Create( "TacoLink", HelpMenuSide );
	link:SetPos( 10, 60 );
	link:SetLinkFont( "Default" );
	link:SetLinkText( "Console Commands" );
	link.ID = 3;
	link:SetCallback( SetContents );
	
	local link = vgui.Create( "TacoLink", HelpMenuSide );
	link:SetPos( 10, 75 );
	link:SetLinkFont( "Default" );
	link:SetLinkText( "Getting Credits" );
	link.ID = 4;
	link:SetCallback( SetContents );
	
	local link = vgui.Create( "TacoLink", HelpMenuSide );
	link:SetPos( 10, 90 );
	link:SetLinkFont( "Default" );
	link:SetLinkText( "Business" );
	link.ID = 5;
	link:SetCallback( SetContents );
	
	local link = vgui.Create( "TacoLink", HelpMenuSide );
	link:SetPos( 10, 105 );
	link:SetLinkFont( "Default" );
	link:SetLinkText( "Stats" );
	link.ID = 6;
	link:SetCallback( SetContents );
	
	local link = vgui.Create( "TacoLink", HelpMenuSide );
	link:SetPos( 10, 120 );
	link:SetLinkFont( "Default" );
	link:SetLinkText( "Administration Team" );
	link.ID = 7;
	link:SetCallback( SetContents );
	
	ApplyBasicInfo();
 end
end

function CreateHelpContents()
if( ValidEntity( LocalPlayer() ) ) then
	if( HelpMenuContent ) then
		HelpMenuContent:Remove();
		HelpMenuContent = nil;
	end

	HelpMenuContent = vgui.Create( "TacoPanel", HelpMenuParent );
	HelpMenuContent:SetPos( HelpMenuParent.ColWidth, HelpMenuParent.HeaderTall );
	HelpMenuContent:SetSize( HelpMenuParent.Col2Width, HelpMenuParent:GetTall() );
	HelpMenuContent:EnableTitle( false );
	HelpMenuContent:EnableCloseButton( false );
	HelpMenuContent:EnableDragging( false );
	HelpMenuContent:EnableFullWindow( true );
end
end

function SetContents( link )
if( ValidEntity( LocalPlayer() ) ) then
	local id = link.ID;
	
	CreateHelpContents();
	
	if( id == 0 ) then
		ApplyBasicInfo();
	end
	
	if( id == 1 ) then
		ApplyRules();
	end
	
	if( id == 2 ) then
		ApplyChatCommands();
	end
	
	if( id == 3 ) then
		ApplyConsoleCommands();
	end
	
	if( id == 4 ) then
		ApplyGettingCredits();
	end
	
	if( id == 5 ) then
		ApplyBusiness();
	end
	
	if( id == 6 ) then
		ApplyStats();
	end
	
	if( id == 7 ) then
		ApplyCredits();
	end
	end
end

function ApplyBasicInfo()

	local text = "Backstory:\n\n";
	text = text .. "Real Time Roleplay is a serious roleplaying community, set in the sands of the deserts of Nevada.\n\n";
	text = text .. "The year is 2019. Approximatly 11 years ago, the world as it was known, was destroyed. No one knows exactly who pushed the button first, but when it all came down to it, missiles flied, everyone died. Everyone save for the few lucky (or unlucky) survivors, scattered across the globe. Most everyone who didn't die in the atomic pyre died in the months afterwards. Food shortages, lack of clean water. Looting, rioting where anything resembling government survived, and most of all, blankets of fallout encompassing most of the world's habitable areas.  Its been 11 years since the bombs fell. Ash from the cities of men still falls from the sky on occasion.\n\n";
	text = text .. "In those 11 years, the world has become a dangerous place. Survival for the refugees that managed to outlive the bombs and the irradiation, took on new levels of complexity. Our story takes place in the deserts of Nevada, in what was once the southwestern United States. A small valley, mostly sheltered from the weather patterns that spread the deadly fallout across the globe. The town of Shady Sands sits in there, near to abandoned military facilities and an old mine. It was once a mining town, once a military town.. now its one of the last remaining torches of a feeble human civilization, doing whatever it takes to keep alive..\n\n";
	text = text .. "Survivors of the Great Atomic War have trickled slowly into the valley for years now, gradually restoring the town to a livable place, scratching just enough food and water out of the harsh environment to continue to survive and even slowly grow. A military force, the National Republic Dawn took root in the town, declaring law and order to be the rule of the day, driving out bandits that had plagued the hills surrounding the town.  This gave way to the rise of an armed band, the National Soviet Revolutionary Front, who claim the NRD to be little more than self appointed tyrants, and began a series of raids and attacks, calling for the people to rise up with them, with the NRD in turn calling for the people to resist the NSRF, claiming the NSRF to seek power and wealth at the people's expense.\n\n";
	text = text .. "And so the valley stands on the edge of a return to the chaos immediately following the day the bombs fell. Will you take up the torches of revolution? Will you rise to the call of the defense of the people? The choice is yours.";
	HelpMenuContent:AddLabel( FormatLine( text, "Default", HelpMenuParent.Col2Width - 120 ), "Default", 10, 9, Color( 255, 255, 255, 255 ) );
	
end

function ApplyRules()
if( ValidEntity( LocalPlayer() ) ) then
	local text = "These are the rules.\n\n";
	text = text .. "1) A roleplay name is needed\n2) Phys-gun DMing is bannable\n2b) Dont phys random things\n3) Killing another player for non-rp reasons is kickable, excluding accidents or the like\n4) Overuse of OOC can be kickable or bannable\n5) Building things unrelated to rp isnt allowed, unless permitted by an administrator\n6) Abusing tooltrust can get you banned from the server, temporarily or permanently\n7) Stupid/dumb roleplay can be kickable/bannable\n8) Flaming over public channels is not allowed, and can result in a ban\n9) No crabwalking. Running around crouched is considered an exploit\n10) No metagaming. Keep your IC separate from your OOC\n11) No using web-speak ICly. Take the time to write out the full word\n12) Players who have been given tooltrust are authorized to create a 'mingebox', and use it to isolate the problem player from the rest of the game\n13) Racism and sexually explicit (IE: pornography) material is not allowed. Both are instant permabans.\n\nDetailed rules at realtimeroleplay.com";

	HelpMenuContent:AddLabel( FormatLine( text, "Default", HelpMenuParent.Col2Width - 120 ), "Default", 10, 9, Color( 255, 255, 255, 255 ) );	

end
end

function ApplyChatCommands()
if( ValidEntity( LocalPlayer() ) ) then
	local text = "These commands are typed in chat\n\n";
	text = text .. "// <text> - Speak in OOC (or \"Out-Of-Character\" chat)  This text is global, and not used for RP.  Other OOC prefixes are /a, and ((\n";
	text = text .. "[[ or .// <text> - Speak in local OOC\n";
	text = text .. "/w <text> - Whisper text locally\n";
	text = text .. "/y <text> - Yell text locally\n";
	text = text .. "/an <text> - Talk anonymously locally\n";
	text = text .. "/r <text> - If you have a radio, send a radio message\n";
	text = text .. "/pm <Name< <text> - Send a private message to someone\n";
	text = text .. "/me <text> - Outputs third person text\n\n";
	text = text .. "/adv <text> - Advertise something for 25 credits\n";
	text = text .. "/write - Write a letter, if you have paper\n";
	text = text .. "/title <text> - Set your character title (viewable by other players)\n\n";
	text = text .. "/adddoorowner <Name> - Add an owner to your door\n";
	text = text .. "/removedoorowner <Name> - Remove owner from your door\n";
	text = text .. "/doortitle <text> - Set the name of a door you're looking at (viewable by other players)\n\n";
	text = text .. "/givegun - Give the player you're looking at the gun you're holding\n";
	text = text .. "/dropgun - Drop the current gun you're holding\n\n";
	text = text .. "/givemoney or /givecredits <Amount> - Give a player you're looking at a specified number of credits\n\n";
	text = text .. "/help - Open help menu\n";
	
	HelpMenuContent:AddLabel( FormatLine( text, "Default", HelpMenuParent.Col2Width - 120 ), "Default", 10, 9, Color( 255, 255, 255, 255 ) );	

	surface.SetFont( "Default" );
	local w, h = surface.GetTextSize( text );

	text = "";

	if( LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() ) then
	
		text = text .. "!kick <Name/PartialName> <Reason> - Kick a player\n";
		text = text .. "!ban <Name/PartialName> <Length in minutes> - Ban a player\n";
		text = text .. "!slap <Name/PartialName> - Slap a player\n";
		text = text .. "!slay <Name/PartialName> - Slay a player\n";
		text = text .. "!bring <Name/PartialName> - Bring a player to you\n";
		text = text .. "!goto <Name/PartialName> - Goto a player to you\n";
		text = text .. "!noclip - Noclip yourself\n";
		
	end
	
	text = text .. "!a <Message> - Speak to admins\n";

	HelpMenuContent:AddLabel( FormatLine( text, "Default", HelpMenuParent.Col2Width - 120 ), "Default", 10, 9 + h, Color( 255, 255, 255, 255 ) );	

end
end

function ApplyConsoleCommands()
if( ValidEntity( LocalPlayer() ) ) then
	local text = "These commands are typed in console\n\n";
	text = text .. "rp_headbob <1/0> - Toggle head bobbing\n";
	text = text .. "rp_toggleholster - Holster and unholster your weapon\n";
	text = text .. "rp_changename <name> - Change your current character's name (doesn't create new character)\n";
	text = text .. "setname <name> - Create a new character\n";
	text = text .. "rp_ramdoor - Ram a door, as opposed to pressing with reload with unholstered fists\n";
	text = text .. "rp_listsaves - List all of your current saves\n";
	text = text .. "rp_deletesave <name> - Delete a save.  PUT QUOTATION MARKS AROUND THE NAME\n";
	text = text .. "rp_proplog [Amount of logs] - Retrieve a log of prop spawning.\n";
	text = text .. "rp_toollog [Amount of logs] - Retrieve a log of tool gun actions\n";
	
	if( LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() or LocalPlayer():HasCombineFlag( "E" ) ) then
	
		text = text .. "rp_setfactionflag <Target> <Flags> - Set a player's current Faction flags\n\n";
	
	else
		text = text .. "\n";
	end
	
	text = text .. "gm_showhelp - Show this menu\n";
	text = text .. "gm_showspare1 or F3 - Show your player menu\n";
	text = text .. "gm_showspare2 or F4 - Own properties and doors\n";
	
	HelpMenuContent:AddLabel( FormatLine( text, "Default", HelpMenuParent.Col2Width - 120 ), "Default", 10, 9, Color( 255, 255, 255, 255 ) );	
	
	surface.SetFont( "Default" );
	local w, h = surface.GetTextSize( text );

	text = "";
	
	if( LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() ) then
	
		text = text .. "Admin commands:\n\n";
		text = text .. "rp_name <Target> - Issue name warning\n";
		text = text .. "rp_seeall - See where all players are\n";
		text = text .. "rp_addtooltrust <Target> - Give tool trust\n";
		text = text .. "rp_removetooltrust <Target> - Remove tool trust\n";
		text = text .. "rp_addttsteamid, rp_removettsteamid <SteamID>\n";
		text = text .. "rp_ttlist - Get TT list\n";
		text = text .. "rp_allowtools <1 or 0> - Enable/disable toolgun\n";
		text = text .. "rp_oocdelay <Amount> - Delay OOC in seconds\n";
		text = text .. "rp_cp, rp_ow, rp_ce, rp_ca <Target> - Team commands\n";
		text = text .. "rp_kick <Name/PartialName> <Reason> - Kick a player\n";
		text = text .. "rp_ban <Name/PartialName> <Length in minutes> - Ban a player\n";
		text = text .. "rp_slap <Name/PartialName> - Slap a player\n";
		text = text .. "rp_slay <Name/PartialName> - Slay a player\n";
		text = text .. "rp_bring <Name/PartialName> - Bring a player to you\n";
		text = text .. "rp_goto <Name/PartialName> - Goto a player to you\n";
		text = text .. "rp_physgunban <Name/PartialName> - Ban a player from physgun\n";
		text = text .. "rp_physgununban <Name/PartialName> - Un-Ban a player from physgun\n";
		text = text .. "rp_noclip - Noclip yourself\n";
		text = text .. "rp_restartmap - Restart the map\n";
		
	end
	
	text = text .. "rp_asay <Message> - Speak to admins\n";

	HelpMenuContent:AddLabel( FormatLine( text, "Default", HelpMenuParent.Col2Width - 120 ), "Default", 10, 9 + h, Color( 255, 255, 255, 255 ) );	
 
 	if( LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() ) then
 	
	 	surface.SetFont( "Default" );
		local w, h = surface.GetTextSize( text );
	
		text = "";
		
		text = text .. "rp_findowner - Find owner of door you're looking at\n";
		text = text .. "rp_unowndoor - Unown door you're looking at\n";
		text = text .. "rp_unownproperty - Unown property of the door you're looking at\n";
		
		HelpMenuContent:AddLabel( FormatLine( text, "Default", HelpMenuParent.Col2Width - 120 ), "Default", 300, 9 + h, Color( 255, 255, 255, 255 ) );	
 	
 	end
 
 	
 end
end

function ApplyGettingCredits()
if( ValidEntity( LocalPlayer() ) ) then
	text = "Credits are the form of currency in Shady Sands.  You can get credits by:\n\n";
	text = text .. "1) Having transactions with other players, working for other players and getting paid\n";
	text = text .. "2) Getting supplies from the NRD. Each supply crate contains some food, water, and 50 credits\n";
	text = text .. "3) Creating a business and selling products.\n";
	
	HelpMenuContent:AddLabel( FormatLine( text, "Default", HelpMenuParent.Col2Width - 120 ), "Default", 10, 9, Color( 255, 255, 255, 255 ) );	
end
end

function ApplyBusiness()

	text = "Businesses are a good way of becoming rich, if you know what you're doing.\n\n";
	text = text .. "To create a business:\n";
	text = text .. "1) Open the player menu\n";
	text = text .. "2) Go under the Business tab\n";
	text = text .. "3) Press Create Business\n";
	
	text = text .. "You can purchase a supply license, allowing you to purchase products and sell them\n";

	HelpMenuContent:AddLabel( FormatLine( text, "Default", HelpMenuParent.Col2Width - 120 ), "Default", 10, 9, Color( 255, 255, 255, 255 ) );	


end

function ApplyStats()

	text = "Strength - The amount of damage your punches or any other melee attacks do.  Punching/melee attacking something will increase your strength.\n";
	text = text .. "Speed - The speed at which your character runs.  Running increases this.\n";
	text = text .. "Sprint - How long you can sprint for.  Running increases this.\n";
	text = text .. "Endurance - Your ability to handle damage or regenerate health over time.  Taking damage increases your endurance overtime. (Melee damage only)\n";
	text = text .. "Aim - Your character's ability to aim. Shooting raises this\n";
	text = text .. "Medic - Your character's ability to heal someone.  Healing/bandaging raises this\n";
	text = text .. "Sneak - How agile you are in moving while sneaking. Crouching around while moving raises this.\n\n";
	
	text = text .. "Raising stats will become more difficult as your stat is higher.  At 85 or higher, it will be the most difficult to raise a stat.\n";
	
	HelpMenuContent:AddLabel( FormatLine( text, "Default", HelpMenuParent.Col2Width - 120 ), "Default", 10, 9, Color( 255, 255, 255, 255 ) );	

	

end

function ApplyCredits()

	text = "Original Coder/Developer - Rick Dark\n\n";
	
	text = text .. "RefugeeRP 2.0 Conversion and Modifications - JT\n\n";
	
	text = text .. "Administration Team Members - \n";
	text = text .. "JT - Founder, Community Manager\n\n";
	
	text = text .. "Argus - Global Roleplay Manager\n";
	text = text .. "Chance - Global Roleplay Manager\n";
	text = text .. "Lucky - Global Roleplay Manager\n\n";
	
	text = text .. "Munroe - Head of Administrators\n\n";
	
	text = text .. "Robro - Local Roleplay Administrator\n";
	
	HelpMenuContent:AddLabel( FormatLine( text, "Default", HelpMenuParent.Col2Width - 120 ), "Default", 10, 9, Color( 255, 255, 255, 255 ) );	
	
end
