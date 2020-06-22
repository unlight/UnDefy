class VoteMessageCaller extends AllVoteMessages;

#EXEC OBJ LOAD FILE=GeneralAmbience.uax

static function color GetColor(optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2) {
	return MakeColor(250, 240, 240);
}

static function string GetString(optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2, optional Object O) {
	//Debug("VoteMessageCaller" @ N @ R1 @ R2 @ O, R1);
	if (R1 != None) return R1.PlayerName @ "has called a vote!";
}

static function ClientReceive(PlayerController P, optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2, optional Object O) {
	if (N != -1) P.ClientPlaySound(sound'GeneralAmbience.beep5');
	Super.ClientReceive(P, N, R1, R2, O);
}

defaultproperties {
	Offset=0
	FontSize=-1
}
