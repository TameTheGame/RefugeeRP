
if( SERVER ) then

	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType = "ar2";

	
	
end

if( CLIENT ) then

	SWEP.PrintName = "ACU Chaingun";
	SWEP.Slot = 2;
	SWEP.SlotPos = 2;
	SWEP.ViewModelFOV = 60;
	
	SWEP.DrawCrosshair = true;

end

SWEP.Base = "weapon_ts_base";

if( SERVER ) then SWEP.FOVAmt = 20; end

SWEP.InvSize = 3;
SWEP.InvWeight = 1;

SWEP.Primary.Sound = Sound( "Weapon_AR2.Single" );

SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl";
SWEP.ViewModel = "models/weapons/v_mach_m249para.mdl";

SWEP.Primary.ClipSize = 100;
SWEP.Primary.DefaultClip = 300;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .05;
SWEP.Primary.Damage = 8;
SWEP.Primary.Force = 6;
SWEP.Primary.RunCone = Vector( 0.05, 0.05, 0 );
SWEP.Primary.SpreadCone = Vector( .015, .030, 0 );
SWEP.Primary.CrouchSpreadCone = Vector( .01, .01, 0 );
SWEP.Primary.ViewPunch = Angle( -0.4, 0.0, 0 );
SWEP.Primary.Automatic = true;

SWEP.IronSightPos = Vector( -2.7, 2.0, -3.0 );
SWEP.IronSightAng = Vector( 0.0, 0.0, 0.0 );

SWEP.ViewPunchStray = true;
SWEP.ViewPunchAdd = Vector( .04, .04, .04 ); 
SWEP.StraySpeed = 1;
