class VoteMessageVotingProgress extends AllVoteMessages;

//static function float GetLifeTime(int N){
//	//if(N == 0) return 1.5; // 0 - votes count & timer
//	return 2;
//}

static function int GetFontSize(int N, PlayerReplicationInfo R1, PlayerReplicationInfo R2, PlayerReplicationInfo MyPRI){
	if(N <= 0) return Super.GetFontSize(N, R1, R2, MyPRI);
	return 0;
}

static function color GetColor(optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2){
	if(N == 1) return MakeColor(10, 240, 10); // vote passed
	if(N == 2) return MakeColor(250, 1, 1); // vote failed
	return MakeColor(250, 240, 240);
}

static function string GetString(optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2, optional Object O){
	local string Pattern;
	local byte i;
	if(N == 1) return "Vote Passed!";
	if(N == 2) return "Vote Failed!";
	Pattern = "^0Voted Yes (%V1/%V3) [%V4] Voted No (%V0/%V2)";
	for(i = 0; i < 4; i++) Pattern = Repl(Pattern, "%V"$i, Voting(O).Voted[i]);
	Pattern = Repl(Pattern, "%V4", Voting(O).Time);
	return Paint(Pattern);
}

defaultproperties{
	Lifetime=2
	Offset=2.11
	FontSize=-1
}
