

if( SERVER ) then

	AddCSLuaFile( "shared.lua" );

end

SWEP.PrintName = "Hands";

if( CLIENT ) then

	
	SWEP.Slot = 0;
	SWEP.SlotPos = 1;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;
	SWEP.DrawDotCrosshair = true;

end

// Variables that are used on both client and server

SWEP.Base = "weapon_ts_base";

SWEP.Author			= "Rick Darkaliono"
SWEP.Instructions	= "Left click (holstered) - Knock On Door\nLeft click (unholstered) - Throw a punch\nRight click (holstered) - Untie\nRight click (unholstered) - Block\nReload (Unholstered) - Ram a door"
SWEP.Contact		= "http://tacoandbanana.com/forums/"
SWEP.Purpose		= "You can use right click while holstered to untie someone!"
SWEP.NotHolsterAnim = ACT_HL2MP_IDLE;

SWEP.ViewModel = Model( "models/weapons/v_fists.mdl" );
SWEP.WorldModel = Model( "models/weapons/w_fists.mdl" );

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.AnimPrefix		= "rpg"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.InvSize = 0;
SWEP.InvWeight = 0;
  
  
SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= ""

SWEP.IronSightPos = Vector( 0, 6.2, -8.0 );
SWEP.IronSightAng = Vector( -4, 0, 0.0 );
SWEP.NoIronSightFovChange = true;
SWEP.NoIronSightAttack = true;

SWEP.LastDoorKick = 0;

SWEP.Untying = false;

/*---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()

	if( SERVER ) then
	
		self:SetWeaponHoldType( "ar2" );
	
	end

	self.HitSounds = {
	
		Sound( "npc/vort/foot_hit.wav" ),
		Sound( "weapons/crossbow/hitbod1.wav" ),
		Sound( "weapons/crossbow/hitbod2.wav" )
	}
	
	self.SwingSounds = {
	
		Sound( "npc/vort/claw_swing1.wav" ),
		Sound( "npc/vort/claw_swing2.wav" )
	
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
  
  	if( self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetVelocity():Length() >= 140 ) then return; end
  	
  	local trace = { }
	trace.start = self.Owner:EyePos();
	trace.endpos = trace.start + self.Owner:GetAimVector() * 60;
	trace.filter = self.Owner;
  	
  	local tr = util.TraceLine( trace );
  	
  	if( self.Owner:GetNWInt( "holstered" ) == 0 ) then
  
	  	if( self.Weapon:GetNWBool( "ironsights" ) ) then return; end
	  
		self.Weapon:EmitSound( self.SwingSounds[math.random( 1, #self.SwingSounds )] );
		
		self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
		
		self.Weapon:SetNextPrimaryFire( CurTime() + 1.4 - ( .8 * math.Clamp( self.Owner:GetNWInt( "sprint" ) / 100, 0, 1 ) )  );
		
		self.Owner:SetNWInt( "sprint", math.Clamp( self.Owner:GetNWInt( "sprint" ) - math.Clamp( 200 / self.Owner:GetNWFloat( "stat.Sprint" ), .01, 40 ), 0, 100 )  );
			
		if( tr.Hit or tr.Entity:IsValid() ) then
			
			if( SERVER ) then
				
				if( tr.Entity:IsValid() ) then
			
					local norm = ( tr.Entity:GetPos() - self.Owner:GetPos() ):Normalize();
					local push = 2000 * norm;
					
					if( tr.Entity:IsPlayer() or tr.Entity:IsPlayerRagdoll() ) then
						local ply = tr.Entity;
						if( tr.Entity:IsPlayerRagdoll() ) then
							ply = tr.Entity:GetPlayer();
						end
						ply:HandlePunch( self.Owner, tr.HitGroup );
						push = 50 * norm;
						tr.Entity:SetVelocity( push );
					else
					
						local stat = self.Owner:GetNWFloat( "stat.Strength" );
						local amt = 0;
						
						if( stat < 17 ) then
							amt = .01;
						elseif( stat < 30 ) then
							amt = .05;
						elseif( stat < 50 ) then
							amt = .03;
						elseif( stat < 75 ) then
							amt = .02;
						elseif( stat < 85 ) then
							amt = .014;
						elseif( stat < 100 ) then
							amt = .001;
						end	
						
						self.Owner:SetNWFloat( "stat.Strength", stat + amt * .35 );
					
						tr.Entity:GetPhysicsObject():ApplyForceOffset( push, tr.HitPos );
					end
				
				end
				
			end
			
			self.Weapon:EmitSound( self.HitSounds[math.random( 1, #self.HitSounds )] );
			
		end
		
	elseif( tr.Entity:IsValid() and tr.Entity:IsDoor() ) then
	
		self.Weapon:EmitSound( Sound( "physics/wood/wood_crate_impact_hard2.wav" ) );
	
	end

  end
 
  /*---------------------------------------------------------
  SecondaryAttack
  ---------------------------------------------------------*/
  
    function SWEP:SecondaryAttack()
  
  	if( self.Owner:GetNWInt( "holstered" ) == 1 ) then
  
	  	if( self.Untying ) then return; end
	  
		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 60;
		trace.filter = self.Owner;
			
		local tr = util.TraceLine( trace );
			
		if( tr.Entity:IsValid() and ( tr.Entity:IsPlayer() or tr.Entity:IsPlayerRagdoll() ) ) then
		
			if( tr.Entity:IsPlayerRagdoll() ) then
				tr.Entity = tr.Entity:GetPlayer();
			end
			
			if( tr.Entity:GetNWInt( "tiedup" ) == 1 ) then
				
				self.Untying = true;
				tr.Entity:SetNWInt( "beingtiedup", 1 );
				self.Owner:SetNWInt( "tyingup", 1 );
				tr.Entity:SetNWInt( "untying", 1 );
				self.Owner:SetNWInt( "untying", 1 );
				self.Owner:SetField( "tieduptarget", tr.Entity:EntIndex() );
				self.Owner:SetPrivateInt( "tieduptarget", tr.Entity:EntIndex() );
				
				if( SERVER ) then
				
					umsg.Start( "CreateProcessBar", self.Owner );
						umsg.Short( -1 );
						umsg.Short( -1 );
						umsg.Short( 25 );
						umsg.String( "Untying" );
						umsg.Short( 1 );
						umsg.Short( 5 ); --time
						umsg.String( "rp_finishtie" );
						umsg.Entity( tr.Entity );
					umsg.End();
		
					self.Owner:SetField( "EndTieUpTime", CurTime() + 5 ); --time
	
				end
			
			else
				
				self.Owner:PrintMessage( 3, "Target is not tied up" );
				self.Weapon:SetNextSecondaryFire( CurTime() + 1 );
				
			end
			
		end
			
	else
		self:ToggleIronsight();
	end

  end
  

SWEP.LastRam = 0;

function SWEP:Think()

	if( self.Weapon:GetNWBool( "ironsights" ) and not self.Owner:KeyDown( IN_ATTACK2 ) ) then
	
		self:SecondaryAttack();
	
	end
	
	if( CLIENT ) then return; end
	
	
	  if( self.Untying ) then
	  	if( not self.Owner:KeyDown( IN_ATTACK2 ) ) then
	  	
	  		self.Untying = false;
	  		self.Owner:ConCommand( "rp_finishtie 0\n" );	
	  	
	  	end
  	end
  	
  	if( SERVER and CurTime() - self.LastRam > 1 and self.Owner:KeyDown( IN_RELOAD ) ) then
  		self.LastRam = CurTime();
		self.Owner:TryDoorRam();
	end

end
