class HitSoundMessage extends LocalMessage;

const My = class'zMain';
var(HitSounds) sound HitSounds[8];
var(HitSounds) sound SimpleHits[3];

#EXEC AUDIO IMPORT GROUP=HitSounds FILE="HitSounds\Low.wav" NAME=Low
#EXEC AUDIO IMPORT GROUP=HitSounds FILE="HitSounds\Normal.wav" NAME=Normal
#EXEC AUDIO IMPORT GROUP=HitSounds FILE="HitSounds\High.wav" NAME=High
#EXEC AUDIO IMPORT GROUP=HitSounds FILE="HitSounds\Highest.wav" NAME=Highest
#EXEC AUDIO IMPORT GROUP=HitSounds FILE="HitSounds\FriendlyLow.wav" NAME=FriendlyLow
#EXEC AUDIO IMPORT GROUP=HitSounds FILE="HitSounds\FriendlyNormal.wav" NAME=FriendlyNormal
#EXEC AUDIO IMPORT GROUP=HitSounds FILE="HitSounds\FriendlyHigh.wav" NAME=FriendlyHigh
#EXEC AUDIO IMPORT GROUP=HitSounds FILE="HitSounds\FriendlyHighest.wav" NAME=FriendlyHighest
#EXEC AUDIO IMPORT GROUP=HitSounds FILE="HitSounds\Hit1.wav" NAME=Hit1

static function ClientReceive(PlayerController P, optional int Damage, optional PlayerReplicationInfo TargePRI, optional PlayerReplicationInfo R2, optional Object O){
	
	local int iHit;
	local float Volume;
	local sound MyHitSound;
	local bool bFriendly;
	
	if(TargePRI == P.PlayerReplicationInfo) return; // повредил самого себя
	bFriendly = P.GameReplicationInfo.bTeamGame && P.PlayerReplicationInfo.Team == TargePRI.Team;
	Volume = My.default.FeedbackVolume;
	// 0 - disabled, 1 - simple, 2 - CPMA style, 3 - with attenuation.
	if(My.default.FeedbackType == 1){
		// simple hit sound: 0 - hit1, 1 - like lowest CPMA, 2 - like normal CPMA
		if(bFriendly) MyHitSound = default.HitSounds[4];
		else MyHitSound = default.SimpleHits[My.default.iSimpleHitType];
	}else if(My.default.FeedbackType == 2){
		if(Damage <= 20) iHit = 0;
		else if(Damage <= 45) iHit = 1;
		else if(Damage <= 70) iHit = 2;
		else iHit = 3;
		if(bFriendly) iHit += 4;
		MyHitSound = default.HitSounds[iHit];
	}else if(My.default.FeedbackType == 3){
		Volume = Damage / My.default.FeedbackLine;
		if(bFriendly) MyHitSound = default.HitSounds[4];
		else MyHitSound = default.SimpleHits[My.default.iSimpleHitType];
	}
	// play hit sound =)
	//if(P.ViewTarget != None) P.PlaySound(MyHitSound,, FClamp(Volume, 0, 2),,,, False); // True
	if(P.ViewTarget != None) P.ViewTarget.PlaySound(MyHitSound,, FClamp(Volume, 0, 2),,,, False); // True
}

static function bool IsConsoleMessage(int N){
	return False;
}

defaultproperties{
	Lifetime=0
	bIsConsoleMessage=False
	HitSounds(0)=sound'Low'
	HitSounds(1)=sound'Normal'
	HitSounds(2)=sound'High'
	HitSounds(3)=sound'Highest'
	HitSounds(4)=sound'FriendlyLow'
	HitSounds(5)=sound'FriendlyNormal'
	HitSounds(6)=sound'FriendlyHigh'
	HitSounds(7)=sound'FriendlyHighest'
	SimpleHits(0)=sound'Hit1'
	SimpleHits(1)=sound'Low'
	SimpleHits(2)=sound'Normal'
}
