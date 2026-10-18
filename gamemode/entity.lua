
--Entity meta functions

local meta = FindMetaTable( "Entity" );

local DoorTypes =
{

	"func_door",
	"func_door_rotating",
	"prop_door_rotating"

}

local VehicleTypes =
{

	"prop_vehicle_jeep",
	"prop_vehicle_airboat"

}

local OwnableTypes =
{
	
	"func_door",
	"func_door_rotating",
	"prop_door_rotating",
	"prop_vehicle_jeep",
	"prop_vehicle_airboat"

}

local UnPhysgunnable =
{
	
	"func_door",
	"func_door_rotating",
	"prop_door_rotating",
	"player",
	"func_breakable",
	"func_brush",
	"func_tracktrain",
	"func_physbox",
	"func_breakable_surf",
	"func_movelinear",
	"func_monitor"
	
}

local UnToolgunable =
{
	
	"func_breakable",
	"func_brush",
	"func_tracktrain",
	"func_physbox",
	"func_breakable_surf",
	"func_movelinear",
	
}

local AdvancedTTModelsOnly =
{

	

}

local BannedModels =
{
	
	"models\props_c17\oildrum001_explosive.mdl",
	"models\props_junk\gascan001a.mdl",
	"models\props_junk\propanecanister001a.mdl",
	"models\props_junk\propane_tank001a.mdl",
	"models\extras\info_speech.mdl"

}

function IsAdvOnlyTTModel( mdl )

	mdl = string.gsub( mdl, "/", "\\" );

	for k, v in pairs( AdvancedTTModelsOnly ) do

		if( v == string.gsub( mdl, "\\", "" ) ) then
			return true;
		end
	
	end
	
	return false;

end

function meta:CanToolgunThis()

	local class = self:GetClass();
	
	for k, v in pairs( UnToolgunable ) do
	
		if( v == class ) then
			return false;
		end
	
	end
	
	return true;	

end

function meta:CanPhysgun()

	local class = self:GetClass();
	
	for k, v in pairs( UnPhysgunnable ) do
	
		if( v == class ) then
			return false;
		end
	
	end
	
	return true;

end

function IsHeavyWeapon( class )

	local hw = 
	{
	
		"weapon_ts_ar2",
		"weapon_ts_beanbagshotgun",
		"weapon_ts_sniper",
		"weapon_ts_beanbagshotgun"
	
	}
	
	for k, v in pairs( hw ) do
	
		if( v == class ) then return true; end
	
	end
	
	return false;

end


function IsBannedModel( mdl )

	mdl = string.gsub( mdl, "/", "\\" );

	for k, v in pairs( BannedModels ) do

		if( v == string.gsub( mdl, "\\", "" ) ) then
			return true;
		end
	
	end
	
	return false;

end

function meta:IsBannedProp()

	if( IsBannedModel( self:GetModel() ) ) then return true; end
	
	return false;

end

function meta:IsPlayerRagdoll()

	if( self:GetNWInt( "playerragdoll" ) == 1 ) then
		return true;
	end
	
	return false;

end

function meta:GetPlayer()

	return player.GetByID( self:GetNWInt( "player" ) );

end

function meta:IsOwnable()

	local class = self:GetClass();
	
	for k, v in pairs( OwnableTypes ) do
	
		if( v == class ) then return true; end
	
	end
	
	return false;

end

function meta:IsItem()

	if( self:GetClass() == "item_prop" ) then return true; end
	
	return false;

end

function meta:IsVehicle()

	local class = self:GetClass();
	
	for k, v in pairs( VehicleTypes ) do
	
		if( v == class ) then return true; end
	
	end
	
	return false;

end

function meta:IsPaper()

	return self:GetNWBool( "CanRead" );

end

function meta:IsDoor()

	local class = self:GetClass();
	
	for k, v in pairs( DoorTypes ) do
	
		if( v == class ) then return true; end
	
	end
	
	return false;

end