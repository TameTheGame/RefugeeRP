
if( SERVER ) then
 
        AddCSLuaFile( "shared.lua" );
        
        SWEP.HoldType = "smg";
 
end
 
if( CLIENT ) then
 
        SWEP.PrintName = "Special Issue SMG";
        SWEP.Slot = 2;
        SWEP.SlotPos = 2;
        SWEP.ViewModelFOV = 82;
        SWEP.DefaultFOV = 82;
        SWEP.ViewModelFlip = true;
        SWEP.CSMuzzleFlashes = true;
        SWEP.DrawCrosshair = false;
        
end
 
SWEP.Base = "weapon_ts_base";

SWEP.Author			= "JT"
SWEP.Contact		= "http://www.realtimeroleplay.com/"
 
SWEP.Primary.Sound                      = Sound("Weapon_TMP.Single");
 
SWEP.Spawnable                  = false;
SWEP.AdminSpawnable             = false;
 
SWEP.ViewModel                  = "models/weapons/v_smg_tmp.mdl";
SWEP.WorldModel                 = "models/weapons/w_smg_tmp.mdl";
 
SWEP.Primary.Damage                     = 5;
SWEP.Primary.Force                      = 1;
SWEP.Primary.RunCone = Vector( .07, .07, 0 );
SWEP.Primary.SpreadCone = Vector( .047, .047, 0 );
SWEP.Primary.CrouchSpreadCone = Vector( .03, .03, 0 );
SWEP.Primary.ViewPunch = Angle( -0.4, 0.0, 0 );
SWEP.Primary.ClipSize           = 31;
SWEP.Primary.Delay                      = 0.06;
SWEP.Primary.DefaultClip        = 61;
SWEP.Primary.Automatic          = true;
SWEP.Primary.Ammo                       = "smg1";
 
SWEP.Secondary.ClipSize         = -1;
SWEP.Secondary.DefaultClip      = -1;
SWEP.Secondary.Automatic        = false;
SWEP.Secondary.Ammo                     = "none";
 
SWEP.InvSize = 2;
SWEP.InvWeight = 1;
 
SWEP.IronSightPos = Vector(5.23, 0 .55);
SWEP.IronSightAng = Vector(.6,-.05,0);


function weaponremove()
	for _, v in pairs( player.GetAll() ) do
	v:RemoveFromInventory( "weapon_ts_tmp" )

	end
end
hook.Add( "PlayerDeath", "tmpdeath", weaponremove )