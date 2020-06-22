//------------------------------------------------------\\
// Snorelax's TeamRadar mutator V 2.0			\\
// This mutator shows your team				\\
// on your radar screen. Super dope!			\\
// TeamRadarConfig.uc					\\
// This is the configuration GUI. It's pretty crappy,	\\
// but I'm a programmer, not an artist :P		\\
//------------------------------------------------------\\

class TestMenu extends GUIPage;

var moSlider RedColorR, RedColorG, RedColorB, BlueColorR, BlueColorG, BlueColorB, EmptyColorR, EmptyColorG, EmptyColorB, IconScale;
var moCheckBox DrawVehicle, DrawPlayers, DrawEmpty;

//var Interaction intTeamRadar;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner); // Call Parent's InitComponent

	//Point our local control variables at their equivalent control
	
	RedColorR = moSlider(Controls[4]);
	RedColorG = moSlider(Controls[5]);
	RedColorB = moSlider(Controls[6]);
	
	BlueColorR = moSlider(Controls[8]);
	BlueColorG = moSlider(Controls[9]);
	BlueColorB = moSlider(Controls[10]);
	
	EmptyColorR = moSlider(Controls[12]);
	EmptyColorG = moSlider(Controls[13]);
	EmptyColorB = moSlider(Controls[14]);
	
	IconScale = moSlider(Controls[15]);
	
	DrawVehicle = moCheckBox(Controls[17]);
	DrawPlayers = moCheckBox(Controls[18]);
	DrawEmpty = moCheckBox(Controls[19]);
	
	//Initialize sliders to their default values, then get the interaction we'll need to work with.
	//ResetControls();
	//GetTeamRadarInteraction();

}

//Initializes the controls. Is also used when the user hits cancel.
//function ResetControls()
//{
//	RedColorR.SetValue(String(class'TeamRadar'.default.RedColorR));
//	RedColorG.SetValue(String(class'TeamRadar'.default.RedColorG));
//	RedColorB.SetValue(String(class'TeamRadar'.default.RedColorB));
//	
//	BlueColorR.SetValue(String(class'TeamRadar'.default.BlueColorR));
//	BlueColorG.SetValue(String(class'TeamRadar'.default.BlueColorG));
//	BlueColorB.SetValue(String(class'TeamRadar'.default.BlueColorB));
//	
//	EmptyColorR.SetValue(String(class'TeamRadar'.default.EmptyColorR));
//	EmptyColorG.SetValue(String(class'TeamRadar'.default.EmptyColorG));
//	EmptyColorB.SetValue(String(class'TeamRadar'.default.EmptyColorB));
//	
//	IconScale.SetValue(String(Class'TeamRadar'.default.IconScale));
//	
//	DrawVehicle.SetComponentValue(String(Class'TeamRadar'.default.bDrawVehicles));
//	DrawPlayers.SetComponentValue(String(Class'TeamRadar'.default.bDrawPlayers));
//	DrawEmpty.SetComponentValue(String(Class'TeamRadar'.default.bDrawEmpty));
//}
//
//
////Self-explanitory
//function GetTeamRadarInteraction()
//{
//	local int i;
//	local PlayerController PC;
//	local bool bFindInteraction;
//	
//	bFindInteraction = false;
//	
//	ForEach AllObjects(class'PlayerController',PC)
//	{
//		if ( Viewport(PC.Player) != None )
//		{
//			While (!bFindInteraction)
//			{
//				intTeamRadar = PC.Player.LocalInteractions[i];
//			
//				if (intTeamRadar == none)
//					break;
//				else
//					if (intTeamRadar.IsA('TeamRadar'))
//						bFindInteraction = true;
//				i++;
//				
//			}
//			if (!bFindInteraction)			//Check if we actually did find it
//				intTeamRadar = None;
//		}
//	}
//}
//
//
////
////UpdateViewIcons updates the client's hud with the new colors in realtime.
////
//function UpdateViewIcons(GUIComponent Sender)
//{
//	TeamRadar(intTeamRadar).RedColorR = int(RedColorR.GetValue());
//	TeamRadar(intTeamRadar).RedColorG = int(RedColorG.GetValue());
//	TeamRadar(intTeamRadar).RedColorB = int(RedColorB.GetValue());
//	
//	TeamRadar(intTeamRadar).BlueColorR = int(BlueColorR.GetValue());
//	TeamRadar(intTeamRadar).BlueColorG = int(BlueColorG.GetValue());
//	TeamRadar(intTeamRadar).BlueColorB = int(BlueColorB.GetValue());
//	
//	TeamRadar(intTeamRadar).EmptyColorR = int(EmptyColorR.GetValue());
//	TeamRadar(intTeamRadar).EmptyColorG = int(EmptyColorG.GetValue());
//	TeamRadar(intTeamRadar).EmptyColorB = int(EmptyColorB.GetValue());
//	
//	TeamRadar(intTeamRadar).IconScale = IconScale.GetValue();
//	
//	TeamRadar(intTeamRadar).bDrawVehicles = bool(DrawVehicle.GetComponentValue());
//	TeamRadar(intTeamRadar).bDrawPlayers = bool(DrawPlayers.GetComponentValue());
//	TeamRadar(intTeamRadar).bDrawEmpty = bool(DrawEmpty.GetComponentValue());
//
//}   	

function bool OKClick(GUIComponent Sender)
{
	
	local int i;
	
	i = 0;
	
	//Update the defaults
	
//	class'TeamRadar'.default.RedColorR = int(RedColorR.GetValue());
//	class'TeamRadar'.default.RedColorG = int(RedColorG.GetValue());
//	class'TeamRadar'.default.RedColorB = int(RedColorB.GetValue());
//	
//	class'TeamRadar'.default.BlueColorR = int(BlueColorR.GetValue());
//	class'TeamRadar'.default.BlueColorG = int(BlueColorG.GetValue());
//	class'TeamRadar'.default.BlueColorB = int(BlueColorB.GetValue());
//	
//	class'TeamRadar'.default.EmptyColorR = int(EmptyColorR.GetValue());
//	class'TeamRadar'.default.EmptyColorG = int(EmptyColorG.GetValue());
//	class'TeamRadar'.default.EmptyColorB = int(EmptyColorB.GetValue());
//	
//	class'TeamRadar'.default.IconScale = IconScale.GetValue();
//	
//	class'TeamRadar'.default.bDrawVehicles = bool(DrawVehicle.GetComponentValue());
//	class'TeamRadar'.default.bDrawPlayers = bool(DrawPlayers.GetComponentValue());
//	class'TeamRadar'.default.bDrawEmpty = bool(DrawEmpty.GetComponentValue());
//	
//	class'TeamRadar'.static.StaticSaveConfig();  // Save all the Mutator's config variables

	Controller.CloseMenu(false);    // Close the window

	return true;
}

defaultproperties
{
	bRenderWorld=True
	bAllowedAsLast=True
	Controls=
	WinTop=0.30
	WinHeight=0.40
}
