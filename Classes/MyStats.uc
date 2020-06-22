class MyStats extends Info;
//var Controller Controller;
//var WeaponStat WeaponStat;
struct MyDamage{
	var class<DamageType> DamageType;
	var class<Weapon> Weapon;
	/*var class<Vehicle> Vehicle;*/
	var int Damage;
	var int Hits;
};
struct MyWeapon{
	var class<Weapon> Weapon;
	var int Fired; // fired = taken - current (после смерти taken = 0)
	var int Previous; // previous (Initial) (start)
};
var int LastDamageId;
var array<MyWeapon> MyWeapons; // fired ammo
var array<MyDamage> GivenDamage;
var array<MyDamage> ReceivedDamage;


function Reset(){
	Super.Reset();
	LastDamageId = 0;
	GivenDamage.Length = 0;
	ReceivedDamage.Length = 0;
	MyWeapons.Length = 0;
}

event Pickup(Pickup Pickup){
	if(UTAmmoPickup(Pickup) != None || WeaponPickup(Pickup) != None){
		CalculateAmmo(True); // pre-pickup (ammo not yet added in ammunition)
		Enable('Tick');
	}
}

function MutateWeaponStats(){
	local int i, Hits;
	local string S;
	CalculateAmmo(True);
	for(i = 0; i < MyWeapons.Length; i++){
		//if(LinkedReplicationInfo.MyWeapons[i].Fired == 0) continue;
		Hits = GetHits(MyWeapons[i].Weapon);
		S = "^3" $ MyWeapons[i].Weapon.static.StaticItemName() $ ":";
		S @= "^8Fired:^5" @ MyWeapons[i].Fired;
		S @= "^8Hits:^5" @ Hits;
		S @= "^8Accuracy:^3" @ GetAcc(Hits, MyWeapons[i].Fired);
		class'zUtil'.static.ConsoleMessage(PlayerController(Owner), S, True);
	}
}

// 0 - spawn, 1 - death, 2 - save (pre-pickup), 3 - post-pickup
function CalculateAmmo(bool bDeathPrePickup){
	
	local Inventory Inv;
	local Weapon W;
	local int Id, AmmoAmount;
	
	//Debug("CalculateAmmo" @ "bDeathPrePickup" @ bDeathPrePickup @ "Pawn" @ Controller(Owner).Pawn);
	if(Controller(Owner).Pawn == None) return;
	for(Inv = Controller(Owner).Pawn.Inventory; Inv != None; Inv = Inv.Inventory){
		W = Weapon(Inv);
		if(W == None) continue;
		Id = GetMyWeaponId(W.Class);
		AmmoAmount = W.AmmoAmount(0);
		if(bDeathPrePickup && MyWeapons[Id].Previous != AmmoAmount){
			MyWeapons[Id].Fired += MyWeapons[Id].Previous - AmmoAmount;
			//for(i = 0; i < 2; i++) if(W.FireModeClass[i].default.bFireOnRelease) MyWeapons[Id].Fired += int(W.GetFireMode(i).Load);
			//if(W.FireModeClass[0].default.bFireOnRelease) MyWeapons[Id].Fired += int(W.FireMode[0].Load);
		}
		MyWeapons[Id].Previous = AmmoAmount;
		//if(PlayerController(Owner) != None)
		//	Debug(MyWeapons[Id].Weapon.static.StaticItemName()  @ "Fired:^5" @ MyWeapons[Id].Fired);
	}
}

function string GetAcc(coerce float Hits, coerce float Fired){
	if(Hits != 0) return Left(Hits * 100.0 / Fired, 4) $ "%";
	return "0.0%";
}

function int GetHits(class<Weapon> W){
	local int i;
	for(i = 0; i < GivenDamage.Length; i++){
		if(GivenDamage[i].Weapon == W) return GivenDamage[i].Hits;
	}
	return 0;
}

function int GetMyWeaponId(class<Weapon> W){
	local int i;
	local MyWeapon MW;
	for(i = 0; i < MyWeapons.Length; i++) if(MyWeapons[i].Weapon == W) return i;
	//Debug("GetMyWeaponId i=" @ i, True);
	MW.Weapon = W;
	MyWeapons[MyWeapons.Length] = MW;
	return i;
}

function UpdateGivenDamage(class<DamageType> DamageType, int Damage){ // Attacker != None already
	if(GivenDamage[LastDamageId].DamageType != DamageType) LastDamageId = GetDamageId(GivenDamage, DamageType);
	GivenDamage[LastDamageId].Damage += Damage;
	GivenDamage[LastDamageId].Hits += 1;
	//if(PlayerController(Owner) != None) Debug(GivenDamage[LastDamageId].Weapon @ GivenDamage[LastDamageId].Hits);
}

function int GetDamageId(out array<MyDamage> A, class<DamageType> DamageType){
	local int i;
	local MyDamage MD;
	for(i = 0; i < A.Length; i++) if(DamageType == A[i].DamageType) return i;
	//Debug("GetDamageId i=" @ i, True);
	MD.DamageType = DamageType;
	if(class<WeaponDamageType>(DamageType) != None) MD.Weapon = class<WeaponDamageType>(DamageType).default.WeaponClass;
	A[A.Length] = MD;
	return i;
}

event Tick(float F){
	CalculateAmmo(False); // post-pickup
	Disable('Tick');	
}

simulated function Debug(coerce string S, bool bForHuman){
	if(bForHuman && PlayerController(Owner) == None) return;
	class'zUtil'.static.Debug(S, Self);
}

defaultproperties{}
