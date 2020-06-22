class MyIcon extends Actor;

//#EXEC TEXTURE IMPORT File=Textures\InConsole.pcx NAME=InConsole LODSET=5 FLAGS=2 MIPS=OFF MASKED=1
#EXEC TEXTURE IMPORT File=Textures\InMenu.pcx NAME=InMenu LODSET=5 FLAGS=2 MIPS=OFF MASKED=1
// drawactor

var Texture MyIcons[2];

event PostBeginPlay(){
	local Pawn P;
	Texture = MyIcons[int(Location.X)-1];
	if(PlayerReplicationInfo(Owner) == None || PlayerReplicationInfo(Owner).PlayerZone == None){
		Destroy();
		return;
	}
	foreach PlayerReplicationInfo(Owner).PlayerZone.ZoneActors(class'Pawn', P){
		if(P.PlayerReplicationInfo != None && P.PlayerReplicationInfo == Owner){
			P.AttachToBone(Self, 'head'); // Base = Pawn
			SetBase(P);
			SetRelativeLocation(128 * vect(1,0,0));
			return;
		}
	}
}

event Tick(float F){
	if(Base == None) Destroy();
	else if(Pawn(Base).PlayerReplicationInfo == None) LifeSpan = 2.5;
	else return;
	Disable('Tick');
}

simulated function Debug(coerce string S){
	class'zUtil'.static.Debug(S, Self);
}

defaultproperties{
	//bHardAttach=True
	bNotOnDedServer=True
	//bAlwaysZeroBoneOffset=True
	RemoteRole=ROLE_None
	//MyIcons(0)=texture'InConsole'
	MyIcons(0)=texture'InMenu'
	MyIcons(1)=texture'InMenu'
	bNoRepMesh=True // :)
	DrawScale=0.15
	//Style=STY_Alpha
	bHidden=False
	//NetPriority=0.8 // глупо
	//NetUpdateFrequency=2.5 // глупо
}
