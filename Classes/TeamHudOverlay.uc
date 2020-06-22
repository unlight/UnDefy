class TeamHudOverlay extends HudOverlay;

const MyClass = class'zMain';

var PlayerController Me;
var MyTeamGameReplicationInfo MTGRI;

struct TeamArray{ var string Info[5]; };
var(TeamInfo) TeamArray TeamMates[8];
var(TeamInfo) byte TeamSize;

var(Position) float SpaceX, SpaceY;
var(Position) float OverlayInfoPos[6]; // назвать по другому

var(BackGround) float OffSetY, OffSetX;
var(BackGround) float BackGroundPosX[5];

var(Metric) float Converter;
var(Metric) string Symbol;

var float NextUpdateTime;
var(Font) Font Font;
var bool bOverlayVisible;

var byte FlagIndex, UDamageIndex;
var color TextColor;

//function GetWeaponString(coerce string W); // return LG, BR RL
//
//function PostBeginPlay(){
//	Me = Level.GetLocalPlayerController();
//	// overlay titles
//	TeamMates[0].Info[0] = "W";
//	TeamMates[0].Info[1] = "Player";
//	TeamMates[0].Info[2] = "H/S";
//	TeamMates[0].Info[3] = "D";
//	TeamMates[0].Info[4] = "Location";
//	// font
//	Font = Me.MyHUD.LoadFont(8 - MyClass.default.OverlaySize);
//	SetTimer(4.0, True);
//}
//
//function string GetTeamMateLocaltion(vector V, out float MinDistance){
//	local float Distance;
//	local int i;
//	local string S;
//	MinDistance = 19999;
//	for(i = 0; i < TeamTournament.LocCount; i++){
//		Distance = VSize(V - TeamTournament.GetLocCoord(i));
//		if(Distance > MinDistance) continue;
//		MinDistance = Distance;
//		S = TeamTournament.LocNamesB[i];
//	}
////	if(MinDistance < 100) S = "Next" @ S;
////	else if(MinDistance < 1000) S = "Near" @ S;
////	else S = "Far" @ S;
////	return S;
//	return "Near" @ S;
//}
//
//function GetOverlaySize(){
//	local byte i;
//	OffSetX = SpaceX * 0.2;
//	OffSetY = Round(SpaceY * 0.1);
//	// это позиции откуда начинать рисовать
//	OverlayInfoPos[0] = MyClass.default.OverlayPosX;
//	OverlayInfoPos[1] = OverlayInfoPos[0] + 2 * SpaceX; // размер для цифры
//	OverlayInfoPos[2] = OverlayInfoPos[1] + 10 * SpaceX; // размер для имени
//	OverlayInfoPos[3] = OverlayInfoPos[2] + 8 * SpaceX; // размер для 100/150
//	OverlayInfoPos[4] = OverlayInfoPos[3] + 4 * SpaceX; // дистанция
//	OverlayInfoPos[5] = OverlayInfoPos[4] + 20 * SpaceX; // локация
//	for(i = 0; i < 5; i++) BackGroundPosX[i] = OverlayInfoPos[i+1] - OverlayInfoPos[i] - OffSetX;
//}
//
//
//event Timer(){
//	UpdateTeamInfo();
//	TimerRate = (3 + Rand(3)) / 10.0; // 0.3~0.5, Rand(3) = {0,1,2} (No 3!)
//}
//
//function Render(Canvas C){
//	local byte i, N;
//	local float PosY;
//	
//	C.Font = Font;
//	
//	if(Level.TimeSeconds > NextUpdateTime){
//		NextUpdateTime = Level.TimeSeconds + 3.1;
//		if(Me.PlayerReplicationInfo.bOnlySpectator) bOverlayVisible = False;
//		else if(!MyClass.default.bTeamOverlay) bOverlayVisible = False;
//		else bOverlayVisible = True;
//		Font = Me.MyHUD.LoadFont(8 - MyClass.default.OverlaySize);
//		C.Font = Font;
//		C.StrLen("X", SpaceX, SpaceY); // SpaceX = 10 SpaceY = 16
//		GetOverlaySize();
//		GetOverlayMetric();
//	}
//	if(!bOverlayVisible) return;
//	
//	// будем рисовать заголовки
//	if(MyClass.default.bDrawOverlayTitles) N = 0; else N = 1;
//	// OverlayPosX устанавливается в GetOverlaySize var OverlayInfoPos[0]
//	PosY = MyClass.default.OverlayPosY;
//	for(i = N; i < TeamSize; i++){
//		switch(i){
//			case FlagIndex: TextColor = class'CTFHUDMessage'.default.YellowColor; break;
//			case UDamageIndex: TextColor = class'HUD'.default.PurpleColor; break;
//			default: TextColor = class'HUD'.default.WhiteColor;
//		}
//		DrawTeamMateInfo(C, TeamMates[i], PosY);
//		PosY += SpaceY + OffSetY;
//	}
//}
//
//function DrawTeamMateInfo(Canvas C, TeamArray Team, float Y){
//	local byte i;
//	local float BackSpaceY;
//	BackSpaceY = Y - OffSetY * 0.5;
//	for(i = 0; i < 5; i++){
//		if(MyClass.default.OverlayBackgroundColor.A > 20){
//			// бэкграунд // OffSetX * X - справа побольше
//			C.SetPos(OverlayInfoPos[i] - OffSetX * 1.5, BackSpaceY);
//			C.DrawColor = MyClass.default.OverlayBackgroundColor;
//			C.Style = 5; // ERenderStyle.STY_Alpha;
//			C.DrawTileStretched(Material'Engine.WhiteTexture', BackGroundPosX[i], SpaceY);
//		}
//		// text
//		C.DrawColor = TextColor;
//		C.SetPos(OverlayInfoPos[i], Y);
//		C.Style = 1; // ERenderStyle.STY_Normal
//		C.DrawText(Team.Info[i]);
//	}
//}
//
//function TeamArray GetMyInfo(){
//	local float Distance;
//	local TeamArray My;
//	if(Me.Pawn == None) return My;
//	if(Me.Pawn.Weapon != None) My.Info[0] = string(Me.Pawn.Weapon.InventoryGroup);
//	My.Info[1] = Me.PlayerReplicationInfo.PlayerName;
//	My.Info[2] = Me.Pawn.Health $ "/" $ int(Me.Pawn.ShieldStrength);
//	My.Info[4] = GetTeamMateLocaltion(Me.Pawn.Location, Distance);
//	My.Info[3] = "" $ int(Distance / Converter) $ Symbol;
//	return My;
//}
//
//function UpdateTeamInfo(){
//	
//	local byte i;
//	local float Distance;
//	local MyInfo LRI;
//	local PlayerReplicationInfo PRI;
//	
//	FlagIndex = 255;
//	UDamageIndex = 255;
//	TeamSize = 1;
//	
//	for(i = 0; i < Level.GRI.PRIArray.Length; i++){
//		PRI = Level.GRI.PRIArray[i];
//		if(!(PRI.Team != None && PRI.Team == Me.PlayerReplicationInfo.Team && PRI != Me.PlayerReplicationInfo)) continue;
//		LRI = class'MyInfo'.static.Get(PRI);
//		//TeamMates[TeamSize].Info[0] = GetWeaponString(LRI.MyWeapon);
//		TeamMates[TeamSize].Info[0] = string(LRI.MyWeapon);
//		TeamMates[TeamSize].Info[1] = PRI.PlayerName;
//		TeamMates[TeamSize].Info[2] = LRI.MyHealth $ "/" $ LRI.MyShield;
//		TeamMates[TeamSize].Info[4] = Eval(MyClass.default.bOverlayNewLocations, GetTeamMateLocaltion(LRI.MyLocation, Distance), PRI.GetLocationName());
//		TeamMates[TeamSize].Info[3] = "" $ int(Distance / Converter) $ Symbol;
//		if(PRI.HasFlag != None) FlagIndex = TeamSize;
//		else if(LRI.bHasUDamage) UDamageIndex = TeamSize;
//		TeamSize++;
//	}
//	if(MyClass.default.bMeInOverlay){
//		TeamMates[TeamSize] = GetMyInfo();
//		TeamSize++;
//	}
//}
//
//function GetOverlayMetric(){
//	switch(MyClass.default.OverlayMetric){
//		case 1: Converter = 16; Symbol = "f"; break;	
//		case 2: Converter = 48; Symbol = "y"; break;
//		default: Converter = 52.5; Symbol = "m";
//	}
//}
//
////function DC(coerce string S, Canvas C, int Y){
////	C.SetPos(200, Y);
////	C.DrawText(S, True);
////}
////
////simulated function Debug(coerce string S){
////	class'zUtil'.static.Debug(S, Self);
////}

defaultproperties{
	FlagIndex=255
	UDamageIndex=255
	bOverlayVisible=False
}
