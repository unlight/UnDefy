class zWindowLoginMenu extends UT2K4PlayerLoginMenu;

var GUITabItem MyMidGamePanel;

function AddPanels(){
	MyMidGamePanel.ClassName = class'zUtil'.static.GetPackageName(Class, True) $ "zMidGamePanel";
	MyMidGamePanel.Caption = "UMP";
	MyMidGamePanel.Hint = "---";
	Panels[Panels.Length] = MyMidGamePanel;
	Super.AddPanels();
}

defaultproperties{}
