class EnemyCam extends zObject;

var xPawn Pawn;
var bool bFloating;
var vector OffsetV;
// draw
var Font MySmallFont;

function MyTick(){
	Super.MyTick();
	// pawnlist - here
	if(class'zMain'.default.EnemyCam != 0 && (Outer.PlayerReplicationInfo.bOnlySpectator || Outer.bDemoOwner)){
		if(Pawn == None || Pawn.PlayerReplicationInfo == None || Outer.ViewTarget == Pawn) CatchEnemy();
	}else Pawn = None;
}

// Me.ViewTarget - тварь за которой смотрим
function CatchEnemy(){
	foreach Outer.DynamicActors(class'xPawn', Pawn){
		if(Pawn != Outer.ViewTarget && Pawn != None && Pawn.PlayerReplicationInfo != None){
			bFloating = False;
			MySmallFont = Outer.MyHUD.LoadFont(7);
			return;
		}
	}
}

function SetUpdateTime(){
	if(bFloating) bFloating = False;
	Super.SetUpdateTime();
}

function rotator GetViewRotation(){
	local rotator R;
	if(Pawn.Controller != None) return Pawn.Controller.Rotation;
	R = Pawn.Rotation;
	R.Pitch = (256 * Pawn.ViewPitch) & 65535;
	return R;
}

function Draw(Canvas C){
	local int PosX, PosY, SmallScreenWidth, SmallScreenHeight;
	local float XL, YL;
	local string Info, Attachment;
	local array<string> Weapon;

	SmallScreenWidth = C.ClipX * class'zMain'.default.EnemyCam / 200;
	SmallScreenHeight = C.ClipY * class'zMain'.default.EnemyCam / 200;
	PosX = C.ClipX - SmallScreenWidth - 5;
	PosY = 5;

	C.DrawPortal(PosX, PosY, SmallScreenWidth, SmallScreenHeight, Pawn, Pawn.Location + OffsetV, GetViewRotation());
	//C.DrawPortal(PosX, PosY, SmallScreenWidth, SmallScreenHeight, Outer, Pawn.Location + OffsetV, Pawn.Rotation);

	C.DrawColor = class'HUD'.default.WhiteColor;
	C.SetPos(PosX, PosY);
	C.DrawBox(C, SmallScreenWidth, SmallScreenHeight);

	if(Pawn.PlayerReplicationInfo != None){
		Info = Pawn.PlayerReplicationInfo.PlayerName @ "("$ Pawn.Health $"/"$ int(Pawn.ShieldStrength) $")";
		if(Pawn.Weapon != None){
			Split(Pawn.Weapon.GetHumanReadableName(), " ", Weapon);
			Info @= "["$ Weapon[0] $"]" @ int(Pawn.Weapon.AmmoStatus() * 100) $ "%";
		}else if(Pawn.WeaponAttachment != None){
			Attachment = GetItemName( string(Pawn.WeaponAttachment) );
			Attachment -= "Attachment";
			Attachment -= "ONS";
			Info @= "["$ Attachment $"]";
		}
		C.Font = MySmallFont;
		C.StrLen(Info, XL, YL);
		C.SetPos((SmallScreenWidth - XL) / 2 + PosX, SmallScreenHeight + C.CurY + 5); // bottom middle (out box)
		//C.SetPos((SmallScreenWidth - XL) / 2 + PosX, C.CurY + 5); // top middle (in box)
		C.DrawText(Info, True);
	}else if(!bFloating){
		SetUpdateTime();
		bFloating = True;
	}
}

defaultproperties{
	UpdateTime=(Min=2.2,Max=2.2)
	OffsetV=(X=0,Y=0,Z=70)
}
