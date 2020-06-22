class DrawBoxTool extends Object within Canvas;

//var string MainTitle;
//var array<string> Headlines;
//var float LargeYL, XL, BoxSizeX, BoxSizeY, OffsetY;
//var float BoxStartPosX, BoxStartPosY, BoxEndPosX;
//var array<float> Positions; // координаты X
var color BackColor, MainTitleColor, HeadlinesColor, TextColor;
//
////var config float SomeConf;
//
//event Created(){
//	Outer.StrLen("X", XL, LargeYL);
//}
//
//function InitPositions(float X, float Y){
//	BoxStartPosX = X;
//	BoxStartPosY = Y;
//}
//
//function SetTitles(string Main, array<string> Lines, int Len){
//	local byte i;
//	local float X, Y;
//	MainTitle = Main;
//	Headlines = Lines;
//	// определяем позиции для текста
//	Positions[0] = BoxStartPosX + 1.1 * XL;
//	for(i = 1; i < Headlines.Length; i++){
//		Outer.StrLen(Headlines[i-1], X, Y);
//		BoxSizeX += X + 2 * Y;
//		Positions[i] = Positions[i-1] + X + 2 * Y;
//	}
//	// устанавливаем длину и высоту рамки (Len)
//	Outer.StrLen(Headlines[i-1], X, Y);
//	BoxSizeX += X + 1.1 * Y;
//	BoxSizeY = LargeYL * (3 + Len);
//	// для следующей рамки
//	BoxEndPosX = BoxStartPosX + BoxSizeX;
//}
//
//function SetColors(color MainTitle, color Headlines, optional color Back){
//	MainTitleColor = MainTitle;
//	HeadlinesColor = Headlines;
//	if(Back.A != 0) BackColor = Back;
//}
//
//function Draw(){
//	// рисуем рамку
//	Outer.DrawColor = BackColor;
//	Outer.SetPos(BoxStartPosX, BoxStartPosY);
//	Outer.DrawTileStretched(Material'InterfaceContent.ScoreBoxA', BoxSizeX, BoxSizeY);
//	// рисуем главный заголовок
//	OffsetY = BoxStartPosY + 0.5 * LargeYL;
//	Outer.SetPos(Positions[0], OffsetY);
//	Outer.DrawColor = MainTitleColor;
//	Outer.DrawText(MainTitle);
//	// рисуем заголовки для текста массива
//	OffsetY += LargeYL;
//	Outer.SetPos(Positions[0], OffsetY);
//	Outer.DrawColor = HeadlinesColor;
//	DrawArrayLine(Headlines);
//}
//
//function DrawArrayLine(out array<string> Lines){
//	local byte i;
//	for(i = 0; i < Lines.Length; i++){
//		Outer.SetPos(Positions[i], OffsetY);
//		Outer.DrawText(Lines[i]);
//	}
//	Lines.Length = 0; // очищаем массив
//	OffsetY += LargeYL; // переходим на новую строку
//}

defaultproperties{
	BackColor=(R=0,G=0,B=0,A=255)
}
