class NewTeamHudSpectatorOverlay extends NewTeamHudOverlay;

/*function UpdateTeamInfo(){
	
	local byte i, TeamNum;
	local MyInfo LRI;
	
	FlagIndex = 255;
	UDamageIndex = 255;
	TeamSize = 1;
	TeamNum = Pawn(Me.ViewTarget).GetTeamNum();

	if(MyClass.default.bMeInOverlay){
		UpdateTeamMateInfo(TeamSize, Pawn(Me.ViewTarget));
		TeamSize++;
	}
	for(i = 0; i < Level.GRI.PRIArray.Length; i++){
		LRI = class'MyInfo'.static.Get(Level.GRI.PRIArray[i]);
		//if(bDemoOwner) Debug("DEMO" @ Me.bDemoOwner @ "LRI.GetTeamNum()" @ LRI.GetTeamNum() @ "LRI.MyPawn" @ LRI.MyPawn);
		if(LRI != None && LRI.GetTeamNum() == TeamNum && Me.PlayerReplicationInfo != Level.GRI.PRIArray[i]){
			UpdateTeamMateInfo(TeamSize, LRI.MyPawn);
			TeamSize++;
		}
	}
}*/

defaultproperties{
}
