class zObject extends Object within PlayerController abstract;

var float NextUpdateTime;
var Range UpdateTime;

event Created(){
	if(UpdateTime.Min == 0) UpdateTime.Min = FRand();
	if(UpdateTime.Max == 0) UpdateTime.Max = UpdateTime.Min + FRand();
	SetUpdateTime();
}

function MyTick(){
	SetUpdateTime();
}

function SetUpdateTime(){
	NextUpdateTime = Outer.Level.TimeSeconds + RandRange(UpdateTime.Min, UpdateTime.Max);
}

final function ChangeUpdateTime(float Min, float Max){
	UpdateTime.Min = Min;
	UpdateTime.Max = Max;
}

final function bool NeedUpdate(){
	return (Outer.Level.TimeSeconds > NextUpdateTime);
}

final function DisableUpdate(){
	NextUpdateTime = MaxInt;
}

final simulated function Debug(coerce string S){
	class'zUtil'.static.Debug(S, Outer);
}

defaultproperties{}
