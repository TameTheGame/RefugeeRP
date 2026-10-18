
if( Scoreboard ) then
	Scoreboard:Remove();
	Scoreboard = nil;
end

ScoreboardVisible = false;

function ScoreboardThink()

	if( Scoreboard and Scoreboard.PlayerRows and Scoreboard:IsVisible() ) then
		
		local MoveRows = true;		
			
		for k, v in pairs( Scoreboard.PlayerRows ) do
		
			for n, m in pairs( v ) do
			
				if( not m.Entity:IsValid() or m.Entity:Team() ~= m.Team ) then
				
					CreatePlayerRows();
					MoveRows = false;
				
				end
			
			end
	
		end		
			
		if( MoveRows ) then
			MovePlayerRows();	
		end
		
		for k, v in pairs( player.GetAll() ) do
		
			if( not ScoreboardHasPlayer( v ) ) then
			
				CreatePlayerRows();
				break;
				
			end
		
		end
		
	end

end
hook.Add( "Think", "ScoreboardThink", ScoreboardThink );

function GetPossibleTeams()

	local teams = { }
	
	for k, v in pairs( player.GetAll() ) do
	
		if( not table.HasValue( teams, v:Team() ) ) then
		
			table.insert( teams, v:Team() );
		
		end
	
	end
	
	table.sort( teams );
	return teams;

end

function MovePlayerRows()

	local x = 1;
	local y = 1;
	local scroll = Scoreboard.Pane:GetScrollAmount();
	
	local count = 0;
	
	for k, v in pairs( Scoreboard.PlayerRows ) do
	
		y = y + 25;
	
		for n, m in pairs( v ) do
		
			m.SpawnIcon:SetPos( x, y + 2 + scroll );
			
			if( m.SpawnIcon.Model ~= m.Entity:GetModel() ) then
			
				m.SpawnIcon:Remove();
				m.SpawnIcon = vgui.Create( "SpawnIcon", Scoreboard.Pane );
				m.SpawnIcon:SetPos( x, y + 2 + scroll );
				m.SpawnIcon:SetSize( 64, 64 );
				m.SpawnIcon:SetModel( m.Entity:GetModel() );
				m.SpawnIcon.Model = m.Entity:GetModel();
			
			end
			
			m.NameLabel:SetPos( 68, y + scroll );
			m.NameLabel:SetText( m.Entity:Nick() );
			
			m.TitleLabel:SetPos( 68, y + 16 + scroll );
			m.TitleLabel:SetText( m.Entity:GetNWString( "title" ) );
			
			m.PingLabel:SetPos( Scoreboard.Pane:GetWide() - 65, y + scroll );
			m.PingLabel:SetText( m.Entity:Ping() );
			
			if( m.IngameAvatar ) then
			
				m.IngameAvatar:SetSize( 0, 0 );
				
				if( string.len( m.Entity:GetNWString( "IngameAvatar" ) ) > 10 ) then
				
					m.IngameAvatar:SetPos( x, y + 2 + scroll );
					m.IngameAvatar:SetSize( 64, 64 );
					m.SpawnIcon:SetVisible( false );
				
				end
				
			end
		
			m.SpawnIcon:SetVisible( Scoreboard:IsVisible() );
			m.NameLabel:SetVisible( Scoreboard:IsVisible() );
			m.TitleLabel:SetVisible( Scoreboard:IsVisible() );
			m.PingLabel:SetVisible( Scoreboard:IsVisible() );
			
			if( m.IngameAvatar ) then
				m.IngameAvatar:SetVisible( Scoreboard:IsVisible() );
			end
			
			y = y + 68;
			
			count = count + 1;
		
		end
	
	end
	
	if( count > 4 ) then
	
		Scoreboard.Pane:SetMaxScroll( y - 256 );
	
	end

end

function msgUpdatePlayerRows()

	if( Scoreboard ) then
		CreatePlayerRows();
	end

end
usermessage.Hook( "UpdateScoreboard", msgUpdatePlayerRows );

function CreatePlayerRows()

	local PossibleTeams = GetPossibleTeams();
	
	if( Scoreboard.PlayerRows ) then
	
		for k, v in pairs( Scoreboard.PlayerRows ) do

			Scoreboard.Pane:RemoveLabel( Scoreboard.Pane.TeamLabel[k] );

			for n, m in pairs( v ) do
			
				m.SpawnIcon:Remove();
				if( m.IngameAvatar ) then
					m.IngameAvatar:Remove();
				end
				Scoreboard.Pane:RemoveLabel( m.NameLabel );
				Scoreboard.Pane:RemoveLabel( m.TitleLabel );
				Scoreboard.Pane:RemoveLabel( m.PingLabel );
			
			end
		
		end
		
		Scoreboard.PlayerRows = nil;
	
	end
	
	Scoreboard.PlayerRows = { }
	
	for k, v in pairs( PossibleTeams ) do
	
		Scoreboard.PlayerRows[v] = { }
	
		for n, m in pairs( player.GetAll() ) do
		
			if( m:Team() == v ) then
			
				Scoreboard.PlayerRows[v][n] = { Entity = m }
			
			end
		
		end
	
	end
	
	local x = 1;
	local y = 1;
	
	Scoreboard.Pane.TeamLabel = { }
	
	for k, v in pairs( Scoreboard.PlayerRows ) do
	
		Scoreboard.Pane.TeamLabel[k] = Scoreboard.Pane:AddLabel( team.GetName( k ), "TargetID", x + 4, y + 1, Color( 255, 255, 255, 255 ) );
	
		y = y + 25;
	
		for n, m in pairs( v ) do
			
			m.SpawnIcon = vgui.Create( "SpawnIcon", Scoreboard.Pane );
			m.SpawnIcon:SetPos( x, y + 2 );
			m.SpawnIcon:SetSize( 64, 64 );
			m.SpawnIcon.Model = m.Entity:GetModel();
			m.SpawnIcon:SetModel( m.SpawnIcon.Model );
			m.SpawnIcon:SetVisible( Scoreboard:IsVisible() );
			m.SpawnIcon:SetMouseInputEnabled( false );
			
			m.Team = m.Entity:Team();
			
			m.NameLabel = Scoreboard.Pane:AddLabel( m.Entity:Nick(), "TargetID", 68, y, Color( 255, 255, 255, 255 ) );
			m.NameLabel:SetVisible( Scoreboard:IsVisible() );
			
			m.TitleLabel = Scoreboard.Pane:AddLabel( m.Entity:GetNWString( "title" ), "TargetID", 68, y + 16, Color( 180, 180, 180, 255 ) );
			m.TitleLabel:SetVisible( Scoreboard:IsVisible() );
			
			m.PingLabel = Scoreboard.Pane:AddLabel( m.Entity:Ping(), "TargetID", Scoreboard.Pane:GetWide() - 65, y, Color( 180, 180, 180, 255 ) );
			m.PingLabel:SetVisible( Scoreboard:IsVisible() );
			

			if( string.len( m.Entity:GetNWString( "IngameAvatar" ) ) > 10 ) then
			
				m.IngameAvatar = vgui.Create( "HTML", Scoreboard.Pane );
				m.IngameAvatar:SetSize( 0, 0 );
			
				m.IngameAvatar:SetPos( x, y + 2 );
				m.IngameAvatar:SetSize( 64, 64 );
				m.IngameAvatar:OpenURL( m.Entity:GetNWString( "IngameAvatar" ) );
				m.SpawnIcon:SetVisible( false );
			
			end
			
			y = y + 68;
		
		end
	
	end

end

function ScoreboardHasPlayer( ply )
	
	for k, v in pairs( Scoreboard.PlayerRows ) do
		for n, m in pairs( v ) do
			if( m.Entity:EntIndex() == ply:EntIndex() ) then
				return true;
			end
		end
	end
	
	return false;

end

surface.CreateFont( "coolvetica", 26, 500, true, false, "TSScoreboardHead" );

function CreateScoreboard()

	local function ScoreboardPaint()
	
		--draw.RoundedBox( 0, 2, 2, ScrW() * .5, 25, Color( 0, 0, 0, 255 ) );
		draw.DrawText( "Real Time Roleplay", "TSScoreboardHead", 7, 5, Color( 0, 0, 0, 255 ) );
		draw.DrawText( "Real Time Roleplay", "TSScoreboardHead", 5, 3, Color( 255, 255, 255, 255 ) );
	
	end
	
	local function PlayerPaint()
	
		local x = 1;
		local y = 1;
		
		for k, v in pairs( Scoreboard.PlayerRows ) do
		
			y = y + 25;
		
			for n, m in pairs( v ) do

				draw.RoundedBox( 2, x, y, Scoreboard.Pane:GetWide(), 65, Color( 50, 50, 50, 200 ) );
			
				y = y + 68;
			
			end
		
		end		
	
	end

	Scoreboard = vgui.Create( "TacoPanel" );
	Scoreboard:SetPos( ScrW() * .25, ScrH() * .25 );
	Scoreboard:SetSize( ScrW() * .5, ScrH() * .5 );
	Scoreboard:EnableTitle( false );
	Scoreboard:EnableCloseButton( false );
	Scoreboard:EnableDragging( false );
	Scoreboard:EnableFullWindow( true );
	Scoreboard:SetPaintHook( ScoreboardPaint );
	Scoreboard:SetColor( Color( 90, 90, 90, 170 ) );
	
	Scoreboard.Pane = vgui.Create( "TacoPanel", Scoreboard );
	Scoreboard.Pane:SetPos( 5, 35 );
	Scoreboard.Pane:SetSize( ScrW() * .5 - 10, ScrH() * .5 - 40 );
	Scoreboard.Pane:SetColor( Color( 80, 80, 80, 50 ) );
	Scoreboard.Pane:EnableTitle( false );
	Scoreboard.Pane:EnableCloseButton( false );
	Scoreboard.Pane:EnableDragging( false );
	Scoreboard.Pane:EnableFullWindow( true );
	Scoreboard.Pane:SetPaintHook( PlayerPaint );
	Scoreboard.Pane:AddScrollBar();
	Scoreboard.Pane:SetMaxScroll( 0 );
	
	CreatePlayerRows();
	
end

function GM:ScoreboardShow()

	if( not Scoreboard ) then
		CreateScoreboard();
	end
	
	Scoreboard:SetVisible( true );
	
	gui.EnableScreenClicker( true );
	
	ScoreboardVisible = true;

end

function GM:ScoreboardHide()

	if( Scoreboard ) then
	
		Scoreboard:SetVisible( false );
		gui.EnableScreenClicker( false );
		
	end
	
	ScoreboardVisible = false;
	
	

end