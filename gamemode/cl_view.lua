
CreateClientConVar( "rp_headbob", "1", true, false );

HeadBobX = 0;
HeadBobY = 0;
HeadBobAng = 0;

function TSCalcView( ply, origin, angles, fov )
if( ValidEntity( LocalPlayer() ) ) then
	if( HeadBobAng > 360 ) then HeadBobAng = 0; end

	if( CrackDrug and CurTime() - DrugTime > 4 ) then
	
		local view = { }
	
		CrackDrugAng = CrackDrugAng or Angle( 0, 0, 0 );		
		CrackDrugAng.y = CrackDrugAng.y + 180 * FrameTime();
		
		view.origin = origin;
		view.angles = ply:GetAimVector():Angle() + CrackDrugAng;
		
		return view;
		
	end

	if( ply:GetNWInt( "thirdperson" ) == 1 ) then

		local view = { }
		
		local mul = 1;
		
		if( ply:GetNWInt( "inversethirdperson" ) == 1 ) then
			
			mul = -1;
			view.angles = ply:GetAimVector():Angle() + Angle( 0, 180, 0 );
			
		else
		
			view.angles = ply:GetAimVector():Angle();
		
		end
		
		local tr = { }
		tr.start = ply:EyePos();
		tr.endpos = ply:EyePos() - ply:GetAimVector() * 100 * mul;
		tr.filter = ply;
		
		local trace = util.TraceLine( tr );
		
		view.origin = trace.HitPos + 10 * ply:GetAimVector() * mul;	
	  	
	  	return view;

	end
	
	if( LocalPlayer():GetInfo( "rp_headbob" ) == "1" ) then
		
		if( ( ply:KeyDown( IN_FORWARD ) or
			ply:KeyDown( IN_BACK ) or
			ply:KeyDown( IN_MOVERIGHT ) or
			ply:KeyDown( IN_MOVELEFT ) ) and ply:IsOnGround() ) then
			
			local view = { }
			view.origin = origin;
			view.angles = angles;
			
			if( ply:GetVelocity():Length() > 150 ) then
				
				HeadBobAng = HeadBobAng + 10 * FrameTime();
				
				view.angles.pitch = view.angles.pitch + math.sin( HeadBobAng ) * .5;
				view.angles.yaw = view.angles.yaw + math.cos( HeadBobAng ) * .2;
						
			else
			
				HeadBobAng = HeadBobAng + 6 * FrameTime();
				
				view.angles.pitch = view.angles.pitch + math.sin( HeadBobAng ) * .5;
				view.angles.yaw = view.angles.yaw + math.cos( HeadBobAng ) * .3;
				
			end
					
			return view;
			
		end
			
		local view = { }
		view.origin = origin;
		view.angles = angles;
		
		view.angles.pitch = view.angles.pitch + math.sin( HeadBobAng );
		view.angles.yaw = view.angles.yaw + math.cos( HeadBobAng );

		return view;

	end
  	end
end
hook.Add( "CalcView", "TSCalcView", TSCalcView );