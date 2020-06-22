class FinalCountDown extends LocalMessage;

var name CountDownName[11];

static function string GetString(optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2, optional Object O){
	if(N == -3) return "Warm-up time is up! Match starting...";
	if(N == -2) return "COUNTDOWN STOPPED!";
	if(N == -1) return "All players are ready! Match starting...";
	if(N == 0) return "The match has begun!";
	if(N == 5) return "5 and counting...";
	return string(N) $ "...";
}
static function color GetColor(optional int N, optional PlayerReplicationInfo R, optional PlayerReplicationInfo R2){
	if(N == -2) return class'HUD'.default.RedColor;
	if(N == -1) return class'HUD'.default.GoldColor;
	if(N == -3) return class'zLocalMessage'.static.MakeColor(1, 250, 1); // green
	return Super.GetColor(N, R, R2);
}

static function ClientReceive(PlayerController P, optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2, optional Object O){
	if(N >= 0) P.QueueAnnouncement(default.CountDownName[N], 1, AP_InstantOrQueueSwitch, 1);
	else P.PlayBeepSound();
	Super.ClientReceive(P, N, R1, R2, O);
}
	
defaultproperties{
	PosY=0.202
	StackMode=SM_Down
	bIsConsoleMessage=False
	Lifetime=1
	bIsUnique=True
	DrawColor=(G=160,R=0)
	FontSize=1
	bFadeMessage=True
	CountDownName(0)="play"
	CountDownName(1)="one"
	CountDownName(2)="two"
	CountDownName(3)="three"
	CountDownName(4)="four"
	CountDownName(5)="five"
	CountDownName(6)="six"
	CountDownName(7)="seven"
	CountDownName(8)="eight"
	CountDownName(9)="nine"
	CountDownName(10)="ten"
}
