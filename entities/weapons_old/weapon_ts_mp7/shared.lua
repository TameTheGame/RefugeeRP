
if( SERVER ) then

	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType = "smg";

end

SWEP.PrintName = "MP7";

if( CLIENT ) then

	
	SWEP.Slot = 2;
	SWEP.SlotPos = 2;
	
	SWEP.DrawCrosshair = false;

end

SWEP.Base = "weapon_ts_base";

SWEP.Primary.Sound = Sound( "Weapon_SMG1.Single" );

SWEP.WorldModel = "models/weapons/w_smg1.mdl";
SWEP.ViewModel = "models/weapons/v_smg1.mdl";

SWEP.InvSize = 2;
SWEP.InvWeight = 1;

SWEP.Primary.ClipSize = 45;
SWEP.Primary.DefaultClip = 90;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = .07;
SWEP.Primary.Damage = 5;
SWEP.Primary.Force = 1;
SWEP.Primary.RunCone = Vector( .07, .07, 0 );
SWEP.Primary.SpreadCone = Vector( .047, .047, 0 );
SWEP.Primary.CrouchSpreadCone = Vector( .03, .03, 0 );
SWEP.Primary.ViewPunch = Angle( -0.4, 0.0, 0 );
SWEP.Primary.Automatic = true;

SWEP.IronSightPos = Vector( -6.4, 2.5, -2.0 );
SWEP.IronSightAng = Vector( 0.0, 0.0, 0.0 );