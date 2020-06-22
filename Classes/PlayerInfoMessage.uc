class PlayerInfoMessage extends PlayerNameMessage;

static function float GetLifeTime(int N){
	return 1.4;
}

static function string GetString(optional int N, optional PlayerReplicationInfo R, optional PlayerReplicationInfo R2, optional Object O){
	local xPawn P;
	local string W;
	
	P = xPawn(O);
	if(P == None || P.PlayerReplicationInfo == None) return W;
	W = GetItemName(string(P.WeaponAttachment));
	W -= "Attachment";
	W -= "ONS";
	
	return P.GetHumanReadableName() @ "Health:" @ P.Health @ "Shield:" @ int(P.ShieldStrength) @"/"@ int(P.SmallShieldStrength) @ "Weapon:" @ "["$ W $"]";
}

defaultproperties{
	bIsConsoleMessage=False
	FontSize=-1
}
