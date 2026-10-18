
local meta = FindMetaTable( "Player" );

function meta:HandleBodyShot( dmginfo )

	self:SetField( "hp.Body", math.Clamp( self:GetField( "hp.Body" ) - dmginfo:GetDamage() * 1.5, 0, 100 ) );

	if( 100 - self:GetField( "hp.Body" ) >= math.Clamp( self:GetNWFloat( "stat.Endurance" ) - 5, 0, 70 ) ) then
	
		self:MakeBleed();
		self:SetBleedAmount( self:GetHeadBleeding() + self:GetArmsBleeding() + 
							self:GetBodyBleeding() + self:GetLegsBleeding() );
	
	end

end

function meta:HandleArmShot( dmginfo )

	self:SetField( "hp.Arms", math.Clamp( self:GetField( "hp.Arms" ) - dmginfo:GetDamage() * 1.9, 0, 100 ) );

	if( 100 - self:GetField( "hp.Arms" ) >= math.Clamp( self:GetNWFloat( "stat.Endurance" ), 0, 75 ) ) then
	
		self:MakeBleed();
		self:SetBleedAmount( self:GetHeadBleeding() + self:GetArmsBleeding() + 
							self:GetBodyBleeding() + self:GetLegsBleeding() );
	
	end

end

function meta:HandleLegShot( dmginfo )

	self:SetField( "hp.Legs", math.Clamp( self:GetField( "hp.Legs" ) - dmginfo:GetDamage() * 2.55, 0, 100 ) );

	if( 100 - self:GetField( "hp.Legs" ) >=  math.Clamp( self:GetNWFloat( "stat.Endurance" ), 0, 75 ) ) then
	
		self:MakeBleed();
		self:SetBleedAmount( self:GetHeadBleeding() + self:GetArmsBleeding() + 
							self:GetBodyBleeding() + self:GetLegsBleeding() );
	
	end
	
	self:GetTable().LegHealthMul = math.Clamp( ( self:GetField( "hp.Legs" ) * .01 ), .01, 1 );

end

--Returns how much the head is bleeding by
function meta:GetHeadBleeding()

	local val = 0;
	
	if( self:GetField( "HeadBleed" ) == 1 ) then
		val = 4;
	end
	
	return val;

end

function meta:HandleStunHit( attacker, hitgroup, extradmg )

	self:ViewPunch( Vector( 11, 0, 0 ) );

	local dmgmul = 1;
	local blocking = false;
	
	if( self:GetActiveWeapon():GetClass() == "ts_hands" ) then
	
		if( self:GetActiveWeapon():GetNWBool( "ironsights" ) ) then
		
			blocking = true;
			
		end
		
	end
	
	if( hitgroup == HITGROUP_HEAD ) then
	
		if( not blocking ) then
			dmgmul = 2.5;
		else
			dmgmul = .8;
		end
	
	elseif( hitgroup == HITGROUP_CHEST ) then
	
		if( not blocking ) then
			dmgmul = 1.8;
		else
			dmgmul = .6;
		end
	
	elseif( hitgroup == HITGROUP_STOMACH ) then
	
		if( not blocking ) then
			dmgmul = 1.8;
		else
			dmgmul = .7;
		end
	
	end
	
	local dmg = 40 * ( attacker:GetNWFloat( "stat.Strength" ) / 100 ) * dmgmul;
	dmg = dmg * ( 33 / self:GetNWFloat( "stat.Endurance" ) );
	
	umsg.Start( "DamageFlash", self );
		umsg.Short( 255 );
		umsg.Short( 255 );
		umsg.Short( 255 );
		umsg.Short( 255 );
		umsg.Float( .2 );
	umsg.End();
	
	umsg.Start( "DoBlurHit", self );
		umsg.Float( 1.8 );
	umsg.End();

	local min = 10;

	if( kill ) then
		min = 0;
	end
	
	local dmgmul = 1;
	
	if( extradmg ) then dmgmul = 2.8; end
	
	local findmg = dmg * .75 * dmgmul;
	
	self:SetHealth( math.Clamp( self:Health() - findmg, min, 100000 ) );
	
	if( self:Health() <= 0 ) then
		self:Slay();
	end
	
	self:SetNWInt( "sprint", math.Clamp( self:GetNWInt( "sprint" ) - 15, 0, 100 )  );
	self:SetField( "LastJump", CurTime() );
	self:SetField( "StunHit", CurTime() );
	
	self:SetNWFloat( "conscious", math.Clamp( self:GetNWFloat( "conscious" ) - dmg * .7 * dmgmul, 0, 100 ) );

	self:RaiseEnduranceStat();

	local stat = attacker:GetNWFloat( "stat.Strength" );
	local amt = 0;
	
	if( stat < 17 ) then
		amt = .01;
	elseif( stat < 30 ) then
		amt = .05;
	elseif( stat < 50 ) then
		amt = .03;
	elseif( stat < 75 ) then
		amt = .02;
	elseif( stat < 85 ) then
		amt = .014;
	elseif( stat < 100 ) then
		amt = .001;
	end	

	if( stat > 55 ) then
		amt = amt * .6;
	end
	
	attacker:SetNWFloat( "stat.Strength", stat + math.Clamp( amt * .3, .0001, 1 ) );

end

function meta:HandlePunch( attacker, hitgroup )

	self:ViewPunch( Vector( -7, 0, 0 ) );

	local dmgmul = 1;
	local blocking = false;
	
	if( self:GetActiveWeapon():GetClass() == "ts_hands" ) then
	
		if( self:GetActiveWeapon():GetNWBool( "ironsights" ) ) then
		
			blocking = true;
			
		end
		
	end
	
	local canblur = false;
	
	if( hitgroup == HITGROUP_HEAD ) then
	
		if( not blocking ) then
			dmgmul = 1.9;
			canblur = true;
		else
			dmgmul = .35;
		end
		
		
	
	elseif( hitgroup == HITGROUP_CHEST ) then
	
		if( not blocking ) then
			dmgmul = 1.45;
			canblur = true;
		else
			dmgmul = .2;
		end
	
	elseif( hitgroup == HITGROUP_STOMACH ) then
	
		if( not blocking ) then
			dmgmul = 1.45;
			canblur = true;
		else
			dmgmul = .25;
		end
	
	end
	
	local dmg = 35 * ( attacker:GetNWFloat( "stat.Strength" ) / 100 ) * dmgmul;
	dmg = dmg * ( 33 / self:GetNWFloat( "stat.Endurance" ) );
	
	if( dmg >= 20 and canblur ) then
	
		umsg.Start( "DoBlurHit", self );
			umsg.Float( .5 );
		umsg.End();
	
	end
	
	self:SetHealth( math.Clamp( self:Health() - dmg * .4, 5, 100000 ) );
	
	self:SetNWFloat( "conscious", math.Clamp( self:GetNWFloat( "conscious" ) - dmg * .28, 0, 100 ) );
	
	self:RaiseEnduranceStat();
	
	local stat = attacker:GetNWFloat( "stat.Strength" );
	local amt = 0;
	
	if( stat < 17 ) then
		amt = .01;
	elseif( stat < 30 ) then
		amt = .038;
	elseif( stat < 50 ) then
		amt = .025;
	elseif( stat < 75 ) then
		amt = .02;
	elseif( stat < 85 ) then
		amt = .014;
	elseif( stat < 100 ) then
		amt = .001;
	end	
	
	if( stat > 55 ) then
		amt = amt * .6;
	end
	
	attacker:SetNWFloat( "stat.Strength", stat + math.Clamp( amt * .25, .0001, 1 ) );
	
end

function meta:GoUnconscious()

	if( self:GetField( "isko" ) == 0 ) then

		self:SetField( "isko", 1 );
		self:SetPrivateInt( "isko", 1 );
		self:CreateServerRagdoll();
		
		self:SetField( "lastkoregen", CurTime() );
		
	end

end

function meta:GoConscious()

	local ragdoll = self:GetRagdoll();
	
	if( not self:Alive() ) then return; end
	
	if( not ragdoll or not ragdoll:IsValid() ) then
	
		self:Slay();
		return; 
	
	end

	self:SetPos( self:GetRagdoll():GetPos() );

	self:SetField( "isko", 0 );
	self:SetPrivateInt( "isko", 0 );
	
	self:SnapFromServerRagdoll();
	
	self:SetField( "lastkoregen", CurTime() );
	

end

--Returns how much the body is bleeding by
function meta:GetBodyBleeding() 

	local val = 0;
	
	val = ( 100 - self:GetField( "hp.Body" ) ) * .06;

	return math.abs( val );

end

--Returns how much the arms are bleeding by
function meta:GetArmsBleeding()

	local val = 0;
	
	val = ( 100 - self:GetField( "hp.Arms"  ) ) * 0.04;
	
	return math.abs( val );

end

--Returns how much the legs are bleeding by
function meta:GetLegsBleeding()

	local val = 0;
	
	val = ( 100 - self:GetField( "hp.Legs" ) ) * .01;
	
	return math.abs( val );

end