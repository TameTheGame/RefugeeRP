


if( SERVER ) then

	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType = "melee";

end

SWEP.PrintName = "Frag Grenade";

if( CLIENT ) then

	
	SWEP.Slot = 2;
	SWEP.SlotPos = 2;
	SWEP.ViewModelFlip		= false	
	SWEP.CSMuzzleFlashes	= true
	SWEP.ViewModelFOV		= 83	
	
	SWEP.DrawCrosshair = false;
	
end

SWEP.Base = "weapon_ts_base";

SWEP.ViewModel			= "models/weapons/v_fists.mdl";
SWEP.WorldModel			= "models/weapons/w_grenade.mdl"
SWEP.Primary.Sound			= Sound( "Weapon_M3.Single" )
SWEP.Invisible = true;

SWEP.ViewModelFOV		= 83

SWEP.InvSize = 1;
SWEP.InvWeight = 1;

SWEP.Primary.ClipSize = 9999;
SWEP.Primary.DefaultClip = 1;
SWEP.Primary.Ammo = "rpg";
SWEP.Primary.IsFrag = true;
SWEP.Primary.Delay = 1.1;
SWEP.Primary.Damage = 1;
SWEP.Primary.Force = 6;
SWEP.Primary.RunCone = Vector( .07, .07, 0 );
SWEP.Primary.SpreadCone = Vector( .04, .04, 0 );
SWEP.Primary.CrouchSpreadCone = Vector( .03, .03, 0 );
SWEP.Primary.ViewPunch = Angle( -6.5, 0.0, 0 );
SWEP.Primary.Automatic = false;

SWEP.ReloadAtEnd = true;

SWEP.IronSightPos = Vector( 5.8, 2.2, -2.0 );
SWEP.IronSightAng = Vector( 2.0, 0.0, 0.0 );

/*---------------------------------------------------------
   Name: SWEP:Precache( )
   Desc: Use this function to precache stuff
---------------------------------------------------------*/
function SWEP:Precache()
end


SWEP.IsGoingToThrow = false;
SWEP.HeldTime = 0;

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
  function SWEP:PrimaryAttack()
  
  	if( CLIENT ) then return; end
  
  	if( not self:CanShootPrimary() ) then return; end
  
  	if( self.IsGoingToThrow ) then return; end
  
	self.IsGoingToThrow = true;
	self.HeldTime = CurTime();
	
	if( self.Weapon:Clip1() < 1 ) then
	
		self.Owner:RemoveWeapon( self.Weapon:GetClass() );
	
	end
	
  end
  
  function SWEP:SecondaryAttack()
  
  end

function SWEP:Reload()



end

function SWEP:ThrowGrenade( force )

	if( CLIENT ) then return; end
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation

	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation

	self:TakePrimaryAmmo( 1 );
	
	timer.Simple( .2, TS.FragTimedThrow, self, force );
	

end

/*---------------------------------------------------------
   Think does nothing
---------------------------------------------------------*/
function SWEP:Think()

	if( self.IsGoingToThrow ) then

	  	if( not self.Owner:KeyDown( IN_ATTACK ) ) then
	
	  		self.IsGoingToThrow = false;
	  		
	  		self:ThrowGrenade( math.Clamp( ( CurTime() - self.HeldTime ), .3, 1 ) );
	  		
	  		self.Weapon:SetNextPrimaryFire( CurTime() + 1 );
	  		
	  	end

	end

end

