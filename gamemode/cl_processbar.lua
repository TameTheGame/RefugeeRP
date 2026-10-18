
ProcessBars = { }

local PB_TYPE_STAYTHEREANDTARGET = 1;
local PB_TYPE_CONTINUOUS = 2;

function msgKillProcessBar( msg )
	
	local ent = msg:ReadEntity();

	for k, v in pairs( ProcessBars ) do
	
		if( v.target == ent ) then
		
			ProcessBars[k] = nil;
		
		end
	
	end

end
usermessage.Hook( "KillProcessBar", msgKillProcessBar );

function msgCreateProcessBar( msg )

	local pb = { }
	pb.x = msg:ReadShort();
	pb.y = msg:ReadShort();
	
	if( pb.x == -1 ) then
		pb.x = ScrW() * .33;
	end
	
	if( pb.y == -1 ) then
		pb.y = ScrH() * .5;	
	end
	
	pb.h = msg:ReadShort();
	pb.name = msg:ReadString();
	pb.type = msg:ReadShort();
	pb.time = msg:ReadShort();
	pb.endcmd = msg:ReadString();
	pb.target = msg:ReadEntity();
	pb.dist = 60;
	
	if( pb.type == 3 ) then
	
		pb.dist = msg:ReadShort();
		pb.type = 1;
	
	end
	
	pb.starttime = CurTime();
	pb.endtime = CurTime() + pb.time;
	pb.Process = 0;
	
	table.insert( ProcessBars, pb );

end
usermessage.Hook( "CreateProcessBar", msgCreateProcessBar );

function ProcessThink()
if( ValidEntity( LocalPlayer() ) ) then
	for k, v in pairs( ProcessBars ) do
	

		v.Process = math.Clamp( ( ( CurTime() - v.starttime ) / v.time ), 0, 1 );
		
		if( v.Process >= 1 ) then
		
			LocalPlayer():ConCommand( v.endcmd .. " 1\n" );
			ProcessBars[k] = nil;
		
		else
		
			if( v.type == PB_TYPE_STAYTHEREANDTARGET ) then
			
				local trace = { }
				trace.start = LocalPlayer():EyePos();
				trace.endpos = trace.start + LocalPlayer():GetAimVector() * v.dist;
				trace.filter = LocalPlayer();
					
				local tr = util.TraceLine( trace );
					
				local killprocess = true;
					
				if( v.target == LocalPlayer() ) then
				
					killprocess = false;
				
				end
					
				if( ValidEntity( tr.Entity ) ) then
				
					if( tr.Entity ~= v.target and v.target ~= LocalPlayer() ) then
					
						if( v.ragdolltarget and v.ragdolltarget:IsValid() and tr.Entity == v.ragdolltarget ) then
						
							killprocess = false;
						
						elseif( tr.Entity:IsPlayerRagdoll() ) then
						
							if( v.target == tr.Entity:GetPlayer() ) then
						
								v.ragdolltarget = tr.Entity;
								killprocess = false;
								
							end
						
						end
						
					else
					
						killprocess = false;
					
					end
				
				end
					
				if( killprocess ) then
				
					LocalPlayer():ConCommand( v.endcmd .. " 0\n" );
					ProcessBars[k] = nil;
				
				end
				
			end
			
		end
	
	end
 end
end
hook.Add( "Think", "ProcessThink", ProcessThink );