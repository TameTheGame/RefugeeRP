

if( SERVER ) then

	AddCSLuaFile( "shared.lua" );

end

SWEP.PrintName = "Keys";

if( CLIENT ) then


	SWEP.Slot = 1;
	SWEP.SlotPos = 1;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;

end

// Variables that are used on both client and server

SWEP.Author			= "Rick Darkaliono"
SWEP.Instructions	= "Left click to lock. Right click to unlock"
SWEP.Contact		= "http://tacoandbanana.com/forums/"
SWEP.Purpose		= ""
SWEP.Invisible = true;

SWEP.ViewModel = Model( "models/weapons/v_fists.mdl" );
SWEP.WorldModel = Model( "models/weapons/w_fists.mdl" );

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.AnimPrefix		= "rpg"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true
  
SWEP.Sound = "doors/door_latch3.wav";
  
SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= ""

SWEP.InvSize = 0;
SWEP.InvWeight = 0;

/*---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()

	if( SERVER ) then
	
		self:SetWeaponHoldType( "normal" );
	
	end

end


/*---------------------------------------------------------
   Name: SWEP:Precache( )
   Desc: Use this function to precache stuff
---------------------------------------------------------*/
function SWEP:Precache()
end

function SWEP:Deploy()

	if( SERVER ) then

		self.Owner:DrawViewModel( false );
		self.Owner:DrawWorldModel( false );
		self.Weapon:SetNextPrimaryFire( CurTime() );
		self.Weapon:SetNextSecondaryFire( CurTime() );
		
	end

end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
  function SWEP:PrimaryAttack()
  
	if( CLIENT ) then return; end

 	local trace = self.Owner:GetEyeTrace();

 	if( not trace.Entity:IsValid() or not trace.Entity:IsOwnable() or self.Owner:EyePos():Distance( trace.Entity:GetPos() ) > 65 ) then
 		return;
	end

	local state = trace.Entity:GetNWInt( "doorstate" );

	if( trace.Entity:OwnsDoor( self.Owner ) or ( ( state == 3 or state == 6 ) and self.Owner:IsCombine() ) ) then
	
		trace.Entity:Fire( "lock", "", 0 );
		
		self.Owner:EmitSound( self.Sound );
		self.Weapon:SetNextPrimaryFire( CurTime() + 1.0 );
		
	else
	
		TS.Notify( self.Owner, "You don't own this!", 4 );
		
		self.Weapon:SetNextPrimaryFire( CurTime() + .5 );
	
	end

  end
 
  /*---------------------------------------------------------
  SecondaryAttack
  ---------------------------------------------------------*/
  function SWEP:SecondaryAttack()
  
	if( CLIENT ) then return; end

 	local trace = self.Owner:GetEyeTrace();

 	if( not trace.Entity:IsValid() or not trace.Entity:IsOwnable() or self.Owner:EyePos():Distance( trace.Entity:GetPos() ) > 65 ) then
 		return;
	end

	
	local state = trace.Entity:GetNWInt( "doorstate" );

	if( trace.Entity:OwnsDoor( self.Owner ) or ( ( state == 3 or state == 6 ) and self.Owner:IsCombine() ) ) then
	
		trace.Entity:Fire( "unlock", "", 0 );

		self.Owner:EmitSound( self.Sound );
		self.Weapon:SetNextSecondaryFire( CurTime() + 1.0 );
		
	else
	
		TS.Notify( self.Owner, "You don't own this!", 4 );
		
		self.Weapon:SetNextSecondaryFire( CurTime() + .5 );
	
	end
 
  end 
