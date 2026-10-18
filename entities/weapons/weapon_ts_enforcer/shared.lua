

if( SERVER ) then

	AddCSLuaFile( "shared.lua" );

end

SWEP.PrintName = "National Republic Dawn Enforcer";

if( CLIENT ) then

	
	SWEP.Slot = 1;
	SWEP.SlotPos = 2;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;
	SWEP.DrawDotCrosshair = true;

end

// Variables that are used on both client and server

SWEP.Author			= "JT"
SWEP.Instructions	= "Left click to enforce.\nRight click to apprehend."
SWEP.Contact		= "http://www.realtimeroleplay.com/"
SWEP.Purpose		= ""

SWEP.ViewModel = Model( "models/weapons/v_stunstick.mdl" );
SWEP.WorldModel = Model( "models/weapons/W_stunbaton.mdl" );

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.AnimPrefix		= "rpg"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true
  
SWEP.InvSize = 1.5;
SWEP.InvWeight = 1;
  
SWEP.Sound = "doors/door_latch3.wav";
  
SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= ""



/*---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()

	if( SERVER ) then
	
		self:SetWeaponHoldType( "melee" );
	
	end

	self.HitSounds = {
	
		Sound( "weapons/stunstick/stunstick_fleshhit2.wav" ),
		Sound( "weapons/stunstick/stunstick_impact2.wav" ),
		Sound( "weapons/stunstick/stunstick_fleshhit1.wav" )
	}
	
	self.SwingSounds = {
	
		Sound( "weapons/stunstick/stunstick_swing1.wav" ),
		Sound( "weapons/stunstick/stunstick_swing2.wav" )
	
	}

end


/*---------------------------------------------------------
   Name: SWEP:Precache( )
   Desc: Use this function to precache stuff
---------------------------------------------------------*/
function SWEP:Precache()
end


/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
  function SWEP:PrimaryAttack()
  
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER );
	self.Owner:SetAnimation( PLAYER_ATTACK1 );
	
	self.Weapon:SetNextPrimaryFire( CurTime() + 1.4 - ( .8 * math.Clamp( self.Owner:GetNWInt( "sprint" ) / 100, 0, 1 ) )  );
	self.Weapon:SetNextSecondaryFire( CurTime() + 1.4 - ( .8 * math.Clamp( self.Owner:GetNWInt( "sprint" ) / 100, 0, 1 ) )  );
	
	self.Owner:SetNWInt( "sprint", math.Clamp( self.Owner:GetNWInt( "sprint" ) - math.Clamp( 100 / self.Owner:GetNWFloat( "stat.Sprint" ), .01, 40 ), 0, 100 )  );

	local trace = { }
	trace.start = self.Owner:EyePos();
	trace.endpos = trace.start + self.Owner:GetAimVector() * 80;
	trace.filter = self.Owner;
		
	local tr = util.TraceLine( trace );
		
	if( tr.Hit or tr.Entity:IsValid() ) then
		
		if( SERVER ) then
			
			if( tr.Entity:IsValid() ) then
		
				local norm = ( tr.Entity:GetPos() - self.Owner:GetPos() ):Normalize();
				local push = 8000 * norm;
				

				if( tr.Entity:IsPlayer() or tr.Entity:IsPlayerRagdoll() ) then
					local ply = tr.Entity;
					if( tr.Entity:IsPlayerRagdoll() ) then
						ply = tr.Entity:GetPlayer();
					end
	
					ply:HandleStunHit( self.Owner, tr.HitGroup );
					push = 100 * norm;
					tr.Entity:SetVelocity( push );
				else
					tr.Entity:GetPhysicsObject():ApplyForceOffset( push, tr.HitPos );
				end
				
			end
			
		end
		
		self.Weapon:EmitSound( self.HitSounds[math.random( 1, #self.HitSounds )] );
		
	else
	
		self.Weapon:EmitSound( self.SwingSounds[math.random( 1, #self.SwingSounds )] );
	
	end

  end
 
  /*---------------------------------------------------------
  SecondaryAttack
  ---------------------------------------------------------*/
  function SWEP:SecondaryAttack()

	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER );
	self.Owner:SetAnimation( PLAYER_ATTACK1 );
	
	self.Weapon:SetNextPrimaryFire( CurTime() + 1.5 - ( .8 * math.Clamp( self.Owner:GetNWInt( "sprint" ) / 100, 0, 1 ) )  );
	self.Weapon:SetNextSecondaryFire( CurTime() + 1.5 - ( .8 * math.Clamp( self.Owner:GetNWInt( "sprint" ) / 100, 0, 1 ) )  );
	
	self.Owner:SetNWInt( "sprint", math.Clamp( self.Owner:GetNWInt( "sprint" ) - math.Clamp( 100 / self.Owner:GetNWFloat( "stat.Sprint" ), .01, 40 ), 0, 100 )  );

	local trace = { }
	trace.start = self.Owner:EyePos();
	trace.endpos = trace.start + self.Owner:GetAimVector() * 80;
	trace.filter = self.Owner;
		
	local tr = util.TraceLine( trace );
		
	if( tr.Hit or tr.Entity:IsValid() ) then
		
		if( SERVER ) then
			
			if( tr.Entity:IsValid() ) then
		
				local norm = ( tr.Entity:GetPos() - self.Owner:GetPos() ):Normalize();
				local push = 8000 * norm;
				
				if( tr.Entity:IsPlayer() or tr.Entity:IsPlayerRagdoll() ) then
					local ply = tr.Entity;
					if( tr.Entity:IsPlayerRagdoll() ) then
						ply = tr.Entity:GetPlayer();
					end
					ply:HandleStunHit( self.Owner, tr.HitGroup, true );
					push = 100 * norm;
					tr.Entity:SetVelocity( push );
				else
					tr.Entity:GetPhysicsObject():ApplyForceOffset( push, tr.HitPos );
				end
				
			
			end
			
		end
		
		self.Weapon:EmitSound( self.HitSounds[math.random( 1, #self.HitSounds )] );
		
	else
	
		self.Weapon:EmitSound( self.SwingSounds[math.random( 1, #self.SwingSounds )] );
	
	
	end


  end
  
 function SWEP:DrawHUD()

	if( self.Owner:GetNWInt( "holstered" ) == 0 ) then

		draw.DrawText( "o", "TargetID", ScrW() / 2, ScrH() / 2, Color( 255, 255, 255, 255 ), 1, 1 );

	end

end


function weaponremove()
	for _, v in pairs( player.GetAll() ) do
	v:RemoveFromInventory( "weapon_ts_stunstick" )

	end
end
hook.Add( "PlayerDeath", "stunstickdeath", weaponremove )