class OvertimeTimerMessage extends zLocalMessage;

static function ClientReceive(PlayerController P, optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2, optional Object O) {
	P.GameReplicationInfo.TimeLimit = 0;
	P.GameReplicationInfo.ElapsedTime = 0;
}

defaultproperties {
	Lifetime=0
}