class VoteMessageType extends AllVoteMessages;

static function color GetColor(optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2){
	return MakeColor(140, 140, 140);
}

static function string GetString(optional int N, optional PlayerReplicationInfo R1, optional PlayerReplicationInfo R2, optional Object O){
	if(Voting(O) != None) return Voting(O).VotedString;
}

defaultproperties{
	Offset=1
	FontSize=0
}