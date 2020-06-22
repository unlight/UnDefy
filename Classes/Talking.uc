class Talking extends zObject;

var array<string> Commands;
var zInteraction Intr;

event Created(){
	Super.Created();
	Commands = class'Help'.static.ConsoleCommands();
	Intr = zInteraction(class'zInteraction'.static.LoadInteraction(Outer, 'zInteraction'));
}

final function TryTalking(byte Type){
	if(Intr.TalkingStatus == 0 && Intr.Me.Pawn != None) Intr.TalkingEvent(Type);
}

function MyTick(){
	Super.MyTick();
	if(GUIController(Outer.Player.GUIController).ActivePage != None) TryTalking(2);
	else if(IsInConsole()){
		TryTalking(1);
		ConsoleTypeEvent();
	}else if(Intr.TalkingStatus != 0) Intr.TalkingEvent(0);
}

function bool IsInConsole(){
	return (Outer.Player.Console.bTyping || Outer.Player.Console.GetStateName() == 'ConsoleVisible');
}

function ConsoleTypeEvent(){
	local string S;
	local Console C;
	C = Outer.Player.Console;
	if(C.TypedStr == "" || Len(C.TypedStr) < 3 || InStr(C.TypedStr, " ") > 0) return;
	S = SearchCommand(C.TypedStr);
	if(S != ""){
		C.TypedStr = S;
		C.TypedStrPos = Len(S);
	}
}

event string SearchCommand(string TypedStr){
	local array<int> Index;
	local string S;
	local int i, N;
	TypedStr = Locs(TypedStr);
	for(i = 0; i < Commands.Length; i++){
		if(InStr(Locs(Commands[i]), TypedStr) == 0) Index[Index.Length] = i;
	}
	if(Index.Length == 0) return S;
	if(Index.Length == 1) return Commands[Index[0]] @ "";
	while(True){
		N++;
		if(Left(Commands[Index[0]], N) ~= Left(Commands[Index[1]], N)) continue;
		return Left(Commands[Index[0]], N - 1);
	}
}

defaultproperties{
	UpdateTime=(Min=0.15,Max=0.25)
}
