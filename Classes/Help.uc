class Help extends Object;

static function string GetMyName(){
	return class'zMain'.default.FriendlyName;
}

static final function WelcomeMessage(PlayerController P){
	class'zUtil'.static.ConsoleMessage(P,
		"^3Welcome to ^5" $GetMyName()$ "^3! ^9Type ^2help ^9in console (Also see Esc -> UnDefy 2004)", True);
}

static final function string CurrentValue(string S, optional PlayerController P){
	local string C;
	if(P != None){
		C = P.ConsoleCommand("get" @ class'zUtil'.static.GetPackageName(default.Class, True) $ "zMain" @ S);
		if(Len(C) >= 21 || Left(C, 21) ~= "Unrecognized property") return "";
		C = "Current Value: ^3" $ C;
		//if(float(C))
	}
	return C;
}

static final function string GetHelp(string S, optional PlayerController P){
	local array<string> A;
	Get(S, A, P);
	A.Remove(0, 1);
	return class'zUtil'.static.Implode(" ", A);
}

static final function Get(string S, out array<string> A, optional PlayerController P){
	local string V;
	local zUtil F;
	A[A.Length] = "Help for command:^3" @ S;
	F = new class'zUtil';
				
	switch(F.Trim(Locs(S))){
		case "nododgingdelay":
			A[A.Length] = "No delay between dodges. (1 - On, 0 - Off).";
			A[A.Length] = "^3Current Value:" @ F.Switcher(class'zMain'.default.bNoDodgingDelay);
			break;
		case "overlaylocationbetween":
			A[A.Length] = "Additional location information in teamoverlay (1 - On, 0 - Off).";
			A[A.Length] = "^3Current Value:" @ F.Switcher(class'zMain'.default.bOverlayLocationBetween);
			break;
		case "ownfootsteps":
			A[A.Length] = "Play own footstep sounds (0 - No, 1 - Yes).";
			if(P != None && class<UnrealPawn>(P.PawnClass) != None) A[A.Length] = "Current Value:^3" @ class<UnrealPawn>(P.PawnClass).default.bPlayOwnFootsteps;
			break;
		case "weaponstats":
			break;
		case "vote":
			A[A.Length] = "Cast your vote. Ex. 'vote yes' or 'vote no'";
			break;
		case "rules":
			A[A.Length] = "Shows server settings.";
			break;
		case "cc":
			A[A.Length] = "Enable/disable autocompletion of some console commands.";
			break;
		case "callvote":
			break;
		case "togglebrightskins":
			A[A.Length] = "";
			break;
		case "crosshairteaminfo":
			A[A.Length] = "Display teammate names and some info (health, shield) when pointing at them (0 - No, 1 - Yes).";
			break;
		case "enemybones":
			A[A.Length] = "Sets enemy bones scale ('BrightSkins' must be set to True, see help for command 'BrightSkins').";
			A[A.Length] = "Usage: EnemyBones <A/B/C>";
			break;
		case "updateskins":
			A[A.Length] = "Force update skins ('BrightSkins' must be set to True, see help for command 'BrightSkins').";
			break;
		case "teamskin":
			A[A.Length] = "Sets team skin ('BrightSkins' must be set to True, see help for command 'BrightSkins').";
			A[A.Length] = "Usage: TeamSkin <skin/color/glow>";
			break;
		case "enemyskin":
			A[A.Length] = "Sets enemy skin ('BrightSkins' must be set to True, see help for command 'BrightSkins').";
			A[A.Length] = "Usage: EnemySkin <skin/color/glow>";
			break;
		case "brightskins":
			A[A.Length] = "Enable/disable force models and Epic bright skins (0 - Disable, 1 - Enable).";
			A[A.Length] = "If enabled than allowed commands: ^9EnemySkin, TeamSkin, UpdateSkins, EnemyBones.";
			break;
		case "notready":
			A[A.Length] = "You are not ready to play (in warmup).";
			break;
		case "ready":
			A[A.Length] = "You are ready to play (in warmup).";
			break;
		case "teamoverlay":
			A[A.Length] = "Enable/disable team overlay (0 - Disable, 1 - Enable).";
			break;
		case "overlaymetric":
			A[A.Length] = "Shows distance in team overlay in different values (0 - meters, 1 - feets, 2 - yards).";
			break;
		case "overlaytitles":
			break;
		case "overlaysize":
			A[A.Length] = "Sets team overlay's size (0 - Disabled).";
			break;
		case "overlaybackground":
			A[A.Length] = "Sets team overlay background color.";
			A[A.Length] = "Usage: OverlayBackground <R> <G> <B> <A> (passed values are 1..255, <A> - opacity (255 = 100%)";
			break;
		case "overlayshowself":
			A[A.Length] = "Show self in team overlay.";
			break;
		case "overlaypos":
			A[A.Length] = "Usage: overlaypos <X> <Y> - sets overlay's position. Where:";
			A[A.Length] = "<X> - X coordinate of the overlay (horizontal)";
			A[A.Length] = "<Y> - Y coordinate of the overlay (vertical)";
			break;
		case "feedbackline":
			A[A.Length] = "'FeedbackType' must be set to 3 (if FeedbackLine = 70 and Damage = 70 sound will be the loudest (100%)";
			break;
		case "simplehittype":
			A[A.Length] = "Sets type of simple hitsound (0 - Hit #1, 1 - Like lowest CPMA, 2 - Like normal CPMA, 'FeedbackType' must be set to 1).";
			break;
		case "feedbacktype":
			A[A.Length] = "Hitsounds type (0 - Disabled, 1 - Simple, 2 - CPMA Style, 3 - With attenuation).";
			break;
		case "feedbackvolume":
			A[A.Length] = "Volume of hitsound (0..2).";
			break;
		case "save":
			A[A.Length] = "Saves your client settings.";
			break;
		case "drawdamageindicators":
			A[A.Length] = "Draw damage indicators (0 - No, 1 - Yes).";
			break;
		case "enemycam":
			A[A.Length] = "Enemy's camera. Works only for spectators. Warning! This is a MAJOR hit to the framerate!";
			A[A.Length] = "Usage: EnemyCam [0..99] (0 - Disabled, 99 - Maximum size 1/4 of screen).";
			break;
		case "timeout":
			A[A.Length] = "To call timeout. In team deathmatch only team captains can call timeout.";
			break;
		case "timein":
			A[A.Length] = "To call timein.";
			break;
		case "mytime":
			break;
		case "showtime":
		case "currenttime":
			A[A.Length] = "Shows current server time.";
			break;
		case "classicsnipersmoke":
			A[A.Length] = "Set classic sniper rifle's smoke effect.";
			A[A.Length] = "Usage: ClassicSniperSmoke <0|1> (0 - Disabled, 1 - Enabled).";
			break;
		case "weaponviewshake":
			A[A.Length] = "Set view shaking for some weapons while firing.";
			A[A.Length] = "Usage: WeaponViewShake <0|1> (0 - Disabled, 1 - Enabled).";
			break;
		case "pickupconsolemessages":
			A[A.Length] = "Pickup messages in console.";
			A[A.Length] = "Usage: PickupConsoleMessages <0|1> (0 - Disabled, 1 - Enabled).";
			break;
		case "about":
			A.Length = 0;
			A[A.Length] = "^3About us:";
			A[A.Length] = "^9Web: unreal64.ru / community.livejournal.com/unreal64/";
			A[A.Length] = "^8Mod homepage: unreal64.planetunreal.gamespy.com";
			A[A.Length] = "^9IRC: irc.dalnet.ru #unreal64";
			break;
		case "shortdeathmessages":	break;
		case "players":	break;
		case "invite":	break;
		case "resign": break;
			A[A.Length] = "Resigns team captainship.";
			A[A.Length] = "Usage: Resign [PlayerID], PlayerID - optionally, your teammate's ID";
			break;
		default:
			A.Length = 0;
			A[A.Length] = "^3" $ GetMyName() @ "Help";
			A[A.Length] = "^0Available commands: (For more information, type: ^3Help <command>^0)";
			A[A.Length] = "^0Game:^9 Save, EnemyCam, TimeOut, TimeIn, ShowTime (or CurrentTime), Ready, NotReady";
			A[A.Length] = "^9ClassicSniperSmoke, WeaponViewShake, PickupConsoleMessages, DrawDamageIndicators";
			A[A.Length] = "^0HitSounds Group:^9 FeedbackLine, SimpleHitType, FeedbackType FeedbackVolume";
			A[A.Length] = "^0TeamOverlay Group:^9 TeamOverlay, OverlayShowSelf, OverlayPos, OverlayTitles";
			A[A.Length] = "^9OverlayMetric, OverlaySize, OverlayBackground, OverlayLocationBetween";
			A[A.Length] = "^0Other:^9 BrightSkins, ToggleBrightSkins, EnemySkin, TeamSkin, UpdateSkins, EnemyBones";
			A[A.Length] = "^9CallVote CC Rules WeaponStats";
	}
	//Localize("Errors","Exec","Core") // OverlayBackgroundColor
	V = CurrentValue(S, P);
	if(V != "") A[A.Length] = V;
}

// auto completition console commands list
static final function array<string> ConsoleCommands(){
	
	local string S;
	local array<string> Commands;
	
	S $= "Vote CallVote ToggleBrightSkins CrosshairTeamInfo TeamReady Ready NotReady";
	S @= "BrightSkins OverlayPos OverlayTitles OverlayMetric OverlaySize TeamOverlay OverlayBackground OverlayShowSelf";
	S @= "FeedbackLine SimpleHitType FeedbackVolume FeedbackType EnemyCam UpdateSkins";
	S @= "Help DrawDamageIndicators ClassicSniperSmoke WeaponViewShake PickupConsoleMessages";
	S @= "TimeOut TimeIn ShowTime CurrentTime MyTime Save";
	S @= "TeamSkin EnemySkin EnemyBones CC Rules WeaponStats OwnFootsteps Players ShortDeathMessages";
	S @= "Invite Resign";
	// other
	S @= "Say TeamSay TeamChatOnly SetSpectateSpeed SetSensitivity SetMouseSmoothing SetMouseAccel SetAutoTaunt Mutate";
	S @= "SetWeaponHand Suicide SetName SetVoice SwitchTeam ChangeTeam SwitchTeam SetProgressMessage SetProgressTime BehindView";
	S @= "ToggleBehindView InvertMouse AdminLogin AdminLogout SetChatPassword EnableVoiceChat DisableVoiceChat";
	S @= "SetSmoothingStrength AdminSay DemoRec OverlayLocationBetween NoDodgingDelay";
	Split(S, " ", Commands);
	class'zUtil'.static.SortString(Commands);
	return Commands;
}


static final function Rules(zMain M, PlayerController P){
	
	local array<string> A;
	local int N;
	local zUtil F;
	
	F = new class'zUtil';
	A[A.Length] = "^5UNDEFY SERVER SETTINGS:";
	A[A.Length] = "^8Hitsounds:" @ F.Switcher(M.bAllowHitSounds);
	A[A.Length] = "^8Brightskins:" @ F.Switcher(M.bAllowBrightSkins);
	A[A.Length] = "^8Allow Team Overlay:" @ F.Switcher(M.bAllowTeamOverlay);
	A[A.Length] = "^8WarmUp:^3" @ Eval(M.WarmUpSeconds == -1, "^1Disabled", Eval(M.WarmUpSeconds == 0, "^2Unlimited", M.WarmUpSeconds @ "seconds"));
	A[A.Length] = "^8Force Respawn Time:^3" @ M.ForceRespawnTime @ "seconds";
	A[A.Length] = "^8Timeouts:^3" @ Eval(M.Timeouts == 0, "^1Disabled", M.Timeouts @ "("$ M.TimeoutLength @ "seconds)");
	A[A.Length] = "^8Voting:" @ F.Switcher(M.VotingTime);
	if(M.VotingTime != 0) A[A.Length-1] @= "^3(" $M.VotingTime$ " seconds, " $M.VotingPassPercent$ "%)";
	A[A.Length] = "^8Interaction Shield:" @ F.Switcher(M.bInteractionShield);
	A[A.Length] = "^8Statistics:^3" @ F.Switcher(M.bServerStats);
	A[A.Length] = "^8Alt. Weapon Settings:^3" @ F.Switcher(M.bAltWeaponSettings);
	A[A.Length] = "^8Dodging Delay:^3" @ F.Switcher(!M.bServerNoDodgingDelay);
	A[A.Length] = "^8Fast Weapon Switching:^3" @ F.Switcher(M.bFastWeaponSwitching);
	
	for(N = 0; N < A.Length; N++) F.ConsoleMessage(P, A[N], True);	
}

defaultproperties{}
