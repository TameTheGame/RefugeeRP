
if( SERVER ) then

	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType = "ar2";
	SWEP.FOVAmt = 70;
	SWEP.NoDrawOnIronSights = true;

end

SWEP.PrintName = "Styer Elite Sniper";

if( CLIENT ) then

	
	SWEP.Slot = 3;
	SWEP.SlotPos = 2;
	SWEP.ViewModelFlip		= true	
	SWEP.CSMuzzleFlashes	= true
	
	SWEP.DrawCrosshair = false;

end

SWEP.Base = "weapon_ts_base";

SWEP.Author			= "JT"
SWEP.Contact		= "http://www.realtimeroleplay.com/"

SWEP.InvSize = 3.2;
SWEP.InvWeight = 2;

SWEP.Primary.Sound = Sound( "weapons/scout/scout_fire-1.wav" );

SWEP.WorldModel = "models/weapons/w_snip_scout.mdl";
SWEP.ViewModel = "models/weapons/v_snip_scout.mdl";

SWEP.Primary.ClipSize = 1;
SWEP.Primary.DefaultClip = 10;
SWEP.Primary.Ammo = "smg1";
SWEP.Primary.Delay = 2;
SWEP.Primary.Damage = 35;
SWEP.Primary.Force = 15;
SWEP.Primary.RunCone = Vector( 0.01, 0.01, 0 );
SWEP.Primary.SpreadCone = Vector( 0.02, 0.02, 0 );
SWEP.Primary.CrouchSpreadCone = Vector( 0.001, 0.001, 0 );
SWEP.Primary.ViewPunch = Angle( -1.75, 0.0, 0 );
SWEP.Primary.Automatic = true;

SWEP.ReloadAtEnd = true;

SWEP.AimSway = true;
SWEP.SwayCone = Vector( .1, .1, 0 );

SWEP.IronSightPos = Vector( -6.4, 2.5, -9.0 );
SWEP.IronSightAng = Vector( 0.0, 0.0, 0.0 );

SWEP.IronSightSound = Sound( "weapons/sniper/sniper_zoomin.wav" );

SWEP.Volume = 80;

if( CLIENT ) then
	SWEP.Mat = Material( "models/weapons/msg-90/vscope" );
end

function SWEP:DrawHUD()
	
	if( self.Weapon:GetNWBool( "ironsights" ) ) then

		surface.SetDrawColor( 0, 0, 0, 255 );
		
		surface.SetMaterial( self.Mat );
		surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() );

	end

end



function weaponremove()
	for _, v in pairs( player.GetAll() ) do
	v:RemoveFromInventory( "weapon_ts_styersniper" )

	end
end
hook.Add( "PlayerDeath", "stydeath", weaponremove )