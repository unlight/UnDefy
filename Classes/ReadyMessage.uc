class ReadyMessage extends zLocalMessage;

// -2 - warmup ended, 1 - playerready, 2 - player not ready // 3 - team ready.
// -1 - all ready = moved to class'FinalCountDown'

static function color GetColor(optional int N, optional PlayerReplicationInfo R, optional PlayerReplicationInfo R2) {
	switch (N) {
		case -2: return class'HUD'.default.RedColor;
		case -1: return class'HUD'.default.GoldColor;
		case 1:
		case 2: return class'HUD'.default.GrayColor;
		case 3: return GetTeamColor(R);
	}
	return class'HUD'.default.WhiteColor;
}

static function ClientReceive(PlayerController P, optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2, optional Object O) {
	P.PlayBeepSound();
	Super.ClientReceive(P, N, R1, R2, O);
}

static function string GetString(optional int N, optional PlayerReplicationInfo R, optional PlayerReplicationInfo R2, optional Object O) {
	switch (N) {
		case -2: return "WARMUP ENDED! Match starting...";
		//case -1: return "All players are ready! Match starting...";
		case 1: if(R != None) return R.PlayerName @ "is READY!"; // R.bReadyToPlay
		case 2: if(R != None) return R.PlayerName @ "is NOT READY!"; // !R.bReadyToPlay
		case 3: if(R != None && R.Team != None) return R.Team.GetHumanReadableName() @ "TEAM is READY!";
	}
}

defaultproperties {
	Lifetime=5
	FontSize=0
	PosY=0.169
	bIsConsoleMessage=False
	bFadeMessage=True
	bIsUnique=True
	StackMode=SM_None
}
