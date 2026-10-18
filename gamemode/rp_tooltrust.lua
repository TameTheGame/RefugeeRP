local meta = FindMetaTable( "Player" );

function meta:IsToolTrusted()

	if( self:GetField( "group_hastoolgun" ) == 1 ) then return true; end
	
	return self:IsAdvToolTrusted();

end

function meta:IsAdvToolTrusted()

	if( self:GetField( "group_hasadvtoolgun" ) == 1 ) then return true; end
	
	return false;

end

TS.BasicTools =
{

	"weld",
	"remover",
	"weld_ez"

}