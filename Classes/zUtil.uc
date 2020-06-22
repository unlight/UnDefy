class zUtil extends Object;

var string Months[12];
var string DaysOfWeek[7];

final static function zMain GetMain(LevelInfo Level) {
	local Mutator M;
	M = Level.Game.BaseMutator;
	for (M = Level.Game.BaseMutator; M != None; M = M.NextMutator) {
		if (zMain(M) != None) return zMain(M);
	}
}

//final static function vector CenterBetweenVectors(vector V1, vector V2){
	//return vect(V1.X + V2.X
//}

//final static function string GetCachePath(Actor A){
//	return A.ConsoleCommand("get ini:Core.System CachePath");
//}
//
//final static function string GetCacheExt(Actor A){
//	return A.ConsoleCommand("get ini:Core.System CacheExt");
//}

final static function string GetPackageHash(PlayerController PC, string Package, optional bool bFullPath) {
	
	local array<string> Results;
	local Security Security;
	local string Path;
	
	if (bFullPath) Path = Package; 
	else Path = Package$".u";
	Security = PC.Spawn(class'Engine.Security');
	Security.LocalPerform(2, Path, "", Results);
	Security.Destroy();
	if (Results.Length == 1) return Results[0];
}

// string functions
static final function bool PregMatch(string Str, string What) {
	if (InStr(Locs(Str), Locs(What)) != -1) return True;
	return False;
}

static final function string LTrim(coerce string S) {
	while(Left(S, 1) == " ") S = Right(S, Len(S) - 1);
	return S;
}

static final function string RTrim(coerce string S) {
	while(Right(S, 1) == " ") S = Left(S, Len(S) - 1);
	return S;
}

static final function string Trim(coerce string S) {
	return LTrim(RTrim(S));
}

//static final function Explode(string S, string Sep, optional out string S1, optional out string S2) {
//	local array<string> Parts;
//	Split(S, Sep, Parts);
//	Parts.Length = 2;
//	S1 = Parts[0]; // Locs()? 
//	S2 = Parts[1];
//}

static final function string GetMutatorString(string LocalURL) {
	local int Pos;
	local array<string> OutParts;
	local string S;
	LocalURL = Locs(LocalURL);
	Pos = InStr(LocalURL, "mutator=");
	if(Pos == -1) return S;
	S = Mid(LocalURL, Pos + Len("mutator="));
	Split(S, "?", OutParts);
	return OutParts[0];
}

static final function string GetMutatorVersion(string LocalURL, string Mutator) {
	
	local int i;
	local array<string> Parts, PartsB;
	
	Split(GetMutatorString(LocalURL), ",", Parts);
	for(i = 0; i < Parts.Length; i++){
		Split(Parts[i], ".", PartsB);
		PartsB.Length = 2;
		if(PartsB[1] ~= Mutator) return Locs(PartsB[0]);
	}
}


static final function bool GetOption(string Options, string Key, out string OutResult) {
	local int i, Pos;
	local string C;
	OutResult = "";
	Options = Locs(Options);
	Key = Locs(Key);
	i = InStr(Options, Key$"=");
	if(i == -1) return False;
	Loop: Pos = i + Len(Key$"=");
	C = Mid(Options, Pos, 1);
	if(IsRealSymbol(C)){
		OutResult $= C;
		i = i + 1;
		goto Loop;
	}
	return True;
}

static final function string Implode(string S, array<string> A){
	return class'GUI'.static.JoinArray(A, S, False);
}

//static final function string IsDigit(string Test, optional bool bAllowDecimal){
//	return class'GUI'.static.IsDigit(Test, bAllowDecimal);
//}

//static function bool LocalizedMessage(PlayerController PC, class<LocalMessage> Message, optional int N, optional PlayerReplicationInfo R1){
//	PC.ReceiveLocalizedMessage(Message, N, R1, R2, O);
//	return True;
//}

static function string StringGaps(coerce string S, int G){
	return S $ StrRepeat(" ", G - Len(S));
}

final static function string StrRepeat(coerce string S, int Count){
	local string Res;
	while(--Count >= 0) Res $= S;
	return Res;
}

static final function bool IsRealSymbol(coerce string S){
	if(S ~= "-") return True;
	if(IsDigit(S)) return True;
	if(IsChar(S)) return True;
	return False;
}
static final function bool IsAlphaNum(coerce string S){
	return (IsDigit(S) || IsChar(S));
}

static final function bool IsDigit(coerce string S){
	if(Asc(S) >= 48 && Asc(S) <= 57) return True;
	return False;
}

static final function bool IsChar(coerce string S){
	local int Code;
	Code = Asc(Caps(S));
	if(Code >= 65 && Code <= 90) return True;
	return False;
}

// multiple of N
static final function bool MultipleOf(coerce int M, int N) {
	return (M % N == 0);
}

static final function string StripColorCodes(string InString){
	return class'GUIComponent'.static.StripColorCodes(InString);
}

static final function string Switcher(coerce bool B){
	return Eval(B, "^2On", "^1Off");
}

static function string Colorize(string ColorToken){ // ColorToken = ^1
	local int N;
	N = int(Right(ColorToken, 1));
	switch(N){
		case 0: return GetColorString(250, 250, 250); // white
		case 1: return GetColorString(250, 1, 1); // red
		case 2: return GetColorString(1, 250, 1); // green
		case 3: return GetColorString(250, 240, 1); // yellow
		case 4: return GetColorString(1, 1, 250); // blue
		case 5: return GetColorString(1, 128, 250); // turq
		case 6: return GetColorString(255, 203, 219); // pink
		case 7: return GetColorString(255, 20, 20); // light-red
		case 8: return GetColorString(130, 130, 130); // grey
		case 9: return GetColorString(160, 160, 160); // grey-white
		default: break;
	}
	return GetColorString(250, 250, 250); // white
}

static function color GetMyColor(int N, optional byte A){
	local string C;
	local color MyColor;
	C = Colorize("^"$N);
	MyColor.R = Asc(Mid(C, 1, 1));
	MyColor.G = Asc(Mid(C, 2, 1));
	MyColor.B = Asc(Mid(C, 3, 1));
	if(A == 0) A = 255;
	MyColor.A = A;
	return MyColor;
}

static function string GetColorString(byte R, byte G, byte B){ // 0 - NOT ALLOWED HERE!
	return chr(27)$chr(R)$chr(G)$chr(B);
}

static function string Paint(string PaintString){
	local string ColorToken, OutString;
	local int Pos, i;
	OutString = "";
	Pos = InStr(PaintString, "^");
	while(Pos > -1){
		if(Pos > 0){
			OutString $= Left(PaintString, Pos);
			PaintString = Mid(PaintString, Pos);
			Pos = 0;
	    }
		i = Len(PaintString);
		ColorToken = Mid(PaintString, Pos, 2);
		if(i-2 > 0)	PaintString = Right(PaintString, i-2);
		else PaintString = "";
		OutString $= Colorize(ColorToken);
		Pos = InStr(PaintString, "^");
	}
	if(PaintString != "") OutString $= PaintString;
	return OutString;
}

static function ConsoleMessage(PlayerController P, string Message, optional bool bEcho){
	Message = Paint(Message);
	if(P.MyHUD == None && !bEcho) bEcho = True;
	if(bEcho) P.ClientMessage(Message); else P.MyHUD.PlayerConsole.Message(Message, 0);
}

static function string GetPackageName(optional coerce string S, optional bool bTrailingDot){
	local int Pos;
	if(S == "") return "UnDefy10"; // v10
	Pos = InStr(S, ".");
	if(bTrailingDot) Pos = Pos + 1; // returns "SomePack." (with dot)
	return Left(S, Pos); // returns "SomePack" (with no dot)
}

static final function array<byte> BitMaskArray(int DecNumber){
	local string Bin;
	local int L, i;
	local array<byte> OutArray;
	Bin = Dec2Bin(DecNumber);
	L = Len(Bin);
	for(i = L; i > 0; i--) OutArray[OutArray.Length] = byte(Mid(Bin, i-1, i));
	return OutArray;
}

static final function string Dec2Bin(int DecNumber){
	local string Bin;
	while(DecNumber > 0){
		Bin = int(DecNumber % 2) $ Bin;
		DecNumber = DecNumber / 2;
	}
	return Bin;
}
static final function string ShortDayOfWeek(int N){
	return Left(default.DaysOfWeek[N], 3);
	if(N == 1) return "Mon";
	if(N == 2) return "Tue";
	if(N == 3) return "Wed";
	if(N == 4) return "Thu";
	if(N == 5) return "Fri";
	if(N == 6) return "Sat";
	return "Sun";
}
// month, three letters
static function string ShortMonthName(int N){
	return Left(default.Months[N-1], 3);
}
static function string LeadingZeros(coerce string N){
	return Right("0" $ N, 2);
}

static function string GetLevelTime(LevelInfo Level){
	local string S;
	S = LeadingZeros(Level.Hour) $ ":" $ LeadingZeros(Level.Minute) $ ":" $ LeadingZeros(Level.Second);
	S @= "(" $ ShortDayOfWeek(Level.DayOfWeek) $ "," @ Level.Day @ ShortMonthName(Level.Month) @ Level.Year $ ")";
	return S;
}

static function SortString(out array<string> A){
	local int i, k;
	local string Temp;
	for(i = 0; i < A.Length - 1; i++){
		for(k = 0; k < A.Length; k++){
			if(StrCmp(A[i], A[k]) > 0) continue;
			Temp = A[i];
			A[i] = A[k];
			A[k] = Temp;
		}
	}
}

//
//static function SortInt(out array<int> A){
//	local int i, k, L1, L2, Polochka;
//	L2 = A.Length;
//	L1 = L2 - 1;
//	for(i = 0; i < L1; i++){
//		for(k = 0; k < L2; k++){
//			if(SortIntInOrder(A[i], A[k])) continue;
//			Polochka = A[i];
//			A[i] = A[k];
//			A[k] = Polochka;
//		}
//	}
//}
//static function bool SortIntInOrder(int A, int B){
//	if(A < B) return False;
//	return True;
//}

static simulated function Debog(coerce string S, Object O, optional Actor A){
	local WeaponFire WeaponFire;
	local string LogString, S2, Time;

	if(WeaponFire(O) != None){
		WeaponFire = WeaponFire(O);
		S2 = Eval(WeaponFire.Level.Game != None, "(Server)", "(Client)");
		Time = string(WeaponFire.Level.TimeSeconds);
		if(A == None) A = WeaponFire.Instigator;
	}
	
	LogString = Time @ O.GetItemName(string(O.Class)) @ "Log:" @ S @ S2;
	Log(LogString);
	if(A != None) A.Level.Game.Broadcast(A, LogString);
}


/*static simulated function string GetFunctionInfo(Function P){
	return "[Class]" @ P.Class @ "[Name]" @ P.Name;
}*/

/*static simulated function string GetPropertyInfo(Property P){
	return "[TYPE]" @ P.Class.Name @ "[NAME]" @ P.Name @ "[VALUE]" @ O.GetPropertyText(string(P.Name)));
}*/

/*static simulated function DebugProp(Object O){
    local Property P;
    foreach O.AllObjects(class'Property', P){
		if(P.Outer == O.Class) Debug("[TYPE]" @ P.Class.Name @ "[NAME]" @ P.Name @ "[VALUE]" @ O.GetPropertyText(string(P.Name)));
	}
}*/

static simulated function string GetCachePath(Subsystem S){
	return S.GetPropertyText("CachePath");
}

static simulated function string GetCacheExt(Subsystem S){
	return S.GetPropertyText("CacheExt");
}

static simulated function Debug(coerce string S, optional Actor A){ // A - optional need simulated actor
	local string LogString, S2, Time;
	local PlayerController P;
	local bool UnCommentReturn;
	return;
	if(A == None){ Log(S); return; }
	if(A.Level != None){
		Time = "" $ A.Level.TimeSeconds;
		P = A.Level.GetLocalPlayerController();
	}
	if(A.Level.Game != None) S2 = "(Server)";
	else S2 = "(Client)";
	LogString = Time @ A.GetHumanReadableName() @ "Log:" @ S @ S2;
	if(A.Level != None && A.Level.Game != None) A.Level.Game.Broadcast(A, LogString);
	else if(P != None) P.ClientMessage(LogString);
	Log(LogString);
}
defaultproperties{
	Months(0)="January"
	Months(1)="February"
	Months(2)="March"
	Months(3)="April"
	Months(4)="May"
	Months(5)="June"
	Months(6)="July"
	Months(7)="August"
	Months(8)="September"
	Months(9)="October"
	Months(10)="November"
	Months(11)="December"
	DaysOfWeek(0)="Sunday"
	DaysOfWeek(1)="Monday"
	DaysOfWeek(2)="Tuesday"
	DaysOfWeek(3)="Wednesday"
	DaysOfWeek(4)="Thursday"
	DaysOfWeek(5)="Friday"
	DaysOfWeek(6)="Saturday"
}
