class InteractionShieldPlus extends ReplicationInfo config(InteractionShieldPlus);
// todo: см. todo list
var private PlayerController Controller;

var private int IntIndex;
var private int OvIndex;
var private int CamIndex;

var private string MyHash;
var const private config string Hash;
var private string KickMessage;
var private string HelpMessage;

var private bool bUTComp;
var private string UTCV;
var private bool bTTM;
var private string TTMV;
var private bool bUnDefy;

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
	Controller.ServerSay(KickMessage);
	Sleep(1.0);
	if(HelpMessage != "") class'zUtil'.static.ConsoleMessage(Controller, HelpMessage, True);
	Sleep(0.5);
	Controller.ConsoleCommand("disconnect");
}

simulated event Die(string S, optional int Code){
	if(!(Right(S, 1) == "." || Right(S, 1) == "!")) S $= "!";
	switch(Code){
		case 1: HelpMessage = "Try to move Undefy09.u from Cache to System.";
	}
	KickMessage = "SECURITY ALERT! Problem with" @ S @ "Report your admin!";
	GotoState('Kick');
}

simulated static function string GetPackName(){
	return class'zUtil'.static.GetPackageName(default.Class) $ ".InteractionShieldPlus";
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

simulated event PostNetBeginPlay(){

	local private string H;
	local private string Pack;
	
	if(Level.NetMode != NM_Client) return;
	Controller = Level.GetLocalPlayerController();
	
	Pack = class'zUtil'.static.GetPackageName(Class);
	H = class'zUtil'.static.GetPackageHash(Controller, Pack);
	if(MyHash != "" && MyHash != H) Die("UnDefy package!", 1);
	BeginPlayCheckup();
	//CheckAutoLoadMenu();
	//RemoveEngineSteam();
	//class'zInteraction'.static.UnloadInteraction(Controller, 'StreamInteraction');
	
	SetTimer(8.0, False);
}

simulated private delegate CheckFunction();

simulated event Timer(){
	switch(CheckFunction){
		case CheckInteraction: CheckFunction = CheckHUD; break; // на следующую в списке switch
		case CheckHUD: CheckFunction = CheckCameraEffects; break;

		default: CheckFunction = CheckInteraction; // на первую в списке switch
	}
	CheckFunction();
	SetTimer(5 + Rand(5), False); // 5-9
}

simulated function CheckInteraction(){
	
	local private string IntClass;
	local private Interaction Interaction;
	
	if(IntIndex >= Controller.Player.LocalInteractions.Length) IntIndex = 0;
	Interaction = Controller.Player.LocalInteractions[IntIndex++];
	IntClass = Locs(Interaction.Class);
	Debug("CheckInteraction IntClass" @ IntClass);
	
	switch(IntClass){
		case "engine.streaminteraction":
			if(StreamInteraction(Interaction).PlaylistManager.Class != class'Engine.StreamPlaylistManager') Die("Playlist Manager" @ StreamInteraction(Interaction).PlaylistManager.Class);
			break;
			//TTM_BS_Interaction
		case UTCV$".utcomp_overlay": if(bUTComp) break; // this shit exists in All Games (Team, etc.)
		case "undefy09.zinteraction": if(bUnDefy) break;
		case "undefy09.skinner": if(bUnDefy) break;
		default: Die("unknown interaction" @ Interaction.Class);
	}
}

simulated function CheckHUD(){
	
	local private string OvClass;
	
	Debug("CheckHUD" @ TimerRate);
	
	if(OvIndex >= Controller.MyHUD.Overlays.Length) OvIndex = 0;
	
	OvClass = Locs(Controller.MyHUD.Overlays[OvIndex].Class);
	switch(OvClass){
		case "engine.scriptedhudoverlay": break;
		case "undefy09.newteamhudoverlay": if(bUnDefy) break;
		case TTMV$".ttm_teamhudoverlay": if(bTTM) break;
		default: Die("unknown HUD Overlay" @ OvClass);
	}
}

simulated function CheckCameraEffects(){
	Debug("CheckCameraEffects" @ TimerRate);
	if(Controller.RendMap != 5) Die("Not allowed Render style.");
//	if(CamIndex >= Controller.CameraEffects.Length) CamIndex = 0;
//	Controller.CameraEffects[CamIndex]
}

//simulated function RemoveEngineSteam(){
////	class'zInteraction'.static.UnloadInteraction(Controller, 'StreamInteraction');
///*	local private Player Player;
//	Player = Controller.Player;
//	for(i = 0; i < Player.LocalInteractions.Length; i++){
//		if(StreamInteraction(Player.LocalInteractions[i]) != None) Controller.Player.InteractionMaster.RemoveInteraction(Player.LocalInteractions[i]);
//	}*/
//}

simulated function BeginPlayCheckup(){
	local private ExtendedConsole C;
	C = ExtendedConsole(Controller.Player.Console);
	if(C == None || C.Class != class'XInterface.ExtendedConsole') Die("Console" @ C.Class);
	if(C.NeedPasswordMenuClass != "GUI2K4.UT2K4GetPassword") Die("Password Menu" @ C.NeedPasswordMenuClass);
	if(!(C.MusicManagerClassName == "GUI2K4.StreamPlayer" || C.MusicManagerClassName == "")) Die("Music Player Menu" @ C.MusicManagerClassName);
	if(C.ChatMenuClass != "GUI2K4.UT2K4InGameChat") Die("InGame Chat Menu Class" @ C.ChatMenuClass);
	if(C.StatsPromptMenuClass != "GUI2K4.UT2K4StatsPrompt") Die("Stats Menu Class" @ C.StatsPromptMenuClass);
	if(C.ServerInfoMenu != "GUI2K4.UT2K4ServerInfo") Die("ServerInfo Menu" @ C.ServerInfoMenu);
	if(C.WaitingGameClassName != "") Die("Waiting Game Class" @ C.WaitingGameClassName);
	if(Controller.InputClass != class'Engine.PlayerInput') Die("PlayerInput" @ Controller.InputClass);
	if(Controller.Player.GUIController.Class != class'GUI2K4.UT2K4GUIController') Die("GUI Controller" @ Controller.Player.GUIController.Class);
}

// [XGame.xPlayer] MidGameMenuClass=GUI2K4.UT2K4DisconnectOptionPage
// StreamPlaylistManager. config array<PlaylistParser> ParserType;

// [Engine.StreamPlaylistManager]
// ParserType=(Type=SPT_B4S,ParserClass="Engine.B4SParser")
// ParserType=(Type=SPT_M3U,ParserClass="Engine.M3UParser")
// ParserType=(Type=SPT_PLS,ParserClass="Engine.PLSParser")

// GUIController.MenuStack

//simulated function CheckAutoLoadMenu(){
//	
//	local private GUIController GC;
//	local private string S;
//	local private int i;
//	local private bool B;
//	
//	GC = GUIController(Controller.Player.GUIController);
//	for(i = 0; i < GC.AutoLoad.Length; i++){
//		B = GC.AutoLoad[i].MenuClassName == "";
//		B = B || GC.AutoLoad[i].MenuClassName == "GUI2K4.UT2K4InGameChat";
//		if(!B) Die("unknown AutoLoad Menu" @ GC.AutoLoad[i].MenuClassName);
//	}
//	S = Controller.ConsoleCommand("get GUI2K4.UT2K4GUIController AutoLoad");
//	switch(S){
//		case "": break;
//		case "((MenuClassName=,bPreInitialize=False))": break;
//		case "((MenuClassName=" $Chr(34)$ "GUI2K4.UT2K4InGameChat" $Chr(34)$ ",bPreInitialize=True))": break;
//		default: Die("strange AutoLoad Menu");
//	}
//}

simulated function Debug(coerce string S){
	class'zUtil'.static.Debug(S, Self);
}

defaultproperties{
	bNetTemporary=True
}
