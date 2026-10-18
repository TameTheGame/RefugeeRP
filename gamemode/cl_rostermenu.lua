

if( RosterMenuWindow ) then
	RosterMenuWindow:Remove();
end

RosterMenuWindow = nil;

RosterMenuOn = false;

function msgRosterMenuToggle()

	RosterMenuOn = !RosterMenuOn;
	
	if( RosterMenuOn ) then
	
	else
	
	end

end
usermessage.Hook( "ToggleRosterMenu", msgRosterMenuToggle );