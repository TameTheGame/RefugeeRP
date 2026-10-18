

if( SERVER ) then

	AddCSLuaFile( "shared.lua" );

end

SWEP.PrintName = "Zip Ties";

if( CLIENT ) then

	
	SWEP.Slot = 1;
	SWEP.SlotPos = 2;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;
	SWEP.DrawDotCrosshair = true;

end

// Variables that are used on both client and server

SWEP.Base = "weapon_ts_base";

SWEP.Author			= "JT"
SWEP.Instructions	= "Tie up or arrest someone"
SWEP.Contact		= "http://www.realtimeroleplay.com/"
SWEP.Purpose		= ""
SWEP.NotHolsterAnim = ACT_HL2MP_IDLE;

SWEP.ViewModel = Model( "models/weapons/v_fists.mdl" );
SWEP.WorldModel = Model( "models/weapons/w_fists.mdl" );

SWEP.InvSize = 0;
SWEP.InvWeight = 0;

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.AnimPrefix		= "rpg"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true
  
  
SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Primary.Automatic		= true				// Automatic/Semi Auto
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.DefaultClip	= 0				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= true			// Automatic/Semi Auto
SWEP.Secondary.Ammo			= ""

SWEP.TyingUp = false;

/*---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()

	if( SERVER ) then
	
		self:SetWeaponHoldType( "ar2" );
	
	end

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
  
  	if( self.TyingUp ) then return; end
  
	local trace = { }
	trace.start = self.Owner:EyePos();
	trace.endpos = trace.start + self.Owner:GetAimVector() * 60;
	trace.filter = self.Owner;
		
	local tr = util.TraceLine( trace );
		
	if( tr.Entity:IsValid() and ( tr.Entity:IsPlayer() or tr.Entity:IsPlayerRagdoll() ) ) then
	
		if( tr.Entity:IsPlayerRagdoll() ) then
			tr.Entity = tr.Entity:GetPlayer();
		end
	
		if( tr.Entity:GetNWInt( "tiedup" ) == 0 ) then
		
			if( tr.Entity:GetNWInt( "beingtiedup" ) == 0 ) then

				self.TyingUp = true;
				tr.Entity:SetNWInt( "beingtiedup", 1 );
				tr.Entity:SetNWInt( "untying", 0 );
				self.Owner:SetNWInt( "tyingup", 1 );
				self.Owner:SetNWInt( "untying", 0 );
				self.Owner:SetField( "tieduptarget", tr.Entity:EntIndex() );
				self.Owner:SetPrivateInt( "tieduptarget", tr.Entity:EntIndex() );
				
				if( SERVER ) then
			
					umsg.Start( "CreateProcessBar", self.Owner );
						umsg.Short( -1 );
						umsg.Short( -1 );
						umsg.Short( 25 );
						umsg.String( "Tying up" );
						umsg.Short( 1 );
						umsg.Short( 5 ); --time
						umsg.String( "rp_finishtie" );
						umsg.Entity( tr.Entity );
					umsg.End();
		
					self.Owner:SetField( "EndTieUpTime", CurTime() + 5 ); --time
					
				end
			
			else
			
				self.Owner:PrintMessage( 3, "Target is currently being tied up" );
				self.Weapon:SetNextPrimaryFire( CurTime() + 1 );
				
			end
		
		else
		
			self.Owner:PrintMessage( 3, "Target is already tied up" );
			self.Weapon:SetNextPrimaryFire( CurTime() + 1 );
		
		end
	
	end

  end
 
  /*---------------------------------------------------------
  SecondaryAttack
  ---------------------------------------------------------*/

  function SWEP:SecondaryAttack()
  
  	if( self.TyingUp ) then return; end
  
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
		
			self.TyingUp = true;
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

  end

function SWEP:Think()

	if( CLIENT ) then return; end

  	if( self.TyingUp ) then
	  	if( self.Owner:GetNWInt( "untying" ) == 0 ) then
	  		if( not self.Owner:KeyDown( IN_ATTACK ) ) then
	
	  			self.TyingUp = false;
		 	  
		 	  	self.Owner:ConCommand( "rp_finishtie 0\n" );
	 			
	  		end
	  	elseif( not self.Owner:KeyDown( IN_ATTACK2 ) ) then
	  	
	  		self.TyingUp = false;
	  		
	  		self.Owner:ConCommand( "rp_finishtie 0\n" );
	  	
	  	end
  	end

end



function weaponremove()
	for _, v in pairs( player.GetAll() ) do
	v:RemoveFromInventory( "weapon_ts_zipties" )

	end
end
hook.Add( "PlayerDeath", "zipdeath", weaponremove )