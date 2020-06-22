class MatchHasBegunMessage extends FinalCountDown;

static function string GetString(optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2, optional Object O){
	return "The match has begun!";
}

//	GameReplicationInfo.RemainingTime = iRemainingMinute * 60;
//	GameReplicationInfo.RemainingMinute = iRemainingMinute;
//	GameReplicationInfo.ElapsedTime = 0;
//	PlayerReplicationInfo.StartTime = 0;

static simulated function ClientReceive(PlayerController P, optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2, optional Object O){
	local Actor A;
	P.GameReplicationInfo.TimeLimit = N;
	//P.GameReplicationInfo.bMatchHasBegun = True;
	if(P.Level.NetMode == NM_Client) foreach P.DynamicActors(class'Actor', A) if(Projectile(A) != None || Gib(A) != None) A.Destroy();
	Super.ClientReceive(P, 0, R1, R2, O);
}

static simulated function Debug(coerce string S, Actor A){
	class'zUtil'.static.Debug(S, A);
}

defaultproperties{}
