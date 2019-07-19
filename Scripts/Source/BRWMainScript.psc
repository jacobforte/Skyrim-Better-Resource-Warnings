ScriptName BRWMainScript extends Quest

ImagespaceModifier[] property ISMod auto
String[] property ISModName auto
BRWMCM MCMQuest

Event OnInit()
	MCMQuest = Quest.GetQuest("BRWMainQuest") As BRWMCM
	RegisterForSingleUpdate(1)
EndEvent

Event OnUpdate()
	If (MCMQuest.menuInitialized)
		Int size = ISMod.Length
		Int i = 0
		While (i < size)
			int index = MCMQuest.ISModList.Find(None)
			MCMQuest.ISModList[index] = ISMod[i]
			MCMQuest.ISModNameList[index] = ISModName[i]
			i += 1
		EndWhile
	Else
		RegisterForSingleUpdate(1)
	EndIf
EndEvent