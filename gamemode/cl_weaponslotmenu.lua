
WeaponSlotAlpha = 0;
LastWeaponSlotUpdate = 0;
CurrentWeaponSlot = 1;
CurrentSlotPos = 1;

WeaponLists = { }

--We'll only use 3 slots
WeaponSlots = 
{

	{ }, --Non-weapons 1
	{ }, --Weapons 2
	{ }, --Misc 3

}

function AddWeapon( slot, class, printname )

	table.insert( WeaponLists, class );

	if( not slot or slot > 3 or slot < 1 ) then
	
		slot = 3;
	
	end
	
	if( WeaponSlots[slot] ) then
		table.insert( WeaponSlots[slot], { class = class, printname = printname } );
	end

end

function RemoveWeapon( class )

	for k, v in pairs( WeaponLists ) do
	
		if( v == class ) then
		
			WeaponLists[k] = nil;
		
		end
	
	end
	
	local wslot;
	local slot;
	
	for k, v in pairs( WeaponSlots ) do
	
		for n, m in pairs( v ) do
		
			if( m.class == class ) then
			
				wslot = k;
				WeaponSlots[k][n] = nil;
				slot = n;
			
			end
		
		end
	
	end
	
	local newslot = slot;
	
	for n = slot, 25 do
	
		if( WeaponSlots[wslot][n] ) then
		
			WeaponSlots[wslot][newslot] = WeaponSlots[wslot][n];
			newslot = newslot + 1;
			WeaponSlots[wslot][n] = nil;
		
		end
	
	end

end

function RefreshWeaponMenu()

	WeaponSlotAlpha = 255;
	LastWeaponSlotUpdate = CurTime();

end

function GoToWeaponSlotMenu( slot )

	if( not WeaponSlots[slot] ) then
	
		return;
	
	end

	RefreshWeaponMenu();

	CurrentWeaponSlot = slot;
	CurrentSlotPos = 1;
	
	UpdateSlotPosition();

end

function UpdateSlotPosition( scroll )

	if( WeaponSlots[CurrentWeaponSlot] ) then
	
		while( not WeaponSlots[CurrentWeaponSlot][CurrentSlotPos] ) do
		
			CurrentSlotPos = CurrentSlotPos + 1;
			
			if( CurrentSlotPos >= #WeaponSlots[CurrentWeaponSlot] ) then
							
				CurrentSlotPos = 1;
				break;
			
			end
		
		end
	
	end

end
