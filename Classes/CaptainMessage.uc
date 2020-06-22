class CaptainMessage extends zLocalMessage; // or welcome

var color TeamColor[4];

static function ClientReceive(PlayerController P, optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2, optional Object O){
	if(N == -1 && class'zMain'.default.bShowWelcomeMessage){
		class'Help'.static.WelcomeMessage(P);
		return;
	}
	Super.ClientReceive(P, N, R1, R2, O);
}

static function string GetString(optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2, optional Object O){
	return "You are team captain!";
}

static function color GetColor(optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2){
	return default.TeamColor[N];
}

defaultproperties{
	TeamColor(0)=(R=255,G=20,B=20,A=255) // red
	TeamColor(1)=(R=0,G=100,B=255,A=255) // turq
	TeamColor(2)=(R=0,G=255,B=0,A=255) // green
	TeamColor(3)=(R=255,G=255,B=0,A=255) // gold
	bFadeMessage=True
	Lifetime=4
	PosY=0.25
	FontSize=1
}
