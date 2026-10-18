

if( SERVER ) then

	AddCSLuaFile( "shared.lua" );

end

SWEP.PrintName = "God Hand";

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

SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= ""

SWEP.Primary.RunCone = Vector( 0, 0, 0 );
SWEP.Primary.SpreadCone = Vector( 0, 0, 0 );
SWEP.Primary.CrouchSpreadCone = Vector( 0, 0, 0 );
SWEP.Primary.ViewPunch = Angle( 0, 0, 0 );
SWEP.Primary.Automatic = false;

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
	
		self.Owner:StripWeapon( "weapon_ts_godhand" );
	
	end
	
	self.Weapon:SetNWInt( "GunMode", self.GunMode, 0 );


end


/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
  function SWEP:PrimaryAttack()

	if( CLIENT ) then
		self.GunMode = self.Weapon:GetNWInt( "GunMode" );
	end
	
	if( self.GunMode == 3 ) then
		
		if( CLIENT ) then return; end
		
		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + 4096 * self.Owner:GetAimVector();
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );
		
		if( tr.Entity:IsValid() and ( tr.Entity:GetClass() == "prop_physics" or tr.Entity:GetClass() == "player" ) ) then

			if( true ) then
				tr.Entity:GetPhysicsObject():SetVelocity( ( self.Owner:GetUp() * 500 + self.Owner:GetForward() * 1000 ) );
			else
				tr.Entity:GetPhysicsObject():SetVelocity( self.Owner:GetUp() * 20000 + self.Owner:GetForward() * 20000 );
			end
			
		end
	
		return;
	
	elseif( self.GunMode == 5 ) then
	
		if( CLIENT ) then return; end
	
		local ents = ents.FindInSphere( self.Owner:GetPos(), 150 );
		
		for k, v in pairs( ents ) do
		
			if( v ~= self.Owner and v:IsValid() and v:IsPlayer() ) then
					
				if( v:GetPhysicsObject():IsValid() ) then

					umsg.Start( "DamageFlash", v );
						umsg.Short( 0 );
						umsg.Short( 165 );
						umsg.Short( 255 );
						umsg.Short( 255 );
						umsg.Float( .5 );
					umsg.End();
					
					umsg.Start( "DoBlurHit", v );
						umsg.Float( 2 );
					umsg.End();

					v:SetVelocity( ( v:GetPos() - self.Owner:GetPos() ):Normalize() * 250 + self.Owner:GetUp() * 300 );
				
				end
				
			end
		
		end
	
		return;
	
	elseif( self.GunMode == 6 ) then
	
		if( SERVER ) then
	
			local trace = { }
			trace.start = self.Owner:EyePos();
			trace.endpos = trace.start + 4096 * self.Owner:GetAimVector();
			trace.filter = self.Owner;
			
			local tr = util.TraceLine( trace );
			
			if( tr.Entity:IsValid() and tr.Entity:IsPlayer() ) then
	
				tr.Entity:MakeBleed();
				
				tr.Entity:SetBleedAmount( tr.Entity:GetBleedAmount() + 3 );
						
			end
			
		end
	
		return;
	
	elseif( self.GunMode == 7 ) then
		  
		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 4096;
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );

		if( CLIENT ) then return; end
		
		if( tr.Entity:IsValid() and ( tr.Entity:GetClass() == "func_door" or tr.Entity:GetClass() == "prop_door_rotating" or tr.Entity:GetClass() == "func_door_rotating" ) ) then
		
			tr.Entity:Fire( "unlock", "", 0 );
			tr.Entity:Fire( "toggle", "", 0 );
		
		end

		if( tr.Entity:IsValid() and tr.Entity:GetClass() == "prop_door_rotating" ) then
		
			
		
			if( true ) then
			
				tr.Entity:EmitSound( Sound(  "physics/wood/wood_box_impact_hard3.wav" ) );
			
				if( SERVER ) then

					local pos = tr.Entity:GetPos();
					local ang = tr.Entity:GetAngles();
					local model = tr.Entity:GetModel();
					local skin = tr.Entity:GetSkin();
					
					tr.Entity:SetNotSolid( true );
					tr.Entity:SetNoDraw( true );
					
					local function ResetDoor( door, fakedoor )
						door:SetNotSolid( false );
						door:SetNoDraw( false );
						fakedoor:Remove();
					end
					
					local norm = ( pos - self.Owner:GetPos() ):Normalize();
					local push = 10000 * norm;


					local ent = ents.Create( "prop_physics" );
					ent:SetPos( pos );
					ent:SetAngles( ang );
					ent:SetModel( model );
					if( skin ) then
						ent:SetSkin( skin );
					end
					ent:Spawn();
					
					timer.Simple( .2, ent.SetVelocity, ent, push );					
					timer.Simple( .2, ent:GetPhysicsObject().ApplyForceCenter, ent:GetPhysicsObject(), push );
																
					timer.Simple( 300, ResetDoor, tr.Entity, ent );
					
				end

			end
		
		end
		
		return;
	
	elseif( self.GunMode == 8 ) then
	
		if( CLIENT ) then return; end
	
		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 4096;
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );
	
		if( tr.Entity and tr.Entity:IsValid() ) then
			
			tr.Entity:GetPhysicsObject():EnableMotion( true );
 			tr.Entity:GetPhysicsObject():Wake();
			
			constraint.RemoveAll( tr.Entity );
			
			local norm = ( tr.Entity:GetPos() - self.Owner:GetPos() ):Normalize();
			local push = 500 * norm;
			
			tr.Entity:GetPhysicsObject():SetVelocity( push );

		end
		
		return;
	
	elseif( self.GunMode == 9 ) then
	
		if( SERVER ) then
	
			local trace = { }
			trace.start = self.Owner:EyePos();
			trace.endpos = trace.start + 4096 * self.Owner:GetAimVector();
			trace.filter = self.Owner;
			
			local tr = util.TraceLine( trace );
			
			if( tr.Entity:IsValid() and tr.Entity:IsPlayer() ) then
	
			    tr.Entity:SetNWFloat( "conscious", 0 );
	     		tr.Entity:GoUnconscious();
	     		
	     	end
	     	
	     end
	     
	     return;
	
	elseif( self.GunMode == 10 ) then
	
		if( CLIENT ) then return; end
		
		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + 4096 * self.Owner:GetAimVector();
		trace.filter = self.Owner;
	
		local tr = util.TraceLine( trace );
	
		for n = 1, 6 do
	
			local pos = tr.HitPos + Vector( math.random( -400, 400 ), math.random( -400, 400 ), math.random( -400, 400 ) );
	
			local exp = ents.Create( "env_explosion" );
				exp:SetKeyValue( "spawnflags", 128 );
				exp:SetPos( pos );
			exp:Spawn();
			exp:Fire( "explode", "", 0 );
		
			local exp = ents.Create( "env_physexplosion" )
				exp:SetKeyValue( "magnitude", 150 )
				exp:SetPos( pos );
			exp:Spawn();
			exp:Fire( "explode", "", 0 );
			
			timer.Simple( 1.0, exp.Remove, exp );
			
		end
		
		return;
			
	elseif( self.GunMode == 11 ) then
	
		if( CLIENT ) then return; end
		
		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + 4096 * self.Owner:GetAimVector();
		trace.filter = self.Owner;
	
		local tr = util.TraceLine( trace );
	
		for n = 1, 6 do
	
			local pos = tr.HitPos + Vector( math.random( -150, 150 ), math.random( -150, 150 ), math.random( -150, 150 ) );
	
			local exp = ents.Create( "env_explosion" );
				exp:SetKeyValue( "spawnflags", 128 );
				exp:SetPos( pos );
			exp:Spawn();
			exp:Fire( "explode", "", 0 );
		
			--timer.Simple( 1.0, exp.Remove, exp );
		
			local exp = ents.Create( "env_physexplosion" );
				exp:SetKeyValue( "magnitude", 150 );
				exp:SetPos( pos );
			exp:Spawn();
			exp:Fire( "explode", "", 0 );
			
			timer.Simple( 1.0, exp.Remove, exp );
			
		end
		
		return;
	
	end


	self:TSShootBullet();


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
  	
		self.Primary.RunCone = Vector( 1, 1, 1 );
		self.Primary.SpreadCone = Vector( 1, 1, 1 );
		self.Primary.CrouchSpreadCone = Vector( 1, 1, 1 );
		
	elseif( self.GunMode == 3 ) then
		
	elseif( self.GunMode == 4 ) then
	
		self.Primary.RunCone = Vector( .2, .2, .2 );
		self.Primary.SpreadCone = Vector( .2, .2, .2 );
		self.Primary.CrouchSpreadCone = Vector( .2, .2, .2 );		
		
	elseif( self.GunMode == 5 ) then
	
	elseif( self.GunMode == 6 ) then
		
	elseif( self.GunMode == 7 ) then
		
  	elseif( self.GunMode == 8 ) then
  	
  	elseif( self.GunMode == 9 ) then
  	
	elseif( self.GunMode == 10 ) then
	
	elseif( self.GunMode == 11 ) then
	
  	elseif( self.GunMode > 0 ) then
  	
  		self.GunMode = 1;
		self.Primary.RunCone = Vector( 0, 0, 0 );
		self.Primary.SpreadCone = Vector( 0, 0, 0 );
		self.Primary.CrouchSpreadCone = Vector( 0, 0, 0 );
  	
  	else --The last gun mode
  	
  		self.GunMode = 11;
  	
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

		modename = "Bullet Punch";

	elseif( self.GunMode == 2 ) then
	
		modename = "Metal Field";
	
	elseif( self.GunMode == 3 ) then
	
		modename = "Force Push";
		
	elseif( self.GunMode == 4 ) then
	
		modename = "Shotgun";
	
	elseif( self.GunMode == 5 ) then
	
		modename = "Release";
	
	elseif( self.GunMode == 6 ) then
	
		modename = "Insides Destroyer";
	
	elseif( self.GunMode == 7 ) then
	
		modename = "Door Opener";
	
	elseif( self.GunMode == 8 ) then
	
		modename = "Prop Breacher";
	
	elseif( self.GunMode == 9 ) then
	
		modename = "Knock Out";
	
	elseif( self.GunMode == 10 ) then
	
		modename = "Bigger Hell";
		
	elseif( self.GunMode == 11 ) then
	
		modename = "Smaller Hell";
	
	end

	draw.DrawText( modename, "GModToolName", ScrW() - 4, 11, Color( 0, 0, 0, 255 ), 2 );
	draw.DrawText( modename, "GModToolName", ScrW() - 5, 10, Color( 255, 255, 255, 255 ), 2 );

	draw.DrawText( "^", "TargetID", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, 255 ), 1, 1 );

end

