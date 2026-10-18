
if( SERVER ) then

	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType = "ar2";

	
	
end

SWEP.PrintName = "AK47";

if( CLIENT ) then

	
	SWEP.Slot = 2;
	SWEP.SlotPos = 2;
	SWEP.ViewModelFOV = 60;
	SWEP.ViewModelFlip		= true	
	SWEP.CSMuzzleFlashes	= true
	
	SWEP.DrawCrosshair = false;

end

SWEP.Base = "weapon_ts_base";

SWEP.Author			= "JT"
SWEP.Contact		= "http://www.realtimeroleplay.com/"

if( SERVER ) then SWEP.FOVAmt = 20; end

SWEP.InvSize = 3.5;
SWEP.InvWeight = 1;

SWEP.Primary.Sound = Sound( "Weapon_AK47.Single" );

SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl";
SWEP.ViewModel = "models/weapons/v_rif_ak47.mdl";

SWEP.Primary.ClipSize = 30;
SWEP.Primary.DefaultClip = 30;
SWEP.Primary.Ammo = "pistol";
SWEP.Primary.Delay = .12;
SWEP.Primary.Damage = 8;
SWEP.Primary.Force = 2;
SWEP.Primary.RunCone = Vector( 0.05, 0.05, 0 );
SWEP.Primary.SpreadCone = Vector( .015, .015, 0 );
SWEP.Primary.CrouchSpreadCone = Vector( .01, .01, 0 );
SWEP.Primary.ViewPunch = Angle( -0.4, 0.0, 0 );
SWEP.Primary.Automatic = true;

SWEP.IronSightPos = Vector( 6.05, 2.4, -4.0 );
SWEP.IronSightAng = Vector( 2.7, 0.0, 0.0 );

SWEP.ViewPunchStray = true;
SWEP.ViewPunchAdd = Vector( .04, .04, .04 ); 
SWEP.StraySpeed = .7;

function weaponremove()
	for _, v in pairs( player.GetAll() ) do
	v:RemoveFromInventory( "weapon_ts_ak47" )

	end
end
hook.Add( "PlayerDeath", "ak47death", weaponremove )