class MyGameRules extends GameRules;

// todo: через netdamage кто в кого стрелял (токены)

var zMain Main;
var bool bOvertimeTimerFixed;
var MyInfo LRIArray[32];

// здесь можно выкинуть в спеки, проигравшего в дуэли
//function bool HandleRestartGame(){
//	return Super.HandleRestartGame();
//}

function MyInfo GetLRI(PlayerReplicationInfo PRI){
	local int N;
	N = PRI.PlayerID - 1;
	if(LRIArray[N] != None) return LRIArray[N];
	LRIArray[N] = class'MyInfo'.static.Get(PRI);
	return LRIArray[N];
}

// Injured - тварь ранили, Attacker - тварь попала
function int NetDamage(int Original, int Damage, Pawn Injured, Pawn Attacker, vector HitLocation, out vector Momentum, class<DamageType> DamageType){
	local MyInfo L1;
	if(NextGameRules != None) Damage = NextGameRules.NetDamage(Original, Damage, Injured, Attacker, HitLocation, Momentum, DamageType);
	if(Attacker != None && Injured.PlayerReplicationInfo != None){
		//Debug("NetDamage.Attacker.PlayerReplicationInfo" @ Attacker @ Attacker.PlayerReplicationInfo);
		L1 = GetLRI(Attacker.PlayerReplicationInfo);
		if(L1.bMyHitsounds && Damage != 0 && Level.TimeSeconds != L1.HitsoundTime){
		 	L1.ClientPlayHitsound(Damage, Injured.PlayerReplicationInfo);
			L1.HitsoundTime = Level.TimeSeconds;
		}
		if(L1.Stats != None) L1.Stats.UpdateGivenDamage(DamageType, Damage);
	}
	return Damage;
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason){
	if(Main.WarmUp != None) return False;
	if(!bOvertimeTimerFixed && Level.Game.bOverTime){
		BroadcastLocalizedMessage(class'OvertimeTimerMessage');
		bOvertimeTimerFixed = True;
	}
	return Super.CheckEndGame(Winner, Reason);
}

function bool PreventDeath(Pawn Killed, Controller Killer, class<DamageType> DamageType, vector HitLocation){
	local bool bLive;
	local MyInfo LRI;
	bLive = Super.PreventDeath(Killed, Killer, DamageType, HitLocation);
	if(Main.bServerStats && Killed.Health <= 0){
		//Debug("PreventDeath" @ Killed @ Killed.PlayerReplicationInfo);
		LRI = GetLRI(Killed.PlayerReplicationInfo);
		if(LRI.Stats != None) LRI.Stats.CalculateAmmo(True); // stats
	}
	return bLive;
}

function ModifyPlayer(Pawn P){ // stats
	local MyInfo LRI;
	//Debug("ModifyPlayer" @ P @ P.PlayerReplicationInfo);
	LRI = GetLRI(P.PlayerReplicationInfo);
	if(LRI.Stats != None) LRI.Stats.CalculateAmmo(False); // pawn spawned
}

function bool OverridePickupQuery(Pawn P, Pickup Item, out byte bAllowPickup){
	local MyInfo LRI;
	//Debug("OverridePickupQuery" @ P @ P.PlayerReplicationInfo);
	LRI = GetLRI(P.PlayerReplicationInfo);

	if(LRI.Stats != None) LRI.Stats.Pickup(Item);

	if(Item.IsA('WeaponPickup')) LRI.SetLastPickupItem(Item.GetHumanReadableName(), 1);
	else if(Item.IsA('ShieldPickup')) LRI.SetLastPickupItem(ShieldPickup(Item).ShieldAmount @ "Shield", 2);
	else if(LRI.IsA('UDamagePack')) LRI.SetLastPickupItem("DOUBLE DAMAGE", 2);
	else if(LRI.IsA('SuperHealthPack')) LRI.SetLastPickupItem("Super Health", 2);

	return Super.OverridePickupQuery(P, Item, bAllowPickup);
}

function ScoreKill(Controller Killer, Controller Killed){
	if(Main.WarmUp != None && Killer != None && Killer.PlayerReplicationInfo != None){
		Killer.PlayerReplicationInfo.Score = 0;
		if(Killer.PlayerReplicationInfo.Team != None) Killer.PlayerReplicationInfo.Team.Score = 0;
	}
	Super.ScoreKill(Killer, Killed);
}

simulated function Debug(coerce string S){
	class'zUtil'.static.Debug(S, Self);
}

defaultproperties{}
