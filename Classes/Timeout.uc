class Timeout extends Info;

var int TimeLeft;

function bool MutateCallIn(PlayerReplicationInfo PRI){
	if(PRI == Level.Pauser) GotoState('PreMatch');
	return (PRI == Level.Pauser);
}

//function bool MutateTeamCallOut(PlayerReplicationInfo PRI){
//	return False;
//}

function bool MutateCallOut(PlayerReplicationInfo PlayerReplicationInfo){
	
	local MyInfo LRI;
	local int TeamNum, N, Timeouts;
	local MyTeamInfo MyTeam;
	local bool bDuel, bFFA, bWarmup, bCaptain;
	
	Timeouts = zMain(Owner).Timeouts;
	bDuel = ((Level.Game.NumPlayers + Level.Game.NumBots == 2) && Level.Game.MaxPlayers == 2);
	bFFA = (!Level.Game.bTeamGame && !bDuel);
	LRI = class'MyInfo'.static.Get(PlayerReplicationInfo);
	TeamNum = LRI.GetTeamNum();
	if(TeamNum != 255) MyTeam = zMain(Owner).MyTeams[TeamNum];
	bWarmup = (Level.GRI.ElapsedTime == 0 || Level.GRI.RemainingTime == 900);
	bCaptain = (MyTeam != None && MyTeam.IsCaptain(LRI));
	
	if(zMain(Owner).IsWarmup()) N = 1;
	else if(PlayerReplicationInfo.bOnlySpectator) N = 2;
	else if(Level.Game.bOverTime) N = 35;
	else if(Level.Pauser == PlayerReplicationInfo) N = 3;
	else if(Level.Pauser != None) N = 33;
	else if(Level.Game.bTeamGame && !bCaptain) N = 34;
	else if(MyTeam != None && MyTeam.TimeoutCalled >= Timeouts) N = 4;
	else if(LRI.TimeoutCalled >= Timeouts) N = 6;
	else if(bWarmup) N = 7;
	else if(bFFA) N = 5;
	else if(!Level.Game.IsInState('MatchInProgress')) N = 8;
	if(N != 0) return LRI.ReceiveMessage(class'UnallowedMessage', N);
	
	if(MyTeam != None) MyTeam.TimeoutCalled++; else LRI.TimeoutCalled++;
	Level.Pauser = PlayerReplicationInfo;
	GotoState('Paused');
	return True;
}

state PreMatch{
	
	function BeginState(){
		TimeLeft = 5;
		BroadcastLocalizedMessage(class'TimeOutMessage', -1, Level.Pauser);
	}
	
	function Timer(){
		BroadcastLocalizedMessage(class'ResumeTimeMessage', TimeLeft);
		if(--TimeLeft <= -1) GotoState('');
	}
	
	function EndState(){
		Level.Pauser = None;
	}
}

state Paused{
	
	function BeginState(){
		SetTimer(1.0, True);
		BroadcastLocalizedMessage(class'TimeOutMessage', -2, Level.Pauser);
		TimeLeft = zMain(Owner).TimeoutLength;
	}
	
	function Timer(){
		BroadcastLocalizedMessage(class'ResumeTimeMessage', TimeLeft);
		if(--TimeLeft <= -1){
			Level.Pauser = None;
			GotoState('');
		}
	}
}

simulated function Debug(coerce string S){
	class'zUtil'.static.Debug(S, Self);
}

defaultproperties{
	RemoteRole=ROLE_None
	bAlwaysTick=True
}
