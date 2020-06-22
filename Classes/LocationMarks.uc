class LocationMarks extends Object;
// тип локации: 1 - near pickup 2 - between p1 & p2
// лифты 1. около LiftCenter есть всегда LiftExit
// todo: мутатор MutNoSuperWeapon заменяет супер оружие
// else if ( xWeaponBase(Other).WeaponType == class'Redeemer' ) xWeaponBase(Other).WeaponType = class'RocketLauncher';
// todo: добавить ближайший пикап 2 и если разница между ними 10 м и он в прямой видимости то используем его

var array<string> LocNames, TempLMNames;
var array<vector> Coordinates;
var Actor SomeActor;

function Initialize(Actor Dummy){ // out array<string> A, out array<vector> B
	SomeActor = Dummy;
	ProcessPickups();
	ProcessNavigationPoints();
	CleanLocationMarks();
	//A = LocNames;
	//B = Coordinates;
}

function CleanLocationMarks(){
	local byte i, j;
	local string Nearest, Letter, ItemLetter;
	for(i = 0; i < LocNames.Length; i++){
		Nearest = NearestLocation(Coordinates[i]);
		if(Nearest == "") continue;
		ItemLetter = Right(LocNames[i], 2);
		for(j = 65; j < 90; j++){
			Letter = " " $ Chr(j);
			if(ItemLetter != Letter) continue;
			LocNames[i] @= Nearest;
			break;
		}
	}
}

function string NearestLocation(vector V){
	local float MinDistance, Distance;
	local byte i;
	local string S;
	MinDistance = 52.5 * 15; // + 5-10 m для lineofsight pickupa
	for(i = 0; i < TempLMNames.Length; i++){
		if(V == Coordinates[i]) continue;
		Distance = VSize(V - Coordinates[i]);
		if(Distance > MinDistance) continue;
		MinDistance = Distance;
		S = TempLMNames[i];
	}
	if(S != "") S = Repl("(%P)", "%P", S);
	return S;
}

function ProcessNavigationPoints(){
	local NavigationPoint N;
	local string S;
	for(N = SomeActor.Level.NavigationPointList; N != None; N = N.NextNavigationPoint){
		if(N.IsA('Teleporter')) S = "Teleport";
		else if(N.IsA('Door')) S = "Door";
		else if(N.IsA('LiftCenter')) S = "Lift";
		else if(N.IsA('JumpPad')) S = "Jump Pad";
		else if(GameObjective(N) != None) S = N.GetHumanReadableName();
		else continue;
		RegisterLocation(N.Location, S);
	}
}

function ProcessPickups(){
	local Pickup P;
	local string S;
	foreach SomeActor.DynamicActors(class'Pickup', P){
		if(P.IsA('WeaponPickup')) S = P.GetHumanReadableName();
		else if(P.IsA('UDamagePack')) S = "DOUBLE DAMAGE";
		else if(P.IsA('ShieldPickup')) S = ShieldPickup(P).ShieldAmount @ "Shield";
		else if(P.IsA('SuperHealthPack')) S = "Super Health";
		else continue;
		RegisterLocation(P.Location, S);
	}
}

function RegisterLocation(vector Coordinate, string S){
	local byte i, j, Count;
	local array<byte> Keys;
	i = TempLMNames.Length;
	Coordinates[i] = Coordinate;
	TempLMNames[i] = S;
	Count = CountStrings(S, TempLMNames, Keys);
	if(Count == 1) LocNames[i] = TempLMNames[i];
	else for(j = 0; j < Keys.Length; j++) LocNames[Keys[j]] = TempLMNames[Keys[j]] @ Chr(65 + j);
}

function byte CountStrings(string S, array<string> A, optional out array<byte> Keys){
	local byte i, Count;
	Keys.Length = 0;
	for(i = 0; i < A.Length; i++){
		if(S != A[i]) continue;
		Keys[Keys.Length] = i;
		Count++;
	}
	return Count;
}

simulated function Debug(coerce string S){
	class'zUtil'.static.Debug(S, SomeActor);
}
defaultproperties{}
