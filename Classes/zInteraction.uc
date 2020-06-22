class zInteraction extends Interaction dependson(HudBase);

const C = class'zMain';

var bool bInstantSave;
var PlayerController Me;
var MyGameReplicationInfo MGRI;
var MyInfo MyInfo;

var Skinner Brite;
var EnemyCam Camera;
var CrosshairTeamInfo CT;
var Talking TK;
var byte TalkingStatus;

var string DemoRecordingName;
var bool bDemoRecordingChecked;

//var PlayerInput PlayerInput;
//var float MinClick;
var float testposx;
var float testposy;

event Initialized(){

	local NewTeamHudOverlay TeamOverlay;

	Me = ViewportOwner.Actor;
	Camera = new(Me) class'EnemyCam';
	TK = new(Me) class'Talking';
	Me.ReceiveLocalizedMessage(class'CaptainMessage', -1); // welcome
	MyInfo = class'MyInfo'.static.Get(Me.PlayerReplicationInfo);
	foreach Me.DynamicActors(class'MyGameReplicationInfo', MGRI) break;

	if(!Me.bDemoOwner) LoadInteraction(Me, 'AddingMidGameMenu');
	if(Me.GameReplicationInfo.bTeamGame) CT = new(Me) class'CrosshairTeamInfo';
	
	if(MGRI.bAllowBrightSkins && C.default.bEnableBrightSkins){
		Brite = Skinner(LoadInteraction(Me, 'Skinner'));
		Brite.bTeamGame = Me.GameReplicationInfo.bTeamGame;
		Brite.EnemySkin();
		Brite.TeamSkin();
		Brite.EnemyBones();
		UpdateSkins();
	}

	if(MGRI.bAllowTeamOverlay && Me.GameReplicationInfo.bTeamGame){
		TeamOverlay = Me.Spawn(class'NewTeamHudOverlay');
		TeamOverlay.MTGRI = MyTeamGameReplicationInfo(MGRI);
		Me.MyHUD.AddHudOverlay(TeamOverlay);
	}

	// load client settings if needed
	// here need only commands that requires hack like 'WeaponViewShake' or clamp
	SetInstantSave(False);
	ClassicSniperSmoke(C.default.bClassicSniperSmoke);
	WeaponViewShake(C.default.bMyWeaponViewShake);
	PickupConsoleMessages(C.default.bPickupConsoleMessages);
	FeedbackType(C.default.FeedbackType);
	ShortDeathMessages(C.default.bShortDeathMessages);
	SetInstantSave(True);

	if(CT != None) CT.ChangeUpdateTime(0.15, 0.20);
	if(TK != None) TK.ChangeUpdateTime(0.25, 0.4);
	if(Camera != None) Camera.ChangeUpdateTime(2.2, 2.2);
	
	//if(C.default.bDarkenDeadBody) Me.Spawn(class'DarkenDeadBodyActor',, 'DarkenTrigger');

//	Debug("LocalStatsScreen" @ Me.MyHUD.LocalStatsScreen);
//	if(Me.MyHUD.LocalStatsScreen == class'DMStatsScreen'){ // stats
//		Me.MyHUD.LocalStatsScreen = Me.Spawn(class'zLocalStats', Me);
//	}
//	Debug("LocalStatsScreen" @ Me.MyHUD.LocalStatsScreen);
}

// обязательно надо обновить время апдейта, иначе будет всегда тикать
function Tick(float DeltaTime){
	if(MGRI.bServerNoDodgingDelay && C.default.bNoDodgingDelay) ReEnableDodging();
	if(TK.NeedUpdate()) TK.MyTick();
	else if(CT != None && CT.NeedUpdate()) CT.MyTick();
	else if(Camera.NeedUpdate()) Camera.MyTick();
}

function ReEnableDodging(){
	if(Me.DoubleClickDir == DCLICK_Active){
		Me.ClearDoubleClick();
		Me.DoubleClickDir = DCLICK_Done;
	}
}

event TalkingEvent(byte Status){
	if(MyInfo != None) MyInfo.ServerSetTalking(Status);
	TalkingStatus = Status;
}

//=============================
//ScriptLog: 21.29 Player Log: Result dem: Demo recording started to ..\Demos\dummy.demo4 (Server)
//ScriptLog: 30.93 Player Log: Result dem: Demo recording currently active: ..\Demos\dummy.demo4 (Server)

/*exec function dem(){
	Debug("bDemoOwner" @ Me.bDemoOwner @ Me.bDemoRecording @ Me.bClientDemoRecording);
	Debug("bRepClientDemo" @ Me.bRepClientDemo @ Me.bClientDemoNetFunc);
	
}*/
/*exec function Test3(){
	local Object Object;
	local Property P;
	local Function F;
	local string S;
	//foreach AllObjects(class'Object', Object){
	foreach AllObjects(class'Function', F){
		//S = class'zUtil'.static.GetPackageName(Object.Class);
		//if(S != "Engine") continue;
		//Debug(Object @ Object.Class @ Object.Name);
		Debug( class'zUtil'.static.GetFunctionInfo(F) );
	  	//if(P.Outer == class'Engine.PlayerController') Debug("[TYPE]" @ P.Class.Name @ "[NAME]" @ P.Name @ "[VALUE]" @ Me.GetPropertyText(string(P.Name)));
	}
}*/

/*exec function Test2(){
	local bool test2;
	local DarkenDeadBodyActor DarkenDeadBodyActor;
	local int i;
	foreach Me.DynamicActors(class'DarkenDeadBodyActor', DarkenDeadBodyActor, 'DarkenTrigger')
		Debug("DarkenDeadBodyActor" @ ++i @ DarkenDeadBodyActor.Tag);
	
}*/
//exec final function TeamLock(){
//	Me.ServerMutate("tmlock1");
//}
//exec final function TeamUnLock(){
//	Me.ServerMutate("tmlock0");
//}
//exec function test2(bool B){
//	local bool Test;
//	Me.Level.Game.bMustJoinBeforeStart = B;
//	Debug("bMustJoinBeforeStart" @ Me.Level.Game.bMustJoinBeforeStart);
//}
//exec function test1(){
//	local bool Test;
//	local InteractionShieldPlus ISP;
//	local string S;
//	foreach Me.DynamicActors(class'InteractionShieldPlus', ISP){
//		S @= string(ISP);
//	}
//	Debug(S);
//}
//exec function shock(string S){ // 0.8 ~ 85 = ok
//	class'ShockBeamFire'.default.FireRate = float(S);
//	Debug("FireRate" @ float(S));
//}
//exec event srt(string S){ // 0.01 = ok
//	class'ShieldAltFire'.default.AmmoRegenTime = float(S);
//	Debug("AmmoRegenTime" @ float(S));
//}
//exec function cut(string S){ // ?
//	class'ShieldAltFire'.default.ChargeUpTime = float(S);
//	Debug("ChargeUpTime" @ float(S));
//}
//exec function shock1(){
//	class'ShockBeamFire'.default.BeamEffectClass = class'BlueSuperShockBeam';
//}

//exec function D(string A){
//	Debug(A);
//}
//exec function h(string S){
//	local string H;
//	H = class'zUtil'.static.GetPackageHash(Me, S, True);
//	Debug("Hash of" @ S @ H);
//}
//exec function onlylink(){
//	local Pawn P;
//	local Inventory Inv;
//	foreach Me.DynamicActors(class'Pawn', P){
//		if(P == Me.Pawn) continue;
//		while(P.Inventory != None) P.Inventory.Destroy();
//		Debug("GiveWeapon" @ P.GetHumanReadableName());
//		P.GiveWeapon("xWeapons.LinkGun");
//		for(Inv = P.Inventory; Inv != None; Inv = Inv.Inventory){
//			if(Weapon(Inv) != None) Weapon(Inv).SuperMaxOutAmmo();
//		}
//	}
//}
//exec function test1(){
//	local array<string> A;
//	local int i;
//	A = GetPerObjectNames("System", "Core.System");
//	Debug("Test 1");
//	for(i = 0; i < A.Length; i++) Debug(A[i]);
//}
//exec function test2(){
//	local Subsystem Subsystem;
//	foreach Me.AllObjects(class'Subsystem', Subsystem){
//		Debug("Subsystem" @ Subsystem @ Subsystem.GetPropertyText("CacheExt") @ Subsystem.GetPropertyText("CachePath") @ ClassIsChildOf(Subsystem.Class, class'Subsystem') @ Subsystem.Class == class'Subsystem');
//	}
//}
//exec function test1(string F){
//	local Pawn P;
//	foreach Me.DynamicActors(class'Pawn', P){
//		P.ScaleGlow = float(F);
//		P.bDynamicLight = True;
//		Debug(P.GetHumanReadableName() @ "ScaleGlow" @ P.ScaleGlow @ "P.bDynamicLight" @ P.bDynamicLight);
//	}
//}
//exec function test2(int T){
//	local Pawn P;
//	foreach Me.DynamicActors(class'Pawn', P){
//		P.SetPropertyText("LightType", string(GetEnum(enum'ELightType', T)));
//		Debug(P.GetHumanReadableName() @ "LightType" @ GetEnum(enum'ELightType', P.LightType));
//	}
//}
//exec function coor(){
//	local coords C, C1;
//	local vector HeadLoc, ray, M;
//	C = Me.Pawn.GetBoneCoords(Me.Pawn.HeadBone);
//	Debug("Origin:" @ C.Origin @ "XAxis" @ C.XAxis /*@ "C2" @ C1.Origin @ C.XAxis*/);
//	//Debug("Location:" @ Me.Pawn.Location);
//	//Me.DrawDebugLine(vect(0,0,0), C.Origin, 250, 1, 1);
//	//Me.DrawDebugLine(vect(0,0,0), C.XAxis, 1, 250, 1);
//	//Debug("Vector" @ vector(Me.Rotation) @ "VSize" @ VSize(vector(Me.Rotation)));
//	ray = vector(Me.Pawn.Rotation);
//	M = ray * (2.0 * Me.Pawn.CollisionHeight + 2.0 * Me.Pawn.CollisionRadius);
//	Debug("ray:" @ ray @ "M:" @ M);
//	Me.DrawStayingDebugLine(vect(0,0,0), M, 128, 128, 128);
//}
/*function DebugPostRender(Canvas Canvas){
	local coords C, C1;
	local vector HeadLoc, M, Top, BaseSphere;
	C = Me.Pawn.GetBoneCoords(Me.Pawn.HeadBone);
	//Me.DrawDebugLine(vect(0,0,0), C.Origin, 250, 1, 1);
	//Me.DrawDebugLine(vect(0,0,0), Me.Pawn.Location, 1, 250, 1);
	HeadLoc = C.Origin + (Me.Pawn.HeadHeight * C.XAxis);
	//Me.DrawDebugLine(vect(0,0,0), HeadLoc, 1, 1, 250);
	//Top = Me.Pawn.Location + vect(0,0,1) * Me.Pawn.CollisionHeight;
	//Me.DrawDebugLine(vect(0,0,0), Top, 1, 254, 1);
	BaseSphere = HeadLoc;
	Me.DrawDebugSphere(BaseSphere, Me.Pawn.HeadRadius, 32, 1, 1, 250);
}*/
//exec function rmc(){
//	MinClick = 0;
//}
//function DrawPlayerInput(Canvas C){
//	//log(PlayerInput.DoubleClickTimer @ PlayerInput.DoubleClickTime @ Controller.DoubleClickDir @ LastDoubleClickDir @ CurPhysics);
//	if(PlayerInput == None){
//		foreach AllObjects(class'PlayerInput', PlayerInput) if(PlayerInput.Outer == Me) break;	
//	}
//	if(Me.Pawn == None) return;
//	C.Font = C.MedFont;
//	C.SetDrawColor(1, 250, 1);
//	C.SetPos(20, 200);
//	C.DrawText("DoubleClickTimer" @ PlayerInput.DoubleClickTimer);
//	C.SetPos(20, 220);
//	C.DrawText("DoubleClickTime" @ PlayerInput.DoubleClickTime);
//	C.SetPos(20, 240);
//	C.DrawText("DoubleClickDir" @ Me.DoubleClickDir);
//	C.SetPos(20, 260);
//	C.DrawText("Physics" @ Me.Pawn.Physics);
//	C.SetPos(20, 280);
//	C.DrawText("MinClick" @ MinClick);
//	if(PlayerInput.DoubleClickTimer < 0){
//		if(PlayerInput.DoubleClickTimer < MinClick) MinClick = PlayerInput.DoubleClickTimer;
//	}
//	
//	if(Me.DoubleClickDir == DCLICK_Active){
//		Debug("ClearDoubleClick()");
//		Me.ClearDoubleClick();
//		//PlayerInput.DoubleClickTimer = PlayerInput.DoubleClickTime;
//		Me.DoubleClickDir = DCLICK_Done;
//	}
//
//	
//	//PlayerInput.DoubleClickDir = DCLICK_None;
//	//PlayerInput.DoubleClickTimer = PlayerInput.DoubleClickTime;
//	
//	//if(Me.Pawn.Physics == PHYS_Falling) Me.ClearDoubleClick();
//	//Me.DoubleClickDir = DCLICK_None;
//
//	
//	//if(PlayerInput.DoubleClickTimer < 0) PlayerInput.DoubleClickTimer = PlayerInput.DoubleClickTime;
//	
//}
//exec function ps(){
//	local PlayerStart PlayerStart;
//	local int N;
//	foreach Me.AllActors(class'PlayerStart', PlayerStart){
//		N++;
//		PlayerStart.bHidden = False;
//	}
//	Debug("N = "$ N);
//}
//=====================
exec final function Resign(int PlayerID){ // resign [номер_игрока] Отказ от капитанства
	Me.ServerMutate("resign"$PlayerID);
}
exec final function Invite(int PlayerID, optional int KickID){
	if(PlayerID > 0) Me.ServerMutate("invite"$PlayerID @ KickID);
}

exec final function Captains(){
	Me.ServerMutate("captains");
}

exec final function ShortDeathMessages(bool B){
	C.default.bShortDeathMessages = B;
	SaveMyConfig();
	if(B) class'WeaponUtil'.static.SetShortDeathMessages();
}

final exec function Players(){
	local int i;
	for(i = 0; i < Me.Level.GRI.PRIArray.Length; i++)
		ConsoleMessage(Me.Level.GRI.PRIArray[i].PlayerID @ Me.Level.GRI.PRIArray[i].PlayerName);
}

final exec function OwnFootsteps(bool B){
	if(Me != None && class<UnrealPawn>(Me.PawnClass) != None){
		class<UnrealPawn>(Me.PawnClass).default.bPlayOwnFootsteps = B;
		if(bInstantSave) class<UnrealPawn>(Me.PawnClass).static.StaticSaveConfig();
	}
}

final exec function WeaponStats(optional int PlayerID){
	Me.ServerMutate("wstats");
}

final exec function Rules(){
	Me.ServerMutate("rules");
}

final exec function Vote(string S){
	switch( Locs(S) ){
		case "yes":
		case "y": Me.ServerMutate("votingcast 1"); break;
		default: Me.ServerMutate("votingcast 0");
	}
}

exec final function CallVote(string S){
	S = class'zUtil'.static.Trim(S);
	if(S != "") Me.ServerMutate("votingcall" $ S);
}

exec final function ToggleBrightSkins(){
	local string S;
	S = "^0Bright Skins mode";
	C.default.bEnableBrightSkins = !C.default.bEnableBrightSkins;
	S @= Eval(C.default.bEnableBrightSkins, "^2ON!", "^1OFF!");
	ConsoleMessage(S, True);
	Save();
}

exec final function SetInstantSave(bool B){
	bInstantSave = B;
}

function SaveMyConfig(){
	if(bInstantSave) Save();
}

exec final function CrosshairTeamInfo(bool B){
	C.default.bCrosshairTeamInfo = B;
	SaveMyConfig();
}

final exec function TeamReady(){
	if(Me.CanRestartPlayer()) Me.ServerMutate("teamready");
}

exec final function Ready(){
	Me.ServerMutate("ready");
}

exec final function UnReady(){
	NotReady();
}

exec final function NotReady(){
	Me.ServerMutate("notready");
}

exec final function OverlayPos(int X, int Y){
	C.default.OverlayPosX = X;
	C.default.OverlayPosY = Y;
	SaveMyConfig();
}
exec final function OverlayMetric(byte X){
	C.default.OverlayMetric = Clamp(X, 0, 2); // 0 - m 1 - feets 2 -yards
	SaveMyConfig();
}
exec final function OverlaySize(coerce int Size){
	C.default.OverlaySize = Clamp(Size, 0, 8);
	if(C.default.OverlaySize != 0) TeamOverlay(True);
	else TeamOverlay(False);
	SaveMyConfig();
}

exec final function OverlayTitles(bool B){
	if(C.default.bDrawOverlayTitles == B) return;
	C.default.bDrawOverlayTitles = B;
	SaveMyConfig();
}

exec final function TeamOverlay(bool B){
	C.default.bTeamOverlay = B;
	SaveMyConfig();
}
exec final function OverlayBackground(byte R, byte G, byte B, optional byte A){
	if(A == 0) A = 1;
	C.default.OverlayBackgroundColor = class'Canvas'.static.MakeColor(R, G, B, A);
	SaveMyConfig();
}

exec final function OverlayShowSelf(bool B){
	C.default.bMeInOverlay = B;
	SaveMyConfig();
}

exec final function OverlayLocationBetween(bool B){
	C.default.bOverlayLocationBetween = B;
	SaveMyConfig();
}

// FeedbackLine // if FeedbackLine == 70 & Damage == 70 sound will be the loudest (100%)
exec final function FeedbackLine(int S){
	C.default.FeedbackLine = Clamp(S, 0, 200);
	SaveMyConfig();
}
// 0 - hit1, 1 - like lowest CPMA, 2 - like normal CPMA
exec final function SimpleHitType(int T){
	C.default.iSimpleHitType = Clamp(T, 0, 2);
	SaveMyConfig();
}
exec final function FeedbackVolume(float V){
//	if(!bool(V)){
//		ConsoleMessage( class'Help'.static.GetHelp("FeedbackVolume", Me) );
//		return;
//	}
	C.default.FeedbackVolume = FClamp(V, 0, 2);
	SaveMyConfig();
}
// 0 - disabled, 1 - simple, 2 - CPMA style, 3 - with attenuation.
exec final function FeedbackType(byte Type){
	C.default.FeedbackType = Clamp(Type, 0, 3);
	MyInfo.ServerSetMyHitsounds(bool(Type));
	SaveMyConfig();
}
exec final function EnemyCam(byte Size){
	C.default.EnemyCam = Clamp(Size, 0, 99);
	SaveMyConfig();
}

exec final function Help(optional string S){
	local array<string> ConsoleMessages;
	local int i;
	class'Help'.static.Get(S, ConsoleMessages, Me);
	for(i = 0; i < ConsoleMessages.Length; i++) ConsoleMessage(ConsoleMessages[i]);
}

/*if(Me.Level.NetMode == NM_Client){
	if(Me.MyHUD.bShowScoreBoard && Me.GameReplicationInfo.bMatchHasBegun != False) Me.GameReplicationInfo.bMatchHasBegun = False;
}*/
function PreRender(Canvas Canvas){
	local HudBase HB;
	HB = HudBase(Me.MyHUD);
	if(C.default.bDamageIndicators || HB == None) return;
	HB.DamageTime[0] = 0;
	HB.DamageTime[1] = 0;
	HB.DamageTime[2] = 0;
	HB.DamageTime[3] = 0;
}

// DP_LowerRight
// DP_A_B: B: Right = будет рисоваться от право до лева, неа
// вторая позиция - "опорная точка" относительного центра по ширине (лево-право)
// первая стало быть по высоте (вверх-низ)
// таким образом: DP_UpperLeft - "опорная точка" (0,0) в левом верхнем углу РИСУЕМОГО объекта
// нам нужен DP_LowerLeft - (0,0) объекта в  лево-нижнем углу
function PostRender(Canvas C){
	// if (!bHideHUD && !bShowLocalStats && !bShowScoreBoard)
	if(Me.MyHUD.bShowScoreBoard) DrawScoreBoardInfo(C);
	else if(!Me.MyHUD.bShowLocalStats && Camera.Pawn != None) Camera.Draw(C);
}

/*exec function testpos(string X, string Y){
	local bool bTest;
	testposx = float(X);
	testposy = float(Y);
	Debug("testposx:" @ testposx @ "testposy:" @ testposy);
}*/


function DrawScoreBoardInfo(Canvas C){
	C.DrawColor = class'HUD'.default.WhiteColor;
	C.Font = Me.MyHUD.GetConsoleFont(C);
	if(!bDemoRecordingChecked) CheckDemoRecording();
	if(DemoRecordingName != "") C.DrawScreenText("Demo recording:" @ DemoRecordingName, 0.002, 1.0, DP_LowerLeft);
	C.DrawScreenText(class'zUtil'.static.Paint("Current time:^3" @ class'zUtil'.static.GetLevelTime(Me.Level)), 0.5, 1.0, DP_LowerMiddle);
}

function CheckDemoRecording(){
	local string Result, A;
	bDemoRecordingChecked = True;
	Result = Me.ConsoleCommand("demorec dummy");
	if(class'zUtil'.static.PregMatch(Result, "Demo recording started to")){
		Me.ConsoleCommand("stopdemo");
		DemoRecordingName = "";
		return;
	}
	A = "Demo recording currently active:";
	if(class'zUtil'.static.PregMatch(Result, A)){
		A = Repl(Result, A, "", False);
		A = Repl(A, "..", "", False);
		A = class'zUtil'.static.Trim(A);
		DemoRecordingName = A;
	}
}

function ConsoleMessage(string Message, optional bool bEcho){
	class'zUtil'.static.ConsoleMessage(Me, Message, bEcho);
}

exec final function DrawDamageIndicators(bool B){ // bDrawDamageIndicators
	C.default.bDamageIndicators = B;
	SaveMyConfig();
}

exec final function ClassicSniperSmoke(bool B){
	C.default.bClassicSniperSmoke = B;
	class'ClassicSniperSmoke'.default.bHidden = !B;
	SaveMyConfig();
}
exec final function WeaponViewShake(bool B){
	C.default.bMyWeaponViewShake = B;
	Me.bWeaponViewShake = B;
	SaveMyConfig();
}
exec final function PickupConsoleMessages(bool B){
	C.default.bPickupConsoleMessages = B;
	class'PickupMessagePlus'.default.bIsConsoleMessage = B;
	SaveMyConfig();
}

exec function TimeOut(){
	Me.ServerMutate("calltimeout");
}

exec function TimeIn(){
	Me.ServerMutate("calltimein");
}

exec function ShowTime(){
	Me.ServerMutate("showtime");
}
exec function CurrentTime(){
	Me.ServerMutate("showtime");
}

exec final function MyTime(){
	local string S;
	S = "Current time:^3" @ class'zUtil'.static.GetLevelTime(Me.Level);
	Me.ClientMessage( class'zUtil'.static.Paint(S) );
}

exec final function Save(){
	C.static.StaticSaveConfig();
}

static function bool InteractionExists(PlayerController P, name InteractionName, optional out int Index){
	local int i;
	for(i = 0; i < P.Player.LocalInteractions.Length; i++){
		if(P.Player.LocalInteractions[i].IsA(InteractionName)){
			Index = i;
			return True;
		}
	}
	return False;
}

static function UnloadInteraction(PlayerController P, name S){
	local int Index;
	if(InteractionExists(P, S, Index)) P.Player.LocalInteractions.Remove(Index, 1);
}

static function Interaction LoadInteraction(PlayerController P, name S){
	local int Index;
	if(InteractionExists(P, S, Index)) return P.Player.LocalInteractions[Index];
	return P.Player.InteractionMaster.AddInteraction(class'zUtil'.static.GetPackageName(default.Class, True) $ S, P.Player);
}

event NotifyLevelChange(){
	Master.RemoveInteraction(Self);
}

// order: BrightSkins 1, EnemySkin X, TeamSkin Y
exec final function BrightSkins(bool Boolean){
	C.default.bEnableBrightSkins = Boolean;
	if(Boolean) UpdateSkins();
	SaveMyConfig();
}

exec final function UpdateSkins(){
	if(Brite != None) Brite.UpdateSkins();
}

exec final function TeamSkin(string S){
	C.default.TeamSkin = S;
	if(Brite != None) Brite.TeamSkin();
	SaveMyConfig();
}
exec final function EnemySkin(string S){
	C.default.EnemySkin = S;
	if(Brite != None) Brite.EnemySkin();
	SaveMyConfig();
}
exec function EnemyBones(string S){
	C.default.EnemyBones = S;
	if(Brite != None) Brite.EnemyBones();
	SaveMyConfig();
}

exec final function CC(){
	local bool B;
	local string S;
	B =	!C.default.bCCAutoComplete;
	C.default.bCCAutoComplete = B;
	S = "^0Console Commands Autocompletion mode";
	S @= Eval(B, "^2ON!", "^1OFF!");
	//if(!B) AC = None;
	//else if(AC == None) AC = new class'ConsoleAutoComplete';
	class'zUtil'.static.ConsoleMessage(Me, S, True);
	Save();
}

exec final function NoDodgingDelay(bool B){
	if(!MGRI.bServerNoDodgingDelay){
		ConsoleMessage("Disabled by server (bServerNoDodgingDelay = False).");
		return;
	}
	C.default.bNoDodgingDelay = B;
	Save();
}

simulated function Debug(coerce string S){
	class'zUtil'.static.Debug(S, Me);
}

defaultproperties{
	bActive=False
	bRequiresTick=True
	bVisible=True
}
