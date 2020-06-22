// =================================================
// UnDefy
// =================================================
class zMain extends Mutator config;

var config bool bFirstRun;
var(Server) config byte Timeouts;
var(Server) config int TimeoutLength;
var(Client) config bool bClassicSniperSmoke;
var(Client) config bool bMyWeaponViewShake;
var(Client) config bool bDamageIndicators;
var(Client) config byte EnemyCam;
var(Client) config bool bPickupConsoleMessages;
var(Server) config byte ForceRespawnTime; // 0 - ignore
var(Server) config bool bAllowHitSounds;
var(ClientHitSounds) config byte FeedbackType;
var(ClientHitSounds) config byte FeedbackLine; // if FeedbackLine == 70 & Damage == 70 sound will be the loudest (100%)
var(ClientHitSounds) config float FeedbackVolume; // hitsound volume (ignores in FeedbackType = 3)
var(ClientHitSounds) config int iSimpleHitType;
var(ClientOverlay) config byte OverlayMetric;
var(ClientOverlay) config int OverlayPosX;
var(ClientOverlay) config int OverlayPosY;
var(ClientOverlay) config bool bMeInOverlay;
var(ClientOverlay) config bool bOverlayLocationBetween;
var(ClientOverlay) config color OverlayBackgroundColor;
var(ClientOverlay) config byte OverlaySize;
var(ClientOverlay) config bool bOverlayNewLocations;
var(ClientOverlay) config bool bTeamOverlay;
var(ClientOverlay) config bool bDrawOverlayTitles;
var(Server) config bool bAllowTeamOverlay; // server
var(Server) config bool bAllowBrightSkins; // server
var(ClientBrightSkins) config bool bEnableBrightSkins;
var(ClientBrightSkins) config string EnemySkin;
var(ClientBrightSkins) config string TeamSkin;
var(Server) config int WarmUpSeconds; // -1 disabled, 0 - infinity
var(EnemyBones) config string EnemyBones;
var(TeamMates) config bool bCrosshairTeamInfo;
var(Items) config bool bDoubleDamage;
var(Items) config bool bAdrenaline;
var(Items) config bool bSuperWeapons;
var(Server) config byte VotingTime;
var(Server) config byte VotingPassPercent;

var(Game) WarmUp WarmUp;
var(Game) MyGameRules GameRules;
var(Game) MyGameReplicationInfo MyGRI;
var(Game) class<MyGameReplicationInfo> MyGameReplicationClass;
var(Game) Voting Voting;
var(Game) Timeout TimeActor;
var MyTeamInfo MyTeams[2];
var config bool bAllCaptains;

var(Mutators) bool bUTComp;
var(Mutators) bool bTTM;
var(Server) config bool bInteractionShield;

var config bool bServerStats;

var(Client) config bool bCCAutoComplete;
var(Client) config bool bShowWelcomeMessage;
var(Client) config bool bShowChatIcon;
var config bool bShortDeathMessages;
var config bool bDarkenDeadBody;

var(Weapons) config bool bAltWeaponSettings;
var(Weapons) bool bNoLightningGunArcs; // config? 
var(Weapons) bool bLowShockFireRate;
var(Weapons) bool bLowShieldAmmo;

// dodging
var config bool bServerNoDodgingDelay; // server
var config bool bNoDodgingDelay;
var config bool bFastWeaponSwitching;

function PreBeginPlay(){

	local string LocalURL, InOpt;
	local zUtil F;

	Super.PreBeginPlay();
	LocalURL = Level.GetLocalURL();
	F = new class'zUtil';

	bUTComp = F.PregMatch(LocalURL, ".MutUTComp");
	bTTM = F.PregMatch(LocalURL, ".TTM_MutMain");
	if(bServerStats) if(bUTComp || bTTM) bServerStats = False;

	// command line
	if(F.GetOption(LocalURL, "bIntShield", InOpt)) bInteractionShield = bool(InOpt);
	if(F.GetOption(LocalURL, "AllowHitSounds", InOpt)) bAllowHitSounds = bool(InOpt);
	if(F.GetOption(LocalURL, "Timeouts", InOpt)) Timeouts = int(InOpt);
	if(F.GetOption(LocalURL, "WarmUpSeconds", InOpt)) WarmUpSeconds = int(InOpt);
	if(F.GetOption(LocalURL, "DoubleDamage", InOpt)) bDoubleDamage = bool(InOpt);
	if(F.GetOption(LocalURL, "AllowBrightSkins", InOpt)) bAllowBrightSkins = bool(InOpt);
	if(F.GetOption(LocalURL, "Adrenaline", InOpt)) bAdrenaline = bool(InOpt);
	if(!bAdrenaline) Level.Game.AddMutator("XGame.MutNoAdrenaline");
	if(F.GetOption(LocalURL, "SuperWeapons", InOpt)) bSuperWeapons = bool(InOpt);
	if(!bSuperWeapons) Level.Game.AddMutator("xWeapons.MutNoSuperWeapon");
	if(F.GetOption(LocalURL, "VotingTime", InOpt)) VotingTime = byte(InOpt);

	// interaction shield
	if(bInteractionShield) class'InteractionShieldPlus'.static.StaticSpawn(Self);
	
	// force respawn
	ForceRespawnTime = Clamp(ForceRespawnTime, 0, 8);
	if(ForceRespawnTime != 0) DeathMatch(Level.Game).bForceRespawn = False;

	// warmup
	if(WarmUpSeconds >= 0) WarmUp = Spawn(class'WarmUp', Self);

	// voting
	if(VotingTime > 0) Voting = Spawn(class'Voting', Self);

	// timeout
	TimeoutLength = Max(10, TimeoutLength);
	Timeouts = Clamp(Timeouts, 0, 9);
	if(Timeouts != 0 && IsTimeoutGame()) TimeActor = Spawn(class'Timeout', Self);

	// My GRI
	if(Level.Game.bTeamGame) MyGameReplicationClass = class'MyTeamGameReplicationInfo';
	MyGRI = Spawn(MyGameReplicationClass, Self);
}

function PostBeginPlay(){
	Super.PostBeginPlay();
	GameRules = Spawn(class'MyGameRules');
	Level.Game.AddGameModifier(GameRules);
	GameRules.Main = Self;
	AltWeaponSettings();
	// stats
	//if(DeathMatch(Level.Game).LocalStatsScreenClass == class'DMStatsScreen') DeathMatch(Level.Game).LocalStatsScreenClass = class'zLocalStats';
	if(!default.bFirstRun) return; // save config
	default.bFirstRun = False;
	class'zMain'.static.StaticSaveConfig();	
}

function AltWeaponSettings(){
	if(!bAltWeaponSettings) return;
	FixShockRifle();
	FixSniperRifle();
	FixShieldGun();
}

function FixSniperRifle(){
	//if(LightningGunArcs != class'SniperFire'.default.NumArcs) return;
	//LightningGunArcs = Clamp(LightningGunArcs, 0, 3);
	if(bNoLightningGunArcs) class'SniperFire'.default.NumArcs = 1;
}

function FixShockRifle(){
	if(bLowShockFireRate) class'ShockBeamFire'.default.FireRate = 0.8; // default 0.7
}

function FixShieldGun(){
	if(!bLowShieldAmmo) return;
	class'ShieldAltFire'.default.AmmoPerFire = 20;
	class'ShieldAmmo'.default.MaxAmmo = 80;
	class'ShieldAmmo'.default.InitialAmount = 80;
}

function ModifyPlayer(Pawn P){

	local Controller C;
	local MyInfo MyInfo, OtherLRI;
	local byte TeamNum;

	Super.ModifyPlayer(P);
	P.bAlwaysRelevant = True;
	if(WarmUp != None && WarmUp.WeaponNames.Length != 0) WarmUp.GiveAllWeapons(P);

	if(bServerStats) GameRules.ModifyPlayer(P); // stats

	MyInfo = GameRules.GetLRI(P.PlayerReplicationInfo);
	TeamNum = MyInfo.GetTeamNum();
	if(TeamNum < 4 && MyTeams[TeamNum] != None) MyTeams[TeamNum].ModifyTeamPlayer(MyInfo);

	MyInfo.MyPawn = xPawn(P);
	
 	if(!bAllowBrightSkins || MyInfo.MyPawn == None) return;
 	
 	for(C = Level.ControllerList; C != None; C = C.NextController){
		if(PlayerController(C) == None || C.PlayerReplicationInfo == None) continue;
		OtherLRI = GameRules.GetLRI(C.PlayerReplicationInfo);
		if(MyInfo != OtherLRI) OtherLRI.ClientSpawnNotify(MyInfo);
	}
}

function Mutate(string MutateString, PlayerController PC){

	local PlayerReplicationInfo PRI;
	local MyInfo LRI;
	local MyTeamInfo MTI;
	local zUtil F;
	local string MyMutation;
	local bool bNoReturn;
	local int N;

	PRI = PC.PlayerReplicationInfo;
	LRI = class'MyInfo'.static.Get(PRI);
	F = new class'zUtil';
	
	N = PC.GetTeamNum();
	MyMutation = Mid(MutateString, 6);
	if(N < 4) MTI = MyTeams[N];
	
	switch(MutateString){
		case "ready": if(WarmUp != None) WarmUp.MutateReady(PRI); break;
		case "teamready": if(WarmUp != None) WarmUp.MutateTeamReady(PRI); break;
		case "notready": if(WarmUp != None) WarmUp.MutateNotReady(PRI); break;
		case "showtime":
		case "currenttime": F.ConsoleMessage(PC, "Current time:^3" @ F.GetLevelTime(Level)); break;
		case "calltimeout": if(TimeActor != None) TimeActor.MutateCallOut(PRI); break;
		case "calltimein": if(TimeActor != None) TimeActor.MutateCallIn(PRI); break;
		case "rules": class'Help'.static.Rules(Self, PC); break;
		case "wstats": if(LRI.Stats != None) LRI.Stats.MutateWeaponStats(); break;
		case "captains": if(Level.Game.bTeamGame) ShowCaptains(LRI);
		default: bNoReturn = True;
	}
	if(!bNoReturn) return;
	
	switch(Left(MutateString, 6)){
		case "voting": if(Voting != None) Voting.MyMutate(LRI, MyMutation); break;
		case "invite": if(MTI != None) MTI.Invite(LRI, MyMutation);
		case "resign": if(MTI != None) MTI.Resign(LRI, MyMutation);
		case "tmlock": 
	}
	Super.Mutate(MutateString, PC);
}

function bool ShowCaptains(MyInfo LRI){
	
	local int TeamIndex;
	local string S;
	local MyInfo Captain;

	if(bAllCaptains) return LRI.ReceiveMessage(class'UnallowedMessage', 50);
	for(TeamIndex = 0; TeamIndex < 2; TeamIndex++){
		Captain = MyTeams[TeamIndex].Captain;
		if(MyTeams[TeamIndex] == None || Captain == None) continue;
		S = MyTeams[TeamIndex].GetHumanReadableName() @ "TEAM" @ Captain.PlayerReplicationInfo.PlayerID;
		LRI.ClientMessage(S @ Captain.GetHumanReadableName());
	}
}

function string ParseChatPercVar(Controller C, string S){

	local MyInfo Linked;
	local Pickup Pickup, MinPickup;
	local float Distance, MinDistance;

	if(NextMutator != None) S = NextMutator.ParseChatPercVar(C, S);
	if(S == "%e" && C.Enemy != None) return C.Enemy.GetHumanReadableName();
	Linked = GameRules.GetLRI(C.PlayerReplicationInfo);
	if(S == "%i") S = Linked.LastPickupItem;
	else if(S == "%n") S = Linked.LastPickupWeapon;
	else if(S == "%u") S = Linked.LastPickupPowerUp;
	else if(S == "%c" && C.Pawn != None){
		MinDistance = 19999;
		foreach DynamicActors(class'Pickup', Pickup){
			if(!(Pickup.IsA('WeaponPickup') || Pickup.IsA('ShieldPickup') || Pickup.IsA('UDamagePack'))) continue;
			Distance = VSize(C.Pawn.Location - Pickup.Location);
			if(Distance > MinDistance) continue;
			MinDistance = Distance;
			MinPickup = Pickup;
		}
		if(ShieldPickup(MinPickup) != None) S = ShieldPickup(MinPickup).ShieldAmount @ "Shield";
		else if(UDamagePack(MinPickup) != None) S = "DOUBLE DAMAGE";
		else if(SuperHealthPack(MinPickup) != None) S = "Super Health";
		else S = MinPickup.GetHumanReadableName();
	}
	return S;
}

function SpawnMyInfo(PlayerReplicationInfo PRI){
	local MyInfo MyInfo;
	MyInfo = Spawn(class'MyInfo', PRI.Owner);
	MyInfo.PlayerReplicationInfo = PRI;
	if(bServerStats) MyInfo.Stats = PRI.Spawn(class'MyStats', PRI.Owner);
	MyInfo.NextReplicationInfo = PRI.CustomReplicationInfo;
	PRI.CustomReplicationInfo = MyInfo;
}

function bool IsRelevant(Actor A, out byte bSuperRelevant){ // если вернуть False то удалим
	if(PlayerReplicationInfo(A) != None) SpawnMyInfo( PlayerReplicationInfo(A) );
	else if(A.IsA('UDamagePack') && !bDoubleDamage) return False;
	else if(Level.Game.bTeamGame && TeamInfo(A) != None) Spawn(class'MyTeamInfo', A);
	else if(bFastWeaponSwitching && GameReplicationInfo(A) != None) GameReplicationInfo(A).bFastWeaponSwitching = True;
	return Super.IsRelevant(A, bSuperRelevant);
}

/*function bool CheckReplacement(Actor A, out byte bSuperRelevant){ // OBSOLETE
	Debug("CheckReplacement" @ A.GetHumanReadableName());
	return Super.CheckReplacement(A, bSuperRelevant);
	if(xPawn(A) != None && xPawn(A).RequiredEquipment[1] ~= "XWeapons.ShieldGun" && bLinkPower){
		xPawn(A).RequiredEquipment[1] = class'zUtil'.static.GetPackageName() $ ".MyShieldGun";
	}
	return Super.CheckReplacement(A, bSuperRelevant);
}*/




//function bool CheckReplacement(Actor A, out byte bSuperRelevant){
//	bSuperRelevant = 0;
//	if(Weapon(A) != None && MyShieldGun(A) == None){
//	//if(ShieldGun(A) != None && string(A.Class) ~= "xWeapons.ShieldGun"){
//		if(LinkGun(A) != None) return True;
//		ReplaceWith(A, class'zUtil'.static.GetPackageName(Class, True) $ "MyShieldGun");
//		Debug("Replace" @ A @ "by MyShieldGun");
//		//return True;
//	}
//	return Super.CheckReplacement(A, bSuperRelevant);
//}

function bool IsWarmup(){
	local ReplicationInfo W;
	if(WarmUp != None) return True;
	foreach DynamicActors(class'ReplicationInfo', W){
		if(W.IsA('UTComp_Warmup') && (bool(W.GetPropertyText("bInWarmup")) || int(W.GetPropertyText("iFinalCountDown")) > 0)) return True;
		if(W.IsA('TTM_GameReplicationInfo') && bool(W.GetPropertyText("bIsWarmup"))) return True;
	}
	return False;
}

function bool IsTimeoutGame(){
	switch(GetItemName(string(Level.Game))){
		case "xDeathMatch":
		case "xTeamGame": return True;
	}
	return False;
}

private function string GetWarmupStatus(){

	local int Seconds, Minutes;
	local zUtil F;

	if(WarmUp != None) return "Warm-up";
	if(Level.GRI.TimeLimit != 0) Seconds = Level.GRI.RemainingTime;
	else Seconds = Level.GRI.ElapsedTime;
	Minutes = Seconds / 60;
	Seconds -= Minutes * 60;
	F = new class'zUtil';
	return F.LeadingZeros(Minutes) $ ":" $ F.LeadingZeros(Seconds) @ Eval(Level.GRI.TimeLimit != 0, "Remained", "Elapsed");
}

function GetServerDetails(out GameInfo.ServerResponseLine S){
	local int i;
	i = S.ServerInfo.Length;
	S.ServerInfo.Length = i + 2;
	S.ServerInfo[i].Key = "Mutator";
	S.ServerInfo[i].Value = FriendlyName;
	S.ServerInfo[i+1].Key = "Time";
	S.ServerInfo[i+1].Value = GetWarmupStatus();
}

static event string GetDescriptionText(string PropertyName){
	switch(PropertyName){
		case "ForceRespawnTime": 	return "Force respawn time in seconds, if 0 ignoring (depends of bForceRespawn)";
		case "Timeouts": 			return "Number of timeouts for player/team in match (0 - disabled)";
		case "TimeoutLength": 		return "Timeout length in seconds";
		case "bAllowHitSounds": 	return "Hitsounds";
		case "bAllowBrightSkins": 	return "Force models and bright skins";
		case "WarmUpSeconds": 		return "Warm-up time in seconds (-1 - disabled, 0 - unlimited, > 0 - this time)";
		case "bDoubleDamage":		return "";
		case "bAdrenaline":			return "";
		case "bSuperWeapons":		return "";
		case "VotingTime":			return "Vote time limit (if 0 voting is disabled)";
		case "VotingPassPercent":	return "";
		case "bInteractionShield":	return "Interaction Shield (Anti-cheat) WARNING! if UTComp, than last version (17a) is necessary";
		case "bServerStats":		return "Weapon stats (beta) (hits, accuracy)";
		case "bAllCaptains":		return "";
		case "bAltWeaponSettings":	return "Alternative weapon settings. Lightning Gun child arcs = 1 (default 3), Shield Gun: MaxAmmo = 80, Ammo Per Fire = 20, ShockRifle: FireRate = 0.8 (default 0.7)";
		case "bServerNoDodgingDelay": 	return "No delay between dodges";
		case "bFastWeaponSwitching":	return "Fast weapon switching (no boost dodging)";
		case "":		return "";
	}
}
//PlayInfo.AddSetting(default.RulesGroup, "ReplacedWeaponClassNames2", default.ONSWeaponDisplayText[5], 0, 1, "Select", WeaponOptions);
static function FillPlayInfo(PlayInfo PlayInfo){
	local int i;
	Super.FillPlayInfo(PlayInfo);
	PlayInfo.AddSetting(default.FriendlyName, "ForceRespawnTime", "Force Respawn Time", 0, i++, "Text", "1;0:8");
	PlayInfo.AddSetting(default.FriendlyName, "Timeouts", "Timeouts", 0, i++, "Text", "1;0:3");
	PlayInfo.AddSetting(default.FriendlyName, "TimeoutLength", "Timeout Length", 0, i++, "Text", "5;0:100");
	PlayInfo.AddSetting(default.FriendlyName, "bAllowHitSounds", "Allow Hitsounds", 0, i++, "Check");
	PlayInfo.AddSetting(default.FriendlyName, "bAllowBrightSkins", "Allow Force Models / Bright Skins", 0, i++, "Check");
	PlayInfo.AddSetting(default.FriendlyName, "WarmUpSeconds", "Warm-up Time", 0, i++, "Text", "1;-1:999");
	PlayInfo.AddSetting(default.FriendlyName, "bDoubleDamage", "Double Damage", 0, i++, "Check");
	PlayInfo.AddSetting(default.FriendlyName, "bAdrenaline", "Adrenaline", 0, i++, "Check");
	PlayInfo.AddSetting(default.FriendlyName, "bSuperWeapons", "Super Weapons", 0, i++, "Check");
	PlayInfo.AddSetting(default.FriendlyName, "VotingTime", "Voting Time", 0, i++, "Text", "1;0:60");
	PlayInfo.AddSetting(default.FriendlyName, "VotingPassPercent", "Voting Pass Percent", 0, i++, "Text", "1;1:100");
	PlayInfo.AddSetting(default.FriendlyName, "bInteractionShield", "Interaction Shield +", 0, i++, "Check");
	PlayInfo.AddSetting(default.FriendlyName, "bServerStats", "Weapon Stats", 0, i++, "Check");
	PlayInfo.AddSetting(default.FriendlyName, "bAllCaptains", "All Captains", 0, i++, "Check");
	PlayInfo.AddSetting(default.FriendlyName, "bAltWeaponSettings", "Alternative Weapon Settings", 0, i++, "Check");
	PlayInfo.AddSetting(default.FriendlyName, "bServerNoDodgingDelay", "No Dodging Delay", 0, i++, "Check");
	PlayInfo.AddSetting(default.FriendlyName, "bFastWeaponSwitching", "Fast Weapon Switching", 0, i++, "Check");
}

simulated function Debug(coerce string S){
	class'zUtil'.static.Debug(S, Self);
}

defaultproperties{
	bAddToServerPackages=True
	bFirstRun=True
	ForceRespawnTime=8
	Timeouts=1
	TimeoutLength=60
	bClassicSniperSmoke=True
	bMyWeaponViewShake=False
	bDamageIndicators=True
	EnemyCam=0
	bPickupConsoleMessages=True
	FriendlyName="UnDefy 2004 v10"
	Description="UnDefy is a simple alternative competition mod for Unreal Tournament 2004. Web: sst.planetunreal.ru"
	GroupName="Unreal64Pack"
	FeedbackType=2
	FeedbackLine=20
	FeedbackVolume=1.0
	iSimpleHitType=1 // simple hit sound: 0 - hit1, 1 - like lowest CPMA, 2 - like normal CPMA
	OverlayMetric=0
	bMeInOverlay=False
	bOverlayLocationBetween=True
	OverlayPosX=8
	OverlayPosY=80
	bAllowTeamOverlay=True
	OverlayBackgroundColor=(R=10,G=10,B=10,A=120)
	OverlaySize=1
	bOverlayNewLocations=True
	bAllowHitSounds=True
	bAllowBrightSkins=True
	bEnableBrightSkins=True
	EnemySkin="Gorge/Blue/250"
	TeamSkin="Reinha/None/120"
	EnemyBones="10/10/0"
	WarmUpSeconds=0
	bTeamOverlay=True
	bDrawOverlayTitles=False
	bCrosshairTeamInfo=True
	bDoubleDamage=True
	bAdrenaline=True
	bSuperWeapons=False
	VotingTime=30
	VotingPassPercent=51
	bCCAutoComplete=True
	bInteractionShield=False
	bShowWelcomeMessage=True
	bShowChatIcon=True
	bServerStats=False
	bShortDeathMessages=False
	bAllCaptains=False
	MyGameReplicationClass=class'MyGameReplicationInfo'
	bDarkenDeadBody=True
	bAltWeaponSettings=False // weapons
	bNoLightningGunArcs=True
	bLowShockFireRate=True
	bLowShieldAmmo=True
	bServerNoDodgingDelay=False
	bNoDodgingDelay=True
	bFastWeaponSwitching=False
}
