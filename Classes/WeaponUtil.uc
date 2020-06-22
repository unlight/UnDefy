class WeaponUtil extends Object;

static function string GetDamageType(class<DamageType> D){
	local string S;
	switch(D){
	case class'DamTypeShieldImpact': S = "Shield Gun"; break;
	case class'DamTypeAssaultBullet': S = "Primary Assault Rifle"; break;
	case class'DamTypeAssaultGrenade': S = "Secondary Assault Rifle"; break;
	case class'DamTypeBioGlob': S = "Secondary Bio Rifle"; break;
	case class'DamTypeClassicHeadshot': S = "Sniper Rifle (Headshot)"; break;
	case class'DamTypeClassicSniper': S = "Sniper Rifle (Body)"; break;
	case class'DamTypeFlakChunk': S = "Primary Flak Cannon"; break;
	case class'DamTypeFlakShell': S = "Secondary Flak Cannon"; break;
	case class'DamTypeLinkPlasma': S = "Primary Link Gun"; break;
	case class'DamTypeLinkShaft': S = "Secondary Link Gun"; break;
	case class'DamTypeSniperHeadShot': S = "Lightning Gun (Headshot)"; break;
	case class'DamTypeSniperShot': S = "Lightning Gun"; break;
	case class'DamTypeShockCombo': S = "Shock Combo"; break;
	case class'DamTypeShockBeam': S = "Primary Shock Rifle"; break;
	case class'DamTypeShockBall': S = "Secondary Shock Rifle"; break;
	case class'DamTypeMinigunBullet': S = "Primary Minigun"; break;
	case class'DamTypeMinigunAlt': S = "Secondary Minigun"; break;
	case class'DamTypeRocketHoming': S = "Homing Rocket"; break;
	case class'DamTypeTeleFrag': S = "Telefrag"; break;
	case class'DamTypeRocket': S = "Rocket Launcher"; break;
	case class'DamTypeRedeemer': S = "Redeemer"; break;
	default:
		if(class<WeaponDamageType>(D) != None) S = class<WeaponDamageType>(D).default.WeaponClass.static.StaticItemName();
		else S = GetItemName(string(D));
		if(class'zUtil'.static.PregMatch(S, "DamType")) S = Repl(S, "DamType", "");
	}
	return S;
}

static function SetDeathString(class<WeaponDamageType> D, string Weapon){
	local string Death, Suicide;
	local color HudColor;
	
	Death = "^0%k %C[" $Weapon$ "] ^0%o";

	HudColor = D.default.WeaponClass.default.HudColor;
	HudColor.R = Clamp(HudColor.R, 1, 250);
	HudColor.G = Clamp(HudColor.G, 1, 250);
	HudColor.B = Clamp(HudColor.B, 1, 250);
	
	Death = Repl(Death, "%C", class'zUtil'.static.GetColorString(HudColor.R, HudColor.G, HudColor.B));
	D.default.DeathString = class'zUtil'.static.Paint(Death);
	
	Suicide = Repl(Repl(Death, " ^0%o", ""), "%k", "%o");
	D.default.FemaleSuicide = class'zUtil'.static.Paint(Suicide);
	D.default.MaleSuicide = D.default.FemaleSuicide;
	//class'zUtil'.static.StripColorCodes()
}

static function SetShortDeathMessages(){
	SetDeathString(class'DamTypeShieldImpact', "Shield");
	SetDeathString(class'DamTypeAssaultBullet', "Bullet");
	SetDeathString(class'DamTypeAssaultGrenade', "Grenade");
	SetDeathString(class'DamTypeBioGlob', "Bio");
	SetDeathString(class'DamTypeClassicHeadshot', "Sniper");
	SetDeathString(class'DamTypeClassicSniper', "Sniper");
	SetDeathString(class'DamTypeFlakChunk', "Flak");
	SetDeathString(class'DamTypeFlakShell', "Flak");
	SetDeathString(class'DamTypeLinkPlasma', "Link");
	SetDeathString(class'DamTypeLinkShaft', "Link");
	SetDeathString(class'DamTypeSniperHeadShot', "Lightning");
	SetDeathString(class'DamTypeSniperShot', "Lightning");
	SetDeathString(class'DamTypeShockCombo', "Sphere");
	SetDeathString(class'DamTypeShockBeam', "Shock");
	SetDeathString(class'DamTypeShockBall', "Shock");
	SetDeathString(class'DamTypeMinigunBullet', "Minigun");
	SetDeathString(class'DamTypeMinigunAlt', "Minigun");
	SetDeathString(class'DamTypeRocketHoming', "Rocket");
	SetDeathString(class'DamTypeTeleFrag', "Telefrag");
	SetDeathString(class'DamTypeRocket', "Rocket");
	SetDeathString(class'DamTypeRedeemer', "Redeemer");
}

static function SetMuzzleFlash(bool B){
	local array< class<Actor> > A;
	local int i;
	A[A.Length] = class'MinigunMuzzleSmoke';
	A[A.Length] = class'MinigunAltMuzzleSmoke';
	A[A.Length] = class'AssaultMuzFlash1st';
	A[A.Length] = class'BioMuzFlash1st';
	A[A.Length] = class'ShockBeamMuzFlash';
	A[A.Length] = class'ShockMuzFlashB';
	A[A.Length] = class'ShockMuzFlash';
	A[A.Length] = class'ShockMuzFlashB';
	A[A.Length] = class'ShockProjMuzFlash';
	A[A.Length] = class'LinkMuzFlashProj1st';
	A[A.Length] = class'LinkMuzFlashBeam1st';
	A[A.Length] = class'LinkMuzFlashProj1st';
	A[A.Length] = class'MinigunMuzFlash1st';
	A[A.Length] = class'FlakMuzFlash1st';
	A[A.Length] = class'RocketMuzFlash1st';
	A[A.Length] = class'ForceRingA';
	A[A.Length] = class'ONSPRVSideGunMuzzleFlash';
	A[A.Length] = class'ONSPRVRearGunCharge';
	A[A.Length] = class'ONSPRVSideGunMuzzleFlash';
	A[A.Length] = class'ONSRVWebLauncherMuzzleFlash';
	
	A[A.Length] = class'MinigunAltMuzzleSmoke';
	A[A.Length] = class'MinigunMuzzleSmoke';
	
	for(i = 0; i < A.Length; i++) A[i].default.bHidden = !B;
}

defaultproperties{}
