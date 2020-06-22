class MyTeamGameReplicationInfo extends MyGameReplicationInfo;

var string LocNamesB[30]; // location marks
var vector LocCoordsB[30];
var byte LocCount;

replication{
	reliable if(bNetInitial && Role == Role_Authority) LocNamesB, LocCoordsB, LocCount;
}

event Tick(float DeltaTime){
	GetLocationMarks();
	Disable('Tick');
}

function int GetLocationMarks(){
	
	local LocationMarks LM;
	local int i;
	
	LM = new class'LocationMarks';
	LM.Initialize(Level.Game);
	if(LM.LocNames.Length > ArrayCount(LocNamesB)) LM.LocNames.Length = ArrayCount(LocNamesB);
	LocCount = LM.LocNames.Length;
	
	for(i = 0; i < LM.LocNames.Length; i++){
		LocNamesB[i] = LM.LocNames[i];
		LocCoordsB[i] = LM.Coordinates[i];
	}
	return LM.LocNames.Length;
}

simulated function vector GetLocCoord(byte i){
	return LocCoordsB[i];
}

function LockTeam(MyInfo LRI);

defaultproperties{}
