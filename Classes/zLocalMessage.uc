class zLocalMessage extends LocalMessage abstract;

final static function color MakeColor(byte R, byte G, byte B, optional byte A) {
	local color C;
	C.R = R;
	C.G = G;
	C.B = B;
	if (A == 0) A = 255;
	C.A = A;
	return C;
}

static function color GetTeamColor(PlayerReplicationInfo R) {
	if (R != None && R.Team != None) return class'CaptainMessage'.default.TeamColor[R.Team.TeamIndex];
	return class'HUD'.default.BlackColor;
}

final static function string Paint(string S) {
	return class'zUtil'.static.Paint(S);
}

//static function ClientReceive(PlayerController P, optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2, optional Object O) {
//	Super.ClientReceive(P, N, R1, R2, O);
//}

//static function float GetLifeTime(int N) {
//}

//static function string GetString(optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2, optional Object O) {
//	return class'zUtil'.static.Paint( Super.GetString(N, R1, R2, O) );
//}
//static function color GetColor(optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2) {
//}

static simulated function Debug(coerce string S, Actor A) {
	class'zUtil'.static.Debug(S, A);
}
	
defaultproperties {
	bFadeMessage=True
	bIsConsoleMessage=False
	FontSize=0
}
