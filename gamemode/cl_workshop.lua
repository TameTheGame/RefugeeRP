
--Scrapped Dec 17 2007

WorkshopIngred = { }

function PopulateAddItemPane()

	local function AddItemCallback( link )
	
		local function RemoveItem( but )
			
			WorkshopIngred[but.butID] = WorkshopIngred[but.butID] - 1;
			
		end
	
		local id = link.InvID;

		if( not WorkshopIngred[id] ) then

			PlayerMenuContent.Pane1.ItemCount = PlayerMenuContent.Pane1.ItemCount + 1;
			
		end
			
		WorkshopIngred[id] = WorkshopIngred[id] or 0;
		WorkshopIngred[id] = WorkshopIngred[id] + 1;
		
		DoWorkshopPane1();
	
	end
	
	if( PlayerMenuContent.AddItemPane.QuantityLabels ) then
	
		for k, v in pairs( PlayerMenuContent.AddItemPane.QuantityLabels ) do
		
			PlayerMenuContent.AddItemPane:RemoveLabel( PlayerMenuContent.AddItemPane.QuantityLabels[k] );
			PlayerMenuContent.AddItemPane.QuantityLabels[k] = nil;
		
			PlayerMenuContent.AddItemPane:RemoveObject( PlayerMenuContent.AddItemPane.SpawnIcons[k] );
			PlayerMenuContent.AddItemPane.SpawnIcons[k] = nil;	
		
		end
		
	end

	PlayerMenuContent.AddItemPane.QuantityLabels = { }
	PlayerMenuContent.AddItemPane.SpawnIcons = { }
	PlayerMenuContent.AddItemPane.Links = { }
	
	local ydisp = 5;
					
	for k, v in pairs( Inventory ) do

		PlayerMenuContent.AddItemPane.SpawnIcons[k] = vgui.Create( "SpawnIcon", PlayerMenuContent.AddItemPane );
		PlayerMenuContent.AddItemPane.SpawnIcons[k]:SetPos( 5, ydisp );
		PlayerMenuContent.AddItemPane.SpawnIcons[k]:SetSize( 64, 64 );
		PlayerMenuContent.AddItemPane.SpawnIcons[k]:SetModel( v.Model );
		PlayerMenuContent.AddItemPane.SpawnIcons[k]:SetMouseInputEnabled( false );
				
		PlayerMenuContent.AddItemPane:AddObject( PlayerMenuContent.AddItemPane.SpawnIcons[k], 5, ydisp );
				
		PlayerMenuContent.AddItemPane.Links[k] = vgui.Create( "TacoLink", PlayerMenuContent.AddItemPane );
		PlayerMenuContent.AddItemPane.Links[k]:SetPos( 70, ydisp + 22 );
		PlayerMenuContent.AddItemPane.Links[k]:SetLinkFont( "Default" );
		PlayerMenuContent.AddItemPane.Links[k]:SetLinkText( v.Name );
		PlayerMenuContent.AddItemPane.Links[k].InvID = k;
		PlayerMenuContent.AddItemPane.Links[k]:SetCallback( AddItemCallback );

		PlayerMenuContent.AddItemPane.QuantityLabels[k] = PlayerMenuContent.AddItemPane:AddLabel( "Amount: " .. v.Amt, "DefaultSmall", 68, ydisp + 35, Color( 255, 255, 255, 255 ) );
				
		PlayerMenuContent.AddItemPane:AddObject( PlayerMenuContent.AddItemPane.Links[k], 70, ydisp + 22 );
				
		ydisp = ydisp + 66;
			
	end
			
	if( ydisp > 270 ) then
			
		PlayerMenuContent.AddItemPane:SetMaxScroll( ydisp - 270 );
		PlayerMenuContent.AddItemPane:AddScrollBar();
			
	end

end

function DoWorkshopPane1()

	local function RemoveItem( but )
		
		WorkshopIngred[but.butID] = WorkshopIngred[but.butID] - 1;

	end
		

	for k, v in pairs( PlayerMenuContent.Pane1.Item ) do
	
		PlayerMenuContent.Pane1:RemoveObject( PlayerMenuContent.Pane1.Item[k].SpawnIcon );
		PlayerMenuContent.Pane1.Item[k].SpawnIcon = nil;
			
		PlayerMenuContent.Pane1:RemoveLabel( PlayerMenuContent.Pane1.Item[k].ItemName );
		PlayerMenuContent.Pane1.Item[k].ItemName = nil;
				
		PlayerMenuContent.Pane1:RemoveButton( PlayerMenuContent.Pane1.Item[k].DropItem );
		PlayerMenuContent.Pane1.Item[k].DropItem = nil;
		
		PlayerMenuContent.Pane1.Item[k] = nil;
		
	end

	local ydisp = 5;

	for k, v in pairs( WorkshopIngred ) do
		
		if( Inventory[k] ) then
	
			local id = k;
				
			PlayerMenuContent.Pane1.Item[id] = { }
					
			PlayerMenuContent.Pane1.Item[id].SpawnIcon = vgui.Create( "SpawnIcon", PlayerMenuContent.Pane1 );
			PlayerMenuContent.Pane1.Item[id].SpawnIcon:SetPos( 5, ydisp );
			PlayerMenuContent.Pane1.Item[id].SpawnIcon:SetSize( 64, 64 );
			PlayerMenuContent.Pane1:AddObject( PlayerMenuContent.Pane1.Item[id].SpawnIcon );
			
			PlayerMenuContent.Pane1.Item[id].SpawnIcon:SetModel( Inventory[id].Model );
			PlayerMenuContent.Pane1.Item[id].SpawnIcon:SetMouseInputEnabled( false );
					
			if( WorkshopIngred[id] == 1 ) then
				PlayerMenuContent.Pane1.Item[id].ItemName = PlayerMenuContent.Pane1:AddLabel( Inventory[id].Name, "TargetID", 70, ydisp + 20, Color( 255, 255, 255, 255 ) );
			else
				PlayerMenuContent.Pane1.Item[id].ItemName = PlayerMenuContent.Pane1:AddLabel( "x" .. WorkshopIngred[id] .. " " .. Inventory[id].Name, "TargetID", 70, ydisp + 20, Color( 255, 255, 255, 255 ) );
			end
			
			PlayerMenuContent.Pane1.Item[id].DropItem = PlayerMenuContent.Pane1:AddButton( "Remove", 70, ydisp + 40, 50, 15 );
			PlayerMenuContent.Pane1.Item[id].DropItem.butID = id;
			PlayerMenuContent.Pane1.Item[id].DropItem:SetCallback( RemoveItem );
			PlayerMenuContent.Pane1.Item[id].DropItem:SetRoundness( 0 );
	
			ydisp = ydisp + 64;
			
		end
	
	end
	
	if( ydisp > PlayerMenuContent:GetTall() - 50 ) then
	
		PlayerMenuContent.Pane1:SetMaxScroll( PlayerMenuContent:GetTall() - 50 - ydisp );
		PlayerMenuContent.Pane1:AddScrollBar();
	
	end

end

function RenderWorkshop()

	if( PlayerMenuContent.AddItemMenu ) then
	
		if( PlayerMenuContent.AddItemPane and PlayerMenuContent.AddItemPane.QuantityLabels ) then
		
			local repopulate = false;
		
			for k, v in pairs( PlayerMenuContent.AddItemPane.QuantityLabels ) do
			
				if( Inventory[k].Amt > 0 ) then
					v:SetText( "Amount: " .. Inventory[k].Amt );
					v:SizeToContents();
				else
					repopulate = true;
					break;
				end
				
			end
			
			if( repopulate ) then
			
				PopulateAddItemPane();
			
			end
		
		end
	
	end
	
	local pane1changed = false;
	
	for k, v in pairs( WorkshopIngred ) do
	
		if( not Inventory[k] or Inventory[k].Amt < 1 or v < 1 ) then
		
			WorkshopIngred[k] = nil;
		
			--[[
			PlayerMenuContent.Pane1:RemoveObject( PlayerMenuContent.Pane1.Item[k].SpawnIcon );
			PlayerMenuContent.Pane1.Item[k].SpawnIcon = nil;
			
			PlayerMenuContent.Pane1:RemoveObject( PlayerMenuContent.Pane1.Item[k].ItemName );
			PlayerMenuContent.Pane1.Item[k].ItemName = nil;
			]]--
			
			PlayerMenuContent.Pane1.ItemCount = PlayerMenuContent.Pane1.ItemCount - 1;
	
			pane1changed = true;

		elseif( PlayerMenuContent.Pane1.Item[k] ) then
		
			if( v > 1 ) then
		
				PlayerMenuContent.Pane1.Item[k].ItemName:SetText( "x" .. v .. " " .. Inventory[k].Name );
				PlayerMenuContent.Pane1.Item[k].ItemName:SizeToContents();
				
			else
			
				PlayerMenuContent.Pane1.Item[k].ItemName:SetText( Inventory[k].Name );
				PlayerMenuContent.Pane1.Item[k].ItemName:SizeToContents();
			
			end
			
		end
		
	end
	
	if( pane1changed ) then
	
		DoWorkshopPane1();
	
	end
	

end

