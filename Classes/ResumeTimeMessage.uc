class ResumeTimeMessage extends LocalMessage;

var name CountDownName[4];
//#exec OBJ LOAD File=MenuSounds.uax

static function color GetColor(optional int N, optional PlayerReplicationInfo R, optional PlayerReplicationInfo R2) {
	if (N == 0) return class'HUD'.default.RedColor;
}

static function ClientReceive(PlayerController P, optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2, optional Object O) {
	if (P.bDemoOwner) return;
	if (N <= 5) P.PlayBeepSound();
	if (N <= 3) P.PlayStatusAnnouncement(default.CountDownName[N], 1, True);
//	else if (N <= 5) P.ClientPlaySound(sound'MenuSounds.select3');
	Super.ClientReceive(P, N, R1, R2, O);
}

static function string GetString(optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2, optional Object O) {
	local string OutString;
	if (N == 0) OutString = "MATCH HAS RESUMED!";
	else if (N <= 5) OutString = "^2Match resuming in " $ "^0" $ string(N) $ "^2 seconds...";
	else OutString = "^3Match resuming in " $ "^0" $ string(N) $ "^3 seconds...";
	return class'zUtil'.static.Paint(OutString);
}

defaultproperties {
	FontSize=1
	bIsConsoleMessage=False
	Lifetime=1
	bIsUnique=True
	StackMode=SM_None
	bFadeMessage=True
	PosY=0.45
	CountDownName(0)="play"
	CountDownName(1)="one"
	CountDownName(2)="two"
	CountDownName(3)="three"
}
