class TimeOutMessage extends LocalMessage;

#exec OBJ LOAD File=IndoorAmbience.uax

static function ClientReceive(PlayerController P, optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2, optional Object O) {
	if (P.bDemoOwner) return;
	if (N == -2) P.ClientPlaySound(sound'IndoorAmbience.siren1', True, 1);
	Super.ClientReceive(P, N, R1, R2, O);
}

static function string GetString(optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2, optional Object O) {
	if (N == -2) return class'zUtil'.static.Paint("^0" $ R1.PlayerName @ "^8has called timeout!");
	if (N == -1) return class'zUtil'.static.Paint("^0" $ R1.PlayerName @ "^8has called timein!");
}

defaultproperties {
	FontSize=2
	bIsConsoleMessage=True
	Lifetime=1
	bIsUnique=True
	StackMode=SM_None
	bFadeMessage=True
	PosY=0.418
}
