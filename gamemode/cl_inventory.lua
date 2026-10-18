
Inventory = { }
InventoryVGUISlots = { }
InventoryDoneVGUI = false;

function BuildInventoryVGUI()
if( ValidEntity( LocalPlayer() ) ) then
	for k, v in pairs( InventoryVGUISlots ) do
	
		local id = v.id;
		local x = v.xdisp;

		local y = k * 94 + 92;
	
		local data = Inventory[id];
		local scroll = PlayerMenuContent:GetScrollAmount();
	
		if( not PlayerMenuContent.InventoryIcon[id] ) then
		
			PlayerMenuContent.InventoryIcon[id] = vgui.Create( "SpawnIcon", PlayerMenuContent );
			PlayerMenuContent.InventoryIcon[id]:SetModel( data.Model );
			PlayerMenuContent.InventoryIcon[id]:SetPos( x + 5, y + scroll );
			PlayerMenuContent.InventoryIcon[id]:SetSize( 64, 64 );
			PlayerMenuContent.InventoryIcon[id]:SetMouseInputEnabled( false );
			
		end
		
		if( not PlayerMenuContent.InventoryDropButton[id] ) then
		
			PlayerMenuContent.InventoryDropButton[id] = PlayerMenuContent:AddButton( "Drop", x + 444, y + 5 + scroll, 40, 15 );
			PlayerMenuContent.InventoryDropButton[id]:SetRoundness( 0 );
			PlayerMenuContent.InventoryDropButton[id]:SetOutlineColor( Color( 0, 0, 0, 100 ) );
			PlayerMenuContent.InventoryDropButton[id].ID = id;
			
			local function DropItem( but )
			
				LocalPlayer():ConCommand( "rp_dropitem " .. but.ID .. "\n" );
			
			end
			
			PlayerMenuContent.InventoryDropButton[id]:SetCallback( DropItem );
			
		end
		
		
		if( data.Usable and not PlayerMenuContent.InventoryUseButton[id] ) then
		
			PlayerMenuContent.InventoryUseButton[id] = PlayerMenuContent:AddButton( "Use", x + 494, y + 5 + scroll, 30, 15 );
			PlayerMenuContent.InventoryUseButton[id]:SetRoundness( 0 );
			PlayerMenuContent.InventoryUseButton[id]:SetOutlineColor( Color( 0, 0, 0, 100 ) );
			PlayerMenuContent.InventoryUseButton[id].ID = id;
			
			local function UseItem( but )
			
				LocalPlayer():ConCommand( "rp_useitem " .. but.ID .. "\n" );
			
			end
			
			PlayerMenuContent.InventoryUseButton[id]:SetCallback( UseItem );
			
		end
	
		if( not PlayerMenuContent.InventoryNameLabel[id] ) then
	
			PlayerMenuContent.InventoryNameLabel[id] = PlayerMenuContent:AddLabel( data.Name, "DefaultSmall", x + 69, y + 6 + scroll, Color( 255, 255, 255, 255 ) );
			
		elseif( PlayerMenuContent.InventoryNameLabel[id]:GetValue() ~= data.Name ) then
		
			PlayerMenuContent.InventoryNameLabel[id]:SetText( data.Name );
			PlayerMenuContent.InventoryNameLabel[id]:SetSize( 250, 30 );
			
		end
		
		if( not PlayerMenuContent.InventoryAmountLabel[id] ) then
		
			PlayerMenuContent.InventoryAmountLabel[id] = PlayerMenuContent:AddLabel( data.Amt, "DefaultSmall", x + 270, y + 7 + scroll, Color( 255, 255, 255, 255 ) );
		
		elseif( PlayerMenuContent.InventoryAmountLabel[id]:GetValue() ~= data.Amt ) then
		
			PlayerMenuContent.InventoryAmountLabel[id]:SetText( data.Amt );
			
		end
		
		if( not PlayerMenuContent.InventoryWeightLabel[id] ) then
		
			PlayerMenuContent.InventoryWeightLabel[id] = PlayerMenuContent:AddLabel( data.Weight, "DefaultSmall", x + 310, y + 7 + scroll, Color( 255, 255, 255, 255 ) );
		
		elseif( PlayerMenuContent.InventoryWeightLabel[id]:GetValue() ~= math.Round( data.Weight * 100 ) / 100 ) then
		
			PlayerMenuContent.InventoryWeightLabel[id]:SetText( math.Round( data.Weight * 100 ) / 100 );
	
		end
		
		if( not PlayerMenuContent.InventorySizeLabel[id] ) then
		
			PlayerMenuContent.InventorySizeLabel[id] = PlayerMenuContent:AddLabel( data.Size, "DefaultSmall", x + 347, y + 7 + scroll, Color( 255, 255, 255, 255 ) );
		
		elseif( PlayerMenuContent.InventorySizeLabel[id]:GetValue() ~= math.Round( data.Size * 100 ) / 100 ) then
		
			PlayerMenuContent.InventorySizeLabel[id]:SetText( math.Round( data.Size * 100 ) / 100 );
			
		end
		
		if( not PlayerMenuContent.InventoryDescLabel[id] ) then
		
			PlayerMenuContent.InventoryDescLabel[id] = PlayerMenuContent:AddLabel( data.Desc, "DefaultSmall", x + 69, y + 30 + scroll, Color( 255, 255, 255, 255 ) );
		
		elseif( PlayerMenuContent.InventoryDescLabel[id]:GetValue() ~= data.Desc ) then
		
			PlayerMenuContent.InventoryDescLabel[id]:SetText( data.Desc );
			
		end

	end
	
	InventoryDoneVGUI = true;
 end
end

function AddInventoryVGUIItem( id, xdisp )

	local item = { }
	item.id = id;
	item.xdisp = xdisp;
	
	table.insert( InventoryVGUISlots, item );
	
end

function msgSetInventoryAmt( msg )

	local id = msg:ReadString();

	if( Inventory[id] ) then
	
		Inventory[id].Amt = msg:ReadShort();
	
	end

end
usermessage.Hook( "SetInventoryAmt", msgSetInventoryAmt );

function msgAddWeaponToInventory( msg )

	local id = msg:ReadString();

	if( not Inventory[id] ) then
	
		local name = msg:ReadString();
		local model = msg:ReadString();
		local weight = msg:ReadFloat();
		local size = msg:ReadFloat();
		
		local newitem = { }
		
		newitem.Name = weapons.Get( name ).PrintName;
		newitem.Amt = 1;
		newitem.Weight = weight;
		newitem.Size = size;
		newitem.Model = model;
		newitem.IsWeapon = true;
		newitem.Usable = false;
		newitem.Desc = "";
		newitem.StoreItem = false;
		
		Inventory[id] = newitem;
		
		AddInventoryVGUIItem( id, 5 );

	else

	
	end

end
usermessage.Hook( "AddWeaponToInventory", msgAddWeaponToInventory );

function msgAddInventory( msg )

	local id = msg:ReadString();

	if( not Inventory[id] ) then
	
		local name = msg:ReadString();
		local model = msg:ReadString();
		local usable = msg:ReadBool();
		local weight = msg:ReadFloat();
		local size = msg:ReadFloat();
		local desc = msg:ReadString();
		local flags = msg:ReadString();
		
		local newitem = { }
		
		newitem.Name = name;
		newitem.Amt = 1;
		newitem.Usable = usable;
		newitem.Weight = math.floor( ( weight * 100 ) ) / 100;
		newitem.Size = math.floor( ( size * 100 ) ) / 100;
		newitem.Model = model;
		newitem.Desc = desc;
		newitem.StoreItem = false;
		newitem.Flags = flags;
		
		Inventory[id] = newitem;
		
		AddInventoryVGUIItem( id, 5 );
	
	else
	
		Inventory[id].Amt = Inventory[id].Amt + 1;
	
	end

end
usermessage.Hook( "AddInventory", msgAddInventory );

function msgDropInventory( msg )

	local id = msg:ReadString();

	Inventory[id].Amt = Inventory[id].Amt - 1;
	
end
usermessage.Hook( "DropInventory", msgDropInventory );

function msgDropWeaponFromInventory( msg )

	local id = msg:ReadString();

	Inventory[id].Amt = 0;

end
usermessage.Hook( "DropWeaponFromInventory", msgDropWeaponFromInventory );

function msgDropAllWeaponsFromInventory( msg )

	for k, v in pairs( Inventory ) do 
		if( string.find( k, "weapon_" ) ) then
			Inventory[k].Amt = 0;
		end
	end

end
usermessage.Hook( "DropAllWeaponsFromInventory", msgDropAllWeaponsFromInventory );

function TakeOutOfInventory( id )

	if( PlayerMenuContent and PlayerMenuContent.InventoryNameLabel and PlayerMenuContent.InventoryNameLabel[id] ) then
	
		PlayerMenuContent:RemoveLabel( PlayerMenuContent.InventoryNameLabel[id] );
		PlayerMenuContent.InventoryNameLabel[id] = nil;
		
		PlayerMenuContent:RemoveLabel( PlayerMenuContent.InventoryAmountLabel[id] );
		PlayerMenuContent.InventoryAmountLabel[id] = nil;
		
		PlayerMenuContent:RemoveLabel( PlayerMenuContent.InventorySizeLabel[id] );
		PlayerMenuContent.InventorySizeLabel[id] = nil;
		
		PlayerMenuContent:RemoveLabel( PlayerMenuContent.InventoryWeightLabel[id] );
		PlayerMenuContent.InventoryWeightLabel[id] = nil;
		
		PlayerMenuContent:RemoveLabel( PlayerMenuContent.InventoryDescLabel[id] );
		PlayerMenuContent.InventoryDescLabel[id] = nil;
		
		PlayerMenuContent:RemoveButton( PlayerMenuContent.InventoryDropButton[id] );
		PlayerMenuContent.InventoryDropButton[id] = nil;
		
		if( PlayerMenuContent.InventoryUseButton[id] ) then
			PlayerMenuContent:RemoveButton( PlayerMenuContent.InventoryUseButton[id] );
			PlayerMenuContent.InventoryUseButton[id] = nil;
		end
		
		PlayerMenuContent.InventoryIcon[id]:Remove();
		PlayerMenuContent.InventoryIcon[id] = nil;
		
	end
	
	if( Inventory[id] ) then

		Inventory[id] = nil;
	
	end

	for k, v in pairs( InventoryVGUISlots ) do
	
		if( v.id == id ) then
		
			InventoryVGUISlots[k] = nil;
		
		end
	
	end

end

function msgResetInventory()

	for k, v in pairs( Inventory ) do
	
		TakeOutOfInventory( k );
		
	end

end
usermessage.Hook( "ResetInventory", msgResetInventory );

function msgRemoveInventory( msg )

	local id = msg:ReadString();
	TakeOutOfInventory( id );

end
usermessage.Hook( "RemoveInventory", msgRemoveInventory );

function UpdateInventory()
if( ValidEntity( LocalPlayer() ) ) then
	local num = 0;
	
	if( not PlayerMenuContent ) then return; end
	
	local scroll = PlayerMenuContent:GetScrollAmount();
	
	for k, v in pairs( Inventory ) do

		local x = 5;
		local y = num * 94 + 92;
	
		draw.RoundedBox( 2, x, y, PlayerMenuContent:GetWide() - 10, 25, Color( 60, 60, 60, 255 ) );
		
		if( PlayerMenuContent.InventoryIcon[k] ) then
		
			PlayerMenuContent.InventoryIcon[k]:SetPos( x + 5, y + scroll );
			
		end
		
		if( PlayerMenuContent.InventoryDropButton[k] ) then
		
			PlayerMenuContent.InventoryDropButton[k].origy = y + 5;
			PlayerMenuContent.InventoryDropButton[k]:SetPos( x + 444, y + 5 + scroll );

		end
		
		if( PlayerMenuContent.InventoryUseButton[k] ) then
		
			PlayerMenuContent.InventoryUseButton[k].origy = y + 5;
			PlayerMenuContent.InventoryUseButton[k]:SetPos( x + 494, y + 5 + scroll );
			
		end

		if( PlayerMenuContent.InventoryNameLabel[k] ) then

			PlayerMenuContent.InventoryNameLabel[k].origy = y + 6;
			PlayerMenuContent.InventoryNameLabel[k]:SetPos( x + 69, y + 6 + scroll );
			PlayerMenuContent.InventoryNameLabel[k]:SizeToContents();
			
		end
		
		if( PlayerMenuContent.InventoryAmountLabel[k] ) then
		
			PlayerMenuContent.InventoryAmountLabel[k].origy = y + 7;
			PlayerMenuContent.InventoryAmountLabel[k]:SetPos( x + 270, y + 7 + scroll );
			PlayerMenuContent.InventoryAmountLabel[k]:SizeToContents();
		
		end
		
		if( PlayerMenuContent.InventoryWeightLabel[k] ) then
		
			PlayerMenuContent.InventoryWeightLabel[k].origy = y + 7;
			PlayerMenuContent.InventoryWeightLabel[k]:SetPos( x + 310, y + 7 + scroll );
			PlayerMenuContent.InventoryWeightLabel[k]:SizeToContents();
			
		end
		
		if( PlayerMenuContent.InventorySizeLabel[k] ) then
		
			PlayerMenuContent.InventorySizeLabel[k].origy = y + 7;
			PlayerMenuContent.InventorySizeLabel[k]:SetPos( x + 347, y + 7 + scroll );
			PlayerMenuContent.InventorySizeLabel[k]:SizeToContents();
			
		end
		
		if( PlayerMenuContent.InventoryDescLabel[k] ) then
		
			PlayerMenuContent.InventoryDescLabel[k].origy = y + 29;
			PlayerMenuContent.InventoryDescLabel[k]:SetPos( x + 69, y + 29 + scroll );
			PlayerMenuContent.InventoryDescLabel[k]:SizeToContents();
			
		end
		
		num = num + 1;

	end
	
	if( FindInventoryCount() <= 0 ) then
	
		if( PlayerMenuContent.NameLabel ) then
			PlayerMenuContent:RemoveLabel( PlayerMenuContent.NameLabel );
			PlayerMenuContent.NameLabel = nil;
		end
		
		if( PlayerMenuContent.AmountLabel ) then
			PlayerMenuContent:RemoveLabel( PlayerMenuContent.AmountLabel );
			PlayerMenuContent.AmountLabel = nil;
		end
		
		if( PlayerMenuContent.WeightLabel ) then
			PlayerMenuContent:RemoveLabel( PlayerMenuContent.WeightLabel );
			PlayerMenuContent.WeightLabel = nil;
		end
		
		if( PlayerMenuContent.SizeLabel ) then
			PlayerMenuContent:RemoveLabel( PlayerMenuContent.SizeLabel );
			PlayerMenuContent.SizeLabel = nil;
		end
	
	end
  end
end

function GetItemCount( id )

	if( Inventory[id] ) then
		return Inventory[id].Amt;
	end
	
	return 0;

end

function FindInventoryCount()

	local num = 0;
	
	for k, v in pairs( Inventory ) do
	
		num = num + 1;
	
	end
	
	return num;

end

function FindInventorySize()

	local num = 0;
	
	for k, v in pairs( Inventory ) do
	
		num = num + v.Size * v.Amt;
	
	end
	
	return num;

end