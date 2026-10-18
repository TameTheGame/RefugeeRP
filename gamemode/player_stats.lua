
local meta = FindMetaTable( "Player" );

--Return movement speeds

--Min: 250
--Max: 600
function meta:FindSneakSpeed()

	return 247 + math.Clamp( self:GetNWFloat( "stat.Sneak" ) * 3.5, 3.5, 170 );

end

--Min: 90
--Max: 110
function meta:FindWalkSpeed()

	return 90 + math.Clamp( self:GetNWFloat( "stat.Speed" ) * .2, 0, 50 );

end

--Min: 170
--Max: 335
function meta:FindSprintSpeed()

	if( self:IsRick() and self:GetModel() == "models/breen.mdl" ) then
	
		return 1000;
	
	end

	return 165 + math.Clamp( self:GetNWFloat( "stat.Speed" ) * 1.7, 0, 50 );

end

--Return multiplier for speed based on leg health
function meta:ModifiedSpeed()

	return math.Clamp( ( self:GetField( "hp.Legs" ) * .01 ), .01, 1 );

end

--Sets player's health and "MaxHealth" (used by clientside)
function meta:SetHealthStat( hp )

	self:SetHealth( hp );
	self:SetNWInt( "MaxHealth", hp );

end

--Increase the aim stat after shooting 
--(based on how far you are from your target, how precise you are, and how experienced you already are )
function meta:RaiseAimStat()

	local aimstat = self:GetNWFloat( "stat.Aim" );
	local amt = 0;
	
	if( aimstat < 17 ) then
		amt = .05;
	elseif( aimstat < 30 ) then
		amt = .019;
	elseif( aimstat < 50 ) then
		amt = .0066;
	elseif( aimstat < 75 ) then
		amt = .005;
	elseif( aimstat < 85 ) then
		amt = .003;
	elseif( aimstat < 100 ) then
		amt = .00025;
	end
	
	if( aimstat > 50 ) then
		amt = amt * .6;
	end
	
	self:SetNWFloat( "stat.Aim", aimstat + math.Clamp( amt * .7, .0001, 1 ) );

end

function meta:RaiseEnduranceStat()
	
	local stat = self:GetNWFloat( "stat.Endurance" );
	local amt = 0;
	
	if( stat < 17 ) then
		amt = .16;
	elseif( stat < 30 ) then
		amt = .067;
	elseif( stat < 50 ) then
		amt = .0417;
	elseif( stat < 75 ) then
		amt = .01;
	elseif( stat < 85 ) then
		amt = .005;
	elseif( stat < 100 ) then
		amt = .001;
	end	
	
	if( stat > 55 ) then
		amt = amt * .6;
	end
	
	self:SetNWFloat( "stat.Endurance", stat + math.Clamp( amt * .65, .0001, 1 ) );

end

function meta:RaiseSprintStat()

	local stat = self:GetNWFloat( "stat.Sprint" );
	local amt = 0;
	
	if( stat < 17 ) then
		amt = .017;
	elseif( stat < 30 ) then
		amt = .0083;
	elseif( stat < 50 ) then
		amt = .005;
	elseif( stat < 75 ) then
		amt = .005;
	elseif( stat < 85 ) then
		amt = .0033;
	elseif( stat < 100 ) then
		amt = .0017;
	end	
	
	if( stat > 45 ) then
		amt = amt * .6;
	end
	
	self:SetNWFloat( "stat.Sprint", stat + math.Clamp( amt * .3, .0001, 1 ) );
	
	self:GetTable().SprintDegradeAmt = math.Clamp( 3 / self:GetNWFloat( "stat.Sprint" ), .01, 2 );
	self:GetTable().SprintHeal = math.Clamp( self:GetNWFloat( "stat.Sprint" ) / 200, .01, 1.5 );
	

end

function meta:RaiseSpeedStat()

	local stat = self:GetNWFloat( "stat.Speed" );
	local amt = 0;
	
	if( stat < 17 ) then
		amt = .017;
	elseif( stat < 30 ) then
		amt = .0083;
	elseif( stat < 50 ) then
		amt = .005;
	elseif( stat < 75 ) then
		amt = .005;
	elseif( stat < 85 ) then
		amt = .0033;
	elseif( stat < 100 ) then
		amt = .0017;
	end	
	
	if( stat > 45 ) then
		amt = amt * .6;
	end
	
	self:SetNWFloat( "stat.Speed", stat + ( math.Clamp( amt * .2, .0001, 1 ) ) );
	
	self:GetTable().WalkSpeed = 90 + math.Clamp( self:GetNWFloat( "stat.Speed" ) * .2, 0, 20 );
	self:GetTable().SprintSpeed = 165 + math.Clamp( self:GetNWFloat( "stat.Speed" ) * 1.7, 0, 150 );
	

end

--Deducts a stat
--Example: ply:DeductStat( "Endurance", .5 );
function meta:DeductStat( var, amt )

	var = "stat." .. var;
	
	self:SetNWFloat( var, self:GetNWFloat( var ) - amt );


end

function meta:RaiseStat( var, amt )

	var = "stat." .. var;
	
	self:SetNWFloat( var, self:GetNWFloat( var ) + amt );


end

function meta:TempStatBoost( var, amt, len )

	local varname = "stat." .. var;
	
	if( self:GetNWFloat( varname ) + amt > 100 ) then
	
		amt = 100 - self:GetNWFloat( varname );
	
	end
	
	if( self:GetNWFloat( varname ) + amt < 0 ) then
	
		amt = -self:GetNWFloat( varname );
	
	end
	
	self:SetField( varname .. "Modifier", self:GetField( varname .. "Modifier" ) + amt );
	self:SetNWFloat( varname, self:GetNWFloat( varname ) + amt );

	if( varname == "stat.Speed" ) then
		self:GetTable().WalkSpeed = 90 + math.Clamp( self:GetNWFloat( "stat.Speed" ) * .2, 0, 20 );
		self:GetTable().SprintSpeed = 165 + math.Clamp( self:GetNWFloat( "stat.Speed" ) * 1.7, 0, 150 );
	elseif( varname == "stat.Sprint" ) then
		self:GetTable().SprintDegradeAmt = math.Clamp( 3 / self:GetNWFloat( "stat.Sprint" ), .01, 2 );
	end

	if( len > 0 ) then

		local function EndStat( ply, varname, amt )
		
			ply:SetField( varname .. "Modifier", ply:GetField( varname .. "Modifier" ) - amt );
			ply:SetNWFloat( varname, ply:GetNWFloat( varname ) - amt );	
		
			if( varname == "stat.Speed" ) then
				self:GetTable().WalkSpeed = 90 + math.Clamp( self:GetNWFloat( "stat.Speed" ) * .2, 0, 20 );
				self:GetTable().SprintSpeed = 165 + math.Clamp( self:GetNWFloat( "stat.Speed" ) * 1.7, 0, 150 );
			elseif( varname == "stat.Sprint" ) then
				self:GetTable().SprintDegradeAmt = math.Clamp( 3 / self:GetNWFloat( "stat.Sprint" ), .01, 2 );
			end
		
		end
		timer.Simple( len, EndStat, self, varname, amt );
		
	end

end
