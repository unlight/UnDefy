class DrawBoxTool extends Object within Canvas;

//var string MainTitle;
//var array<string> Headlines;
//var float LargeYL, XL, BoxSizeX, BoxSizeY, OffsetY;
//var float BoxStartPosX, BoxStartPosY, BoxEndPosX;
//var array<float> Positions; // ���������� X
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
//	// ���������� ������� ��� ������
//	Positions[0] = BoxStartPosX + 1.1 * XL;
//	for(i = 1; i < Headlines.Length; i++){
//		Outer.StrLen(Headlines[i-1], X, Y);
//		BoxSizeX += X + 2 * Y;
//		Positions[i] = Positions[i-1] + X + 2 * Y;
//	}
//	// ������������� ����� � ������ ����� (Len)
//	Outer.StrLen(Headlines[i-1], X, Y);
//	BoxSizeX += X + 1.1 * Y;
//	BoxSizeY = LargeYL * (3 + Len);
//	// ��� ��������� �����
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
//	// ������ �����
//	Outer.DrawColor = BackColor;
//	Outer.SetPos(BoxStartPosX, BoxStartPosY);
//	Outer.DrawTileStretched(Material'InterfaceContent.ScoreBoxA', BoxSizeX, BoxSizeY);
//	// ������ ������� ���������
//	OffsetY = BoxStartPosY + 0.5 * LargeYL;
//	Outer.SetPos(Positions[0], OffsetY);
//	Outer.DrawColor = MainTitleColor;
//	Outer.DrawText(MainTitle);
//	// ������ ��������� ��� ������ �������
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
//	Lines.Length = 0; // ������� ������
//	OffsetY += LargeYL; // ��������� �� ����� ������
//}

defaultproperties{
	BackColor=(R=0,G=0,B=0,A=255)
}
