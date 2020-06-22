class InteractionShieldPlus extends ReplicationInfo config(InteractionShieldPlus);
// todo: см. todo list
var private PlayerController Gamer;

var private int IntIndex;
var private int OvIndex;

var private string MyHash;
var const private config string Hash;
var private string KickMessage;
//var private string HelpMessage;

var private bool bUTComp;
var private string UTCV;
var private bool bTTM;
var private string TTMV;
var private bool bUnDefy;

const UDV = "undefy10"; // lowercase

replication{
	reliable if(bNetInitial && Role == Role_Authority) MyHash, bUTComp, bTTM, TTMV, UTCV, bUnDefy;
}

// todo: GUIController.MenuStack - проверить эти менюшки
event PreBeginPlay(){
	
	local string URL;
	local zUtil F;
	
	F = new class'zUtil';
	URL = Level.GetLocalURL();
	MyHash = Hash;
	
	bUTComp = F.PregMatch(URL, ".MutUTComp");
	UTCV = F.GetMutatorVersion(URL, "MutUTComp");
	bTTM =  F.PregMatch(URL, ".TTM_MutMain");
	TTMV = F.GetMutatorVersion(URL, "TTM_MutMain");
	bUnDefy = F.PregMatch(URL, ".zMain");
	
	Log("Interaction Shield (Plus) Initialized!");
	Log("UTComp" @ bUTComp $", bTTM" @ bTTM $", UnDefy" @ bUnDefy);
	if(MyHash != "") Log("MD5 Hash:" @ MyHash);
}

simulated state Kick{
	Begin:
	Gamer.ServerSay(KickMessage);
	Sleep(1.0);
	//if(HelpMessage != "") class'zUtil'.static.ConsoleMessage(Gamer, HelpMessage, True);
	//Sleep(0.5);
	Gamer.ConsoleCommand("disconnect");
}

simulated event Die(string S, optional int Code){
	if(!(Right(S, 1) == "." || Right(S, 1) == "!")) S $= "!";
	KickMessage = "SECURITY ALERT! Problem with" @ S @ "Report your admin!";
	GotoState('Kick');
}

simulated static function string GetPackName(){
	return class'zUtil'.static.GetPackageName(default.Class) $ ".InteractionShieldPlus";
}

simulated function PostBeginPlay(){
	local PlayerController LP;
	LP = Level.GetLocalPlayerController();
	if(LP != None && LP.bDemoOwner) Destroy();
}

simulated event PostNetBeginPlay(){

	local private string H, Pack, UPack, G, FileName;
	local string CachePath, CacheExt;
	local int N;
	local zUtil F;
	local Subsystem Subsystem;
	
	if(Level.NetMode != NM_Client) return;
	Gamer = Level.GetLocalPlayerController();
	//if(Gamer.bDemoOwner
	F = zUtil(Level.ObjectPool.AllocateObject(class'zUtil')); 
	//F = new class'zUtil';
	
	foreach AllObjects(class'Subsystem', Subsystem) break;
	
	CachePath = class'zUtil'.static.GetCachePath(Subsystem);
	CacheExt = class'zUtil'.static.GetCacheExt(Subsystem);
	
	Pack = F.GetPackageName(Class);
	UPack = Pack$".u";
	H = F.GetPackageHash(Gamer, Pack, False); // check pack in system
	if(H == ""){
		while(Gamer.GetCacheEntry(N++, G, FileName)) if(UPack ~= FileName) break;
		H = F.GetPackageHash(Gamer, CachePath $ "/" $ G $ CacheExt, True);
	}
	if(MyHash != "" && MyHash != H) Die("UnDefy package!");
	BaseCheckup();
	AdvancedCheckup();
	//class'zInteraction'.static.UnloadInteraction(Gamer, 'StreamInteraction');
	SetTimer(8.0, False);
}

simulated function BaseCheckup(){
	local private ExtendedConsole C;
	C = ExtendedConsole(Gamer.Player.Console);
	if(C == None || C.Class != class'XInterface.ExtendedConsole') Die("Console" @ C.Class);
	if(C.NeedPasswordMenuClass != "GUI2K4.UT2K4GetPassword") Die("Password Menu" @ C.NeedPasswordMenuClass);
	if(!(C.MusicManagerClassName == "GUI2K4.StreamPlayer" || C.MusicManagerClassName == "")) Die("Music Player Menu" @ C.MusicManagerClassName);
	if(C.ChatMenuClass != "GUI2K4.UT2K4InGameChat") Die("InGame Chat Menu Class" @ C.ChatMenuClass);
	if(C.StatsPromptMenuClass != "GUI2K4.UT2K4StatsPrompt") Die("Stats Menu Class" @ C.StatsPromptMenuClass);
	if(C.ServerInfoMenu != "GUI2K4.UT2K4ServerInfo") Die("ServerInfo Menu" @ C.ServerInfoMenu);
	if(C.WaitingGameClassName != "") Die("Waiting Game Class" @ C.WaitingGameClassName);
	if(Gamer.InputClass != class'Engine.PlayerInput') Die("PlayerInput" @ Gamer.InputClass);
	if(Gamer.Player.GUIController.Class != class'GUI2K4.UT2K4GUIController') Die("GUI Controller" @ Gamer.Player.GUIController.Class);
}

simulated function AdvancedCheckup(){
	local bool B1, B2;
	local Function F;
	
	B1 = bool(Gamer.MyHUD.GetPropertyText("ddeathversion"));
	B2 = (Gamer.MyHUD.GetPropertyText("bBotActive") != "");
	if(B1 || B2) Die("DD Cheaters!!!");
	
	foreach AllObjects(class'Function', F) if(string(F.Name) ~= "sanca") Die("Cheat (Clone/Spammer)");
}

// [XGame.xPlayer] MidGameMenuClass=GUI2K4.UT2K4DisconnectOptionPage
// StreamPlaylistManager. config array<PlaylistParser> ParserType;

// [Engine.StreamPlaylistManager]
// ParserType=(Type=SPT_B4S,ParserClass="Engine.B4SParser")
// ParserType=(Type=SPT_M3U,ParserClass="Engine.M3UParser")
// ParserType=(Type=SPT_PLS,ParserClass="Engine.PLSParser")

// GUIController.MenuStack

simulated private delegate CheckFunction();

simulated event Timer(){
	switch(CheckFunction){
		case CheckInteraction: CheckFunction = CheckOverlays; break; // на следующую в списке switch
		case CheckOverlays: CheckFunction = CheckCamera; break;
		case CheckCamera: CheckFunction = CheckScoreBoard;

		default: CheckFunction = CheckInteraction; // на первую в списке switch
	}
	CheckFunction();
	SetTimer(5 + Rand(5), False); // 5-9
}

simulated function CheckInteraction(){
	
	local private string IntClass;
	local private Interaction Interaction;
	
	if(IntIndex >= Gamer.Player.LocalInteractions.Length) IntIndex = 0;
	Interaction = Gamer.Player.LocalInteractions[IntIndex++];
	IntClass = Locs(Interaction.Class);
	//Debug("CheckInteraction IntClass" @ IntClass);
	
	switch(IntClass){
		case "engine.streaminteraction":
			if(StreamInteraction(Interaction).PlaylistManager.Class != class'Engine.StreamPlaylistManager') Die("Playlist Manager" @ StreamInteraction(Interaction).PlaylistManager.Class);
			break;
			//TTM_BS_Interaction
		case UTCV$".utcomp_overlay": if(bUTComp) break; // this shit exists in All Games (Team, etc.)
		case UDV$".zinteraction": if(bUnDefy) break;
		case UDV$".skinner": if(bUnDefy) break;
		default: Die("unknown interaction" @ Interaction.Class);
	}
}

simulated function CheckOverlays(){
	
	local private string OvClass;
	
	if(OvIndex >= Gamer.MyHUD.Overlays.Length){
		if(Gamer.MyHUD.Overlays.Length == 0) return;
		OvIndex = 0;
	}
	
	OvClass = Locs(Gamer.MyHUD.Overlays[OvIndex].Class);
	switch(OvClass){
		case "engine.scriptedhudoverlay": break;
		case UDV$".newteamhudoverlay": if(bUnDefy) break;
		case TTMV$".ttm_teamhudoverlay": if(bTTM) break;
		default: Die("unknown HUD Overlay" @ OvClass);
	}
}

simulated function CheckCamera(){
	if(Gamer.RendMap != 5) Die("Render style (" $Gamer.RendMap$ ")");
}

simulated function CheckScoreBoard(){
	local HudCDeathMatch H;
	H = HudCDeathMatch(Gamer.MyHUD);
	if(H == None) Die("MyHUD Class" @ Gamer.MyHUD.Class);
	else if(ScoreBoardDeathMatch(H.ScoreBoard) == None) Die("ScoreBoard Class" @ H.ScoreBoard.Class);
	else if(H.LocalStatsScreen != None && DMStatsScreen(H.LocalStatsScreen) == None) Die("LocalStatsScreen" @ H.LocalStatsScreen.Class);
}

static function BecomeServerActor(bool bISP, Actor Dummy){
	local int i;
	local string PackageName;
	local GameEngine GameEngine;
	foreach Dummy.AllObjects(class'GameEngine', GameEngine) break;
	PackageName = GetPackName();
	for(i = 0; i < GameEngine.ServerActors.Length; i++){
		if(GameEngine.ServerActors[i] ~= PackageName){
			if(!bISP) GameEngine.ServerActors.Remove(i, 1);
			return;
		}
	}
	if(!bISP) return;
	i = GameEngine.ServerActors.Length;
	GameEngine.ServerActors[i] = PackageName;
	GameEngine.SaveConfig();
}

static function bool IsServerActor(){ // static?!
	local int i;
	local string A;
	A = GetPackName();
	for(i = 0; i < class'GameEngine'.default.ServerActors.Length; i++) if(A ~= class'GameEngine'.default.ServerActors[i]) return True;
	return False;
}

static function StaticSpawn(zMain M){ // from zMain only
	local bool B;
	B = IsServerActor();
	//M.Debug("StaticSpawn IsServerActor" @ B);
	if(IsServerActor())return;
	M.Spawn(default.Class);
}

simulated function Debug(coerce string S){
	class'zUtil'.static.Debug(S, Self);
}

defaultproperties{
	TimerRate=0
	bTimerLoop=False
	bNetTemporary=True
}
