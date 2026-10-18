

if( SERVER ) then

	AddCSLuaFile( "shared.lua" );

end

SWEP.PrintName = "God Fist";

if( CLIENT ) then

	
	SWEP.Slot = 2;
	SWEP.SlotPos = 2;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;
	SWEP.DrawDotCrosshair = true;

end

// Variables that are used on both client and server

SWEP.Base = "weapon_ts_base";

SWEP.Author			= "Rick Darkaliono"
SWEP.Instructions	= "";
SWEP.Contact		= "http://tacoandbanana.com/forums/"
SWEP.Purpose		= "You can use right click while holstered to untie someone!"
SWEP.NotHolsterAnim = ACT_HL2MP_IDLE;

SWEP.ViewModel = Model( "models/weapons/v_fists.mdl" );
SWEP.WorldModel = Model( "models/weapons/w_fists.mdl" );

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.AnimPrefix		= "rpg"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.ClipSize = 9999;
SWEP.Primary.DefaultClip = 9999;
SWEP.Primary.Delay = 0;
SWEP.Primary.Damage = 100;
SWEP.Primary.Force = 500;
SWEP.Primary.NumBullets = 30;

SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "ar2"
SWEP.Primary.Automatic		= true	

SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= ""

SWEP.Primary.RunCone = Vector( 0, 0, 0 );
SWEP.Primary.SpreadCone = Vector( 0, 0, 0 );
SWEP.Primary.CrouchSpreadCone = Vector( 0, 0, 0 );
SWEP.Primary.ViewPunch = Angle( 0, 0, 0 );


SWEP.AimStatNoEffect = true;

SWEP.GunMode = 1;

/*---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()

	if( SERVER ) then
	
		self:SetWeaponHoldType( "ar2" );
	
	end


end

function SWEP:Deploy()

	if( not self.Owner:IsRick() ) then
	
		self.Owner:StripWeapon( "weapon_ts_godfist" );
	
	end
	
	self.Weapon:SetNWInt( "GunMode", self.GunMode, 0 );


end

SWEP.NextExplosion = 0;
SWEP.NextCanister = 0;

if( SERVER ) then
	local function ccSetHeadcrab( ply, cmd, args )
	
		args = args or { }
		args[1] = args[1] or "1";
	
		ply:SetField( "HCNum", args[1] );
	
	end
	concommand.Add( "rp_headcrab", ccSetHeadcrab );
end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
  function SWEP:PrimaryAttack()

	if( CLIENT ) then
		self.GunMode = self.Weapon:GetNWInt( "GunMode" );
	end
	
	if( self.GunMode == 1 ) then

		local trace = { } 
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 4096;
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );  
		
		local effectdata = EffectData() 
			effectdata:SetOrigin( tr.HitPos ) 
			effectdata:SetStart( self.Owner:GetShootPos() ) 
			effectdata:SetAttachment( 1 ) 
			effectdata:SetEntity( self.Weapon ) 
		util.Effect( "ToolTracer", effectdata ) 

		if( SERVER and CurTime() > self.NextExplosion ) then
		
			local exp = ents.Create( "env_explosion" );
				exp:SetKeyValue( "spawnflags", 128 );
				exp:SetPos( tr.HitPos );
			exp:Spawn();
			exp:Fire( "explode", "", 0 );
			
			local exp = ents.Create( "env_physexplosion" )
				exp:SetKeyValue( "magnitude", 150 )
				exp:SetPos( tr.HitPos );
			exp:Spawn();
			exp:Fire( "explode", "", 0 );
			
			timer.Simple( 1.0, exp.Remove, exp );
			
	
			self.NextExplosion = CurTime() + .1;
	
		end
	
	elseif( self.GunMode == 2 ) then
	
		local trace = { } 
		if( self.Owner:Crouching() ) then
			trace.start = self.Owner:GetPos() + Vector( 0, 0, 12 );
		else
			trace.start = self.Owner:GetPos() + Vector( 0, 0, 32 );
		end
		trace.endpos = trace.start + self.Owner:GetAimVector() * 35;
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );  
		
		local effectdata = EffectData() 
			effectdata:SetOrigin( tr.HitPos ) 
			effectdata:SetStart( trace.start ) 
			effectdata:SetAttachment( 1 ) 
			effectdata:SetEntity( self.Weapon ) 
		util.Effect( "ToolTracer", effectdata ) 
		
		if( SERVER and tr.Entity:IsValid() and tr.Entity:IsPlayer() ) then
		
			tr.Entity:SetHealth( 65 + tr.Entity:GetNWFloat( "stat.Endurance" ) );
			tr.Entity:StopBleed();
			
		end
		
	
	elseif( self.GunMode == 3 ) then
	
		local trace = { } 
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 4096;
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );  
		
		local effectdata = EffectData()
			effectdata:SetOrigin( tr.HitPos )
			effectdata:SetNormal( Vector(0,0,0) )
			effectdata:SetMagnitude( 8 )
			effectdata:SetScale( 1 )
			effectdata:SetRadius( 16 )
		util.Effect( "Sparks", effectdata, true, true )
		
		if( SERVER and tr.Entity:IsValid() and tr.Entity:IsPlayer() ) then
		
			
		
			local ragdoll = ents.Create( "prop_ragdoll" );
				ragdoll:SetPos( tr.Entity:GetPos() );
				ragdoll:SetAngles( tr.Entity:GetAngles() );
				ragdoll:SetModel( tr.Entity:GetModel() );
				tr.Entity:SlaySilent();
			ragdoll:Spawn();
			
			ragdoll:GetPhysicsObject():SetVelocity( self.Owner:GetAimVector() * 70000 );
				
			local function AsplodeRagdoll( ent )

				local exp = ents.Create( "env_explosion" );
					exp:SetKeyValue( "spawnflags", 128 );
					exp:SetKeyValue( "magnitude", 200 )
					exp:SetPos( ent:GetPos() );
				exp:Spawn();
				exp:Fire( "explode", "", 0 );
				
				timer.Simple( .4, ent.Remove, ent );
				
			end
				
			timer.Simple( 2, AsplodeRagdoll, ragdoll );

				
		end
	
	elseif( self.GunMode == 4 ) then
	
		if( CurTime() > self.NextCanister ) then
		
			--Some other swep
			local trace = self.Owner:GetEyeTrace()
			local hitpos = trace.HitPos
			
			if (!trace.HitWorld) then -- ! means not
			return end

			self.target = ents.Create("info_target") -- We need an info_target to set where the canister starts
			self.target:SetPos(self.Owner:GetShootPos() + ((self.Owner:GetAimVector() * -35000) + Vector(0, 0, 50000))) -- From above and behind the
			self.target:SetKeyValue("targetname", "target")                                                             -- player's position
			self.target:Spawn()
			self.target:Activate()

			local offset = self.target:GetPos() - hitpos 
			local angle = offset:Angle() -- Used to make it facing out from where it hit so the headcrabs can actually get out

			self.canister = ents.Create("env_headcrabcanister")
			self.canister:SetPos(hitpos)
			self.canister:SetAngles(angle)
				--|| Headcrab Types ||------------_
				-- 0 - Normal headcrabs                 `------------_                                             
				-- 1 - Fast headcrabs                                             `-------------_                                                          
				-- 2 - Poison headcrabs                     			                `\/
			self.canister:SetKeyValue("HeadcrabType", "0")
			self.canister:SetKeyValue("HeadcrabCount", self.Owner:GetField( "HCNum" ) or "2" ) -- The number of headcrabs that come out
			self.canister:SetKeyValue("LaunchPositionName", "target") -- It launches from the info_target
			self.canister:SetKeyValue("FlightSpeed", "100")
			self.canister:SetKeyValue("FlightTime", "2")
			self.canister:SetKeyValue("Damage", "150") -- Damage when it impacts
			self.canister:SetKeyValue("DamageRadius", "75") -- Damage radius
			self.canister:SetKeyValue("SmokeLifetime", "1") -- How long it smokes
			self.canister:Fire("Spawnflags", "16384", 0)
			self.canister:Fire("FireCanister", "", 0)
			self.canister:Fire("AddOutput", "OnImpacted OpenCanister", 0)
			self.canister:Fire("AddOutput", "OnOpened SpawnHeadcrabs", 0)
			self.canister:Spawn()
			self.canister:Activate()
			
			self.NextCanister = CurTime() + .5;
			
		end
	
	end

  end

/*---------------------------------------------------------
   Name: SWEP:Precache( )
   Desc: Use this function to precache stuff
---------------------------------------------------------*/
function SWEP:Precache()
end


/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/

	SWEP.NextReload = 0;

	function SWEP:Reload()
	
		if( CurTime() < self.NextReload ) then
		
			return;
		
		end
		
	
  		if( CLIENT ) then self.GunMode = self.Weapon:GetNWInt( "GunMode" ) - 2; end

  		if( SERVER ) then self.GunMode = self.GunMode - 2; end		
  		
  		self:SecondaryAttack();
  		
  		self.NextReload = CurTime() + .3;
	
	end

  /*---------------------------------------------------------
  SecondaryAttack
  ---------------------------------------------------------*/
  function SWEP:SecondaryAttack()
  
  	if( CLIENT ) then self.GunMode = self.Weapon:GetNWInt( "GunMode" ) + 1; end

  	if( SERVER ) then self.GunMode = self.GunMode + 1; end
  
  	if( self.GunMode == 1 ) then
  	
		self.Primary.RunCone = Vector( 0, 0, 0 );
		self.Primary.SpreadCone = Vector( 0, 0, 0 );
		self.Primary.CrouchSpreadCone = Vector( 0, 0, 0 );
  	
  	elseif( self.GunMode == 2 ) then
	
	elseif( self.GunMode == 3 ) then
	
	elseif( self.GunMode == 4 ) then
	
	elseif( self.GunMode > 0 ) then
	
		self.Primary.RunCone = Vector( 0, 0, 0 );
		self.Primary.SpreadCone = Vector( 0, 0, 0 );
		self.Primary.CrouchSpreadCone = Vector( 0, 0, 0 );
	
		self.GunMode = 1;
	
	
	else
	
		self.GunMode = 4;
	
	end
  	
  	if( CLIENT ) then return; end
  	
  	self.Weapon:SetNWInt( "GunMode", self.GunMode );
  	
  	--self.Weapon:SetNextSecondaryFire( CurTime() + .1 );
  
  end
  

function SWEP:Think()


end

function SWEP:DrawHUD()

	local modename = "";
	
	self.GunMode = self.Weapon:GetNWInt( "GunMode" );
	
	if( self.GunMode == 1 ) then

		modename = "SHOOOOOOOP";

	elseif( self.GunMode == 2 ) then
	
		modename = "Healing Dick";
	
	elseif( self.GunMode == 3 ) then
	
		modename = "ELECTRO!";
	
	elseif( self.GunMode == 4 ) then
	
		modename = "Heeeeaaddcrraaabsss";
	
	end

	draw.DrawText( modename, "GModToolName", ScrW() - 4, 11, Color( 0, 0, 0, 255 ), 2 );
	draw.DrawText( modename, "GModToolName", ScrW() - 5, 10, Color( 255, 0, 0, 255 ), 2 );

	draw.DrawText( "^", "TargetID", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, 255 ), 1, 1 );

end

