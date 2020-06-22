class WarmUp extends Info;
// todo: настройка (warmup бит маска) 1 - все оружие
// note: разминка: Weapon.bEndOfRound = запрещает стрелять

var int WarmUpSeconds; // 0 - infinity
var int iCountDown;
var int WarmupEndReason; // -3 - warmup ended, -1 - all ready -2 - countdown stopped
var int RealTimeLimit;
var array<string> WeaponNames;
var bool bCountDownStopped;
var bool bLimited;
var byte NotReadyPlayerID;

event PreBeginPlay(){
	Super.PreBeginPlay();
	Level.Game.InitialState = 'MatchInProgress';
	DeathMatch(Level.Game).bFirstBlood = True;
	DeathMatch(Level.Game).bPlayersMustBeReady = True;
	DeathMatch(Level.Game).bWaitForNetPlayers = False;
	Deathmatch(Level.Game).NetWait = 0;
	//bMustJoinBeforeStart = False;
	//Level.Game.bDelayedStart = False; // игрок сразу респавнится как только вошел в игру, но тогда будут глюки если ушел в спеки и потом снова зашел. Error: Couldn't spawn player of type
	Level.Game.bWaitingToStartMatch = False;
	WarmUpSeconds = zMain(Owner).WarmUpSeconds;
	Log("Warmup started in" @ Level.Title @ Repl("(%S seconds)", "%S", WarmUpSeconds));
	SetTimer(1.0, True);
}

function bool MutateReady(PlayerReplicationInfo PRI){

	local MyInfo LRI;
	local int N;
	
	LRI = class'MyInfo'.static.Get(PRI);
	
	if(PRI.bOnlySpectator) N = 13;
	else if(PRI.bReadyToPlay) N = 31;
	else if(IsCountDown() && bLimited) N = 42;
	if(N != 0) return LRI.ReceiveMessage(class'UnallowedMessage', N);
	
	PRI.bReadyToPlay = True;
	BroadcastLocalizedMessage(class'ReadyMessage', 1, PRI);
}

function bool MutateNotReady(PlayerReplicationInfo PRI){
	
	local MyInfo LRI;
	local int N;
	
	LRI = class'MyInfo'.static.Get(PRI);
	
	if(!PRI.bReadyToPlay) N = 43;
	else if(IsCountDown() && bLimited) N = 42;
	else if(IsCountDown() && iCountDown < 2) N = 44; // too late
	else if(!LRI.bCanStopCountDown) N = 45;
	if(N != 0) return LRI.ReceiveMessage(class'UnallowedMessage', N);
	
	PRI.bReadyToPlay = False;
	BroadcastLocalizedMessage(class'ReadyMessage', 2, PRI);
	if(IsCountDown()) LRI.bCanStopCountDown = False;
}

function bool MutateTeamReady(PlayerReplicationInfo PlayerReplicationInfo){

	local MyInfo LRI;
	local MyTeamInfo MyTeam;
	local Controller C;
	local int TeamNum, N;
	
	LRI = class'MyInfo'.static.Get(PlayerReplicationInfo);
	TeamNum = LRI.GetTeamNum();
	if(TeamNum != 255) MyTeam = zMain(Owner).MyTeams[TeamNum];
	
	if(!Level.Game.bTeamGame) N = 46;
	else if(!bool(MyTeam)) N = 47;
	else if(!MyTeam.IsCaptain(LRI)) N = 34;
	if(N != 0) return LRI.ReceiveMessage(class'UnallowedMessage', N);
	
	for(C = Level.ControllerList; C != None; C = C.NextController){
		if(C.GetTeamNum() == TeamNum) C.PlayerReplicationInfo.bReadyToPlay = True;
	}
	BroadcastLocalizedMessage(class'ReadyMessage', 3, PlayerReplicationInfo);
}

auto state StartUp{
	event Tick(float F){
		local Pickup P;
		Level.Game.GameReplicationInfo.bMatchHasBegun = True; // иначе кнопка 'spectate' неактивна
		RealTimeLimit = DeathMatch(Level.Game).TimeLimit;
		DeathMatch(Level.Game).TimeLimit = 0;
		Level.Game.EndLogging("Warmup");
		// register weapons
		WeaponNames.Length = 0;
		foreach DynamicActors(class'Pickup', P){
			if(WeaponPickup(P) != None && !P.IsSuperItem()) WeaponNames[WeaponNames.Length] = string(P.InventoryType);
			P.StartSleeping();
		}
		if(WarmUpSeconds > 0) GotoState('Limited');
		else GotoState('Waiting');
	}
}

function Timer(){
	if(Level.Game.NumPlayers < 1){
		GotoState('Waiting');
		return;
	}
	if(CheckAll(True)){
		WarmupEndReason = -1;
		GotoState('CountDown');
		return;
	}
	if(bLimited) return;
	
	if(class'zUtil'.static.MultipleOf(Level.TimeSeconds, 40)) BroadcastSelfReady();
	else if(Level.Game.bTeamGame && class'zUtil'.static.MultipleOf(Level.TimeSeconds, 30)) BroadcastNotReady(-5); // team
	else if(class'zUtil'.static.MultipleOf(Level.TimeSeconds, 20)) BroadcastNotReady(-4); // player
	else if(class'zUtil'.static.MultipleOf(Level.TimeSeconds, 5)) BroadcastLocalizedMessage(class'WarmUpMessage', 0);
}

function BroadcastSelfReady(){
	local Controller C;
	for(C = Level.ControllerList; C != None; C = C.NextController){
		if(PlayerController(C) == None || PlayerController(C).IsSpectating()) continue;
		PlayerController(C).ReceiveLocalizedMessage(class'WarmUpMessage', -3, C.PlayerReplicationInfo);
	}
}

function BroadcastNotReady(int N){ // 4- player, 5- team
	local PlayerReplicationInfo PRI;
	local int i;
	if(NotReadyPlayerID >= Level.GRI.PRIArray.Length) NotReadyPlayerID = 0;
	for(i = NotReadyPlayerID; i < Level.GRI.PRIArray.Length; i++){
		PRI = Level.GRI.PRIArray[NotReadyPlayerID++];
		if(!PRI.bBot && !PRI.bOnlySpectator && !PRI.bReadyToPlay){
			BroadcastLocalizedMessage(class'WarmUpMessage', N, PRI);
			return;
		}
	}
	BroadcastLocalizedMessage(class'WarmUpMessage', 0);
}

state Waiting{
	function Timer();
	Begin:
	Sleep(5);
	if(Level.Game.NumPlayers < 1) Goto('Begin');
	GotoState('');
}
state Limited{
	function BeginState(){
		bLimited = True;
	}
	function Timer(){
		//if(Level.Game.NumPlayers < 1) return;
		Global.Timer();
		WarmUpSeconds = WarmUpSeconds - 1;
		if(WarmUpSeconds <= 0) WarmupEndReason = -3;
		if(WarmupEndReason != 0) GotoState('CountDown');
		else BroadcastLocalizedMessage(class'WarmUpMessage', WarmUpSeconds);
	}
}

function bool IsCountDown(){
	return False;
}


/*function LockWeapons(){
	local Controller C;
	local MyInfo LRI;
	for(C = Level.ControllerList; C != None; C = C.NextController){
		LRI = zMain(Owner).GameRules.GetLRI(C.PlayerReplicationInfo);
		if(LRI != None) LRI.RemoveWeapons();
	}
}*/

state CountDown{
	
	function bool IsCountDown(){
		return True;
	}
	
	function BeginState(){
		bCountDownStopped = False;
		iCountDown = 11;
		BroadcastLocalizedMessage(class'FinalCountDown', WarmupEndReason); // -1 все готовы, -3-разминка закончилась
		SetTimer(1, True);
		//LockWeapons();
	}
	function Timer(){
		iCountDown = iCountDown - 1;
		if(iCountDown <= 0){
			Destroy();
			return;
		}
		bCountDownStopped = (WarmUpSeconds == 0 && WarmupEndReason == -1 && CheckAll(False));
		if(bCountDownStopped){
			iCountDown = -2; // -2 отсчет остановлен
			GotoState('');
		}
		BroadcastLocalizedMessage(class'FinalCountDown', iCountDown);
	}
	// warmup ends here
	function EndState(){
		local Actor A;
		if(bCountDownStopped) return;
		DeathMatch(Level.Game).TimeLimit = RealTimeLimit;
		// уничтожаем лишнее
		WeaponNames.Length = 0;
		foreach DynamicActors(class'Actor', A){
			if(GameInfo(A) != None) continue;
			else if(xPlayerReplicationInfo(A) != None) ResetPlayerReplicationInfo( xPlayerReplicationInfo(A) );
			else if(Pickup(A) != None && Pickup(A).bDropped) A.Destroy();
			else if(UnrealPawn(A) != None) UnrealPawn(A).Spree = 0;
			if(A != None) A.Reset();
		}
		// game
		GameReset();
		GamePreBeginPlay();
		GamePostBeginPlay();
		Level.Game.StartMatch();
		BroadcastLocalizedMessage(class'MatchHasBegunMessage', RealTimeLimit);
	}
}

function GiveAllWeapons(Pawn P){
	local Inventory Inv;
	local byte i, Count;
	if(IsCountDown()) return;
	//for(i = 0; i < WeaponNames.Length; i++) P.GiveWeapon(WeaponNames[i]);
	for(i = 0; i < WeaponNames.Length; i++) P.CreateInventory(WeaponNames[i]);
	for(Inv = P.Inventory; Inv != None; Inv = Inv.Inventory){
		if(Weapon(Inv) != None) Weapon(Inv).SuperMaxOutAmmo();
		if(++Count > 250) return;
	}
}

// Level.Game.PostBeginPlay();
// если сделать это то свой чел в тиме будет в тебя стрелять
function GamePostBeginPlay(){
	local DeathMatch DeathMatch;
	DeathMatch = DeathMatch(Level.Game);
	if(DeathMatch.GameStats != None){
		DeathMatch.GameStats.Level.TimeSeconds = 0;
		DeathMatch.GameStats.NewGame();
		DeathMatch.GameStats.ServerInfo();
	}
}
function GamePreBeginPlay(){
	local DeathMatch DeathMatch;
	DeathMatch = DeathMatch(Level.Game);
	DeathMatch.InitGameReplicationInfo();
	DeathMatch.InitVoiceReplicationInfo();
	DeathMatch.InitLogging();
}
// Level.Game.Reset()
function GameReset(){
	local DeathMatch DeathMatch;
	DeathMatch = DeathMatch(Level.Game);
	DeathMatch.bFirstBlood = False;
	DeathMatch.bGameEnded = False;
	DeathMatch.bOverTime = False;
	DeathMatch.ElapsedTime = 0;
	DeathMatch.StartTime = 0;
	DeathMatch.RemainingTime = 60 * DeathMatch.TimeLimit; // +1
}

function ResetPlayerReplicationInfo(xPlayerReplicationInfo PRI){
	local int i;
	PRI.StartTime = 0;
	PRI.Score = 0;
	PRI.Deaths = 0;
	PRI.HasFlag = None;
	PRI.NumLives = 0;
	PRI.bOutOfLives = False;
	PRI.HasFlag = None;
	PRI.WeaponStatsArray.Length = 0;
	PRI.VehicleStatsArray.Length = 0;
	PRI.ComboCount = 0;
	PRI.FlakCount = 0;
	PRI.HeadCount = 0;
	PRI.RanOverCount = 0;
	PRI.DaredevilPoints = 0;
	PRI.GoalsScored = 0;
	PRI.bFirstBlood = False;
	for(i = 0; i < 6; i++) PRI.Spree[i] = 0;
	for(i = 0; i < 7; i++) PRI.MultiKills[i] = 0;
	for(i = 0;i < 5; i++) PRI.Combos[i] = 0;
	PRI.GoalsScored = 0;
	PRI.FlagTouches = 0;
	PRI.FlagReturns = 0;
	PRI.Kills = 0;
	PRI.Suicides = 0;
}

function bool CheckAll(bool bReady){
	local Controller C;
	local PlayerController PlayerController;
	local int ReadyPlayersCount, UnReadyPlayersCount;
	//if(Level.Game.NumPlayers < 1) return False;
	for(C = Level.ControllerList; C != None; C = C.NextController){
		PlayerController = PlayerController(C);
		if(PlayerController == None || PlayerController.PlayerReplicationInfo.bOnlySpectator) continue;
		if(PlayerController.PlayerReplicationInfo.bReadyToPlay) ReadyPlayersCount++;
		else UnReadyPlayersCount++;
	}
	if(bReady) return (ReadyPlayersCount == Level.Game.NumPlayers);
	else return UnReadyPlayersCount > 0;
}

simulated function Debug(coerce string S){
	class'zUtil'.static.Debug(S, Self);
}

defaultproperties{}
