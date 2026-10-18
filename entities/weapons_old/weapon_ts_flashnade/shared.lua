


if( SERVER ) then

	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType = "melee";

end

SWEP.PrintName = "Flash Grenade";

if( CLIENT ) then

	
	SWEP.Slot = 2;
	SWEP.SlotPos = 2;
	SWEP.ViewModelFlip		= false	
	SWEP.CSMuzzleFlashes	= true
	SWEP.ViewModelFOV		= 83	
	
	SWEP.DrawCrosshair = false;
	
end

SWEP.Base = "weapon_ts_base";

SWEP.ViewModel			= "models/weapons/v_fists.mdl";
SWEP.WorldModel			= "models/weapons/w_grenade.mdl"
SWEP.Primary.Sound			= Sound( "Weapon_M3.Single" )
SWEP.Invisible = true;

SWEP.ViewModelFOV		= 83

SWEP.InvSize = 1;
SWEP.InvWeight = 1;

SWEP.Primary.ClipSize = 9999;
SWEP.Primary.DefaultClip = 1;
SWEP.Primary.Ammo = "rpg";
SWEP.Primary.IsFlashbang = true;
SWEP.Primary.Delay = 1.1;
SWEP.Primary.Damage = 1;
SWEP.Primary.Force = 6;
SWEP.Primary.RunCone = Vector( .07, .07, 0 );
SWEP.Primary.SpreadCone = Vector( .04, .04, 0 );
SWEP.Primary.CrouchSpreadCone = Vector( .03, .03, 0 );
SWEP.Primary.ViewPunch = Angle( -6.5, 0.0, 0 );
SWEP.Primary.Automatic = false;

SWEP.ReloadAtEnd = true;

SWEP.IronSightPos = Vector( 5.8, 2.2, -2.0 );
SWEP.IronSightAng = Vector( 2.0, 0.0, 0.0 );

/*---------------------------------------------------------
   Name: SWEP:Precache( )
   Desc: Use this function to precache stuff
---------------------------------------------------------*/
function SWEP:Precache()
end


SWEP.IsGoingToThrow = false;
SWEP.HeldTime = 0;

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
  function SWEP:PrimaryAttack()
  
  	if( CLIENT ) then return; end
  
  	if( not self:CanShootPrimary() ) then return; end
  
  	if( self.IsGoingToThrow ) then return; end
  
	self.IsGoingToThrow = true;
	self.HeldTime = CurTime();
	
	if( self.Weapon:Clip1() < 1 ) then
	
		self.Owner:RemoveWeapon( self.Weapon:GetClass() );
	
	end

  end
  
  function SWEP:SecondaryAttack()
  
  end


function SWEP:Reload()

	return;	

end

function SWEP:ThrowGrenade( force )

	if( CLIENT ) then return; end
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation

	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation

	self:TakePrimaryAmmo( 1 );
	
	local function TimedThrow( force )

	
		local pos = self.Owner:GetPos() + Vector( 0, 0, 40 ) + self.Owner:GetForward() * 15 + self.Owner:GetRight() * 15;
		
		if( self.Owner:Crouching() ) then
		
			pos = pos - Vector( 0, 0, 30 ) - self.Owner:GetForward() * 10 - self.Owner:GetRight() * 18;
		
		end
		
		local nade = ents.Create( "prop_physics" );
		nade:SetPos( pos );
		nade:SetAngles( self.Owner:GetAngles() );
		nade:SetModel( "models/weapons/w_grenade.mdl" );
		nade:Spawn();
		
		nade:SetOwner( self.Owner );
	
	
		timer.Simple( .1, nade:GetPhysicsObject().SetVelocity, nade:GetPhysicsObject(), ( self.Owner:EyeAngles():Forward() * ( 800 * force ) ) + self:GetUp() * 150 );
		
		local function RemoveNade( nade )
		
			local targets = ents.FindInSphere( nade:GetPos(), 1500 );
			local filter = RecipientFilter();
			
			for k, v in pairs( targets ) do
			
				if( v:IsPlayer() ) then
				
					if( v:CanTraceTo( nade ) ) then
					
						filter:AddPlayer( v );
					
					end
				
				end
			
			end
			
			umsg.Start( "AttemptFlash", filter ); 
				umsg.Entity( nade );
			umsg.End();
			
			local lightent = MakeLight( self.Owner, 255, 255, 255, 10, 320, { Pos = nade:GetPos(), Angle = Angle( 0, 0, 0 ) } );
	
			lightent:SetPos( nade:GetPos() );
	
			timer.Simple( .1, lightent.Remove, lightent );
	
			if( nade and nade:IsValid() ) then
				timer.Simple( .2, nade.Remove, nade );
			end
		
		end
		
		timer.Simple( 1.6, RemoveNade, nade );
		
	end
	
	timer.Simple( .2, TimedThrow, force );

end

/*---------------------------------------------------------
   Think does nothing
---------------------------------------------------------*/
function SWEP:Think()

	if( self.IsGoingToThrow ) then

	  	if( not self.Owner:KeyDown( IN_ATTACK ) ) then
	
	  		self.IsGoingToThrow = false;
	  		
	  		self:ThrowGrenade( math.Clamp( ( CurTime() - self.HeldTime ), .3, 1 ) );
	  		
	  		self.Weapon:SetNextPrimaryFire( 1 );
	  		
	  	end

	end

end

