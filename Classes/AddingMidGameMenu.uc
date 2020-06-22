class AddingMidGameMenu extends Interaction;

event Initialized() {
	ViewportOwner.Actor.ShowMidGameMenu(False);
}

event Tick(float DeltaTime) {
	
	local GUIController GUIController;
	local UT2K4PlayerLoginMenu LoginMenu;
	local MidGamePanel Panel;
	
	GUIController = GUIController(ViewportOwner.GUIController);
	if (GUIController != None && GUIController.ActivePage != None) {
		LoginMenu = UT2K4PlayerLoginMenu(GUIController.ActivePage);
		if (LoginMenu != None) {
			Panel = MidGamePanel( LoginMenu.c_Main.AddTab("UnDefy 2004", string(class'MyMidGamePanel') ));
	  		if (Panel != None) Panel.ModifiedChatRestriction = LoginMenu.UpdateChatRestriction;
	  		Master.RemoveInteraction(Self);
			ViewportOwner.Actor.ClientCloseMenu(True);
		}
	}
}

defaultproperties {
	bActive=False
	bRequiresTick=True
	bVisible=False
	bNativeEvents=False
}
