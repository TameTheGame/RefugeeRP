

if( SERVER ) then

	AddCSLuaFile( "shared.lua" );

end

SWEP.PrintName = "Christmas Launcher";

if( CLIENT ) then

	
	SWEP.Slot = 1;
	SWEP.SlotPos = 2;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;
	SWEP.DrawDotCrosshair = true;

end

// Variables that are used on both client and server

SWEP.Base = "weapon_ts_base";

SWEP.Author			= "Rick Darkaliono"
SWEP.Instructions	= "Bitch."
SWEP.Contact		= "http://tacoandbanana.com/forums/"
SWEP.Purpose		= ""
SWEP.NotHolsterAnim = ACT_HL2MP_IDLE;

SWEP.ViewModel = Model( "models/weapons/v_rpg.mdl" );
SWEP.WorldModel = Model( "models/weapons/w_rocket_launcher.mdl" );

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
SWEP.Primary.Delay = .15;

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

function SWEP:Reload()

  	self.Owner:EmitSound( "Weapon_RPG.Single" );

  	if( CLIENT ) then return; end
  	
  	local trace = { } 
	trace.start = self.Owner:GetShootPos();
	trace.endpos = trace.start + self.Owner:GetAimVector() * 10;
	trace.filter = self.Owner;
	
	local tr = util.TraceLine( trace );
	
	local prop = ents.Create( "prop_physics" );
	
	prop:SetModel( "models/props_junk/rock001a.mdl" );
	prop:SetPos( self.Owner:GetShootPos() );
	prop:Spawn();
	
	prop:GetPhysicsObject():SetVelocity( self.Owner:GetAimVector() * 20000 );
  
  	prop:SetColor( 79, 79, 79, 255 );
  
  	local function DeleteRock( rock )
  	
  		if( rock and rock:IsValid() ) then
  		
  			rock:Remove();
  		
  		end
  	
  	end
  	
  	timer.Simple( 7, DeleteRock, prop );
  
  	self:SetNextSecondaryFire( CurTime() + .15 );
  

end


/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
  function SWEP:PrimaryAttack()
  
  	self.Owner:EmitSound( "Weapon_RPG.Single" );

  	if( CLIENT ) then return; end
  	
  	local trace = { } 
	trace.start = self.Owner:GetShootPos();
	trace.endpos = trace.start + self.Owner:GetAimVector() * 10;
	trace.filter = self.Owner;
	
	local tr = util.TraceLine( trace );
	
	local item = TS.CreateItem( "ration", tr.HitPos, Angle( 0, 0, 0 ) );
	
	item:GetPhysicsObject():SetVelocity( self.Owner:GetAimVector() * 20000 );
  
  	if( math.random( 1, 2 ) == 1 ) then
  	
  		item:SetColor( 180, 0, 0, 255 );
  	
  	else
  	
  		item:SetColor( 0, 180, 0, 255 );
  	
  	end
  
  	self:SetNextPrimaryFire( CurTime() + .15 );
  
  end
 
  /*---------------------------------------------------------
  SecondaryAttack
  ---------------------------------------------------------*/

  function SWEP:SecondaryAttack()
  
  	local trace = { } 
	trace.start = self.Owner:EyePos();
	trace.endpos = trace.start + self.Owner:GetAimVector() * 4096;
	trace.filter = self.Owner;
	
	local tr = util.TraceLine( trace );  
  
	local effectdata = EffectData() 
 		effectdata:SetOrigin( tr.HitPos ) 
 		effectdata:SetStart( self.Owner:GetShootPos() ) 
 		effectdata:SetAttachment( 1 ) 
 		effectdata:SetEntity( self.Weapon ) 
 	util.Effect( "ToolTracer", effectdata ) 

 	if( SERVER ) then
 	
	 	if( tr.Entity:IsValid() and tr.Entity:IsPlayer() ) then
	 	
	 		if( not tr.Entity:GetField( "ChristmasCheer" ) ) then
	 		
	 			umsg.Start( "ChristmasCheer", tr.Entity );
	 			umsg.End();
	 		
	 			local function TurnOffCheer( ply )
	 				ply:SetField( "ChristmasCheer", false );
	 			end
	 			
	 			timer.Simple( 1, TurnOffCheer, tr.Entity );
	 		
	 		end
	 	
	 		tr.Entity:SetField( "ChristmasCheer", true );
	 	
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


