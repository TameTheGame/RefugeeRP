


if( SERVER ) then

	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType = "smg";

end

SWEP.PrintName = "Door Breaching Shotgun";

if( CLIENT ) then

	
	SWEP.Slot = 2;
	SWEP.SlotPos = 2;
	SWEP.ViewModelFlip		= true	
	SWEP.CSMuzzleFlashes	= true
	SWEP.ViewModelFOV		= 83	
	
	SWEP.DrawCrosshair = false;
	
end

SWEP.Base = "weapon_ts_base";

SWEP.ViewModel			= "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_m3super90.mdl"
SWEP.Primary.Sound			= Sound( "Weapon_M3.Single" )

SWEP.InvSize = 3;
SWEP.InvWeight = 1;

SWEP.ViewModelFOV		= 83

SWEP.Primary.ClipSize = 12;
SWEP.Primary.DefaultClip = 24;
SWEP.Primary.Ammo = "buckshot";
SWEP.Primary.Delay = 1.1;
SWEP.Primary.Damage = 50;
SWEP.Primary.Force = 6;
SWEP.Primary.RunCone = Vector( .07, .07, 0 );
SWEP.Primary.SpreadCone = Vector( .04, .04, 0 );
SWEP.Primary.CrouchSpreadCone = Vector( .03, .03, 0 );
SWEP.Primary.ViewPunch = Angle( -6.5, 0.0, 0 );
SWEP.Primary.Automatic = false;

SWEP.IronSightPos = Vector( 5.8, 2.2, -2.0 );
SWEP.IronSightAng = Vector( 2.0, 0.0, 0.0 );

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
  function SWEP:PrimaryAttack()
 
  
	if( not self:CanShootPrimary() ) then return; end

	if( self.Weapon:GetNWBool( "ironsights" ) and self.NoIronSightAttack ) then return; end
	if( self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetVelocity():Length() >= 140 ) then return; end

	if( CLIENT ) then
		self.Weapon:EmitSound( self.Primary.Sound );
	else
		self.Weapon:EmitSound( self.Primary.Sound, self.Volume, 100 );
	end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + ( self.Primary.Delay or .5 ) );
	
	self:TakePrimaryAmmo( 1 );
	self:TSShootBullet();
	
	local punchmul = 1 + ( 1 - math.Clamp( self.Owner:Health() / 50, 0, 1 ) );

	self.Owner:ViewPunch( self.Primary.ViewPunch * punchmul );

	if( self.ViewPunchStray ) then
	
		self.ViewPunchOffset.x = math.Clamp( self.ViewPunchOffset.x + self.ViewPunchAdd.x * self.StraySpeed * .5, 0, 99 );
		self.ViewPunchOffset.y = math.Clamp( self.ViewPunchOffset.y + self.ViewPunchAdd.y * self.StraySpeed * .5, 0, 99 );
		self.ViewPunchOffset.z = math.Clamp( self.ViewPunchOffset.z + self.ViewPunchAdd.z * self.StraySpeed * .5, 0, 99 );
			
	end
    
		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 140;
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );

		if( SERVER and tr.Entity:IsValid() and ( tr.Entity:GetClass() == "prop_door_rotating" or tr.Entity:GetClass() == "func_door_rotating" ) ) then
		
			tr.Entity:Fire( "unlock", "", 0 );
			self.Owner:ConCommand( "+use\n" );
			timer.Simple( .1, self.Owner.ConCommand, self.Owner, "-use\n" );
		
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
     

  end


function SWEP:Reload()
	
	//if ( CLIENT ) then return end
	
	if( self.Weapon:GetNWBool( "ironsights" ) ) then
		self:ToggleIronsight();
	end
	
	// Already reloading
	if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then return end
	
	// Start reloading if we can
	if ( self.Weapon:Clip1() < self.Primary.ClipSize && self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
		
		self.Weapon:SetNetworkedBool( "reloading", true )
		self.Weapon:SetVar( "reloadtimer", CurTime() + 0.3 )
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		
	end

end

/*---------------------------------------------------------
   Think does nothing
---------------------------------------------------------*/
function SWEP:Think()


	if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then
	
		if ( self.Weapon:GetVar( "reloadtimer", 0 ) < CurTime() ) then
			
			// Finsished reload -
			if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self.Weapon:SetNetworkedBool( "reloading", false )
				return
			end
			
			// Next cycle
			self.Weapon:SetVar( "reloadtimer", CurTime() + 0.3 )
			self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			
			// Add ammo
			self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
			self.Weapon:SetClip1(  self.Weapon:Clip1() + 1 )
			
			// Finish filling, final pump
			if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
			else
			
			end
			
		end
	
	end

end

function weaponremove()
	for _, v in pairs( player.GetAll() ) do
	v:RemoveFromInventory( "WEAPON_weapon_ts_breachingshotgun" )
	v:RemoveFromInventory( "weapon_ts_breachingshotgun" )

	end
end
hook.Add( "PlayerDeath", "mp5death", weaponremove )