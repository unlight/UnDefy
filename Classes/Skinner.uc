class Skinner extends Interaction;
// FIX ME DarkenDeadBody сделан не по человечески
const C = class'zMain';

var array<MyInfo> NoSkinned;
var xUtil.PlayerRecord PlayerRecords[2]; // 0 = enemy, 1 = team
var byte Glowing[2];
var byte TeamNum[2];
var bool bTeamGame;

var int Count;

function EnemyBones();

//event Initialized(){
//	EnemySkin();
//	TeamSkin();
//	EnemyBones();
//	UpdateSkins();
//}

event NotifyLevelChange(){
	Master.RemoveInteraction(Self);
}

function TeamSkin(){
	PreLoadSkin(1, C.default.TeamSkin);
}

function EnemySkin(){
	PreLoadSkin(0, C.default.EnemySkin);
}

function UpdateSkins(){

	local int i;
	local MyInfo MyLRI, OtherLRI;
	local PlayerReplicationInfo PRI;

	MyLRI = class'MyInfo'.static.Get(ViewportOwner.Actor.PlayerReplicationInfo);
	NoSkinned.Length = 0;
	
	for(i = 0; i < ViewportOwner.Actor.Level.GRI.PRIArray.Length; i++){
		PRI = ViewportOwner.Actor.Level.GRI.PRIArray[i];
		if(PRI != None) OtherLRI = class'MyInfo'.static.Get(PRI);
		if(PRI != None && OtherLRI != None && OtherLRI != MyLRI) MyLRI.ClientSpawnNotify(OtherLRI);
	}
	bRequiresTick = True;
}

final function Setup(xPawn xPawn, bool bEnemy){
	
	local int i;
	if(bEnemy) i = 0; else i = 1;
	
	xPawn.bAlreadySetup = False;
	xPawn.TeamSkin = 255;
	xPawn.Setup(PlayerRecords[i]);
	class'SpeciesType'.static.SetTeamSkin(xPawn, PlayerRecords[i], TeamNum[i]);

	xPawn.AmbientGlow = Glowing[i];
	xPawn.bUseLightingFromBase = False;
	xPawn.bUnlit = False;
	xPawn.bAcceptsProjectors = False;
}

function Tick(float DeltaTime){

	local int i, MyTeamID;
	local xPawn xPawn;

	// когда в спеках, в ДМ тварь за которой смотришь тоже становится врагом
	xPawn = xPawn(ViewportOwner.Actor.ViewTarget);
	if(bTeamGame && xPawn != None) MyTeamID = xPawn.GetTeamNum();
	else MyTeamID = 1;

	// ищем новую тварь
	for(i = 0; i < NoSkinned.Length; i++){
		xPawn = NoSkinned[i].MyPawn;
		
		// check for dummies
		if(NoSkinned[i] == None || (NoSkinned[i].bSkinned && xPawn != None && xPawn.PlayerReplicationInfo != None)){
			//Debug("Removed Dummy NoSkinned" @ NoSkinned[i].bSkinned @ xPawn @ xPawn.PlayerReplicationInfo);
			NoSkinned.Remove(i, 1);
			i = i - 1;
			continue;
		}
		
		if(xPawn == None){
			continue;
			//if(++Count < 1999) continue;
			//Debug("MyInfo.bSkinned is False, but no Pawn" @ NoSkinned[i] @ "NoSkinned.Length" @ NoSkinned.Length);
			//Count = 0;
		/*}else if(ViewportOwner.Actor.Role == ROLE_Authority){
			if(NoSkinned[i].OldPawn != None && NoSkinned[i].OldPawn.PlayerReplicationInfo == None && C.default.bDarkenDeadBody){
				xPawn.AmbientGlow = 0;
				Debug("Down AmbientGlow:" @ xPawn.GetHumanReadableName());
			}*/
		}else if(xPawn.PlayerReplicationInfo == None){
			if(xPawn.AmbientGlow != 0 && C.default.bDarkenDeadBody){
				xPawn.AmbientGlow = 0;
				//xPawn.bUnlit = True;
			}
		}else if(!NoSkinned[i].bSkinned){
			Setup(xPawn, MyTeamID != xPawn.GetTeamNum());
			//Debug("Setup" @ i @ "xPawnTeam" @ xPawn.GetTeamNum()  @ "My" @ MyTeamID @ "Len-1" @ NoSkinned.Length - 1);
			NoSkinned[i].bSkinned = True;
			NoSkinned.Remove(i, 1);
			//if(C.default.bDarkenDeadBody && xPawn.Event == '') xPawn.Event = 'DarkenTrigger';
			i = i - 1;
		}
	}
	bRequiresTick = bool(NoSkinned.Length);
	//Debug("NoSkinned.Length" @ NoSkinned.Length);
}

function AuthorityModeDarkBody(){
	local xPawn P;
	if(!C.default.bDarkenDeadBody) return;
	foreach ViewportOwner.Actor.DynamicActors(class'xPawn', P){
		if(P.PlayerReplicationInfo == None && P.AmbientGlow != 0) P.AmbientGlow = 0;
	}
}

/*function SpawnNotify(MyInfo PawnInfo){
	//if(NoSkinned.Length > ViewportOwner.Actor.Level.GRI.PRIArray.Length) Warn("Skinner.NoSkinned.Length is more PRIArray! Looks strange...");
	//if(ViewportOwner.Actor.ViewTarget == PawnInfo.MyPawn) Warn("ViewTarget respawn");
}*/

final function PreLoadSkin(byte i, string Skinny){
	local array<string> Skin;
	Split(Skinny, "/", Skin);
	Skin.Length = 3;
	TeamNum[i] = GetTeamSkin(Skin[1]);
	PlayerRecords[i] = class'xUtil'.static.FindUPLPlayerRecord(Skin[0]);
	Glowing[i] = Clamp(int(Skin[2]), 0, 254); // 255 = pulse
}

final function byte GetTeamSkin(string C){
	switch(Locs(C)){
		case "blue": return 1;
		case "red": return 0;
	}
	return 255;
}

simulated function Debug(coerce string S){
	class'zUtil'.static.Debug(S, ViewportOwner.Actor);
}

defaultproperties{
	bRequiresTick=False
	bActive=False
	bVisible=False
	bNativeEvents=False
}
