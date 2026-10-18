
--Resources!  Instead of using .res files.

resource.AddFile( "models/weapons/v_fists.mdl" );
resource.AddFile( "models/weapons/w_fists.mdl" );

resource.AddFile( "models/weapons/v_stunstick.mdl" );
resource.AddFile( "models/weapons/W_stunbaton.mdl" );
resource.AddFile( "materials/models/weapons/v_stunstick/v_stunstick_diffuse.vmt" );
resource.AddFile( "materials/models/weapons/v_stunstick/v_stunstick_diffuse.vtf" );

resource.AddFile( "materials/models/weapons/v_stunstick/v_stunstick_normal.vtf" )

resource.AddFile( "materials/models/weapons/msg-90/body.vmt" );
resource.AddFile( "materials/models/weapons/msg-90/bullet.vmt" );
resource.AddFile( "materials/models/weapons/msg-90/scope.vmt" );
resource.AddFile( "materials/models/weapons/msg-90/vscope.vmt" );
resource.AddFile( "materials/models/weapons/msg-90/body.vtf" );
resource.AddFile( "materials/models/weapons/msg-90/bullet.vtf" );
resource.AddFile( "materials/models/weapons/msg-90/scope.vtf" );
resource.AddFile( "materials/models/weapons/msg-90/vscope.vtf" );
resource.AddFile( "materials/models/weapons/msg-90/body_ref.vtf" );
resource.AddFile( "materials/models/weapons/msg-90/bullet_ref.vtf" );
resource.AddFile( "materials/models/weapons/msg-90/scope_ref.vtf" );
resource.AddFile( "models/weapons/v_msg90.mdl" );
resource.AddFile( "models/weapons/w_msg90.mdl" );

--NRD
TS.IncludeResourcesInFolder( "models/ODST/" );
TS.IncludeResourcesInFolder( "materials/ODST/" );

--NSRF
TS.IncludeResourcesInFolder( "models/srpmodels/" );
TS.IncludeResourcesInFolder( "materials/models/player/loner1/" );
TS.IncludeResourcesInFolder( "materials/models/player/loner2/" );
TS.IncludeResourcesInFolder( "materials/models/player/loner3/" );

--[[Beta Music/Sounds
resource.AddFile( "sound/realtimeroleplay/drums.mp3" );
resource.AddFile( "sound/realtimeroleplay/event1.mp3" );
resource.AddFile( "sound/realtimeroleplay/event2.mp3" );
resource.AddFile( "sound/realtimeroleplay/event3.mp3" );
resource.AddFile( "sound/realtimeroleplay/tradestart.mp3" );
resource.AddFile( "sound/realtimeroleplay/tradeend.mp3" );--]]
