class NewTeamHudOverlay extends HudOverlay;

const MyClass = class'zMain';
const NUMCELLS = 6; // инфа о тиммейте
const LAST = 5;

var PlayerController Me;
var MyTeamGameReplicationInfo MTGRI;

struct TeamArray{ var string Info[NUMCELLS]; };
var(TeamInfo) TeamArray TeamMates[8];
var(TeamInfo) byte TeamSize;

var(Position) float SpaceX, SpaceY;
var(Position) float OverlayInfoPos[7]; // размеры на каждую клетку (NUMCELLS+1)
var int Widths[NUMCELLS];

var(BackGround) float OffSetY, OffSetX;
var(BackGround) float BackGroundPosX[NUMCELLS]; // позиции для отрисовки бэкграунда

var(Metric) float Converter;
var(Metric) string Symbol;

var float NextUpdateTime;
var(Font) Font Font;
var bool bOverlayVisible;

var byte FlagIndex, UDamageIndex;
var color TextColor;

function PostBeginPlay(){
	Me = Level.GetLocalPlayerController();
	// overlay titles
	TeamMates[0].Info[0] = "W";
	TeamMates[0].Info[1] = "Player";
	TeamMates[0].Info[2] = "H/S";
	TeamMates[0].Info[3] = "D";
	TeamMates[0].Info[4] = "Location";
//	TeamMates[0].Info[5] = "Sp";
	// font
	Font = Me.MyHUD.LoadFont(8 - MyClass.default.OverlaySize);
	SetTimer(3.0, True);
	// width
	Widths[0] = 2; // размер для цифры
	Widths[1] = 10; // размер для имени
	Widths[2] = 8; // размер для 100/150
	Widths[3] = 4; // дистанция
	Widths[4] = 20; // локация
	Widths[5] = 4; // дополнительное поле для таймера (udamage)
}


/*function PostPostBeginPlay(){
	local array<CacheManager.WeaponRecord> WR;
	class'CacheManager'.static.GetWeaponList(WR);
}*/

function string GetTeamMateLocaltion(vector V, out float MinDistance){
	local float Distance;
	local int i, K;
	//local string S2;
	MinDistance = MaxInt;
	for(i = 0; i < MTGRI.LocCount; i++){
		Distance = VSize(V - MTGRI.GetLocCoord(i));
		if(Distance > MinDistance) continue;
		MinDistance = Distance;
		K = i;
		//NearbyPoint = MTGRI.GetLocCoord(i);
		//S = MTGRI.LocNamesB[i];
	}
	// 27 Jul 2009: between position detection (thanks to Nina Pronina)
	if(MyClass.default.bOverlayLocationBetween && MinDistance > 525){
		return "Near" @ MTGRI.LocNamesB[K] @ "/" @ GetBetweenLocation(V, K);
	}
	return "Near" @ MTGRI.LocNamesB[K];
}

// X = Teammate Location, K = Nearest Point :)
function string GetBetweenLocation(vector X, int K){
	
	local int i, M;
	local vector NearbyPoint;
	local float MinDistance, Distance;
	
	NearbyPoint = MTGRI.GetLocCoord(K);
	MinDistance = MaxInt;
	for(i = 0; i < MTGRI.LocCount; i++){
		if(i == K) continue;
		//SomeLocation = MTGRI.GetLocCoord(i); // other location
		//C = (NearbyPoint + SomeLocation) / 2.0; // center
		Distance = VSize(((NearbyPoint + MTGRI.GetLocCoord(i)) / 2.0) - X);
		if(Distance > MinDistance) continue;
		MinDistance = Distance;
		M = i;
	}
	return MTGRI.LocNamesB[M];
}

function GetOverlaySize(){
	local byte i, N, BackLen;
	OffSetX = SpaceX * 0.2;
	OffSetY = Round(SpaceY * 0.1);
	
	OverlayInfoPos[0] = MyClass.default.OverlayPosX; // это позиции откуда начинать рисовать
	BackLen = NUMCELLS + 1;
	
	for(i = 1; i < BackLen; i++){
		N = i - 1;
		OverlayInfoPos[i] = OverlayInfoPos[N] + Widths[N] * SpaceX;
		BackGroundPosX[N] = OverlayInfoPos[i] - OverlayInfoPos[N] - OffSetX;
	}
}


event Timer(){
	//Debug("Timer" @ Me.GetHumanReadableName() @ "MTGRI.LocCount" @ MTGRI.LocCount);
	UpdateTeamInfo();
	TimerRate = (4 + Rand(2)) / 10.0; // Rand(3) = {0,1,2} (No 3!)
}

function Render(Canvas C){
	local byte i, N;
	local float PosY;
	
	C.Font = Font;
	
	if(Level.TimeSeconds > NextUpdateTime){
		NextUpdateTime = Level.TimeSeconds + 3 + Rand(9) / 10.0;
		if(Me.PlayerReplicationInfo.bOnlySpectator && !Me.bDemoOwner) bOverlayVisible = False;
		else if(!MyClass.default.bTeamOverlay) bOverlayVisible = False;
		else bOverlayVisible = True;
		Font = Me.MyHUD.LoadFont(8 - MyClass.default.OverlaySize);
		C.Font = Font;
		C.StrLen("X", SpaceX, SpaceY); // SpaceX = 10 SpaceY = 16
		GetOverlaySize();
		GetOverlayMetric();
	}
	if(!bOverlayVisible) return;
	
	// будем рисовать заголовки
	if(MyClass.default.bDrawOverlayTitles) N = 0; else N = 1;
	// OverlayPosX устанавливается в GetOverlaySize var OverlayInfoPos[0]
	PosY = MyClass.default.OverlayPosY;
	for(i = N; i < TeamSize; i++){
		switch(i){
			case FlagIndex: TextColor = class'CTFHUDMessage'.default.YellowColor; break;
			case UDamageIndex: TextColor = class'HUD'.default.PurpleColor; break;
			default: TextColor = class'HUD'.default.WhiteColor; ResetSpecialInfoCell(i);
		}
		DrawTeamMateInfo(C, TeamMates[i], PosY);
		PosY += SpaceY + OffSetY;
	}
}

function DrawTeamMateInfo(Canvas C, TeamArray Team, float Y){
	local byte i;
	local float BackSpaceY;
	BackSpaceY = Y - OffSetY * 0.5;
	for(i = 0; i < NUMCELLS; i++){
		if(i == LAST && Team.Info[i] == "") continue; // не рисуем спец. поле
		//if(MyClass.default.OverlayBackgroundColor.A > 20){
			// бэкграунд // OffSetX * X - справа побольше
			C.SetPos(OverlayInfoPos[i] - OffSetX * 1.5, BackSpaceY);
			C.DrawColor = MyClass.default.OverlayBackgroundColor;
			C.Style = 5; // ERenderStyle.STY_Alpha;
			C.DrawTileStretched(Material'Engine.WhiteTexture', BackGroundPosX[i], SpaceY);
		//}
		// text
		C.DrawColor = TextColor;
		C.SetPos(OverlayInfoPos[i], Y);
		C.Style = 1; // ERenderStyle.STY_Normal
		C.DrawText(Team.Info[i]);
	}
}

function string GetUDamageTime(int Index, xPawn P){
	local float UTime;
	UDamageIndex = Index;
	UTime = P.UDamageTime - P.Level.TimeSeconds;
	return class'zUtil'.static.Paint("^0" $ Mid(UTime, 0, InStr(UTime, ".") + 2));
}

function bool CleanTeamMateInfo(byte Index){
	local int i;
	for(i = 0; i < NUMCELLS; i++) TeamMates[Index].Info[i] = "";
	return False;
}

function ResetSpecialInfoCell(int Index){
	TeamMates[Index].Info[LAST] = "";
}

static function string GetWeaponString(xWeaponAttachment WA){
	if(WA == None) return "?";
	switch(WA.Class){
		case class'AssaultAttachment': return "2";
		case class'BallAttachment': return class'zUtil'.static.Paint("^3B");
		case class'BioAttachment': return "3";
		case class'ClassicSniperAttachment': return "9";
		case class'FlakAttachment': return "7";
		case class'LinkAttachment': return class'zUtil'.static.Paint("^25");
		//case class'LinkAttachment': return "5";
		case class'MinigunAttachment': return "6";
		case class'ONSAVRiLAttachment': return "8";
		case class'ONSGrenadeAttachment': return "7";
		case class'ONSMineLayerAttachment': return "3";
		case class'PainterAttachment': return "0";
		//case class'ONSPainterAttachment': return "0"; // OnslaughtFull
		case class'RedeemerAttachment': return "0";
		case class'RocketAttachment': return "8";
		case class'ShieldAttachment': return "1";
		case class'ShockAttachment': return "4";
		case class'SniperAttachment': return "9";
		case class'TransAttachment': return "1";
		default: return Left(WA.GetHumanReadableName(), 1);
	}
}

function bool UpdateTeamMateInfo(byte Index, xPawn Pawn){
	local float Distance;
	if(Pawn == None || Pawn.PlayerReplicationInfo == None) return CleanTeamMateInfo(Index);
	TeamMates[Index].Info[0] = GetWeaponString(Pawn.WeaponAttachment);
	TeamMates[Index].Info[1] = Pawn.PlayerReplicationInfo.PlayerName;
	TeamMates[Index].Info[2] = Pawn.Health $ "/" $ int(Pawn.ShieldStrength);
	TeamMates[Index].Info[4] = GetTeamMateLocaltion(Pawn.Location, Distance);
	TeamMates[Index].Info[3] = "" $ int(Distance / Converter) $ Symbol;
	
	if(Pawn.HasUDamage()) TeamMates[Index].Info[LAST] = GetUDamageTime(Index, Pawn);
	else if(Pawn.PlayerReplicationInfo.HasFlag != None) FlagIndex = Index;
	
	return True;
}

function UpdateTeamInfo(){
	
	local byte i, TeamNum;
	local MyInfo LRI;
	
	FlagIndex = 255;
	UDamageIndex = 255;
	TeamSize = 1;
	TeamNum = Me.GetTeamNum();
	
	if(MyClass.default.bMeInOverlay && TeamNum != 255){
		UpdateTeamMateInfo(TeamSize, xPawn(Me.Pawn));
		TeamSize++;
	}
	
	if(TeamNum == 255 && Pawn(Me.ViewTarget) != None && Pawn(Me.ViewTarget).PlayerReplicationInfo != None){
		LRI = class'MyInfo'.static.Get(Pawn(Me.ViewTarget).PlayerReplicationInfo);
		TeamNum = LRI.GetTeamNum();
	}
	
	for(i = 0; i < Level.GRI.PRIArray.Length; i++){
		LRI = class'MyInfo'.static.Get(Level.GRI.PRIArray[i]);
		//if(bDemoOwner) Debug("DEMO" @ Me.bDemoOwner @ "LRI.GetTeamNum()" @ LRI.GetTeamNum() @ "LRI.MyPawn" @ LRI.MyPawn);
		if(LRI != None && LRI.GetTeamNum() == TeamNum && Me.PlayerReplicationInfo != Level.GRI.PRIArray[i]){
			UpdateTeamMateInfo(TeamSize, LRI.MyPawn);
			TeamSize++;
		}
	}
}

function GetOverlayMetric(){
	switch(MyClass.default.OverlayMetric){
		case 1: Converter = 16.0; Symbol = "f"; break;	
		case 2: Converter = 48.0; Symbol = "y"; break;
		default: Converter = 52.5; Symbol = "m";
	}
}

//function DC(coerce string S, Canvas C, int Y){
//	C.SetPos(200, Y);
//	C.DrawText(S, True);
//}
//

simulated function Debug(coerce string S){
	class'zUtil'.static.Debug(S, Self);
}

defaultproperties{
	FlagIndex=255
	UDamageIndex=255
	bOverlayVisible=False
}
