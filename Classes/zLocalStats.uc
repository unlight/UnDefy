class zLocalStats extends DMStatsScreen;

//var string SavedFontArrayNames[9];
//var Font SavedFontArrayFonts[9];
//var float IndentX, OffsetY, LargeYL, PosX;
//
var int FontHack; // + רנטפע לוםüרו, - רנטפע במכüרו
//
//simulated event DrawScoreboard(Canvas C){
//	local MyInfo Linked;
//	local array<string> HeadLines, StatStrings;
//	local DrawBoxTool Box;
//	local float YPos;//, XPos;
//	local byte i;
//	
//	Super.DrawScoreboard(C);
//	if(PRI != None) Linked = class'MyInfo'.static.Get(PRI);
//	if(Linked == None || Linked.Stats == None) return;
//
//	ReplaceFonts();
//	
//	Box = new(C) class'DrawBoxTool';
//	YPos = C.CurY + Box.LargeYL;
//	Box.InitPositions(0.015 * C.ClipX, YPos);
//	HeadLines[0] = "Damage Type" @ class'zUtil'.static.StrRepeat(" ", 10);
//	HeadLines[1] = "Damage";
//	HeadLines[2] = "Hits";
//	Box.SetTitles("DAMAGE STATS", HeadLines, Linked.Stats.GivenDamage.Length);
//	Box.SetColors(HUDClass.default.GoldColor, HUDClass.default.WhiteColor, HUDClass.default.BlackColor);
//	Box.Draw();
//	C.DrawColor = HUDClass.default.TurqColor;
//	for(i = 0; i < Linked.Stats.GivenDamage.Length; i++){
//		StatStrings[0] = class'WeaponUtil'.static.GetDamageType(Linked.Stats.GivenDamage[i].DamageType);
//		StatStrings[1] = string(Linked.Stats.GivenDamage[i].Damage);
//		StatStrings[2] = string(Linked.Stats.GivenDamage[i].Hits);
//		Box.DrawArrayLine(StatStrings);
//	}
//	/// second
////	XPos = Box.BoxEndPosX + Box.LargeYL;
////	Box = new(C) class'DrawBoxTool';
////	Box.InitPositions(XPos, YPos);
////	HeadLines.Length = 0;
////	HeadLines[0] = "Damage Type" @ class'zUtil'.static.StrRepeat(" ", 10);
////	HeadLines[1] =  "Damage";
////	Box.SetTitles("DAMAGE STATS", HeadLines, Linked.GivenDamage.Length);
////	Box.SetColors(HUDClass.default.GoldColor, HUDClass.default.WhiteColor, HUDClass.default.TurqColor);
////	Box.Draw();
////	C.DrawColor = HUDClass.default.GoldColor;
////	for(i = 0; i < Linked.GivenDamage.Length; i++){
////		StatStrings[0] = class'StatsFunctions'.static.GetDamageType(Linked.GivenDamage[i].Type);
////		StatStrings[1] = string(Linked.GivenDamage[i].Value);
////		Box.DrawArrayLine(StatStrings);
////	}	
//	RestoreFonts();
//}
//
//function RestoreFonts(){
//	local int i;
//	if(PlayerOwner == None || PlayerOwner.MyHUD == None) return;
//	for(i = 0; i < 9; i++) PlayerOwner.MyHUD.FontArrayFonts[i] = SavedFontArrayFonts[i];
//}
//function ReplaceFonts(){
//	local int i;
//	if(PlayerOwner == None || PlayerOwner.MyHUD == None) return;
//	for(i = 0; i < 9; i++){
//		SavedFontArrayFonts[i] = PlayerOwner.MyHUD.FontArrayFonts[i];
//		if(i < 9 - FontHack) PlayerOwner.MyHUD.FontArrayFonts[i] = PlayerOwner.MyHUD.FontArrayFonts[i+FontHack];
//	}
//}

defaultproperties{
	FontHack=1
}
