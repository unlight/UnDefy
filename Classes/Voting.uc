class Voting extends ReplicationInfo;

var array<string> Maps, Options, URL; // URL: game, mutators, params
var PlayerReplicationInfo Kicked;
var MyInfo Caller;
var bool bLastCaller;
var float LastCallTime;
var string VotedString;
var int Time;
var byte Voted[4], PassPercent, Status; // 1-passed 2-failed 255-clear(ended time) 0-progress
var bool bVoteTypeBroadcasted;

replication{
	reliable if(bNetDirty && Role == Role_Authority) VotedString, Voted, Time;
}

function PostBeginPlay(){
	Level.Game.LoadMapList("DM", Maps);
}

function Reset(){
	
	local byte i;
	local array<PlayerReplicationInfo> AllPRI;
	
	AllPRI = Level.GRI.PRIArray;
	bVoteTypeBroadcasted = False;
	VotedString = default.VotedString;
	Status = 0;
	Options.Length = 0;
	URL.Length = 0;
	
	for(i = 0; i < 4; i++) Voted[i] = 0;
	for(i = 0; i < AllPRI.Length; i++) if(AllPRI[i] != None) class'MyInfo'.static.Get(AllPRI[i]).bVoted = False;
	
	RemoteRole = ROLE_None;
	NetUpdateTime = Level.TimeSeconds - 1;
	LastCallTime = Level.TimeSeconds;
}

function bool MyMutate(MyInfo LRI, string MyMutation){
	switch(Left(MyMutation, 4)){
		case "call": return Call(LRI, Mid(MyMutation, 4)); //  Mid(MyMutation, 4) = 'calllgarcs 1' 'callrestart'
		case "cast": return Cast(Right(MyMutation, 1), LRI);
	}
}

function bool IsAllowCall(MyInfo LRI){
	
	local int WaitN20;
	local int Wait;
	local int N;
	
	Wait = Level.TimeSeconds - LastCallTime;
	WaitN20 = 20 + Wait;
	bLastCaller = (LRI == Caller);
	
	if(IsInState('VoteInProgress')) N = 12;
	//else if(LRI.Me.PlayerReplicationInfo.bOnlySpectator) N = 13; // allow spectators to vote
	else if(bLastCaller && Wait < 10) N = WaitN20;
	if(N != 0) return LRI.ReceiveMessage(class'UnallowedMessage', N);
	return True;
}

function bool Call(MyInfo LRI, string CallOptions){

	local GameInfo Game;
	local BroadcastHandler BH;
	local GameReplicationInfo GRI;
	local zMain M;
	local bool BP;
	local int IntP;
	local string V, P, Map;

	if(!IsAllowCall(LRI)) return False;
	
	Split(CallOptions, " ", Options); // 'calllgarcs 1' 'callrestart'
	Options.Length = 3;
	
	M = zMain(Owner);
	BH = Level.Game.BroadcastHandler;
	GRI = Level.Game.GameReplicationInfo;
	Game = Level.Game;
	P = Options[1];
	BP = bool(Options[1]);
	IntP = int(Options[1]);
	
	switch(Options[0]){
		case "mutespecs": if(BH.bPartitionSpectators != BP) V = "Mute Spectators" @ P; break;
		case "map": Map = SearchMapName(P); if(Map != "") V = "Map" @ Map; Options[1] = Map; break;
		case "ws": Options[0] = "weaponstay";
		case "weaponstay": if(BP != Game.bWeaponStay) V = "Weapon Stay" @ BP; break;
		case "tl": Options[0] = "timelimit";
		case "timelimit": if(IntP > 0) V = "TimeLimit" @ P; break;
		case "minplayers": V = "MinPlayers" @ P; break;
		case "maxplayers": if(intP > 0) V = "MaxPlayers" @ P; break;
		case "kick": Kicked = GRI.FindPlayerByID(intP); if(Kicked != None && !Kicked.bAdmin) V = "Kick" @ Kicked.PlayerName; break;
		case "restart": V = "Restart Map"; break;
		case "mode": Options[0] = "game";
		case "game": V = GameVoting(); break;
		case "isp": if(M.bInteractionShield != BP) V = "Interaction Shield" @ BP; break;
		case "doubledamage": Options[0] = "dd";
		case "dd": if(M.bDoubleDamage != BP) V = "Double Damage" @ BP; break;
		case "isa": V = "Interaction Shield (Server Actor)" @ BP; break;
		//case "lgca": Options[0] = "lgarcs";
		//case "lgarcs": if(M.LightningGunArcs != Clamp(IntP, 0, 3)) V = "Lightning Gun Child Arcs" @ P; break;
		case "altws": if(M.bAltWeaponSettings != BP) V = "Alternative Weapon Settings" @ BP; break;
		case "nodd": Options[0] = "nododgedelay";
		case "nododgedelay": V = "No Dodge Delay Time" @ BP; break;
		case "dodgedelay": V = "Dodge Delay Time" @ !BP; break;
		case "fastws": V = "Fast Weapon Switching" @ BP; break;
		
		case "tickrate": if(IntP > 0); IntP = Clamp(IntP, 20, 85); V = "Tick Rate" @ IntP; break;
		default: return LRI.ReceiveMessage(class'UnallowedMessage', 36);
	}
	// start a vote
	if(V != ""){
		VotedString = V;
		Caller = LRI;
		GotoState('VoteInProgress');
	}
}

function VotePassed(){
	
	local GameInfo Game;
	local BroadcastHandler BH;
	local GameReplicationInfo GRI;
	local zMain M;
	local bool BP;
	local int IntP;
	local string P, URLed;
	local class<zMain> MC;
	
	M = zMain(Owner);
	MC = class'zMain';
	BH = Level.Game.BroadcastHandler;
	GRI = Level.Game.GameReplicationInfo;
	Game = Level.Game;
	P = Options[1];
	BP = bool(Options[1]);
	IntP = int(Options[1]);
	URLed = class'zUtil'.static.Implode("?", URL);
	
	switch(Options[0]){ // vote passed...
		case "mutespecs": BH.SetPropertyText("bPartitionSpectators", P); break;
		case "map": Level.ServerTravel(P, False); break;
		case "weaponstay": 
		case "timelimit": 
		case "minplayers": 
		case "maxplayers": Game.SetPropertyText(Options[0], P); break;
		case "kick": KickPlayer(Kicked); break;
		case "restart": Level.ServerTravel("?restart", False); break;
		case "game": Level.ServerTravel(URLed, False); break;
		case "isp": ChangeDefaultValue("bInteractionShield", BP); break;
		//case "lgarcs": ChangeDefaultValue("LightningGunArcs", IntP); break;
		case "dd": ChangeDefaultValue("bDoubleDamage", BP); break;
		case "isa": class'InteractionShieldPlus'.static.BecomeServerActor(BP, Self); break; // need restart
		case "altws": ChangeDefaultValue("bAltWeaponSettings", BP); break;
		case "nododgedelay": ChangeDefaultValue("bNoDodgingDelay", BP); break;
		case "dodgedelay": ChangeDefaultValue("bNoDodgingDelay", !BP); break;
		case "fastws": ChangeDefaultValue("bFastWeaponSwitching", BP); break;
		
		case "tickrate": ChangeTickRate(IntP); break;
	}
}

function ChangeDefaultValue(coerce string Property, coerce string V, optional int Code){
	Owner.SetPropertyText(Property, V);
	Owner.SaveConfig();
	switch(Property){
		case "bAltWeaponSettings": zMain(Owner).AltWeaponSettings(); break;
		case "bDoubleDamage": DestroyActor(class'UDamagePack'); break;
	}
}

// todo: проверка чтобы только Интернет, а не LAN
function ChangeTickRate(int IntP){
	IntP = Clamp(IntP, 20, 85);
	ConsoleCommand("set IpDrv.TcpNetDriver NetServerMaxTickRate" @ IntP);
}

function bool Cast(coerce int Index, MyInfo LRI){
	
	local int N;
	
	if(!IsInState('VoteInProgress')) N = 11;
	else if(LRI.bVoted) N = 14; // !!!
	if(N != 0) return LRI.ReceiveMessage(class'UnallowedMessage', N);
	
	Index = Clamp(Index, 0, 1);
	Voted[Index]++;
	Voted[Index+2]--;
	LRI.bVoted = True;
}

function int NumPlayers(){
	return Level.Game.NumPlayers; // !!!
}

state VoteInProgress{

	function BeginState(){

		Time = zMain(Owner).VotingTime;
		PassPercent = zMain(Owner).VotingPassPercent;
		
		Voted[2] = Ceil(PassPercent * NumPlayers() / 100.0);
		Voted[3] = Voted[2];
		
		Cast(1, Caller); // 1 = Yes, 0 = No
		
		BroadcastLocalizedMessage(class'VoteMessageCaller', Time, Caller.PlayerReplicationInfo);
		SetTimer(1.0, True);
		RemoteRole = ROLE_SimulatedProxy;
		NetUpdateTime = Level.TimeSeconds - 1;
	}

	function EndState(){
		
		local Controller C;
		local MyInfo LRI;
		
		for(C = Level.ControllerList; C != None; C = C.NextController){
			if(C.PlayerReplicationInfo == None) continue;
			LRI = class'MyInfo'.static.Get(C.PlayerReplicationInfo);
			LRI.ReceiveMessage(class'VoteMessageCaller', -1, Caller.PlayerReplicationInfo);
			LRI.ReceiveMessage(class'VoteMessageType', -1,,, Self);
			LRI.ReceiveMessage(class'VoteMessageVotingProgress', Status);
		}
		
		Reset();
		Disable('Timer');
	}

	function Timer(){
		BroadcastLocalizedMessage(class'VoteMessageVotingProgress',,,, Self);
		if(!bVoteTypeBroadcasted){
			BroadcastLocalizedMessage(class'VoteMessageType', Time,,, Self);
			bVoteTypeBroadcasted = True;			
		}
		// check votes
		if(--Time < 0) Status = 2;
		else if(Voted[1] * 100.0 / NumPlayers() >= PassPercent) Status = 1; // passed
		else if(Voted[0] * 100.0 / NumPlayers() >= PassPercent) Status = 2; // failed

		if(Status == 1) VotePassed();
		if(Status != 0) GotoState('');
	}
}

// ucc server DM-rankin.ut2?game=xGame.xTeamGame?Mutator=xWeapons.MutNoSuperWeapon,XGame.MutNoAdrenaline,UnDefy09.zMain?timelimit=10?Minplayers=2?Difficulty=5?MaxPlayers=4?Timeouts=2?WarmUpSeconds=0 ini=ut2004-1v1-7x4.ini
function string GameVoting(){ // callvote game tdm rankin
	
	URL[0] = SearchMapName(Options[2]); // 0 - game 1- type, 2 - map
	if(URL[0] == "") return "";
	
	switch(Options[1]){
		case "1x1": case "1x1": case "1v1": case "1on1": case "duel":
			URL[1] = "Game=xGame.xDeathMatch";
			//URL[2] = "Mutator=xWeapons.MutNoSuperWeapon,XGame.MutNoAdrenaline," $ class'zUtil'.static.GetPackageName(Class) $ ".zMain";
			//URL[2] = "Mutator=XGame.MutNoAdrenaline";
			URL[2] = "timelimit=15?MaxPlayers=2?DoubleDamage=False";
			return "1on1" @ URL[0];
		case "tdm":
		case "team":
			URL[1] = "Game=xGame.xTeamGame";
			URL[2] = "timelimit=20?DoubleDamage=True";
			return "Team DeathMatch" @ URL[0];
	}
}

function KickPlayer(PlayerReplicationInfo PRI){
	local PlayerController PC;
	PC = PlayerController(PRI.Owner);
	if(PRI != None && PC != None && NetConnection(PC.Player) != None){
		PC.ClientNetworkMessage("AC_Kicked", "You have been kicked!");
		if(PC.Pawn != None) PC.Pawn.Destroy();
		if(PC != None) PC.Destroy();
	}
}

function string SearchMapName(string S){
	local int i;
	for(i = 0; i < Maps.Length; i++) if(class'zUtil'.static.PregMatch(Maps[i], S)) return Maps[i];
}

function IsValidVote(string P);

function DestroyActor(class<Actor> ActorClass){
	local Actor A;
	foreach DynamicActors(ActorClass, A) A.Destroy();
}

simulated function Debug(coerce string S){
	class'zUtil'.static.Debug(S, Self);
}

defaultproperties{
	RemoteRole=ROLE_None
}
