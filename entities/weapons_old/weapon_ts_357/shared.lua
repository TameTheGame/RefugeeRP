

if( SERVER ) then

	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType = "pistol";

end

if( CLIENT ) then

	SWEP.PrintName = "357 Magnum";
	SWEP.Slot = 2;
	SWEP.SlotPos = 3;
	SWEP.ViewModelFlip		= true	
	SWEP.CSMuzzleFlashes	= true
	SWEP.ViewModelFOV		= 60	
	
	SWEP.DrawCrosshair = false;
	
end

SWEP.Base = "weapon_ts_base";

SWEP.ViewModel		= "models/weapons/v_357.mdl"
SWEP.WorldModel		= "models/weapons/w_357.mdl"
SWEP.Primary.Sound			= Sound("Weapon_357.Single")

SWEP.InvSize = 1;
SWEP.InvWeight = 0.5;

SWEP.Primary.ClipSize = 6;
SWEP.Primary.DefaultClip = 24;
SWEP.Primary.Ammo = "pistol";
SWEP.Primary.Delay = .5;
SWEP.Primary.Damage = 10;
SWEP.Primary.Force = 6;
SWEP.Primary.RunCone = Vector( .05, .05, 0 );
SWEP.Primary.SpreadCone = Vector( .035, .035, 0 );
SWEP.Primary.CrouchSpreadCone = Vector( .03, .03, 0 );
SWEP.Primary.ViewPunch = Angle( -0.4, 0.0, 0 );
SWEP.Primary.Automatic = false;


SWEP.IronSightPos 		= Vector( -5.625, 2.55, 0 )
SWEP.IronSightAng 		= Vector( .385, 0, 1 )
