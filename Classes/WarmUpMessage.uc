class WarmUpMessage extends SpecialKillMessage; // LocalMessage

const MyLifeTime = 0.9;
// 0 - warmup
// n - seconds left
static function float GetLifeTime(int N){
	if(N <= 0) return 5 * MyLifeTime;
	return MyLifeTime;
}

static function ClientReceive(PlayerController P, optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2, optional Object O){
	if(P.GameReplicationInfo.TimeLimit != 0){
		P.GameReplicationInfo.TimeLimit = 0;
		//P.GameReplicationInfo.bMatchHasBegun = False; // if bMatchHasBegun = False кнопка join/spectate выключается
	}
	Super(LocalMessage).ClientReceive(P, N, P.PlayerReplicationInfo, R2, O);
}

static function color GetColor(optional int N, optional PlayerReplicationInfo R, optional PlayerReplicationInfo R2){
	switch(N){
		case -3: if(R != None && R.bReadyToPlay) return class'zLocalMessage'.static.MakeColor(1, 250, 1); break;
		case -4: return class'HUD'.default.GrayColor;
		case -5: return class'zLocalMessage'.static.GetTeamColor(R);
	}
	return default.DrawColor;
}

static function string GetString(optional int N, optional PlayerReplicationInfo R, optional PlayerReplicationInfo R2, optional Object O){
	switch(N){
		case 0: return "Warmup...";
		case -3: if(R != None) return "You are" @ Eval(R.bReadyToPlay, "", "NOT") @ "READY!";
		case -4: if(R != None) return R.PlayerName @ "is NOT READY!"; // !R.bReadyToPlay
		case -5: if(R != None) return R.Team.GetHumanReadableName() @ "TEAM is NOT READY!";
		default: return "Warmup ends in " $ N $ "...";
	}
//	return class'zUtil'.static.Paint("^3Match starts in " $ N $ "...");
}

defaultproperties{
	bIsConsoleMessage=False
	FontSize=-1
	DrawColor=(R=250,G=240,B=0,A=200)
}
