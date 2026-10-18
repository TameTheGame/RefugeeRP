
PlayerMenuOn = false;

if( PlayerMenuParent ) then 
	PlayerMenuParent:Remove();
end

if( PlayerMenuContent ) then
	PlayerMenuContent:Remove();
end

if( PlayerMenuRadio ) then
	PlayerMenuRadio:Remove();
end

if( PlayerShop ) then
	PlayerShop:Remove();
end

if( CombineRations ) then
	CombineRations:Remove();
end

PlayerMenuParent = nil;
PlayerMenuContent = nil;
PlayerMenuRadio = nil;
PlayerShop = nil;
CombineRations = nil;
CurrentPlayerMenuID = 0;

function ClosePlayerMenu()

	PlayerMenuOn = false;
	GUIClickerCount = GUIClickerCount - 1;
	GUIClickerEnabled = true;
	
	PlayerMenuParent:SetVisible( false );
	
	if( PlayerMenuRadio ) then
		PlayerMenuRadio:SetVisible( false );
		PlayerMenuRadio.FreqEntry:OnKeyCodePressed( 64 );
	end
	
	if( PlayerShop ) then
		PlayerShop:SetVisible( false );
	end
	
	if( CombineRations ) then
		CombineRations:SetVisible( false );
	end
	
	gui.EnableScreenClicker( false );
	
end

function PlayerMenuThink()
if( ValidEntity( LocalPlayer() ) ) then
	if( PlayerMenuOn and PlayerMenuParent and PlayerMenuParent:IsVisible() ) then
	
		if( ( not LocalPlayer():IsCombineDefense() and LocalPlayer():HasItem( "radio" ) ) and not PlayerMenuRadio ) then
		
			CreatePlayerMenuRadio();
			
		end
		
		if( ( LocalPlayer():IsCombineDefense() ) and PlayerMenuRadio ) then
		
			PlayerMenuRadio:Remove();	
			PlayerMenuRadio = nil;
		
		end
		
		if( PlayerMenuRadio and LocalPlayer():HasItem( "radio" ) and not PlayerMenuRadio:IsVisible() ) then
			PlayerMenuRadio:SetVisible( true );
			PlayerMenuRadio.FreqEntry:SetText( math.Round( GetFloat( "radiofreq" ) * 100 ) / 100 );
		end
		
		if( not PlayerShop and string.find( GetString( "businessflags" ), "d" ) ) then
		
			--CreatePlayerShop();
		
		end
		
		if( PlayerShop and not PlayerShop:IsVisible() and string.find( GetString( "businessflags" ), "d" ) ) then
		
			PlayerShop:SetVisible( true );
		
		end
		
		if( PlayerShop and not string.find( GetString( "businessflags" ), "d" ) ) then
		
			PlayerShop:Remove();
			PlayerShop = nil;
			
		end
		
		if( not CombineRations and LocalPlayer():IsCombineDefense() ) then
		
			CreateCombineRations();
		
		end
		
		if( CombineRations and not CombineRations:IsVisible() and LocalPlayer():IsCombineDefense() ) then
		
			CombineRations:SetVisible( true );
		
		end		
		
		if( CombineRations and not LocalPlayer():IsCombineDefense() ) then
		
			CombineRations:Remove();
			CombineRations = nil;
		
		end
	
	end
 end
end
hook.Add( "Think", "PlayerMenuThink", PlayerMenuThink );

function msgTogglePlayerMenu()
if( ValidEntity( LocalPlayer() ) ) then

	PlayerMenuOn = !PlayerMenuOn;
	
	if( PlayerMenuOn ) then
	
		GUIClickerEnabled = true;
		GUIClickerCount = GUIClickerCount + 1;
	
		if( not PlayerMenuParent ) then
		
			CreatePlayerMenuVGUI();
		
		end
		
		InventoryDoneVGUI = false;
		
		PlayerMenuParent:SetVisible( true );
		
		if( CurrentPlayerMenuID == 1 ) then
		
			CreatePlayerMenuContentVGUI();
			CreatePlayerMenuSubContentVGUI( 1 );
		
		end
	
	end

	gui.EnableScreenClicker( GUIClickerEnabled );
 end
end
usermessage.Hook( "TogglePlayerMenu", msgTogglePlayerMenu );

function ChangeMenu( but )

	local id = but.MenuID;
	CurrentPlayerMenuID = id;

	CreatePlayerMenuContentVGUI();
	CreatePlayerMenuSubContentVGUI( id );
	
end

surface.CreateFont( "TargetID", 16, 500, true, false, "SmallTargetID" );

function CreateCombineRations()
if( ValidEntity( LocalPlayer() ) ) then
	local function CombineRationPaint()
	
		surface.SetFont( "DefaultSmall" );
		CombineRations.RationCount:SetText( "Supply Count: " .. GetGlobalInt( "CombineRations" ) );
		CombineRations.RationCount:SetSize( surface.GetTextSize( "Supply Count: " .. GetGlobalInt( "CombineRations" ) ), 25 );
	
	end
	
	local function DropRation()
	
		LocalPlayer():ConCommand( "rp_dropration\n" );
	
	end

	CombineRations = vgui.Create( "TacoPanel" );
	CombineRations:SetPos( 10, 10 );
	CombineRations:SetSize( 220, 75 );
	CombineRations:EnableTitle( false );
	CombineRations:EnableCloseButton( false );
	CombineRations:EnableDragging( false );
	CombineRations:EnableFullWindow( true );	
	CombineRations:SetPaintHook( CombineRationPaint );
	
	local spawn = vgui.Create( "SpawnIcon", CombineRations );
	spawn:SetPos( 5, 5 );
	spawn:SetSize( 64, 64 );
	spawn:SetModel( "models/Items/item_item_crate.mdl" );
	spawn:SetMouseInputEnabled( false );
	
	CombineRations:AddLabel( "Supplies arrive periodically", "DefaultSmall", 75, 5, Color( 255, 255, 255, 255 ) );

	CombineRations.RationCount = CombineRations:AddLabel( "", "DefaultSmall", 75, 15, Color( 255, 255, 255, 255 ) );

	local but = CombineRations:AddButton( "Drop", 75, 45, 35, 15 );
	but:SetCallback( DropRation );
	but:SetRoundness( 0 );
	end
end

function CreatePlayerMenuSubContentVGUI( id )
if( ValidEntity( LocalPlayer() ) ) then
	InventoryDoneVGUI = false;

	if( id == 0 ) then
	
		PlayerMenuParent:SetTitle( "Player Menu - Stats" );
	
		PlayerMenuContent:SetPaintHook( RenderStatsMenu );
		PlayerMenuContent:AddLabel( "Physical Stats", "TargetID", 5, 5, Color( 255, 255, 255, 255 ) );
		
		PlayerMenuContent:AddLabel( "Strength - How strong you are", "DefaultSmall", 10, 35, Color( 255, 255, 255, 255 ) );
		PlayerMenuContent.StrengthNum = PlayerMenuContent:AddLabel( "", "DefaultSmall", 165, 55, Color( 255, 255, 255, 255 ) );
		
		PlayerMenuContent:AddLabel( "Endurance - How much damage you can withstand, and your health amount", "DefaultSmall", 10, 75, Color( 255, 255, 255, 255 ) );
		PlayerMenuContent.EnduranceNum = PlayerMenuContent:AddLabel( "", "DefaultSmall", 165, 95, Color( 255, 255, 255, 255 ) );
		
		PlayerMenuContent:AddLabel( "Speed - How fast you are", "DefaultSmall", 10, 115, Color( 255, 255, 255, 255 ) );		
		PlayerMenuContent.SpeedNum = PlayerMenuContent:AddLabel( "", "DefaultSmall", 165, 135, Color( 255, 255, 255, 255 ) );
		
		PlayerMenuContent:AddLabel( "Sprint - How long you can run", "DefaultSmall", 10, 155, Color( 255, 255, 255, 255 ) );		
		PlayerMenuContent.SprintNum = PlayerMenuContent:AddLabel( "", "DefaultSmall", 165, 175, Color( 255, 255, 255, 255 ) );
				
		PlayerMenuContent:AddLabel( "Skill Stats", "TargetID", 5, 200, Color( 255, 255, 255, 255 ) );
			
		PlayerMenuContent:AddLabel( "Aim - How well you aim", "DefaultSmall", 10, 230, Color( 255, 255, 255, 255 ) );
		PlayerMenuContent.AimNum = PlayerMenuContent:AddLabel( "", "DefaultSmall", 165, 250, Color( 255, 255, 255, 255 ) );
		
		PlayerMenuContent:AddLabel( "Medic - Your ability to heal people", "DefaultSmall", 10, 270, Color( 255, 255, 255, 255 ) );
		PlayerMenuContent.MedicNum = PlayerMenuContent:AddLabel( "", "DefaultSmall", 165, 290, Color( 255, 255, 255, 255 ) );
		
		PlayerMenuContent:AddLabel( "Sneak/Acrobatics - How quickly and well you can move around", "DefaultSmall", 10, 310, Color( 255, 255, 255, 255 ) );	
		PlayerMenuContent.SneakNum = PlayerMenuContent:AddLabel( "", "DefaultSmall", 165, 330, Color( 255, 255, 255, 255 ) );
			
	elseif( id == 1 ) then
	
		PlayerMenuParent:SetTitle( "Player Menu - Inventory" );
		PlayerMenuContent:SetPaintHook( RenderInventory );
		
		PlayerMenuContent:AddLabel( "Inventory", "TargetID", 5, 1, Color( 255, 255, 255, 255 ) );
		PlayerMenuContent.SpaceNum = PlayerMenuContent:AddLabel( "", "SubTitle", 5, 30, Color( 255, 255, 255, 255 ) );
		
		PlayerMenuContent.CrntSpaceNum = PlayerMenuContent:AddLabel( "", "SubTitle", 5, 45, Color( 255, 255, 255, 255 ) );
		
		PlayerMenuContent:AddScrollBar();
		PlayerMenuContent:SetMaxScroll( 0 );
		
		PlayerMenuContent.InventoryNameLabel = { }
		PlayerMenuContent.InventoryAmountLabel = { }
		PlayerMenuContent.InventorySizeLabel = { }
		PlayerMenuContent.InventoryWeightLabel = { }
		PlayerMenuContent.InventoryDescLabel = { }
		PlayerMenuContent.InventoryDropButton = { }
		PlayerMenuContent.InventoryRebelDropButton = { }
		PlayerMenuContent.InventoryUseButton = { }
		PlayerMenuContent.InventoryIcon = { }
		
		BuildInventoryVGUI();
		
	--[[elseif( id == 2 ) then
	
		PlayerMenuParent:SetTitle( "Player Menu - Finance" );
		PlayerMenuContent:SetPaintHook( RenderFinance );
		
		PlayerMenuContent:AddLabel( "Finance", "TargetID", 5, 1, Color( 255, 255, 255, 255 ) );
		
		PlayerMenuContent:AddLabel( "Getting loans is a good way of getting some money when you're just starting out.  Remember to pay your loans back,\nor the Combine will make you pay it back.", "DefaultSmall", 5, 180, Color( 255, 255, 255, 255 ) );
		
		function CreateLoanPayFrame()
		
			local function PayLoan( pnl, val )
			
				LocalPlayer():ConCommand( "rp_payloan " .. val .. "\n" );
				PlayerMenuContent.PayLoanFrame:Remove();
				
			end
		
			PlayerMenuContent.PayLoanFrame = vgui.Create( "TacoFrame" );
			PlayerMenuContent.PayLoanFrame:SetTitle( "Pay A Loan" );
			PlayerMenuContent.PayLoanFrame:SetPos( ScrW() / 2 - 50, ScrH() / 2 - 45 );
			PlayerMenuContent.PayLoanFrame:SetSize( 100, 90 );
			PlayerMenuContent.PayLoanFrame:AddLabel( "Amount to pay:", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
			PlayerMenuContent.PayLoanFrame.Entry = PlayerMenuContent.PayLoanFrame:AddEntry( PayLoan, 5, 55, 100 );
			PlayerMenuContent.PayLoanFrame:SetVisible( true );
			
		end
		
		function CreateLoanFrame()
		
			local function TakeLoan( pnl, val )
			
				LocalPlayer():ConCommand( "rp_takeloan " .. val .. "\n" );
				PlayerMenuContent.LoanFrame:Remove();
				
			end
		
			PlayerMenuContent.LoanFrame = vgui.Create( "TacoFrame" );
			PlayerMenuContent.LoanFrame:SetTitle( "Take A Loan" );
			PlayerMenuContent.LoanFrame:SetPos( ScrW() / 2 - 50, ScrH() / 2 - 45 );
			PlayerMenuContent.LoanFrame:SetSize( 100, 90 );
			PlayerMenuContent.LoanFrame:AddLabel( "Amount of loan:", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
			PlayerMenuContent.LoanFrame.Entry = PlayerMenuContent.LoanFrame:AddEntry( TakeLoan, 5, 55, 100 );
			PlayerMenuContent.LoanFrame:SetVisible( true );
			
		end
		
		PlayerMenuContent.LoanButton = PlayerMenuContent:AddButton( "Take Loan", 5, 110, 60, 18 );
		PlayerMenuContent.LoanButton:SetRoundness( 0 );
		PlayerMenuContent.LoanButton:SetCallback( CreateLoanFrame );
		
		PlayerMenuContent.LoanButton = PlayerMenuContent:AddButton( "Pay Loan", 5, 140, 60, 18 );
		PlayerMenuContent.LoanButton:SetRoundness( 0 );
		PlayerMenuContent.LoanButton:SetCallback( CreateLoanPayFrame );--]]
		
	elseif( id == 3 ) then
	
		PlayerMenuParent:SetTitle( "Player Menu - Biography" );
		PlayerMenuContent:SetPaintHook( RenderBiography );
		
		PlayerMenuContent.BioIcon = vgui.Create( "SpawnIcon", PlayerMenuContent );
		PlayerMenuContent.BioIcon.Model = LocalPlayer():GetModel();
		PlayerMenuContent.BioIcon:SetModel( LocalPlayer():GetModel() );
		PlayerMenuContent.BioIcon:SetPos( 5, 1 );
		PlayerMenuContent.BioIcon:SetSize( 64, 64 );
		PlayerMenuContent.BioIcon:SetMouseInputEnabled( false );
		
		PlayerMenuContent.NameLabel = PlayerMenuContent:AddLabel( LocalPlayer():Nick(), "TargetID", 70, 1, Color( 255, 255, 255, 255 ) );
		PlayerMenuContent.AgeLabel = PlayerMenuContent:AddLabel( "Age: " .. GetString( "info.Age" ), "SmallTargetID", 70, 24, Color( 255, 255, 255, 255 ) );
		PlayerMenuContent.RaceLabel = PlayerMenuContent:AddLabel( "Race: " .. GetString( "info.Race" ), "SmallTargetID", 70, 41, Color( 255, 255, 255, 255 ) );
		PlayerMenuContent.BioLabel = PlayerMenuContent:AddLabel( "Information: " .. GetString( "info.Bio" ), "SmallTargetID", 5, 68, Color( 255, 255, 255, 255 ) );
		
		local function SetAgeFrame()
	
			if( PlayerMenuContent.AgeFrame ) then
				PlayerMenuContent.AgeFrame:Remove();
				PlayerMenuContent.AgeFrame = nil;
			end
	
			local function SetAge( pnl, val )
			
				if( tonumber( val ) and tonumber( val ) >= 16 and tonumber( val ) <= 65 ) then
			
					surface.SetFont( "TargetID" );
				
					PlayerMenuContent.AgeLabel:SetText( "Age: " .. val );
					LocalPlayer():ConCommand( "rp_setage " .. GetString( "UniqueID" ) .. " " .. val .. "\n" );
					PlayerMenuContent.AgeLabel:SetSize( surface.GetTextSize( "Age: " .. val ), 25 );
					PlayerMenuContent.AgeFrame:Remove();
					PlayerMenuContent.AgeFrame = nil;
					
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
			
			PlayerMenuContent.AgeFrame = vgui.Create( "TacoFrame" );
			PlayerMenuContent.AgeFrame:SetTitle( "Set Character Age" );
			PlayerMenuContent.AgeFrame:SetColor( Color( 30, 30, 30, 255 ) );
			PlayerMenuContent.AgeFrame:SetPos( ScrW() / 2 - 50, ScrH() / 2 - 45 );
			PlayerMenuContent.AgeFrame:SetSize( 160, 90 );
			PlayerMenuContent.AgeFrame:AddLabel( "Age:", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
			PlayerMenuContent.AgeFrame.Entry = PlayerMenuContent.AgeFrame:AddEntry( SetAge, 5, 55, 100 );
			PlayerMenuContent.AgeFrame:SetVisible( true );
		
		end
		
		PlayerMenuContent.AgeButton = PlayerMenuContent:AddButton( "Edit Age", 500, 24, 60, 20 );
		PlayerMenuContent.AgeButton:SetRoundness( 0 );
		PlayerMenuContent.AgeButton:SetCallback( SetAgeFrame );
		
		local function SetRaceFrame()
	
			if( PlayerMenuContent.RaceFrame ) then
				PlayerMenuContent.RaceFrame:Remove();
				PlayerMenuContent.RaceFrame = nil;
			end
	
			local function SetRace( pnl, val )
			
				surface.SetFont( "TargetID" );
			
				PlayerMenuContent.RaceLabel:SetText( "Race: " .. val );
				LocalPlayer():ConCommand( "rp_setrace " .. GetString( "UniqueID" ) .. " " .. val .. "\n" );
				PlayerMenuContent.RaceLabel:SetSize( surface.GetTextSize( "Race: " .. val ), 25 );
				PlayerMenuContent.RaceFrame:Remove();
				PlayerMenuContent.RaceFrame = nil;
				
			end
			
			PlayerMenuContent.RaceFrame = vgui.Create( "TacoFrame" );
			PlayerMenuContent.RaceFrame:SetTitle( "Set Character Race" );
			PlayerMenuContent.RaceFrame:SetColor( Color( 30, 30, 30, 255 ) );
			PlayerMenuContent.RaceFrame:SetPos( ScrW() / 2 - 50, ScrH() / 2 - 45 );
			PlayerMenuContent.RaceFrame:SetSize( 160, 90 );
			PlayerMenuContent.RaceFrame:AddLabel( "Race:", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
			PlayerMenuContent.RaceFrame.Entry = PlayerMenuContent.RaceFrame:AddEntry( SetRace, 5, 55, 100 );
			PlayerMenuContent.RaceFrame:SetVisible( true );
		
		end
		
		PlayerMenuContent.RaceButton = PlayerMenuContent:AddButton( "Edit Race", 500, 50, 60, 20 );
		PlayerMenuContent.RaceButton:SetRoundness( 0 );
		PlayerMenuContent.RaceButton:SetCallback( SetRaceFrame );
		
		local function DescFrame()
		
			if( PlayerMenuContent.DescFrame ) then
				PlayerMenuContent.DescFrame:Remove();
				PlayerMenuContent.DescFrame = nil;
			end
		
			local function SetDesc( pnl, val )
			
				if( string.len( PlayerMenuContent.DescFrame.Entry:GetValue() ) <= 100 ) then
			
					surface.SetFont( "TargetID" );
		
					PlayerMenuContent:RemoveLabel( PlayerMenuContent.BioLabel );
					PlayerMenuContent.BioLabel = PlayerMenuContent:AddLabel( FormatLine( string.gsub(  "Information: " .. PlayerMenuContent.DescFrame.Entry:GetValue(), "\n", "" ), "TargetID", 450 ), "SmallTargetID", 5, 68, Color( 255, 255, 255, 255 ) );
					LocalPlayer():ConCommand( "rp_setdesc " .. GetString( "UniqueID" ) .. " \"" .. PlayerMenuContent.DescFrame.Entry:GetValue() .. "\"\n" );
					PlayerMenuContent.DescFrame:Remove();
					PlayerMenuContent.DescFrame = nil;
						
				else
				
					local warn = vgui.Create( "TacoFrame" );
					warn:SetTitle( string.len( PlayerMenuContent.DescFrame.Entry:GetValue() ) .. " characters long" );
					warn:SetColor( Color( 30, 30, 30, 255 ) );
					warn:SetPos( ScrW() / 2 - 50, ScrH() / 2 - 45 );
					warn:SetSize( 160, 90 );
					warn:AddLabel( "Description must be under 100 characters", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
					warn:SetVisible( true );
				
				end
				
			end
			
			PlayerMenuContent.DescFrame = vgui.Create( "TacoFrame" );
			PlayerMenuContent.DescFrame:SetTitle( "Set Character Description" );
			PlayerMenuContent.DescFrame:SetColor( Color( 30, 30, 30, 255 ) );
			PlayerMenuContent.DescFrame:SetPos( ScrW() / 2 - 100, ScrH() / 2 - 117 );
			PlayerMenuContent.DescFrame:SetSize( 200, 235 );
			PlayerMenuContent.DescFrame:AddLabel( "Description (must be under 101 characters):", "DefaultSmall", 5, -70, Color( 255, 255, 255, 255 ) );
			PlayerMenuContent.DescFrame.Entry = PlayerMenuContent.DescFrame:AddMultilineEntry( SetDesc, 5, 60, 170, 130 );
			PlayerMenuContent.DescFrame:SetVisible( true );
		
			local but = vgui.Create( "TacoButton", PlayerMenuContent.DescFrame );
			but:SetText( "Done" );
			but:SetPos( 5, 200 );
			but:SetSize( 50, 15 );
			but:SetRoundness( 0 );
			but:SetCallback( SetDesc );
			
		end
		
		PlayerMenuContent.DescButton = PlayerMenuContent:AddButton( "Edit Bio", 500, 75, 60, 20 );
		PlayerMenuContent.DescButton:SetRoundness( 0 );
		PlayerMenuContent.DescButton:SetCallback( DescFrame );		
	
	elseif( id == 4 ) then
	
		PlayerMenuParent:SetTitle( "Player Menu - Workshop" );
		PlayerMenuContent:SetPaintHook( RenderWorkshop );
		
		local function AddItem()
		
			PlayerMenuContent.AddItemMenu = vgui.Create( "TacoPanel" );			
			PlayerMenuContent.AddItemMenu:SetPos( ScrW() / 2 - 100, ScrH() / 2 - 150 );
			PlayerMenuContent.AddItemMenu:SetSize( 200, 300 );
			PlayerMenuContent.AddItemMenu:SetTitle( "Add an item (Click name)" );
			PlayerMenuContent.AddItemMenu:MakePopup();
			
			PlayerMenuContent.AddItemPane = vgui.Create( "TacoPanel", PlayerMenuContent.AddItemMenu );
			PlayerMenuContent.AddItemPane:SetPos( 5, 25 );
			PlayerMenuContent.AddItemPane:SetSize( 190, 270 );
			PlayerMenuContent.AddItemPane:SetColor( Color( 30, 30, 30, 255 ) );
			PlayerMenuContent.AddItemPane:TurnIntoChild();
					
			PopulateAddItemPane();
		
		end
		
		local function AddTool()
		
		end
		
		local function RemoveTool()
		
		end
		
		local function CombineItems()
		
		end
		
		local function MoveRight()
		
		end
		
		local function MoveLeft()
		
		end
		
		PlayerMenuContent.AddItem = PlayerMenuContent:AddButton( "Combine Items", PlayerMenuContent:GetWide() / 2 + 25, 10, 100, 20 );
		PlayerMenuContent.AddItem:SetRoundness( 0 );
		PlayerMenuContent.AddItem:SetCallback( CombineItems );
		
		PlayerMenuContent.AddItem = PlayerMenuContent:AddButton( "Add Item", 20, 10, 100, 20 );
		PlayerMenuContent.AddItem:SetRoundness( 0 );
		PlayerMenuContent.AddItem:SetCallback( AddItem );
		--[[
		PlayerMenuContent.AddItem = PlayerMenuContent:AddButton( "Remove Item", 130, 10, 100, 20 );
		PlayerMenuContent.AddItem:SetRoundness( 0 );
		PlayerMenuContent.AddItem:SetCallback( RemoveItem );
		]]--
		PlayerMenuContent.AddItem = PlayerMenuContent:AddButton( "Add Tool", PlayerMenuContent:GetWide() / 2 + 25, 140, 100, 20 );
		PlayerMenuContent.AddItem:SetRoundness( 0 );
		PlayerMenuContent.AddItem:SetCallback( AddTool );
		
		PlayerMenuContent.AddItem = PlayerMenuContent:AddButton( "Remove Tool", PlayerMenuContent:GetWide() / 2 + 135, 140, 100, 20 );
		PlayerMenuContent.AddItem:SetRoundness( 0 );
		PlayerMenuContent.AddItem:SetCallback( RemoveTool );
		
		--[[
		PlayerMenuContent.AddItem = PlayerMenuContent:AddButton( ">", PlayerMenuContent:GetWide() / 2 - 12, 40, 20, 20 );
		PlayerMenuContent.AddItem:SetRoundness( 0 );
		PlayerMenuContent.AddItem:SetCallback( MoveRight );

		PlayerMenuContent.AddItem = PlayerMenuContent:AddButton( "<", PlayerMenuContent:GetWide() / 2 - 12, 65, 20, 20 );
		PlayerMenuContent.AddItem:SetRoundness( 0 );
		PlayerMenuContent.AddItem:SetCallback( MoveLeft );
]]--
		PlayerMenuContent.Pane1 = vgui.Create( "TacoPanel", PlayerMenuContent );
		PlayerMenuContent.Pane1:SetPos( 20, 40 );
		PlayerMenuContent.Pane1:SetSize( PlayerMenuContent:GetWide() / 2 - 35, PlayerMenuContent:GetTall() - 50 );
		PlayerMenuContent.Pane1:SetColor( Color( 30, 30, 30, 255 ) );
		PlayerMenuContent.Pane1:TurnIntoChild();
		
		if( not PlayerMenuContent.Pane1.Item ) then
			PlayerMenuContent.Pane1.Item = { }
			PlayerMenuContent.Pane1.ItemCount = 0;
		end
		
		PlayerMenuContent.Pane2 = vgui.Create( "TacoPanel", PlayerMenuContent );
		PlayerMenuContent.Pane2:SetPos( PlayerMenuContent:GetWide() / 2 + 15, 40 );
		PlayerMenuContent.Pane2:SetSize( PlayerMenuContent:GetWide() / 2 - 35, 64 );
		PlayerMenuContent.Pane2:SetColor( Color( 30, 30, 30, 255 ) );
		PlayerMenuContent.Pane2:TurnIntoChild();
		
		PlayerMenuContent.ToolPane = vgui.Create( "TacoPanel", PlayerMenuContent );
		PlayerMenuContent.ToolPane:SetPos( PlayerMenuContent:GetWide() / 2 + 15, 170 );
		PlayerMenuContent.ToolPane:SetSize( PlayerMenuContent:GetWide() / 2 - 35, 189 );
		PlayerMenuContent.ToolPane:SetColor( Color( 30, 30, 30, 255 ) );
		PlayerMenuContent.ToolPane:TurnIntoChild();
		
		DoWorkshopPane1();
		
	elseif( id == 5 ) then
	
		PlayerMenuParent:SetTitle( "Player Menu - Business" );
		PlayerMenuContent:SetPaintHook( RenderBusiness );
	
		local function CreateBusinessVGUI()
		
			local function GiveMoneyFrame()
			
				local function GiveMoney( pnl, var )
				
					LocalPlayer():ConCommand( "rp_givebusinessmoney " .. var .. "\n" );
					PlayerMenuContent.GiveFrame:Remove();
					
				end
			
				PlayerMenuContent.GiveFrame = vgui.Create( "TacoFrame" );
				PlayerMenuContent.GiveFrame:SetTitle( "Give Money" );
				PlayerMenuContent.GiveFrame:SetPos( ScrW() / 2 - 50, ScrH() / 2 - 45 );
				PlayerMenuContent.GiveFrame:SetSize( 160, 90 );
				PlayerMenuContent.GiveFrame:AddLabel( "Amount to give to business:", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
				PlayerMenuContent.GiveFrame.Entry = PlayerMenuContent.GiveFrame:AddEntry( GiveMoney, 5, 55, 100 );
				PlayerMenuContent.GiveFrame:SetVisible( true );

			end
			
			local function TakeMoneyFrame( pnl, val )

				local function TakeMoney( pnl, var )
				
					LocalPlayer():ConCommand( "rp_takebusinessmoney " .. var .. "\n" );
					PlayerMenuContent.TakeFrame:Remove();
					
				end
			
				PlayerMenuContent.TakeFrame = vgui.Create( "TacoFrame" );
				PlayerMenuContent.TakeFrame:SetTitle( "Take Money" );
				PlayerMenuContent.TakeFrame:SetPos( ScrW() / 2 - 50, ScrH() / 2 - 45 );
				PlayerMenuContent.TakeFrame:SetSize( 160, 90 );
				PlayerMenuContent.TakeFrame:AddLabel( "Amount to take from business:", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
				PlayerMenuContent.TakeFrame.Entry = PlayerMenuContent.TakeFrame:AddEntry( TakeMoney, 5, 55, 100 );
				PlayerMenuContent.TakeFrame:SetVisible( true );
				
			end
			
			local function ChangeJobFrame( pnl, val )
	
				local function ChangeJob( pnl, val )
				
					LocalPlayer():ConCommand( "rp_setjobtitle \"" .. string.gsub( val, "\"", "'" ) .. "\"\n" );
					PlayerMenuContent.ChangeJob:Remove();
				
				end
	
				PlayerMenuContent.ChangeJob = vgui.Create( "TacoFrame" );
				PlayerMenuContent.ChangeJob:SetTitle( "Set Job Title" );
				PlayerMenuContent.ChangeJob:SetPos( ScrW() / 2 - 50, ScrH() / 2 - 45 );
				PlayerMenuContent.ChangeJob:SetSize( 140, 90 );
				PlayerMenuContent.ChangeJob:AddLabel( "New Job Name:", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
				PlayerMenuContent.ChangeJob.Entry = PlayerMenuContent.ChangeJob:AddEntry( ChangeJob, 5, 55, 100 );
				PlayerMenuContent.ChangeJob.Entry:SetText( GetString( "job" ) );
				PlayerMenuContent.ChangeJob:SetVisible( true );
			
			end
			
			local function ChangeBusinessNameFrame( pnl, val )
			
				local function ChangeName( pnl, val )
				
					LocalPlayer():ConCommand( "rp_setbusinessname \"" .. string.gsub( val, "\"", "'" ) .. "\"\n" );
					PlayerMenuContent.ChangeName:Remove();
					
				end
			
				PlayerMenuContent.ChangeName = vgui.Create( "TacoFrame" );
				PlayerMenuContent.ChangeName:SetTitle( "Set Business Name" );
				PlayerMenuContent.ChangeName:SetPos( ScrW() / 2 - 50, ScrH() / 2 - 45 );
				PlayerMenuContent.ChangeName:SetSize( 140, 90 );
				PlayerMenuContent.ChangeName:AddLabel( "New Name:", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
				PlayerMenuContent.ChangeName.Entry = PlayerMenuContent.ChangeName:AddEntry( ChangeName, 5, 55, 100 );
				PlayerMenuContent.ChangeName.Entry:SetText( GetGlobalString( "business." .. GetInt( "businessid" ) .. ".businessname" ) );
				PlayerMenuContent.ChangeName:SetVisible( true );
			
			end
			
			
			local function BuySuppliesWindow()
						
				local function BuyItem( but )
				
					local id = but.ID;
					local index = but.Index;
					
					if( GetGlobalFloat( "business." .. GetInt( "businessid" ) .. ".bankamount" ) - StoreItems[index].StockPrice < 0 ) then
					
						local warn = vgui.Create( "TacoFrame" );
						warn:SetTitle( "Not enough money" );
						warn:SetPos( ScrW() / 2 - 50, ScrH() / 2 - 45 );
						warn:SetSize( 160, 90 );
						warn:AddLabel( "Your business does not have\nenough money to purchase this", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
						warn:SetVisible( true );
					
						return;
					
					end
					
					LocalPlayer():ConCommand( "rp_businesspurchase " .. id .. "\n" );
					
				end
				
				local function RebelBuyItem( but )

					local id = but.ID;
					local index = but.Index;
					
					LocalPlayer():ConCommand( "rp_rebelpurchase " .. id .. "\n" );
						
				
				end
						
				local function SuppliesWindowPaint()
				
					if( PlayerMenuContent ) then
				
						surface.SetFont( "DefaultSmall" );
						
						PlayerMenuContent.SuppliesWindow.BankAmount:SetText( "Current Business Bank Amount: $" .. GetGlobalFloat( "business." .. GetInt( "businessid" ) .. ".bankamount" ) );
						PlayerMenuContent.SuppliesWindow.BankAmount:SetSize( surface.GetTextSize( "Current Business Bank Amount: $" .. GetGlobalFloat( "business." .. GetInt( "businessid" ) .. ".bankamount" ) ), 25 );
							
					end
					
					for k, v in pairs( StoreItems ) do
					
						surface.SetFont( "DefaultSmall" );
						
						local additem = true;
						
						if( v.BlackMarket and not LocalPlayer():HasPlayerFlag( "X" ) ) then
							additem = false;
						end
						
						if( v.ID == "newspaper" and not LocalPlayer():HasPlayerFlag( "N" ) ) then
							additem = false;
						end
						
						if( v.SupplyLicense > 0 and TS.GetBusinessInt( GetInt( "businessid" ), "haslicense." .. v.SupplyLicense ) ~= 1 ) then
						
							additem = false;
						
						end
						
						if( additem ) then
						--[[
							PlayerMenuContent.SuppliesWindowContent.CrntStockLabels[k]:SetText( TS.GetBusinessStock( GetInt( "businessid" ), v.ID ) or 0 );
							PlayerMenuContent.SuppliesWindowContent.CrntStockLabels[k]:SetSize( surface.GetTextSize( TS.GetBusinessStock( GetInt( "businessid" ), v.ID ) or 0 ), 25 );
						]]--
						end
							
					end
						
				end
						
				PlayerMenuContent.SuppliesWindow = vgui.Create( "TacoPanel" );
				PlayerMenuContent.SuppliesWindow:SetSize( 600, 500 );
				PlayerMenuContent.SuppliesWindow:SetPos( ScrW() / 2 - 300, ScrH() / 2 - 250 );
				PlayerMenuContent.SuppliesWindow:SetTitle( "Buy Supplies" );
				PlayerMenuContent.SuppliesWindow:SetPaintHook( SuppliesWindowPaint );
				
				PlayerMenuContent.SuppliesWindow.BankAmount = PlayerMenuContent.SuppliesWindow:AddLabel( "", "DefaultSmall", 5, 5, Color( 255, 255, 255, 255 ) );
				
				PlayerMenuContent.SuppliesWindow:MakePopup();
				
				PlayerMenuContent.SuppliesWindowContent = vgui.Create( "TacoPanel", PlayerMenuContent.SuppliesWindow );
				PlayerMenuContent.SuppliesWindowContent:SetPos( 5, 60 );
				PlayerMenuContent.SuppliesWindowContent:SetSize( 590, 430 );
				PlayerMenuContent.SuppliesWindowContent:EnableTitle( false );
				PlayerMenuContent.SuppliesWindowContent:EnableCloseButton( false );
				PlayerMenuContent.SuppliesWindowContent:EnableDragging( false );
				PlayerMenuContent.SuppliesWindowContent:EnableFullWindow( true );
				PlayerMenuContent.SuppliesWindowContent:SetColor( Color( 50, 50, 50, 255 ) );
				PlayerMenuContent.SuppliesWindowContent:AddScrollBar();
				PlayerMenuContent.SuppliesWindowContent:SetMaxScroll( 0 );
					
				PlayerMenuContent.SuppliesWindowContent.NameLabel = PlayerMenuContent.SuppliesWindowContent:AddLabel( "Name", "DefaultSmall", 70, 1, Color( 255, 255, 255, 255 ) );
				PlayerMenuContent.SuppliesWindowContent.PriceLabel = PlayerMenuContent.SuppliesWindowContent:AddLabel( "Price", "DefaultSmall", 235, 1, Color( 255, 255, 255, 255 ) );
				PlayerMenuContent.SuppliesWindowContent.StockLabel = PlayerMenuContent.SuppliesWindowContent:AddLabel( "Number of Items per Stock", "DefaultSmall", 335, 1, Color( 255, 255, 255, 255 ) );
				PlayerMenuContent.SuppliesWindowContent.CrntStockLabel = PlayerMenuContent.SuppliesWindowContent:AddLabel( "Current Amount", "DefaultSmall", 465, 1, Color( 255, 255, 255, 255 ) );
				
				PlayerMenuContent.SuppliesWindowContent.StockLabel:SetVisible( false );
				PlayerMenuContent.SuppliesWindowContent.CrntStockLabel:SetVisible( false );
																				
				PlayerMenuContent.SuppliesWindowContent.SpawnIcons = { }
				PlayerMenuContent.SuppliesWindowContent.NameLabels = { }
				PlayerMenuContent.SuppliesWindowContent.DescLabels = { }
				PlayerMenuContent.SuppliesWindowContent.PriceLabels = { }
				PlayerMenuContent.SuppliesWindowContent.StockLabels = { }
				PlayerMenuContent.SuppliesWindowContent.CrntStockLabels = { }
				PlayerMenuContent.SuppliesWindowContent.BMCostLabels = { }
				
				local n = 1;
							
				for k, v in pairs( StoreItems ) do
			
					local additem = true;
				
					if( v.BlackMarket and not LocalPlayer():HasPlayerFlag( "X" ) ) then
					
						additem = false;
					end

					if( v.SupplyLicense > 0 and TS.GetBusinessInt( GetInt( "businessid" ), "haslicense." .. v.SupplyLicense ) ~= 1 ) then

						additem = false;
					
					end
					
					if( v.ID == "newspaper" and not LocalPlayer():HasPlayerFlag( "N" ) ) then
			
						additem = false;
					
					end
						

					if( additem ) then

						local x = 5;
						local y = 85 * ( n - 1 ) + 15;
						
						PlayerMenuContent.SuppliesWindowContent.SpawnIcons[k] = vgui.Create( "SpawnIcon", PlayerMenuContent.SuppliesWindowContent );
						PlayerMenuContent.SuppliesWindowContent.SpawnIcons[k]:SetPos( x, y );
						PlayerMenuContent.SuppliesWindowContent.SpawnIcons[k]:SetSize( 64, 64 );
						PlayerMenuContent.SuppliesWindowContent.SpawnIcons[k]:SetModel( v.Model );
						PlayerMenuContent.SuppliesWindowContent.SpawnIcons[k]:SetMouseInputEnabled( false );
						
						PlayerMenuContent.SuppliesWindowContent.SpawnIcons[k] = PlayerMenuContent.SuppliesWindowContent:AddObject( PlayerMenuContent.SuppliesWindowContent.SpawnIcons[k], x, y );
						
						PlayerMenuContent.SuppliesWindowContent.NameLabels[k] = PlayerMenuContent.SuppliesWindowContent:AddLabel( v.Name, "DefaultSmall", 71, y, Color( 255, 255, 255, 255 ) );
						PlayerMenuContent.SuppliesWindowContent.NameLabels[k]:SetSize( 150, 25 );
						PlayerMenuContent.SuppliesWindowContent.DescLabels[k] = PlayerMenuContent.SuppliesWindowContent:AddLabel( v.Desc, "DefaultSmall", 71, y + 17, Color( 255, 255, 255, 255 ) );
						PlayerMenuContent.SuppliesWindowContent.PriceLabels[k] = PlayerMenuContent.SuppliesWindowContent:AddLabel( "$" .. v.StockPrice, "DefaultSmall", 235, y, Color( 255, 255, 255, 255 ) );
						PlayerMenuContent.SuppliesWindowContent.StockLabels[k] = PlayerMenuContent.SuppliesWindowContent:AddLabel( v.StockCount, "DefaultSmall", 335, y, Color( 255, 255, 255, 255 ) );
						PlayerMenuContent.SuppliesWindowContent.CrntStockLabels[k] = PlayerMenuContent.SuppliesWindowContent:AddLabel( "0", "DefaultSmall", 465, y - 7, Color( 255, 255, 255, 255 ) );
		
						if( LocalPlayer():HasPlayerFlag( "X" ) and
							LocalPlayer():HasPlayerFlag( "F" ) and
							v.BMRebelCost and v.BMRebelCost > -1 ) then				
							PlayerMenuContent.SuppliesWindowContent.BMCostLabels[k] = PlayerMenuContent.SuppliesWindowContent:AddLabel( "Cost: " .. v.BMRebelCost .. "%", "DefaultSmall", x + 95, y + 66, Color( 255, 255, 255, 255 ) );
						end
						
						PlayerMenuContent.SuppliesWindowContent.StockLabels[k]:SetVisible( false );
						PlayerMenuContent.SuppliesWindowContent.CrntStockLabels[k]:SetVisible( false );
						
						local but =  PlayerMenuContent.SuppliesWindowContent:AddButton( "Buy", x, y + 66, 30, 15 );
						but.ID = v.ID;
						but.Index = k;
						but:SetRoundness( 0 );
						but:SetCallback( BuyItem );
		
						if( LocalPlayer():HasPlayerFlag( "X" ) and
							LocalPlayer():HasPlayerFlag( "F" ) and
							v.BMRebelCost and v.BMRebelCost > -1 ) then
						
							local but =  PlayerMenuContent.SuppliesWindowContent:AddButton( "Rebel Buy", x + 30, y + 66, 55, 15 );
							but.ID = v.ID;
							but.Index = k;
							but:SetRoundness( 0 );
							but:SetCallback( RebelBuyItem );
							
						end
								
						n = n + 1;
						
					end
							
				end
				
				if( n > 4 ) then
				
					PlayerMenuContent.SuppliesWindowContent:SetMaxScroll( 82 * n - 328 );
				
				end
						
			end
			
		--[[
			PlayerMenuContent.NameLabel = PlayerMenuContent:AddLabel( "", "TargetID", 5, 3, Color( 255, 255, 255, 255 ) );
			PlayerMenuContent.ProfitLabel = PlayerMenuContent:AddLabel( "Current Bank Amount: $0", "DefaultSmall", 5, 35, Color( 255, 255, 255, 255 ) );
		
			surface.SetFont( "DefaultSmall" );
			PlayerMenuContent.ChangeNameBut = PlayerMenuContent:AddButton( "Change Name", surface.GetTextSize( PlayerMenuContent.NameLabel:GetValue() ), 2, 80, 25 );
			PlayerMenuContent.ChangeNameBut:SetRoundness( 0 );
			PlayerMenuContent.ChangeNameBut:SetCallback( ChangeBusinessNameFrame );
			
			PlayerMenuContent.GiveBankBut = PlayerMenuContent:AddButton( "Give Money", 5, 60, 70, 25 );
			PlayerMenuContent.GiveBankBut:SetRoundness( 0 );
			PlayerMenuContent.GiveBankBut:SetCallback( GiveMoneyFrame );
			
			PlayerMenuContent.TakeBankBut = PlayerMenuContent:AddButton( "Take Money", 80, 60, 70, 25 );
			PlayerMenuContent.TakeBankBut:SetRoundness( 0 );
			PlayerMenuContent.TakeBankBut:SetCallback( TakeMoneyFrame );
			
			PlayerMenuContent.ChangeJobBut = PlayerMenuContent:AddButton( "Change Job Title", 5, 100, 100, 25 );
			PlayerMenuContent.ChangeJobBut:SetRoundness( 0 );
			PlayerMenuContent.ChangeJobBut:SetCallback( ChangeJobFrame );
			
			PlayerMenuContent.SuppliesBut = PlayerMenuContent:AddButton( "Purchase Supply License ($2500)", 5, 135, 205, 25 );
			PlayerMenuContent.SuppliesBut:SetRoundness( 0 );

			
			if( TS.GetBusinessInt( GetInt( "businessid" ), "supplylicense" ) == 1 ) then
	
				PlayerMenuContent.SuppliesBut:SetText( "Buy Supplies" );
				PlayerMenuContent.SuppliesBut:SetSize( 100, 25 );
				PlayerMenuContent.SuppliesBut:SetCallback( BuySuppliesWindow );	
			
			else
			

				PlayerMenuContent.SuppliesBut:SetCallback( PurchaseLicense );
			
			end
			]]--
			
			local function PurchaseLicenses()
			
				local function BuyLicense( but )
				
					LocalPlayer():ConCommand( "rp_purchasesupplylicense " .. but.LID .. "\n" );
				
					if( GetFloat( "money" ) >= ( but.Money or 0 ) ) then
						but:Remove();
					end
				
				end
			
				PlayerMenuContent.SupplyLicenseWindow = vgui.Create( "TacoPanel" );
				PlayerMenuContent.SupplyLicenseWindow:SetSize( 250, 120 );
				PlayerMenuContent.SupplyLicenseWindow:SetPos( ScrW() / 2 - 125, ScrH() / 2 - 60 );
				PlayerMenuContent.SupplyLicenseWindow:SetTitle( "Supply Licenses" );
				PlayerMenuContent.SupplyLicenseWindow:MakePopup();
				
				if( TS.GetBusinessInt( GetInt( "businessid" ), "haslicense.1" ) ~= 1 ) then
				
					PlayerMenuContent.SupplyLicenseWindow.FoodButton = PlayerMenuContent.SupplyLicenseWindow:AddButton( "Food/Drink Licence (300 credits)", 5, 5, 200, 18 );
					PlayerMenuContent.SupplyLicenseWindow.FoodButton.LID = 1;
					PlayerMenuContent.SupplyLicenseWindow.FoodButton.Money = 300;
					PlayerMenuContent.SupplyLicenseWindow.FoodButton:SetCallback( BuyLicense );
				
				end
					
				if( TS.GetBusinessInt( GetInt( "businessid" ), "haslicense.2" ) ~= 1 ) then
					
					PlayerMenuContent.SupplyLicenseWindow.ElectronicsButton = PlayerMenuContent.SupplyLicenseWindow:AddButton( "Travelers License (175 credits)", 5, 26, 200, 18 );
					PlayerMenuContent.SupplyLicenseWindow.ElectronicsButton.LID = 2;
					PlayerMenuContent.SupplyLicenseWindow.ElectronicsButton.Money = 175;
					PlayerMenuContent.SupplyLicenseWindow.ElectronicsButton:SetCallback( BuyLicense );
					
				end
		
				if( TS.GetBusinessInt( GetInt( "businessid" ), "haslicense.3" ) ~= 1 ) then
		
					PlayerMenuContent.SupplyLicenseWindow.MiscButton = PlayerMenuContent.SupplyLicenseWindow:AddButton( "Medical License (225 credits)", 5, 47, 200, 18 );
					PlayerMenuContent.SupplyLicenseWindow.MiscButton.LID = 3;
					PlayerMenuContent.SupplyLicenseWindow.MiscButton.Money = 225;
					PlayerMenuContent.SupplyLicenseWindow.MiscButton:SetCallback( BuyLicense );
					
				end
						
				
				if( LocalPlayer():HasPlayerFlag( "X" ) ) then
				
					if( TS.GetBusinessInt( GetInt( "businessid" ), "haslicense.4" ) ~= 1 ) then
				
						PlayerMenuContent.SupplyLicenseWindow.BMButton = PlayerMenuContent.SupplyLicenseWindow:AddButton( "Black Market", 5, 68, 200, 18 );
						PlayerMenuContent.SupplyLicenseWindow.BMButton.LID = 4;
						PlayerMenuContent.SupplyLicenseWindow.BMButton:SetCallback( BuyLicense );
					
					end
						
				end
				
				--[[

				if( GetFloat( "money" ) < 2500 ) then
				
					PlayerMenuContent.BusinessFrame = vgui.Create( "TacoFrame" );
					PlayerMenuContent.BusinessFrame:SetTitle( "Cannot get license" );
					PlayerMenuContent.BusinessFrame:SetPos( ScrW() / 2 - 50, ScrH() / 2 - 45 );
					PlayerMenuContent.BusinessFrame:SetSize( 160, 50 );				
					PlayerMenuContent.BusinessFrame:AddLabel( "Need atleast 2500 tokens", "DefaultSmall", 20, 10, Color( 255, 255, 255, 255 ) );
					PlayerMenuContent.BusinessFrame:SetVisible( true );
					
					return;
					
				end
				
				LocalPlayer():ConCommand( "rp_purchasesupplylicense\n" );
				
				PlayerMenuContent.SuppliesBut:SetText( "Buy Supplies" );
				PlayerMenuContent.SuppliesBut:SetSize( 100, 25 );
				PlayerMenuContent.SuppliesBut:SetCallback( BuySuppliesWindow );
				
				]]--

			end
		
			PlayerMenuContent.NameLabel = PlayerMenuContent:AddLabel( "", "TargetID", 5, 3, Color( 255, 255, 255, 255 ) );
			PlayerMenuContent.ProfitLabel = PlayerMenuContent:AddLabel( "Current Bank Amount: $0", "DefaultSmall", 5, 35, Color( 255, 255, 255, 255 ) );
		
			surface.SetFont( "DefaultSmall" );
			PlayerMenuContent.ChangeNameBut = PlayerMenuContent:AddButton( "Change Name", surface.GetTextSize( PlayerMenuContent.NameLabel:GetValue() ), 2, 80, 25 );
			PlayerMenuContent.ChangeNameBut:SetRoundness( 0 );
			PlayerMenuContent.ChangeNameBut:SetCallback( ChangeBusinessNameFrame );
			
			PlayerMenuContent.GiveBankBut = PlayerMenuContent:AddButton( "Give Money", 5, 60, 70, 25 );
			PlayerMenuContent.GiveBankBut:SetRoundness( 0 );
			PlayerMenuContent.GiveBankBut:SetCallback( GiveMoneyFrame );
			
			PlayerMenuContent.TakeBankBut = PlayerMenuContent:AddButton( "Take Money", 80, 60, 70, 25 );
			PlayerMenuContent.TakeBankBut:SetRoundness( 0 );
			PlayerMenuContent.TakeBankBut:SetCallback( TakeMoneyFrame );
			
			PlayerMenuContent.ChangeJobBut = PlayerMenuContent:AddButton( "Change Job Title", 5, 100, 100, 25 );
			PlayerMenuContent.ChangeJobBut:SetRoundness( 0 );
			PlayerMenuContent.ChangeJobBut:SetCallback( ChangeJobFrame );
			
			PlayerMenuContent.ChangeJobBut = PlayerMenuContent:AddButton( "Buy Supplies", 110, 100, 100, 25 );
			PlayerMenuContent.ChangeJobBut:SetRoundness( 0 );
			PlayerMenuContent.ChangeJobBut:SetCallback( BuySuppliesWindow );
			
			PlayerMenuContent.SuppliesBut = PlayerMenuContent:AddButton( "Purchase Supply Licenses", 5, 135, 205, 25 );
			PlayerMenuContent.SuppliesBut:SetRoundness( 0 );

			
		--	if( TS.GetBusinessInt( GetInt( "businessid" ), "supplylicense" ) == 1 ) then
	
			--	PlayerMenuContent.SuppliesBut:SetText( "Buy Supplies" );
			--	PlayerMenuContent.SuppliesBut:SetSize( 100, 25 );
			--	PlayerMenuContent.SuppliesBut:SetCallback( BuySuppliesWindow );	
			
			--else
			

				PlayerMenuContent.SuppliesBut:SetCallback( PurchaseLicenses );
				
		--	end
			
		end 
	
		if( GetInt( "ownsbusiness" ) == 0 ) then
		
			local function CreateBusiness( pnl, val )
			
				LocalPlayer():ConCommand( "rp_createbusiness \"" .. string.gsub( val, "\"", "'" ) .. "\"\n" );
				PlayerMenuContent.BusinessFrame:Remove();
				PlayerMenuContent:RemoveButton( PlayerMenuContent.CreateBusinessBut );
				PlayerMenuContent:RemoveLabel( PlayerMenuContent.BusinessExpense );
				
				CreateBusinessVGUI();
			
			end
		
			local function CreateBusinessForm()
			
				if( GetFloat( "money" ) < 2500 ) then
				
					PlayerMenuContent.BusinessFrame = vgui.Create( "TacoFrame" );
					PlayerMenuContent.BusinessFrame:SetTitle( "Cannot create business" );
					PlayerMenuContent.BusinessFrame:SetPos( ScrW() / 2 - 50, ScrH() / 2 - 45 );
					PlayerMenuContent.BusinessFrame:SetSize( 160, 50 );				
					PlayerMenuContent.BusinessFrame:AddLabel( "Need at least 2500 credits", "DefaultSmall", 20, 10, Color( 255, 255, 255, 255 ) );
					PlayerMenuContent.BusinessFrame:SetVisible( true );
					
					return;
					
				end
			
				PlayerMenuContent.BusinessFrame = vgui.Create( "TacoFrame" );
				PlayerMenuContent.BusinessFrame:SetTitle( "Create Business" );
				PlayerMenuContent.BusinessFrame:SetPos( ScrW() / 2 - 50, ScrH() / 2 - 45 );
				PlayerMenuContent.BusinessFrame:SetSize( 100, 90 );
				PlayerMenuContent.BusinessFrame:AddLabel( "Name of business:", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );
				PlayerMenuContent.BusinessFrame.Entry = PlayerMenuContent.BusinessFrame:AddEntry( CreateBusiness, 5, 55, 100 );
				PlayerMenuContent.BusinessFrame:SetVisible( true );
			
			end
		
			PlayerMenuContent.CreateBusinessBut = PlayerMenuContent:AddButton( "Create Business", 5, 40, 100, 24 );
			PlayerMenuContent.CreateBusinessBut:SetRoundness( 0 );
			PlayerMenuContent.CreateBusinessBut:SetCallback( CreateBusinessForm );
		
		else
		
			CreateBusinessVGUI();
			
		end
	
	end
 end
end

function CreateBasePlayerVGUI()
if( ValidEntity( LocalPlayer() ) ) then
	local function DelayedCreate()
	
		local function VGUIUpdate( VGUIBaseW, Pos, Color, Size )
		
			Msg( "FFFF\n" );
			if( SOrigMenuCallBack( VGUIBaseW, Pos, Color, Size ) ) then 
			
				return true;
			
			end
			
			return false;
		
		end
		
		hook.Add( PlayerWeapKey, PlayerVGUICB, VGUIUpdate );
	
	end
--	timer.Simple( 10, DelayedCreate );
end
end

function CreatePlayerMenuContentVGUI()
if( ValidEntity( LocalPlayer() ) ) then
	if( PlayerMenuContent ) then
		PlayerMenuContent:Remove();
		PlayerMenuContent = nil;
	end

	PlayerMenuContent = vgui.Create( "TacoPanel", PlayerMenuParent );
	PlayerMenuContent:SetPos( 5, 65 );
	PlayerMenuContent:SetSize( PlayerMenuParent:GetWide() - 10, PlayerMenuParent:GetTall() - 70 );
	PlayerMenuContent:EnableTitle( false );
	PlayerMenuContent:EnableCloseButton( false );
	PlayerMenuContent:EnableDragging( false );
	PlayerMenuContent:EnableFullWindow( true );
	PlayerMenuContent:SetRoundness( 6 );
	if( ChristmasMod ) then
		PlayerMenuContent:SetColor( Color( 255, 255, 255, 110 ) );
	else
		PlayerMenuContent:SetColor( Color( 50, 50, 50, 110 ) );
	end
	end
end

local function DropBusinessItem( but )
if( ValidEntity( LocalPlayer() ) ) then
	local itemid = but.ID;
	
	LocalPlayer():ConCommand( "rp_dropbusinessitem " .. itemid .. "\n" );
end
end

local function MoveItemList()
	if( ValidEntity( LocalPlayer() ) ) then
	local n = 1;
	
	for k, v in pairs( PlayerShop.Items ) do
		
		local index = 1;
		
		for l, m in pairs( StoreItems ) do
			
			if( m.ID == v ) then
				
				index = l;
				break;
			
			end
			
		end
			
		local data = StoreItems[index];
								
		local x = 5;
		local y = 85 * ( n - 1 ) + 15;
					
		PlayerShop.SpawnIcons[k]:SetPos( x, y + 20 );	
		PlayerShop.NameLabels[k]:SetPos( 71, y );			
		PlayerShop.DropButton[k]:SetPos( x, y + 66 );
		PlayerShop.CrntStockLabels[k]:SetPos( 200, y - 7 );
		
		n = n + 1;
						
	end
					
	if( n > 5 ) then
			
		PlayerShop:SetMaxScroll( 85 * ( n + 1 ) - 500 );
					
	end
 end
end

local function msgGiveStoreItem( msg )
if( ValidEntity( LocalPlayer() ) ) then
	local item = msg:ReadString();
	
	local index = 1;
	local n = 1;
	
	for k, v in pairs( PlayerShop.Items ) do
		n = n + 1;
	end
	
	for l, m in pairs( StoreItems ) do
			
		if( m.ID == item ) then
			index = l;
			break;
		end
			
	end
			
	local data = StoreItems[index];
	local k = #PlayerShop.Items + 1;
			
	PlayerShop.Items[k] = data.ID;
								
	local x = 5;
	local y = 85 * ( n - 1 ) + 15;
									
	PlayerShop.SpawnIcons[k] = vgui.Create( "SpawnIcon", PlayerShop );
	PlayerShop.SpawnIcons[k]:SetPos( x, y + 20 );
	PlayerShop.SpawnIcons[k]:SetSize( 64, 64 );
	PlayerShop.SpawnIcons[k]:SetModel( data.Model );
	PlayerShop.SpawnIcons[k]:SetMouseInputEnabled( false );
						
	PlayerShop.SpawnIcons[k] = PlayerShop:AddObject( PlayerShop.SpawnIcons[k], x, y + 20 );
						
	PlayerShop.NameLabels[k] = PlayerShop:AddLabel( data.Name, "DefaultSmall", 71, y, Color( 255, 255, 255, 255 ) );
	PlayerShop.NameLabels[k]:SetSize( 150, 25 );
	PlayerShop.CrntStockLabels[k] = PlayerShop:AddLabel( TS.GetBusinessStock( GetInt( "businessid" ), data.ID ) or 0, "DefaultSmall", 200, y - 7, Color( 255, 255, 255, 255 ) );		
					
	PlayerShop.DropButton[k] = PlayerShop:AddButton( "Drop", x, y + 66, 35, 15 );
	PlayerShop.DropButton[k].ID = data.ID;
	PlayerShop.DropButton[k].Index = index;
	PlayerShop.DropButton[k]:SetRoundness( 0 );
	PlayerShop.DropButton[k]:SetCallback( DropBusinessItem );
			
	if( n > 5 ) then
					
		PlayerShop:SetMaxScroll( 85 * ( n + 1 ) - 500 );
					
	end
 end
end
usermessage.Hook( "GiveStoreItem", msgGiveStoreItem );

local function msgTakeStoreItem( msg )
if( ValidEntity( LocalPlayer() ) ) then
	local name = msg:ReadString();

	local id = 1;
	
	for k, v in pairs( PlayerShop.Items ) do
	
		if( v == name ) then
			id = k;
			break;
		end
	
	end

	PlayerShop:RemoveObject( PlayerShop.SpawnIcons[id] );
	PlayerShop.SpawnIcons[id] = nil;
					
	PlayerShop:RemoveLabel( PlayerShop.NameLabels[id] );
	PlayerShop.NameLabels[id] = nil;
					
	PlayerShop:RemoveButton( PlayerShop.DropButton[id] );
	PlayerShop.DropButton[id] = nil;
					
	PlayerShop:RemoveLabel( PlayerShop.CrntStockLabels[id] );
	PlayerShop.CrntStockLabels[id] = nil;
					
	PlayerShop.Items[id] = nil;	
					
	MoveItemList();
 end
end
usermessage.Hook( "TakeStoreItem", msgTakeStoreItem );

timer.Simple( 5, CreateBasePlayerVGUI );

function CreatePlayerShop()
if( ValidEntity( LocalPlayer() ) ) then
	local function ShopWindowPaint()

		PlayerShop:EnableCloseButton( false );

		for k, v in pairs( PlayerShop.Items ) do
			
			PlayerShop.CrntStockLabels[k]:SetText( TS.GetBusinessStock( GetInt( "businessid" ), v ) or 0 );
			surface.SetFont( "DefaultSmall" );
			PlayerShop.CrntStockLabels[k]:SetSize( surface.GetTextSize( TS.GetBusinessStock( GetInt( "businessid" ), v ) or 0 ), 25 );
		
		end	
	
	end
		
	local function CreateItemList()
		
		PlayerShop.Items = { }																			
		PlayerShop.SpawnIcons = { }
		PlayerShop.NameLabels = { }
		PlayerShop.DropButton = { }
		PlayerShop.CrntStockLabels = { }
		
		local items = TS.GetBusinessItemTable( GetInt( "businessid" ) );
		local n = 1;	
							
		for k, v in pairs( items ) do
		
			local index = 1;
		
			for l, m in pairs( StoreItems ) do
			
				if( m.ID == v ) then
					index = l;
					break;
				end
			
			end
			
			local data = StoreItems[index];
			
			local additem = true;
			
			if( additem ) then
			
				PlayerShop.Items[k] = data.ID;
									
				local x = 5;
				local y = 85 * ( n - 1 ) + 15;
										
				PlayerShop.SpawnIcons[k] = vgui.Create( "SpawnIcon", PlayerShop );
				PlayerShop.SpawnIcons[k]:SetPos( x, y + 20 );
				PlayerShop.SpawnIcons[k]:SetSize( 64, 64 );
				PlayerShop.SpawnIcons[k]:SetModel( data.Model );
				PlayerShop.SpawnIcons[k]:SetMouseInputEnabled( false );
							
				PlayerShop.SpawnIcons[k] = PlayerShop:AddObject( PlayerShop.SpawnIcons[k], x, y + 20 );
							
				PlayerShop.NameLabels[k] = PlayerShop:AddLabel( data.Name, "DefaultSmall", 71, y, Color( 255, 255, 255, 255 ) );
				PlayerShop.NameLabels[k]:SetSize( 150, 25 );
				PlayerShop.CrntStockLabels[k] = PlayerShop:AddLabel( TS.GetBusinessStock( GetInt( "businessid" ), data.ID ), "DefaultSmall", 200, y - 7, Color( 255, 255, 255, 255 ) );
				
				PlayerShop.DropButton[k] = PlayerShop:AddButton( "Drop", x, y + 66, 30, 15 );
				PlayerShop.DropButton[k].ID = data.ID;
				PlayerShop.DropButton[k].Index = index;
				PlayerShop.DropButton[k]:SetRoundness( 0 );
				PlayerShop.DropButton[k]:SetCallback( DropBusinessItem );
				
				n = n + 1;
				
			end
							
		end
					
		if( n > 5 ) then
					
			PlayerShop:SetMaxScroll( 85 * ( n + 1 ) - 500 );
					
		end
		
	end
	
	if( PlayerShop ) then
		PlayerShop:Remove();
		PlayerShop = nil;
	end
	
	PlayerShop = vgui.Create( "TacoPanel" );
	PlayerShop:SetSize( 300, 500 );
	PlayerShop:SetPos( ScrW() * .2 + 610, ScrH() / 2 - 250 );
	PlayerShop:SetTitle( "Business Inventory" );
	PlayerShop:SetPaintHook( ShopWindowPaint );		
	PlayerShop:EnableCloseButton( false );
	PlayerShop:AddScrollBar();
	
	--PlayerShop:MakePopup();

	PlayerShop.NameLabel = PlayerShop:AddLabel( "Name", "DefaultSmall", 70, 1, Color( 255, 255, 255, 255 ) );
	PlayerShop.CrntStockLabel = PlayerShop:AddLabel( "Current Amount", "DefaultSmall", 200, 1, Color( 255, 255, 255, 255 ) );
				
	CreateItemList();		

	PlayerShop:SetVisible( false );
 end
end

function CreatePlayerMenuRadio()
if( ValidEntity( LocalPlayer() ) ) then
	PlayerMenuRadio = vgui.Create( "TacoFrame" );
	PlayerMenuRadio:SetPos( 10, ScrH() * .2 );
	PlayerMenuRadio:SetSize( 100, 85 );
	PlayerMenuRadio:SetTitle( "Radio" );
	PlayerMenuRadio:SetVisible( true );
	
	PlayerMenuRadio.FreqLabel = PlayerMenuRadio:AddLabel( "Frequency", "DefaultSmall", 5, 0, Color( 255, 255, 255, 255 ) );

	local function ChangeFreq( pnl, val )
	
		local val = tonumber( val );
	
		if( not val or val < 0 or val > 9999.9 ) then
			return;
		end
	
		LocalPlayer():ConCommand( "rp_changefrequency " .. val .. "\n" );
		PlayerMenuRadio.FreqEntry:SetText( math.Round( val * 100 ) / 100 );
	
	end
	

	PlayerMenuRadio.FreqEntry = PlayerMenuRadio:AddEntry( ChangeFreq, 5, 55, 100 );
	PlayerMenuRadio.FreqEntry:SetText( GetFloat( "radiofreq" ) );
	end
end

function CreatePlayerMenuVGUI()
if( ValidEntity( LocalPlayer() ) ) then
	PlayerMenuParent = vgui.Create( "TacoPanel" );
	PlayerMenuParent:SetPos( ScrW() * .2, ScrH() * .2 );
	PlayerMenuParent:SetSize( 600, 440 );
	PlayerMenuParent:SetTitle( "Player Menu" );
	PlayerMenuParent:SetCloseEvent( ClosePlayerMenu );
	PlayerMenuParent:SetKeyboardInputEnabled( true );
	PlayerMenuParent:SetRoundness( 8 );
	if( ChristmasMod ) then
		PlayerMenuParent:SetColor( Color( 0, 200, 0, 80 ) );
	else
		PlayerMenuParent:SetColor( Color( 60, 60, 60, 80 ) );
	end
	CreatePlayerMenuContentVGUI();
	CreatePlayerMenuSubContentVGUI( 0 );
	
	local tab = PlayerMenuParent:AddButton( "Biography", 11, 5, 108, 30 );
	tab:SetColor( Color( 50, 50, 50, 200 ) );
	tab:SetRoundness( 4 );
	tab.MenuID = 3;
	tab:SetCallback( ChangeMenu );
	
	local tab = PlayerMenuParent:AddButton( "Stats", 122, 5, 108, 30 );
	tab:SetColor( Color( 50, 50, 50, 200 ) );
	tab:SetRoundness( 4 );
	tab.MenuID = 0;
	tab:SetCallback( ChangeMenu );

	local tab = PlayerMenuParent:AddButton( "Business", 234, 5, 108, 30 );
	tab:SetColor( Color( 50, 50, 50, 200 ) );
	tab:SetRoundness( 4 );
	tab.MenuID = 5;
	tab:SetCallback( ChangeMenu );	
--[[
	local tab = PlayerMenuParent:AddButton( "Finance", 290, 5, 90, 30 );
	tab:SetColor( Color( 50, 50, 50, 200 ) );
	tab:SetRoundness( 4 );
	tab.MenuID = 2;
	tab:SetCallback( ChangeMenu );--]]

	local tab = PlayerMenuParent:AddButton( "Inventory", 346, 5, 108, 30 );
	tab:SetColor( Color( 50, 50, 50, 200 ) );
	tab:SetRoundness( 4 );
	tab.MenuID = 1;
	tab:SetCallback( ChangeMenu );
--[[
	local tab = PlayerMenuParent:AddButton( "Workshop", 480, 5, 90, 30 );
	tab:SetColor( Color( 50, 50, 50, 200 ) );
	tab:SetRoundness( 4 );
	tab.MenuID = 4;
	tab:SetCallback( ChangeMenu );
	]]--
	end
end

surface.CreateFont( "TargetID", 14, 500, true, false, "SubTitle" );

--FINANCE
function RenderFinance()
if( ValidEntity( LocalPlayer() ) ) then
	draw.DrawText( "Economic Value: ", "DefaultSmall", 5, 35, Color( 255, 255, 255, 255 ) );
	draw.DrawText( "Your borrowed total: ", "DefaultSmall", 5, 50, Color( 255, 255, 255, 255 ) );
	draw.DrawText( "How much you owe: ", "DefaultSmall", 5, 65, Color( 255, 255, 255, 255 ) );
	draw.DrawText( "Current amount of money: ", "DefaultSmall", 5, 80, Color( 255, 255, 255, 255 ) );
	
	local econcolor = Color( 10, 200, 10, 255 );
	
	if( GetGlobalFloat( "EconomyMoney" ) < 0 ) then
		econcolor = Color( 200, 10, 10, 255 );
	end
	
	draw.DrawText( "$" .. GetGlobalFloat( "EconomyMoney" ), "DefaultSmall", 150, 35, econcolor );
	draw.DrawText( "$" .. GetFloat( "borrowamount" ), "DefaultSmall", 150, 50, Color( 255, 255, 255, 255 ) );
	
	local owecolor = Color( 255, 255, 255, 255 );
	
	if( GetFloat( "oweamount" ) > 0 ) then
		owecolor = Color( 200, 10, 10, 255 );
	end
	
	draw.DrawText( "$" .. GetFloat( "oweamount" ), "DefaultSmall", 150, 65, owecolor );
	draw.DrawText( "$" .. GetFloat( "money" ), "DefaultSmall", 150, 80, Color( 255, 255, 255, 255 ) );
			
	end	
end


--BUSINESS
function RenderBusiness()
if( ValidEntity( LocalPlayer() ) ) then
	if( GetInt( "ownsbusiness" ) == 1 ) then
		
		local id = GetInt( "businessid" );
		
		surface.SetFont( "TargetID" );
		PlayerMenuContent.NameLabel:SetSize( surface.GetTextSize( GetGlobalString( "business." .. id .. ".businessname" ) ), 23 );
		PlayerMenuContent.NameLabel:SetText( GetGlobalString( "business." .. id .. ".businessname" ) );
		
		PlayerMenuContent.ChangeNameBut:SetPos( surface.GetTextSize( PlayerMenuContent.NameLabel:GetValue() ) + 30, 2 );
			
		
		surface.SetFont( "DefaultSmall" );
		PlayerMenuContent.ProfitLabel:SetSize( surface.GetTextSize( "Current Bank Amount: $" .. GetGlobalFloat( "business." .. id .. ".bankamount" ) ), 23 );
		PlayerMenuContent.ProfitLabel:SetText( "Current Bank Amount: $" .. GetGlobalFloat( "business." .. id .. ".bankamount" ) );
		
	end
 end
end

--BIOGRAPHY
function RenderBiography()
if( ValidEntity( LocalPlayer() ) ) then
	if( PlayerMenuContent.BioIcon ) then
		if( PlayerMenuContent.BioIcon.Model ~= LocalPlayer():GetModel() ) then
			PlayerMenuContent.BioIcon = vgui.Create( "SpawnIcon", PlayerMenuContent );
			PlayerMenuContent.BioIcon.Model = LocalPlayer():GetModel();
			PlayerMenuContent.BioIcon:SetModel( LocalPlayer():GetModel() );
			PlayerMenuContent.BioIcon:SetPos( 5, 1 );
			PlayerMenuContent.BioIcon:SetSize( 64, 64 );
			PlayerMenuContent.BioIcon:SetMouseInputEnabled( false );
		end
	end
end
end

--INVENTORY
function RenderInventory()
if( ValidEntity( LocalPlayer() ) ) then
	if( not InventoryDoneVGUI ) then return; end

	PlayerMenuContent.SpaceNum:SetText( "Max Carrying Space: " .. math.Round( GetFloat( "inventory.MaxSize" ) * 100 ) / 100 );
	PlayerMenuContent.SpaceNum:SizeToContents();
	
	PlayerMenuContent.CrntSpaceNum:SetText( "Currently Used Space: " .. math.Round( GetFloat( "inventory.CrntSize" ) * 100 ) / 100 );
	PlayerMenuContent.CrntSpaceNum:SizeToContents();
	
	local num = 0;

	local scroll = PlayerMenuContent:GetScrollAmount();

	for k, v in pairs( InventoryVGUISlots ) do

		local x = PlayerMenuContent.InventoryIcon[v.id]:GetPos() + 5;
		local y = num * 94 + 92;
	
		draw.RoundedBox( 2, x, y, PlayerMenuContent:GetWide() - 10, 25, Color( 60, 60, 60, 255 ) );
		
		num = num + 1;

	end

	if( num > 0 ) then
	
		if( not PlayerMenuContent.NameLabel ) then
			PlayerMenuContent.NameLabel = PlayerMenuContent:AddLabel( "Name", "DefaultSmall", 73, 78 + scroll, Color( 255, 255, 255, 255 ) );
		end
		
		if( not PlayerMenuContent.AmountLabel ) then
			PlayerMenuContent.AmountLabel = PlayerMenuContent:AddLabel( "Amount", "DefaultSmall", 265, 75 + scroll, Color( 255, 255, 255, 255 ) );
		end
		
		if( not PlayerMenuContent.WeightLabel ) then
			PlayerMenuContent.WeightLabel = PlayerMenuContent:AddLabel( "Weight", "DefaultSmall", 308, 75 + scroll, Color( 255, 255, 255, 255 ) );
		end
		
		if( not PlayerMenuContent.SizeLabel ) then
			PlayerMenuContent.SizeLabel = PlayerMenuContent:AddLabel( "Size", "DefaultSmall", 345, 75 + scroll, Color( 255, 255, 255, 255 ) );
		end

		
	end

	if( num >= 4 ) then

		PlayerMenuContent:SetMaxScroll( math.Clamp( ( num - 3 ) * 94 + 2, 0, 1500 ) );
	
	end
	
	UpdateInventory();
	end
end

--STATS MENU
function RenderStatsMenu()
if( ValidEntity( LocalPlayer() ) ) then
	draw.RoundedBox( 2, 10, 50, 150, 20, Color( 0, 0, 0, 255 ) );
	draw.RoundedBox( 2, 11, 51, math.Clamp( 148 * ( GetFloat( "stat.Strength" ) / 100 ), 2, 148 ), 18, Color( 0, 200, 0, 255 ) );

	draw.RoundedBox( 2, 10, 90, 150, 20, Color( 0, 0, 0, 255 ) );
	draw.RoundedBox( 2, 11, 91, math.Clamp( 148 * ( GetFloat( "stat.Endurance" ) / 100 ), 2, 148 ), 18, Color( 0, 200, 0, 255 ) );

	draw.RoundedBox( 2, 10, 130, 150, 20, Color( 0, 0, 0, 255 ) );
	draw.RoundedBox( 2, 11, 131, math.Clamp( 148 * ( GetFloat( "stat.Speed" ) / 100 ), 2, 148 ), 18, Color( 0, 200, 0, 255 ) );

	draw.RoundedBox( 2, 10, 170, 150, 20, Color( 0, 0, 0, 255 ) );
	draw.RoundedBox( 2, 11, 171, math.Clamp( 148 * ( GetFloat( "stat.Sprint" ) / 100 ), 2, 148 ), 18, Color( 0, 200, 0, 255 ) );

	draw.RoundedBox( 2, 10, 245, 150, 20, Color( 0, 0, 0, 255 ) );
	draw.RoundedBox( 2, 11, 246, math.Clamp( 148 * ( GetFloat( "stat.Aim" ) / 100 ), 2, 148 ), 18, Color( 0, 0, 180, 255 ) );

	draw.RoundedBox( 2, 10, 285, 150, 20, Color( 0, 0, 0, 255 ) );
	draw.RoundedBox( 2, 11, 286, math.Clamp( 148 * ( GetFloat( "stat.Medic" ) / 100 ), 2, 148 ), 18, Color( 0, 0, 180, 255 ) );

	draw.RoundedBox( 2, 10, 325, 150, 20, Color( 0, 0, 0, 255 ) );
	draw.RoundedBox( 2, 11, 326, math.Clamp( 148 * ( GetFloat( "stat.Sneak" ) / 100 ), 2, 148 ), 18, Color( 0, 0, 180, 255 ) );

	PlayerMenuContent.StrengthNum:SetText( math.floor( GetFloat( "stat.Strength" ) ) );
	PlayerMenuContent.StrengthNum:SizeToContents();
	
	PlayerMenuContent.EnduranceNum:SetText( math.floor( GetFloat( "stat.Endurance" ) ) );
	PlayerMenuContent.EnduranceNum:SizeToContents();
	
	PlayerMenuContent.SpeedNum:SetText( math.floor( GetFloat( "stat.Speed" ) ) );
	PlayerMenuContent.SpeedNum:SizeToContents();
	
	PlayerMenuContent.SprintNum:SetText( math.floor( GetFloat( "stat.Sprint" ) ) );
	PlayerMenuContent.SprintNum:SizeToContents();
	
	PlayerMenuContent.AimNum:SetText( math.floor( GetFloat( "stat.Aim" ) ) );
	PlayerMenuContent.AimNum:SizeToContents();
	
	PlayerMenuContent.MedicNum:SetText( math.floor( GetFloat( "stat.Medic" ) ) );
	PlayerMenuContent.MedicNum:SizeToContents();
	
	PlayerMenuContent.SneakNum:SetText( math.floor( GetFloat( "stat.Sneak" ) ) );
	PlayerMenuContent.SneakNum:SizeToContents();
	
	
	end
end

