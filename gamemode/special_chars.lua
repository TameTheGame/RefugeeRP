*
function CheckSpecialCharacter( ply )

	-- JT
	--[[if( ply:SteamID() == "STEAM_REDACTED" and ply:Nick() == "Josh Taylor" and ply:Team() == 1 ) then

		ply:SetModel( "models/combatsoldier3.mdl" );
		return;
	
	end

	-- Rick, in case he ever comes to RTRP
	if( ply:SteamID() == "STEAM_REDACTED" and ply:Nick() == "Rick Darkaliono" and ply:Team() == 1 ) then

		ply:SetModel( "models/odessa.mdl" );
		return;
	
	end--]]

	if( ply:Team() == 1 ) then
	
		--Kama
		--[[if( ply:SteamID() == "STEAM_REDACTED" and ply:Nick() == "Kama Sutra" ) then
		
			ply:SetModel( "models/gman.mdl" );

		end
		
		--Sleeper
		if( ply:SteamID() == "STEAM_REDACTED") then
		
			ply:SetModel( "models/monk.mdl" );
		
		end--]]
		
		local query = "SELECT `CustomModel`, `CustomModelName` FROM `rtrp_donations` WHERE `STEAMID` = '" .. ply:SteamID() .. "'";	
		local tab = mysql.query( TS.SQL, query );	
		
		if( tab and #tab > 0 and string.len( tab[1][1] ) > 6 ) then
		
			local model = tab[1][1];
			local name = tab[1][2];
			
			if( ply:Nick() == name ) then
			
				ply:SetModel( model );
			
			end
		
		end
	
		--[[
		
		--Saphira
		if( ply:SteamID() == "STEAM_REDACTED" and ply:Nick() == "Rachel Gatess" ) then
		
			ply:SetModel( "Models/Barnes/Citizen/Female_01.mdl" );
		
		end
		
		--Ace
		if( ply:SteamID() == "STEAM_REDACTED" and ply:Nick() == "Gareth Cromwaltier" ) then
		
			ply:SetModel( "models/Barnes/Citizen/male_07.mdl" );
			
		end
		
		--Manzermias
		if( ply:SteamID() == "STEAM_REDACTED" and ply:Nick() == "Nikolai Kowalsky" ) then
		
			ply:SetModel( "models/Barnes/Citizen/male_02.mdl" );
		
		end
		
		--Dave Brown
		if( ply:SteamID() == "STEAM_REDACTED" and ply:Nick() == "Leo Scott" ) then
		
			ply:SetModel( "models/Barnes/Citizen/male_04.mdl" );
		
		end
		
		--Herb
		if( ply:SteamID() == "STEAM_REDACTED" and ply:Nick() == "Herb Vargo" ) then
		
			ply:SetModel( "models/Barnes/Citizen/male_02.mdl" );
		
		end
		]]--
		
	
	--[[
		if( ply:GetField( "CustomModel" ) ~= "" ) then
		
			ply:SetModel( ply:GetField( "CustomModel" ) );
		
		end
	]]--
	--[[	--Caffeine
		if( ply:SteamID() == "STEAM_REDACTED" and ply:Nick() == "Jonathan Schultz" ) then
		
			ply:SetModel( "Models/eli.mdl" );
		
		end
	]]--
	end

end