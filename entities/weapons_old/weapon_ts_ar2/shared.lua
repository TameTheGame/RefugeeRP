
if( SERVER ) then

	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType = "ar2";

	
	
end

SWEP.PrintName = "Combine Standard Pulse Rifle";

if( CLIENT ) then

	
	SWEP.Slot = 2;
	SWEP.SlotPos = 2;
	SWEP.ViewModelFOV = 60;
	
	SWEP.DrawCrosshair = false;

end

SWEP.Base = "weapon_ts_base";

if( SERVER ) then SWEP.FOVAmt = 20; end

SWEP.InvSize = 3.5;
SWEP.InvWeight = 1;

SWEP.Primary.Sound = Sound( "Weapon_AR2.Single" );

SWEP.WorldModel = "models/weapons/w_irifle.mdl";
SWEP.ViewModel = "models/weapons/v_irifle.mdl";

SWEP.Primary.ClipSize = 30;
SWEP.Primary.DefaultClip = 90;
SWEP.Primary.Ammo = "ar2";
SWEP.Primary.Delay = .09;
SWEP.Primary.Damage = 10;
SWEP.Primary.Force = 2;
SWEP.Primary.RunCone = Vector( 0.05, 0.05, 0 );
SWEP.Primary.SpreadCone = Vector( .015, .015, 0 );
SWEP.Primary.CrouchSpreadCone = Vector( .01, .01, 0 );
SWEP.Primary.ViewPunch = Angle( -0.4, 0.0, 0 );
SWEP.Primary.Automatic = true;

SWEP.IronSightPos = Vector( -6.48, 2.4, -6.0 );
SWEP.IronSightAng = Vector( -1.0, -5.4, 0.0 );

SWEP.ViewPunchStray = true;
SWEP.ViewPunchAdd = Vector( .04, .04, .04 ); 
SWEP.StraySpeed = 1;
