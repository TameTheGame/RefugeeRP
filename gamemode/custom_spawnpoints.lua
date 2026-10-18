
-- Might as well hard code it.

CustomSpawnPoints = { }
CustomCPSpawnPoints = { }

local function AddSpawnPoint( map, pos, ang, cp )

	if( not cp ) then

		if( not CustomSpawnPoints[map] ) then
		
			CustomSpawnPoints[map] = { }
		
		end
		
	else
	
		if( not CustomCPSpawnPoints[map] ) then
		
			CustomCPSpawnPoints[map] = { }
		
		end	
	
	end
	
	local sp = { }
	sp.Pos = pos;
	sp.Ang = ang;
	
	if( not cp ) then
		table.insert( CustomSpawnPoints[map], sp );
	else
		table.insert( CustomCPSpawnPoints[map], sp );
	end

end

AddSpawnPoint( "rp_central17_v3_dsrp", Vector( 1781.6112060547, 477.4841003418, 8.03125 ), Angle( 0.076904296875, 184.16381835938, 0 ) );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( 1438.4271240234, -796.00695800781, -4.96875 ), Angle( 9.6240234375, 179.54956054688, 0 ) );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( 1438.4483642578, -872.84741210938, -4.96875 ), Angle( 4.3560791015625, 175.59997558594, 0 ) );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( 936.73254394531, 491.353515625, 8.03125 ), Angle( 10.9423828125, 269.46716308594, 0 ) );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( 735.29901123047, 493.59820556641, 43.357780456543 ), Angle( 6.6632080078125, 268.51135253906, 0 ) );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( 808.12915039063, 1881.1137695313, 72.03125 ), Angle( 0.406494140625, 180.57678222656, 0 ) );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( 810.37939453125, 1640.3264160156, 72.03125 ), Angle( 1.8951416015625, 195.06774902344, 0 ) );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( 537.73529052734, 1950.7819824219, 72.03125 ), Angle( 1.2359619140625, 2.39501953125, 0 ) );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( -484.89883422852, 1068.7952880859, 69.711296081543 ), Angle( 2.5543212890625, 271.17553710938, 0 ) );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( -2402.5034179688, 1724.3690185547, 8.03125 ), Angle( 0.5767822265625, 13.95263671875, 0 ) );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( -2304.43359375, 1651.4571533203, 8.03125 ), Angle( 0.5767822265625, 13.95263671875, 0 ) );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( -1386.8389892578, -2356.2717285156, 64.03125 ), Angle( 1.2359619140625, 0.4833984375, 0 ) );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( -1387.8996582031, -2230.5966796875, 64.03125 ), Angle( 2.8839111328125, 1.142578125, 0 ) );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( 960.97674560547, -2338.2758789063, 8.03125 ), Angle( 1.2359619140625, 270.24719238281, 0 ) );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( 827.25494384766, -2342.7993164063, 8.03125 ), Angle( 4.2022705078125, 270.90637207031, 0 ) );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( 156.171875, -2388.6865234375, 8.03125 ), Angle( 2.5543212890625, 92.730102539063, 0 ) );

AddSpawnPoint( "rp_central17_v3_dsrp", Vector( -722.27282714844, -1679.3073730469, 64.03125 ), Angle( 1.8951416015625, 86.473388671875, 0 ), true );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( -780.46264648438, -1674.1704101563, 64.03125 ), Angle( 359.26391601563, 88.121337890625, 0 ), true );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( -599.05554199219, -787.37835693359, 64.03125 ), Angle( 2.8839111328125, 181.35681152344, 0 ), true );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( -595.15942382813, -865.02026367188, 64.03125 ), Angle( 2.8839111328125, 181.35681152344, 0 ), true );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( -714.65539550781, -727.74102783203, 64.03125 ), Angle( 2.8839111328125, 271.92810058594, 0 ), true );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( -785.16534423828, -730.11437988281, 64.03125 ), Angle( 2.8839111328125, 271.92810058594, 0 ), true );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( -349.37896728516, -788.52056884766, 192.03125 ), Angle( 5.51513671875, 275.87768554688, 0 ), true );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( -443.23049926758, -797.34906005859, 192.03125 ), Angle( 4.2022705078125, 271.26892089844, 0 ), true );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( -441.54190063477, -873.57745361328, 192.03125 ), Angle( 4.2022705078125, 271.26892089844, 0 ), true );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( -348.68270874023, -871.52044677734, 192.03125 ), Angle( 4.2022705078125, 271.26892089844, 0 ), true );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( -346.74850463867, -958.83526611328, 192.03125 ), Angle( 4.2022705078125, 271.26892089844, 0 ), true );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( -471.48187255859, -961.59838867188, 192.03125 ), Angle( 4.2022705078125, 271.26892089844, 0 ), true );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( -469.52188110352, -1050.0804443359, 192.03125 ), Angle( 4.2022705078125, 271.26892089844, 0 ), true );
AddSpawnPoint( "rp_central17_v3_dsrp", Vector( -357.2610168457, -1047.5968017578, 192.03125 ), Angle( 4.2022705078125, 271.26892089844, 0 ), true );
