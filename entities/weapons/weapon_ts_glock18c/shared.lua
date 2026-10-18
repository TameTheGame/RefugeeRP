
if( SERVER ) then

	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType = "pistol";
	
	SWEP.FOVAmt = 0;

end

SWEP.PrintName = "Glock 18C";

if( CLIENT ) then

	
	SWEP.Slot = 2;
	SWEP.SlotPos = 2;

end

SWEP.Base = "weapon_ts_base";

SWEP.Author			= "JT"
SWEP.Contact		= "http://www.realtimeroleplay.com/"

SWEP.Primary.Sound = Sound( "weapons/pistol/pistol_fire3.wav" );

SWEP.WorldModel = "models/weapons/w_pistol.mdl";
SWEP.ViewModel = "models/weapons/v_pistol.mdl";

SWEP.InvSize = 1;
SWEP.InvWeight = 1;

SWEP.Primary.ClipSize = 18;
SWEP.Primary.DefaultClip = 100;
SWEP.Primary.Ammo = "pistol";
SWEP.Primary.Delay = .0375;
SWEP.Primary.Automatic = true;
SWEP.Primary.Damage = 7;
SWEP.Primary.Force = 1;
SWEP.Primary.RunCone = Vector( .1, .1, 0 );
SWEP.Primary.SpreadCone = Vector( .05, .05, 0 );
SWEP.Primary.CrouchSpreadCone = Vector( .03, .03, 0 );
SWEP.Primary.ViewPunch = Angle( .8, .8, 0 );

SWEP.IronSightPos = Vector( -5.8, 3.1, -5.0 );
SWEP.IronSightAng = Vector( 2.0, -1.0, 0.0 );

SWEP.IronSightPos = Vector( 4.33, 2.78, -1 );
SWEP.IronSightAng = Vector( 0.74,0,0 );
	

end

function weaponremove()
	for _, v in pairs( player.GetAll() ) do
	v:RemoveFromInventory( "weapon_ts_glock18c" )

	end
end
hook.Add( "PlayerDeath", "glockdeath", weaponremove )
