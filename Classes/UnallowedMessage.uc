class UnallowedMessage extends zLocalMessage;

var array<string> MessageText;

static function ClientReceive(PlayerController P, optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2, optional Object O){
	local string S;
	if(N >= 20 && N <= 30) S = Repl(default.MessageText[15], "%N", 31 - N);
	else if(N == 33) S = Repl(default.MessageText[N], "%N", P.Level.Pauser.PlayerName);
	else S = default.MessageText[N];
	class'zUtil'.static.ConsoleMessage(P, S, True);
}

defaultproperties{
	MessageText(1)="Warmup in progress!"
	MessageText(2)="Spectators can't call timeout!"
	MessageText(3)="Your timeout in progress!"
	MessageText(4)="No more timeouts for your team!"
	MessageText(5)="You can't call timeout here!" // FFA
	MessageText(6)="No more timeouts for you!"
	MessageText(7)="You can't call timeout during warmup!"
	MessageText(8)="Match is not in progress!" // old = You can't call timeout right now!
	MessageText(11)="No vote in progress!"
	MessageText(12)="A vote already in progress!"
	MessageText(13)="You are spectator!"
	MessageText(14)="You already voted!"
	MessageText(15)="Wait %N second(s)!"
	MessageText(31)="You are already ready!"
	MessageText(32)="Match in progress!"
	MessageText(33)="Match paused by %N!"
	MessageText(34)="You are not team captain!"
	MessageText(35)="You can't call timeout in overtime!"
	MessageText(36)="Unknown vote parameter"
	MessageText(37)="This player is not invitable"
	MessageText(38)="Only team captains can invite players"
	MessageText(39)="This player is already in your team!"
	MessageText(40)="Sorry!"
	MessageText(41)="You can't kick this player!"
	MessageText(42)="Counting..." // limited & countdown
	MessageText(43)="You are already not ready!"
	MessageText(44)="Sorry, it is too late!" // warmup. not ready in countdown < 2
	MessageText(45)="Sorry, game is starting..." // bCanStopCountDown = False
	MessageText(46)="This is not team game!"
	MessageText(47)="Sorry, unknown team player..."
	MessageText(48)="No need to invite this player" // invite
	MessageText(49)="This player is not spectator"
	MessageText(50)="All players are captains!"
	MessageText(51)="This player is already in your team!"
	Lifetime=0
	bIsConsoleMessage=True
}
