class MyInfo extends LinkedReplicationInfo;
// todo: разделить на LRI бота и человека
var bool bMyHitsounds;
var float HitsoundTime;
var bool bCanStopCountDown;

var(Item) string LastPickupItem;
var(Item) string LastPickupWeapon;
var(Item) string LastPickupPowerUp;
var(Voting) bool bVoted;
var byte TimeoutCalled;

//var byte MyWeapon;
//var vector MyLocation;
//var byte MyHealth;
//var byte MyShield;
//var byte MySmallShield;
var bool bHasUDamage;
var MyStats Stats;

var PlayerReplicationInfo PlayerReplicationInfo;
var xPawn MyPawn;

var bool bSkinned;

replication{
	unreliable if(Role == Role_Authority) ClientPlayHitsound;
	//unreliable if(Role == Role_Authority) MyPawn, ClientPlayHitsound; // 3. client: work
	//unreliable if(Role == Role_Authority && !bNetOwner) MyPawn; // 1 server NOT ok (skins not work), client Ok
	//unreliable if(Role == Role_Authority) MyPawn; // work client and server // demorecspectator
	//reliable if((!bNetOwner || bDemoRecording || bRepClientDemo) && Role==ROLE_Authority) MyPawn; // 5 clietnt ok, server: skins work, demorec spectator
	unreliable if(Role == Role_Authority && (!bNetOwner || bDemoRecording)) MyPawn; // 4 // client ok, server side - server: skins work, demorec spectator
	reliable if(Role < ROLE_Authority) ServerSetMyHitsounds, ServerSetTalking;
	reliable if(Role == Role_Authority) TalkingNotify, ClientSpawnNotify;
	reliable if(bNetInitial && Role == ROLE_Authority) PlayerReplicationInfo;
}


function ForceSwitchTeam(optional MyInfo Kicked){
	if(Kicked != None && PlayerController(Kicked.Owner) != None) PlayerController(Kicked.Owner).SwitchTeam();
	if(PlayerController(Owner) != None) PlayerController(Owner).SwitchTeam();
}

function ForceBecomeActivePlayer(MyInfo Kicked){
	if(Kicked == Self) return;
	Level.Game.MaxSpectators++;
	PlayerController(Kicked.Owner).BecomeSpectator();
	Level.Game.MaxSpectators--;
	PlayerController(Owner).BecomeActivePlayer();
}

function bool AllowBecomeActivePlayer(){

	local PlayerController P;

	P = PlayerController(Owner);
	if(P == None || P.PlayerReplicationInfo == None) return False;
	if(!Level.GRI.bMatchHasBegun) return False;
	if(Level.Game.bMustJoinBeforeStart) return False;
	if(Level.Game.NumPlayers >= Level.Game.MaxPlayers) return False;
	if(P.IsInState('GameEnded') || P.IsInState('RoundEnded')) return False;
	return True;
}

simulated function string GetHumanReadableName(){
	return PlayerReplicationInfo.GetHumanReadableName();
}

simulated function ClientSpawnNotify(MyInfo PawnInfo){
	
	local PlayerController LP;
	local Skinner Skinner;

	PawnInfo.bSkinned = False;	
	LP = Level.GetLocalPlayerController();
	Skinner = Skinner(class'zInteraction'.static.LoadInteraction(LP, 'Skinner'));
	Skinner.bRequiresTick = True;
	Skinner.NoSkinned[Skinner.NoSkinned.Length] = PawnInfo;
	// authority darken mode hack 
	if(Role == ROLE_Authority && LP != None) Skinner.AuthorityModeDarkBody();
}

simulated function int GetTeamNum(){
	if(Controller(Owner) != None) return Controller(Owner).GetTeamNum();
	if(PlayerReplicationInfo == None || PlayerReplicationInfo.Team == None) return 255;
	return PlayerReplicationInfo.Team.TeamIndex;
}

//function UpdateTeamInfo(Pawn P){
//	if(P.Weapon != None) MyWeapon = P.Weapon.InventoryGroup;
//	MyLocation = P.Location;
//	MyHealth = P.Health;
//	MyShield = P.ShieldStrength;
//	if(xPawn(P) != None) MySmallShield = xPawn(P).SmallShieldStrength;
//	bHasUDamage = P.HasUDamage();
//}

// server
function bool ReceiveMessage(class<LocalMessage> Message, optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2, optional Object O){
	if(PlayerController(Owner) != None) PlayerController(Owner).ReceiveLocalizedMessage(Message, N, R1, R2, O);
	return False;
}

function bool ClientMessage(coerce string S, optional name Type){
	if(PlayerController(Owner) != None) PlayerController(Owner).ClientMessage(S, Type);
	return False;
}

// client
simulated event Timer(){
	PlayerController(PlayerReplicationInfo.Owner).ServerRestartPlayer();
}

//function RemoveWeapons(){
//   while ( PlayerPawn.Inventory != None ) PlayerPawn.Inventory.Destroy();
//}

function ServerSetTalking(byte Status){ // 0 - none 1 - cons 2 - menu
	
	local Controller C;
	local MyInfo OtherLRI;
	
	if(Level.NetMode != NM_Client) for(C = Level.ControllerList; C != None; C = C.NextController){
		if(C.PlayerReplicationInfo != None && PlayerController(C) != None){
			OtherLRI = class'MyInfo'.static.Get(C.PlayerReplicationInfo);
			if(OtherLRI != None && OtherLRI != Self) OtherLRI.TalkingNotify(Status, PlayerReplicationInfo);
		}
	}
}

simulated function TalkingNotify(byte Status, PlayerReplicationInfo Talker){

	local MyIcon Icon;
	local vector V;
	
	if(!class'zMain'.default.bShowChatIcon || Talker == None) return;
	switch(Status){
		case 1:
		case 2:
			V.X = Status;
			Spawn(class'MyIcon', Talker,, V);
			break;
		default: foreach Talker.ChildActors(class'MyIcon', Icon) Icon.Destroy();
	}
}

// client
simulated function ClientPlayHitsound(int Damage, PlayerReplicationInfo InjuredPRI){
	//Debug("ClientPlayHitsound" @ Damage @ PlayerReplicationInfo @ PlayerReplicationInfo.Owner @ Owner);
	PlayerController(PlayerReplicationInfo.Owner).ReceiveLocalizedMessage(class'HitSoundMessage', Damage, InjuredPRI);
}

function ServerSetMyHitsounds(bool B){
	bMyHitsounds = (B && class'zUtil'.static.GetMain(Level).bAllowHitSounds);
}

function SetLastPickupItem(string S, byte Type){
	LastPickupItem = S;
	switch(Type){
		case 1: LastPickupWeapon = S; break;
		case 2: LastPickupPowerUp = S; break;
	}
}

static function MyInfo Get(PlayerReplicationInfo PRI){
	local LinkedReplicationInfo LRI;
	LRI = PRI.CustomReplicationInfo;
	while(LRI != None){
		if(LRI.IsA('MyInfo')) return MyInfo(LRI);
		LRI = LRI.NextReplicationInfo;
	}
	return None;
}

simulated function Debug(coerce string S){
	class'zUtil'.static.Debug(S, Self);
}

defaultproperties{
	bMyHitsounds=False // default for bots
	bCanStopCountDown=True
}
