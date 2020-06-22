class AllVoteMessages extends zLocalMessage abstract;

var float Offset;
var float OffsetY;

static function float GetLifeTime(int N){
	if(N <= 2) return 2.2;
	return MaxInt;
}

static function GetPos(int N, out EDrawPivot OutDrawPivot, out EStackMode OutStackMode, out float OutPosX, out float OutPosY){
	Super.GetPos(N, OutDrawPivot, OutStackMode, OutPosX, OutPosY);
	OutPosY += default.Offset * default.OffsetY;
}

defaultproperties{
	bIsUnique=True
	bIsSpecial=True
	bFadeMessage=True
	OffsetY=0.0218
	PosY=0.23
}
