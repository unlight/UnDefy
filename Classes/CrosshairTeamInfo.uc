class CrosshairTeamInfo extends zObject;

function MyTick(){
	Super.MyTick();
	if(class'zMain'.default.bCrosshairTeamInfo) DrawCrosshairTeamInfo();
}

function DrawCrosshairTeamInfo(){
	
	local xPawn Pawn, MyPawn;
	local vector HitLocation, HitNormal, TraceStart;

	MyPawn = xPawn(Outer.ViewTarget);
	if(MyPawn == None || MyPawn.PlayerReplicationInfo == None || MyPawn.PlayerReplicationInfo.Team == None || Outer.bBehindView) return;
	TraceStart = MyPawn.Location + MyPawn.BaseEyeHeight * vect(0,0,1);
	
	Pawn = xPawn( Outer.Trace(HitLocation, HitNormal, TraceStart + 2800 * vector(Outer.Rotation), TraceStart, True) );
	if(Pawn == None || Pawn.PlayerReplicationInfo == None || Pawn.PlayerReplicationInfo.Team == None || Pawn.PlayerReplicationInfo.Team != MyPawn.PlayerReplicationInfo.Team) return;
	Outer.ReceiveLocalizedMessage(class'PlayerInfoMessage',,,, Pawn);
}

defaultproperties{
	UpdateTime=(Min=0.25,Max=0.3)
}
