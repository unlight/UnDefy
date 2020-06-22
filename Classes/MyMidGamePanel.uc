class MyMidGamePanel extends MidGamePanel;

var automated GUIScrollTextBox ScrollTextBox;
//var automated GUIMenuOption Options;
//var automated GUIMultiOptionList OptionList;

//function InternalOnChange(GUIComponent Sender){
//	Debug("InternalOnChange" @ Sender);
//}


function InitComponent(GUIController MyController, GUIComponent MyOwner) {
	local array<string> Readme;
	local int i;
	
	Super.InitComponent(MyController, MyOwner);

	Readme[Readme.Length] = "==============================";
	Readme[Readme.Length] = "*** UnDefy UT 2004 Mutator ***";
	Readme[Readme.Length] = "==============================";
	Readme[Readme.Length] = "Version: v10";
	Readme[Readme.Length] = "Date: 1 Aug 2009";
	Readme[Readme.Length] = "Web: sst.planetunreal.ru";
	Readme[Readme.Length] = "IRC: irc.dalnet.ru #unreal64";
	Readme[Readme.Length] = "Feedback, suggestions are welcome...";
	Readme[Readme.Length] = " ";
	Readme[Readme.Length] = "DESCRIPTION";
	Readme[Readme.Length] = "===========";
	Readme[Readme.Length] = "UnDefy is a simple alternative competition mod for Unreal Tournament 2004.";
	Readme[Readme.Length] = "This mutator adds new features (which unfortunately doesn't exists in UTComp and TTM), such as timeout, enemy's cam, alternative location names (in team overlay), various team chat tokens, etc. No GUI ;) UnDefy can by used like addon for UTComp or TTM.";
	Readme[Readme.Length] = "Recommended for gametypes 1v1 and team deathmatch 2v2 (no bots!)";
	Readme[Readme.Length] = "Mod hasn't GUI, use console commands (see below).";
	Readme[Readme.Length] = " ";
	Readme[Readme.Length] = "CLIENT CONSOLE COMMANDS";
	Readme[Readme.Length] = "=======================";
	Readme[Readme.Length] = "NOTE: Dont' forget save your client settings by typing command 'save'";
	Readme[Readme.Length] = "* help - shows help";
	Readme[Readme.Length] = "* ownfootsteps <0|1> - own footstep sounds (0 - No, 1 - Yes)";
	Readme[Readme.Length] = "* showtime (or currenttime) - shows current server time";
	Readme[Readme.Length] = "* mytime - shows current client time";
	Readme[Readme.Length] = "* enemycam - enemy's camera in top/right corner (only for spectators)";
	Readme[Readme.Length] = "* feedbacktype <0|1|2|3> - hitsounds type, 0 - disabled, 1 - simple, 2 - CPMA style, 3 - with attenuation.";
	Readme[Readme.Length] = "* feedbackvolume <0..2> - volume of hitsound";
	Readme[Readme.Length] = "* simplehittype <0|1|2> - set type of simple hitsound ('FeedbackType' must be set to 1), 0 - hit1, 1 - like lowest CPMA, 2 - like normal CPMA";
	Readme[Readme.Length] = "* feedbackline <0..200> - 'FeedbackType' must be set to 3. if FeedbackLine = 70 and Damage == 70 sound will be the loudest (100%) [dont't work]";
	Readme[Readme.Length] = "* overlaypos <X> <Y> - sets overlay's position. where:";
	Readme[Readme.Length] = "<X> - X coordinate of the overlay (horizontal)";
	Readme[Readme.Length] = "<Y> - Y coordinate of the overlay (vertical)";
	Readme[Readme.Length] = "example: setoverlay 10 80 - set overlay in left/top corner";
	Readme[Readme.Length] = "To set overlay in right/top corner you should use: setoverlay 600 80 (depends of screen resolution, experiment with that)";
	Readme[Readme.Length] = "* overlayshowself <0|1> - show self in overlay";
	Readme[Readme.Length] = "* overlaybackground <R> <G> <B> <A> - sets overlay background color, passed values are 1..255, <A> - opacity (255 = 100%)";
	Readme[Readme.Length] = "* overlaysize <0..8> - sets overlay's size (0 - disabled)";
	Readme[Readme.Length] = "* overlaymetric <0|1|2> - show distance in different values, 0 - in meters, 1 - feets, 2 - yards";
	Readme[Readme.Length] = "* teamoverlay <0|1> - enable/disable team overlay";
	Readme[Readme.Length] = "* drawdamageindicators <0|1> - drawing damage indicators";
	Readme[Readme.Length] = "* classicsnipersmoke <0|1> - classic sniper rifle's smoke effect";
	Readme[Readme.Length] = "* weaponviewshake <0|1> - view shaking for some weapons while firing";
	Readme[Readme.Length] = "* pickupconsolemessages <0|1> - pickup messages in console";
	Readme[Readme.Length] = "* ready - (in warmup) you are ready to play";
	Readme[Readme.Length] = "* notready - (in warmup) you are not ready to play";
	Readme[Readme.Length] = "* teamready - (in warmup for teamcaptains) your players of your team are ready";
	Readme[Readme.Length] = "* timeout - calls timeout";
	Readme[Readme.Length] = "* timein - calls timein";
	Readme[Readme.Length] = "* brightskins <0|1> - enable/disable force models & epic bright skins";
	Readme[Readme.Length] = "* enemyskin <skin/color/glow> - sets enemy skin (requres BrightSkins = 1)";
	Readme[Readme.Length] = "* teamskin <skin/color/glow> - sets teammate skin (requres BrightSkins = 1)";
	Readme[Readme.Length] = "where:";
	Readme[Readme.Length] = "skin - skin's name (Gorge, Malcolm, Brock, Gaargod, Axon, Sapphire, Rylisa, Cathode, Ophelia, Enigma)";
	Readme[Readme.Length] = "color - maybe blue, red or none";
	Readme[Readme.Length] = "glow - 0..255";
	Readme[Readme.Length] = "example 1: enemyskin gorge/blue/250";
	Readme[Readme.Length] = "example 2: enemyskin reinha/none/200";
	Readme[Readme.Length] = "* updateskins - force update skins (requres BrightSkins = 1)";
	Readme[Readme.Length] = "* enemybones <A/B/C> - sets enemy bones scale (requres BrightSkins = 1)";
	Readme[Readme.Length] = "where: A - scale (in percents) for left foot, B - for right foot, C - for head (Max 25)";
	Readme[Readme.Length] = "example: enemybones 25/25/10";
	Readme[Readme.Length] = "* crosshairteaminfo <0|1> - display teammate names and some info (health, shield) when pointing at them";
	Readme[Readme.Length] = "* togglebrightskins - enable/disable brightskins";
	Readme[Readme.Length] = "* vote - cast your vote. Ex. 'vote yes' or 'vote no'.";
	Readme[Readme.Length] = "* cc - enable/disable autocompletion of some console commands.";
	Readme[Readme.Length] = "* rules - shows server settings.";
	Readme[Readme.Length] = "* players - shows all PlayerIDs (for kicking)";
	Readme[Readme.Length] = "* shortdeathmessages <0|1> - colored short death messages (to disable it you need restart UT)";
	Readme[Readme.Length] = "* overlaylocationbetween <0|1> - Additional location information in teamoverlay";
	Readme[Readme.Length] = "* nododgingdelay <0|1> - no delay between dodges (requres bServerNoDodgingDelay = True on the server)";
	Readme[Readme.Length] = "* captains - shows players that are team captains";
	Readme[Readme.Length] = " ";
	Readme[Readme.Length] = "VOTING";
	Readme[Readme.Length] = "======";
	Readme[Readme.Length] = "Use console command 'callvote <parameter> <value>'";
	Readme[Readme.Length] = "<parameter>:";
	Readme[Readme.Length] = "map - map (<value> can be part of map name)";
	Readme[Readme.Length] = "mutespecs - mute spectators";
	Readme[Readme.Length] = "weaponstay (or ws) - weapon stay";
	Readme[Readme.Length] = "timelimit (or tl) - Time Limit (0 not allowed)";
	Readme[Readme.Length] = "minplayers - minimum players";
	Readme[Readme.Length] = "maxplayers - maximum players (0 not allowed)";
	Readme[Readme.Length] = "kick <PlayerID> - kick player with ID = <PlayerID>";
	Readme[Readme.Length] = "restart - restart current game";
	Readme[Readme.Length] = "game - new gametype";
	Readme[Readme.Length] = " usage: callvote game <type> <map>";
	Readme[Readme.Length] = " <type> - '1on1' or 'tdm'";
	Readme[Readme.Length] = " <map> - part of full of map name";
	Readme[Readme.Length] = "isp - interaction shiled plus (brutal anticheat)";
	Readme[Readme.Length] = "dd (or doubledamage) - double damage";
	Readme[Readme.Length] = "altws - alternative weapon settings (see below)";
	Readme[Readme.Length] = "dodgedelay <0|1>";
	Readme[Readme.Length] = "nododgedelay <1|0>";
	Readme[Readme.Length] = "fastws <1|0> - fast weapon switching (without boost dodging)";
	Readme[Readme.Length] = " ";
	Readme[Readme.Length] = "TEAM GAME CHAT TOKENS (CASE SENSITIVE)";
	Readme[Readme.Length] = "======================================";
	Readme[Readme.Length] = "%e - The last player to hit you";
	Readme[Readme.Length] = "%u - last picked up powerup (Double Damage, Mega Health, Shield Pack)";
	Readme[Readme.Length] = "%n - last picked up weapon";
	Readme[Readme.Length] = "%i - last picked up item (weapon or powerup)";
	Readme[Readme.Length] = "%c - nearest accessible/inaccessible item (weapon or powerup)";

	// ok
	for(i = 0; i < Readme.Length; i++) ScrollTextBox.AddText(Readme[i]);
	//ScrollTextBox.Restart();
}
simulated function Debug(coerce string S){
	class'zUtil'.static.Debug(S, PlayerOwner());
}

defaultproperties{
	Begin Object class=GUIScrollTextBox Name=Box1
		bScaleToParent=True
		bBoundToParent=True
		WinWidth=0.986166
		WinHeight=0.935612
		WinLeft=0.011778
		WinTop=0.000000
		TabOrder=0
		bVisibleWhenEmpty=True
		bNoTeletype=True
		FontScale=FNS_Small
		Separator="~"
	End Object
	ScrollTextBox=Box1
}
