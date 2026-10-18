

if( SERVER ) then

	AddCSLuaFile( "shared.lua" );

end

SWEP.PrintName = "Medic";

if( CLIENT ) then

	SWEP.Slot = 5;
	SWEP.SlotPos = 1;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;

end

SWEP.InvSize = 1;
SWEP.InvWeight = .7;

// Variables that are used on both client and server

SWEP.Author			= "Rick Darkaliono"
SWEP.Instructions	= "Left click to heal others.\nRight click to heal yourself.\nReload + <left/right click> - Apply bandage to someone or yourself"
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

SWEP.Healing = false;


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
  	
  	if( self.Owner:GetField( "isko" ) == 1 ) then return; end
  
  	if( self.Healing ) then return; end
  
	local trace = { }
	trace.start = self.Owner:EyePos();
	trace.endpos = trace.start + self.Owner:GetAimVector() * 60;
	trace.filter = self.Owner;
		
	local tr = util.TraceLine( trace );
		
	if( tr.Entity:IsValid() and ( tr.Entity:IsPlayer() or tr.Entity:IsPlayerRagdoll() ) ) then
	
		if( not self.Owner:KeyDown( IN_RELOAD ) or ( self.Owner:KeyDown( IN_RELOAD ) and tr.Entity:IsBleeding() ) ) then

			if( self.Owner:KeyDown( IN_RELOAD ) and not self.Owner:HasItem( "bandage" ) ) then
			
				self.Owner:PrintMessage( 3, "You don't have a bandage" );
				return;
			
			end

			if( not self.Owner:KeyDown( IN_RELOAD ) and not self.Owner:HasItem( "healthvial" ) ) then
			
				self.Owner:PrintMessage( 3, "You don't have a health vial" );
				return;
			
			end

			if( tr.Entity:IsPlayerRagdoll() ) then
				tr.Entity = tr.Entity:GetPlayer();
			end
		
			if( tr.Entity:GetNWInt( "beinghealed" ) == 0 ) then
	
					self.Healing = true;
					tr.Entity:SetNWInt( "beinghealed", 1 );
					
					self.Owner:SetField( "healingself", 0 );
					self.Owner:SetPrivateInt( "healingself", 0 );
					

					self.Owner:SetNWInt( "healing", 1 );
					
					self.Owner:SetField( "healingtarget", tr.Entity:EntIndex() );
					self.Owner:SetPrivateInt( "healingtarget", tr.Entity:EntIndex() );
					
					if( self.Owner:KeyDown( IN_RELOAD ) ) then
						self.Owner:SetField( "healtype", 1 );
						self.Owner:SetPrivateInt( "healtype", 1 );

					else
						self.Owner:SetField( "healtype", 0 );
						self.Owner:SetPrivateInt( "healtype", 0 );

					end
				
					if( SERVER ) then
					
						umsg.Start( "CreateProcessBar", self.Owner );
							umsg.Short( -1 );
							umsg.Short( -1 );
							umsg.Short( 25 );
						
						if( self.Owner:KeyDown( IN_RELOAD ) ) then
							umsg.String( "Applying Bandage" );
						else
							umsg.String( "Applying Medical Aid" );
						end
								
							umsg.Short( 1 );
							umsg.Short( 5 ); --time
							umsg.String( "rp_finishheal" );
							umsg.Entity( tr.Entity );
						umsg.End();
			
						self.Owner:SetField( "EndHealTime", CurTime() + 5 ); --time
			
					end
			
					
			else
				
				self.Owner:PrintMessage( 3, "Target is currently already being healed" );
				self.Weapon:SetNextPrimaryFire( CurTime() + 1 );
					
			end
			
		else
		
			self.Owner:PrintMessage( 3, "Target is not bleeding" );
		
		end
	
	end

  end
 
  /*---------------------------------------------------------
  SecondaryAttack
  ---------------------------------------------------------*/
  function SWEP:SecondaryAttack()
  

  	if( CLIENT ) then return; end
  	
  	if( self.Owner:GetField( "isko" ) == 1 ) then return; end
  
  	if( self.Healing ) then return; end
	
		if( not self.Owner:KeyDown( IN_RELOAD ) or ( self.Owner:KeyDown( IN_RELOAD ) and self.Owner:IsBleeding() ) ) then

			if( self.Owner:KeyDown( IN_RELOAD ) and not self.Owner:HasItem( "bandage" ) ) then
			
				self.Owner:PrintMessage( 3, "You don't have a bandage" );
				return;
			
			end
			
			if( not self.Owner:KeyDown( IN_RELOAD ) and not self.Owner:HasItem( "healthvial" ) ) then
			
				self.Owner:PrintMessage( 3, "You don't have a health vial" );
				return;
			
			end
		
			if( self.Owner:GetNWInt( "beinghealed" ) == 0 ) then
	
					self.Healing = true;
					self.Owner:SetNWInt( "beinghealed", 1 );
					
					self.Owner:SetField( "healingself", 1 );
					self.Owner:SetPrivateInt( "healingself", 1 );
					

					self.Owner:SetNWInt( "healing", 1 );
					
					self.Owner:SetField( "healingtarget", self.Owner:EntIndex() );
					self.Owner:SetPrivateInt( "healingtarget", self.Owner:EntIndex() );
				
					if( self.Owner:KeyDown( IN_RELOAD ) ) then
						self.Owner:SetField( "healtype", 1 );
						self.Owner:SetPrivateInt( "healtype", 1 );
					else
						self.Owner:SetField( "healtype", 0 );
						self.Owner:SetPrivateInt( "healtype", 0 );
					end
					
					if( SERVER ) then
					
					
					
						umsg.Start( "CreateProcessBar", self.Owner );
							umsg.Short( -1 );
							umsg.Short( -1 );
							umsg.Short( 25 );
						
						if( self.Owner:KeyDown( IN_RELOAD ) ) then
							umsg.String( "Applying Bandage" );
						else
							umsg.String( "Applying Medical Aid" );
						end
								
							umsg.Short( 1 );
							umsg.Short( 5 ); --time
							umsg.String( "rp_finishheal" );
							umsg.Entity( self.Owner );
						umsg.End();
			
						self.Owner:SetField( "EndHealTime", CurTime() + 5 ); --time
			
					end
				
			else
				
				self.Owner:PrintMessage( 3, "You're currently already being healed" );
				self.Weapon:SetNextSecondaryFire( CurTime() + 1 );
					
			end
			
		else
		
			self.Owner:PrintMessage( 3, "You're not bleeding" );
		
		end

  end 
  
   function SWEP:DrawHUD()

		draw.RoundedBox( 4, ScrW() - 150, ScrH() - 80, 220, 55, Color( 50, 50, 50, 200 ) ); 
		draw.DrawText( GetItemCount( "bandage" ) .. " Bandages", "TargetID", ScrW() - 8, ScrH() - 73, Color( 0, 0, 0, 255 ), 2 );
		draw.DrawText( GetItemCount( "bandage" ) .. " Bandages", "TargetID", ScrW() - 10, ScrH() - 75, Color( 255, 255, 255, 255 ), 2 );
		draw.DrawText( GetItemCount( "healthvial" ) .. " Health-vials", "TargetID", ScrW() - 8, ScrH() - 53, Color( 0, 0, 0, 255 ), 2 );
		draw.DrawText( GetItemCount( "healthvial" ) .. " Health-vials", "TargetID", ScrW() - 10, ScrH() - 55, Color( 255, 255, 255, 255 ), 2 );
		
	end

	function SWEP:Think()

		if( CLIENT ) then return; end

	  	if( self.Healing ) then
	  	
	  		if( self.Owner:GetField( "isko" ) == 1 ) then 
				
				self.Healing = false;		
				--self.Owner:ConCommand( "rp_stopheal\n" );
			  		
				self.Owner:ConCommand( "rp_finishheal 0\n" );	
			  			  			
	  		end
		
			if( self.Owner:GetField( "healingself" ) == 0 ) then
		
				if( not self.Owner:KeyDown( IN_ATTACK ) ) then
			
			  		self.Healing = false;
			  		--self.Owner:ConCommand( "rp_stopheal\n" );
			  		
					self.Owner:ConCommand( "rp_finishheal 0\n" );	
			  		
			  	elseif( self.Owner:GetField( "healtype" ) == 1 ) then
			  	
			  	
			  		local target = ents.GetByIndex( self.Owner:GetField( "healingtarget" ) );
			  	
			  		if( not self.Owner:HasItem( "bandage" ) or ( target and target:IsValid() and target:IsPlayer() and not target:IsBleeding() ) ) then
			  		
				  		self.Healing = false;
				  		--self.Owner:ConCommand( "rp_stopheal\n" );
			  		
						self.Owner:ConCommand( "rp_finishheal 0\n" );	
			  		
			  		end
			  	
			  	end
			  	
			else
			
					if( not self.Owner:KeyDown( IN_ATTACK2 ) ) then
			
				  		self.Healing = false;
						
						self.Owner:ConCommand( "rp_finishheal 0\n" );	
				  		
				  	end
			
			end

	  	end
	
	end
	
	