class MyTeamInfo extends ReplicationInfo;

var zMain Main;
var MyInfo Captain;
var byte TeamIndex;
var byte TimeoutCalled;

function ModifyTeamPlayer(MyInfo LRI){
	if(Captain != None && IsCaptain(Captain)) return;
	Captain = LRI;
	Captain.ReceiveMessage(class'CaptainMessage', TeamIndex);
}

auto state StartUp{
	event Tick(float F){
		TeamIndex = TeamInfo(Owner).TeamIndex;
		Main = class'zUtil'.static.GetMain(Level);
		Main.MyTeams[TeamIndex] = Self;
		GotoState('');
		Disable('Tick');
	}
}

function bool Resign(MyInfo C, string MyMutation){

	local MyInfo NewCaptain;
	local int N;
	
	NewCaptain = MyInfoById( int(MyMutation) );
	
	if(Main.bAllCaptains) N = 50;
	else if(NewCaptain == None || !IsOnTeam(NewCaptain)) N = 47;
	else if(!IsCaptain(C)) N = 34;
	
	if(N != 0) return C.ReceiveMessage(class'UnallowedMessage', N);
	
	Captain = NewCaptain;
	Captain.ReceiveMessage(class'CaptainMessage', TeamIndex);
}

function bool Invite(MyInfo LRI, string MyMutation){ // только из спеков в свою команду
	
	local int N;
	local array<string> Muts;
	local MyInfo Invited, Kicked;

	Split(MyMutation, " ", Muts);
	Invited = MyInfoById( int(Muts[0]) );
	Kicked = MyInfoById( int(Muts[1]) );
	
	if(!IsCaptain(LRI)) N = 34;
	else if(LRI.GetTeamNum() == Invited.GetTeamNum()) N = 51;
	else if(Invited == None || Kicked == None) N = 47;
	else if(Invited.AllowBecomeActivePlayer()) N = 48;
	else if(!Invited.PlayerReplicationInfo.bOnlySpectator) N = 49;
	else if(!Main.IsWarmup()) N = 32;
	
	if(N != 0) return LRI.ReceiveMessage(class'UnallowedMessage', N);
	
	Invited.ForceBecomeActivePlayer(Kicked);
	if(Invited.GetTeamNum() != TeamIndex) Invited.ForceSwitchTeam();
}

function MyInfo MyInfoById(int PlayerID){
	local PlayerReplicationInfo LocalPRI;
	LocalPRI = Level.GRI.FindPlayerByID(PlayerID);
	if(LocalPRI != None) return class'MyInfo'.static.Get(LocalPRI);
	return None;
}

simulated function string GetHumanReadableName(){
	return Owner.GetHumanReadableName();
}

//simulated event NotifyLocalPlayerTeamReceived(){
//	local bool B;
//	Debug("NotifyLocalPlayerTeamReceived");
//}

function bool CanRestart(MyInfo LRI){
	return (PlayerController(LRI.Owner) != None && PlayerController(LRI.Owner).CanRestartPlayer());
}

function bool IsCaptain(MyInfo LRI){
	return (CanRestart(LRI) && IsOnTeam(LRI) && (Main.bAllCaptains || Captain == LRI));
}

function bool IsOnTeam(MyInfo LRI){
	return (LRI.PlayerReplicationInfo.Team != None && LRI.PlayerReplicationInfo.Team.TeamIndex == TeamIndex);
}

simulated function Debug(coerce string S){
	class'zUtil'.static.Debug(S, Self);
}

defaultproperties{
//	bNotifyLocalPlayerTeamReceived=True
	NetUpdateFrequency=1
}
