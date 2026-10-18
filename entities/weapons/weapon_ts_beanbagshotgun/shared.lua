


if( SERVER ) then

	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType = "smg";

end

SWEP.PrintName = "NL Beanbag Shotgun";

if( CLIENT ) then

	
	SWEP.Slot = 2;
	SWEP.SlotPos = 2;
	SWEP.ViewModelFlip		= true	
	SWEP.CSMuzzleFlashes	= true
	SWEP.ViewModelFOV		= 83	
	
	SWEP.DrawCrosshair = false;
	
end

SWEP.Base = "weapon_ts_base";

SWEP.Author			= "JT"
SWEP.Contact		= "http://www.realtimeroleplay.com/"

SWEP.ViewModel			= "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_m3super90.mdl"
SWEP.Primary.Sound			= Sound( "Weapon_M3.Single" )

SWEP.ViewModelFOV		= 83

SWEP.InvSize = 3;
SWEP.InvWeight = 1;

SWEP.Primary.ClipSize = 12;
SWEP.Primary.DefaultClip = 12;
SWEP.Primary.Ammo = "buckshot";
SWEP.Primary.Delay = 1.1;
SWEP.Primary.Damage = 1;
SWEP.Primary.Force = 6;
SWEP.Primary.RunCone = Vector( .07, .07, 0 );
SWEP.Primary.SpreadCone = Vector( .04, .04, 0 );
SWEP.Primary.CrouchSpreadCone = Vector( .03, .03, 0 );
SWEP.Primary.ViewPunch = Angle( -6.5, 0.0, 0 );
SWEP.Primary.Automatic = false;

SWEP.IronSightPos = Vector( 5.8, 2.2, -2.0 );
SWEP.IronSightAng = Vector( 2.0, 0.0, 0.0 );

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
  
	if( not self:CanShootPrimary() ) then return; end

	if( self.Weapon:GetNWBool( "ironsights" ) and self.NoIronSightAttack ) then return; end
	if( self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetVelocity():Length() >= 140 ) then return; end

	if( CLIENT ) then
		self.Weapon:EmitSound( self.Primary.Sound );
	else
		self.Weapon:EmitSound( self.Primary.Sound, self.Volume, 100 );
	end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + ( self.Primary.Delay or .5 ) );
	
	self:TakePrimaryAmmo( 1 );
	self:TSShootBullet();
	
	local punchmul = 1 + ( 1 - math.Clamp( self.Owner:Health() / 50, 0, 1 ) );

	self.Owner:ViewPunch( self.Primary.ViewPunch * punchmul );

	if( self.ViewPunchStray ) then
	
		self.ViewPunchOffset.x = math.Clamp( self.ViewPunchOffset.x + self.ViewPunchAdd.x * self.StraySpeed * .5, 0, 99 );
		self.ViewPunchOffset.y = math.Clamp( self.ViewPunchOffset.y + self.ViewPunchAdd.y * self.StraySpeed * .5, 0, 99 );
		self.ViewPunchOffset.z = math.Clamp( self.ViewPunchOffset.z + self.ViewPunchAdd.z * self.StraySpeed * .5, 0, 99 );
			
	end
	
	if( SERVER ) then
    
		local trace = { }
		trace.start = self.Owner:EyePos();
		trace.endpos = trace.start + self.Owner:GetAimVector() * 400;
		trace.filter = self.Owner;
		
		local tr = util.TraceLine( trace );

     	if( tr.Entity:IsValid() and tr.Entity:IsPlayer() ) then

			local hitgroup = tr.Hitgroup;
			
			local dmg = math.Clamp( 100 - ( 25 / ( 190 / self.Owner:GetPos():Distance( tr.Entity:GetPos() ) ) ), 50, 100 );
     	
     		if( hitgroup == HITGROUP_HEAD ) then
     			dmg = dmg * 1.7;
     		elseif( hitgroup == HITGROUP_CHEST ) then
     			dmg = dmg * 1.4;
     		elseif( hitgroup == HITGROUP_STOMACH ) then
     			dmg = dmg * 1.2;
     		else
     			dmg = dmg * .9;
     		end
     		
     		tr.Entity:SetNWFloat( "conscious", math.Clamp( tr.Entity:GetNWFloat( "conscious" ) - dmg, 0, 50 ) );
     		tr.Entity:GoUnconscious();
     		
     		local function ApplyRagdollForce( ply, attacker, hitpos )
     		
     			local shootpos = attacker:GetPos() + Vector( 0, 0, 32 );
     			local norm = ( shootpos - hitpos ):Normalize();
     		
     			local ragdoll = ply:GetRagdoll();
     		
     			ragdoll:GetPhysicsObject():ApplyForceOffset( norm * -10000, hitpos );
     		
     		end
     		
     		ApplyRagdollForce( tr.Entity, self.Owner, tr.HitPos );
     		
     		tr.Entity:TempStatBoost( "Endurance", -13, 60 );
     		
     	end

	end

  end


function SWEP:Reload()
	
	//if ( CLIENT ) then return end
	
	if( self.Weapon:GetNWBool( "ironsights" ) ) then
		self:ToggleIronsight();
	end
	
	// Already reloading
	if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then return end
	
	// Start reloading if we can
	if ( self.Weapon:Clip1() < self.Primary.ClipSize && self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
		
		self.Weapon:SetNetworkedBool( "reloading", true )
		self.Weapon:SetVar( "reloadtimer", CurTime() + 0.3 )
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		
	end

end

/*---------------------------------------------------------
   Think does nothing
---------------------------------------------------------*/
function SWEP:Think()


	if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then
	
		if ( self.Weapon:GetVar( "reloadtimer", 0 ) < CurTime() ) then
			
			// Finsished reload -
			if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self.Weapon:SetNetworkedBool( "reloading", false )
				return
			end
			
			// Next cycle
			self.Weapon:SetVar( "reloadtimer", CurTime() + 0.3 )
			self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			
			// Add ammo
			self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
			self.Weapon:SetClip1(  self.Weapon:Clip1() + 1 )
			
			// Finish filling, final pump
			if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
				self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
			else
			
			end
			
		end
	
	end

end

function weaponremove()
	for _, v in pairs( player.GetAll() ) do
	v:RemoveFromInventory( "weapon_ts_beanbagshotgun" )

	end
end
hook.Add( "PlayerDeath", "bbsdeath", weaponremove )
