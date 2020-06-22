class MyGameReplicationInfo extends ReplicationInfo;

var bool bAllowTeamOverlay;
var bool bAllowBrightSkins;
var byte ForceRespawnTime;
var bool bTimeToLoad;
var bool bServerNoDodgingDelay;

replication{
	reliable if(bNetInitial && Role == Role_Authority) bAllowTeamOverlay, bAllowBrightSkins, ForceRespawnTime, bServerNoDodgingDelay;
	//reliable if(bNetDirty && Role == Role_Authority) bAllowTeamOverlay; // если придется часто перезагружаться после голосования
}

event PostBeginPlay(){
	Super.PostBeginPlay();
	bAllowTeamOverlay = Level.Game.bTeamGame && zMain(Owner).bAllowTeamOverlay;
	bAllowBrightSkins = zMain(Owner).bAllowBrightSkins;
	ForceRespawnTime = zMain(Owner).ForceRespawnTime;
	bServerNoDodgingDelay = zMain(Owner).bServerNoDodgingDelay;
}


simulated function PostNetBeginPlay(){
	Super.PostNetBeginPlay();
	if(Level.NetMode != NM_DedicatedServer) SetTimer(0.5, True);
}

simulated event Timer(){ // LoadInteraction

	local MyInfo LRI;
	local PlayerController P;
	local PlayerReplicationInfo PRI;
	local int i;

	P = Level.GetLocalPlayerController();
	if(P == None || P.PlayerReplicationInfo == None || P.GameReplicationInfo == None) return;
	LRI = class'MyInfo'.static.Get(P.PlayerReplicationInfo);
	if(LRI == None || LRI.PlayerReplicationInfo == None) return;
	for(i = 0; i < Level.GRI.PRIArray.Length; i++){
		PRI = Level.GRI.PRIArray[i];
		if(PRI != None) LRI = class'MyInfo'.static.Get(PRI);
		if(PRI == None || LRI == None || LRI.PlayerReplicationInfo == None) return;
	}
	if(!bTimeToLoad){
		bTimeToLoad = True;
		SetTimer(0.5, False);
		return;
	}
	class'zInteraction'.static.LoadInteraction(P, 'zInteraction');
	//Debug("LoadInteraction OK");
	Disable('Timer');
}

simulated function NotifyLocalPlayerDead(PlayerController P){
	if(ForceRespawnTime != 0) class'MyInfo'.static.Get(P.PlayerReplicationInfo).SetTimer(ForceRespawnTime, False);
}

simulated function Debug(coerce string S){
	class'zUtil'.static.Debug(S, Self);
}

defaultproperties{
	NetUpdateFrequency=2
}
