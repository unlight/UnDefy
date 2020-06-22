class zGUITabPanel extends GUITabPanel abstract;

var automated GUIScrollTextBox ScrollTextBox;
var string DefaultText;

const Counter = 1;

event InitComponent(GUIController MyController, GUIComponent MyOwner){
	Super.InitComponent(MyController, MyOwner);
	ScrollTextBox.SetContent(DefaultText);
	Debug("InitComponent" @ Self @ MyController @ MyOwner);
}

event OnCreateComponent(GUIComponent NewComponent, GUIComponent Sender){
	Debug("OnCreateComponent" @ Self @ NewComponent @ Sender);
}
event OnActivate(){
	Debug("OnActivate");
}

event OnWatch(){
	Debug("OnWatch");
}

event OnShow(){
	Debug("OnShow" @ Self);
}
event bool OnClick(GUIComponent Sender){
	Debug("OnClick" @ Sender);
	return True;
}
//event bool OnChange(GUIComponent Sender){
//	Debug("OnChange" @ Sender);
//	return True;
//}
//OnChange(GUIComponent Sender)

simulated function Debug(coerce string S){
	class'zUtil'.static.Debug(S, PlayerOwner());
}

defaultproperties{
	bBoundToParent=True
	bScaleToParent=True
	bInit=False
	Begin Object class=GUIScrollTextBox Name=GUIScrollTextBox1
		WinWidth=0.95
		WinHeight=0.95
		WinLeft=0.02
		WinTop=0.02
		TabOrder=0
		bVisibleWhenEmpty=True
		bNoTeletype=True
	End Object
	ScrollTextBox=GUIScrollTextBox1
}
