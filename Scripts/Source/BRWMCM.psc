scriptname BRWMCM extends SKI_ConfigBase

Actor property PlayerRef auto
Spell property BRWLowHealthSpell auto
Spell property BRWLowStaminaSpell auto
Spell property BRWLowMagickaSpell auto
Spell property BRWLowLightSpell auto
Spell property BRWUndetectedSpell auto

;Audio variables
Float AudioMedHealthPercent = 0.60
Float AudioLowHealthPercent = 0.30
GlobalVariable property CombatLowStaminaPercent auto
GlobalVariable property RunningMedStaminaPercent auto
GlobalVariable property RunningLowStaminaPercent auto
;Audio menu variables
Int iAudioMedHealthPercent
Int iAudioLowHealthPercent
Int iAudioCombatLowStaminaPercent
Int iAudioRunningMedStaminaPercent
Int iAudioRunningLowStaminaPercent

;All Imagespace Modifiers. Must be added manually
ImagespaceModifier[] property ISModList auto
String[] property ISModNameList auto
;Imagespace Modifiers FormLists
ImagespaceModifier[] property LowHealthList auto
ImagespaceModifier[] property LowStaminaList auto
ImagespaceModifier[] property LowMagickaList auto
ImagespaceModifier[] property LowLightList auto
ImagespaceModifier[] property UndetectedList auto
;Percentages that modifierss start applying
Float[] property LowHealthPercentage auto
Float[] property LowStaminaPercentage auto
Float[] property LowMagickaPercentage auto
Float[] property LowLightPercentage auto
;Float[] property UndetectedPercentage auto
;The max magnitude of modifierss
Float[] property LowHealthMaxMagnitude auto
Float[] property LowStaminaMaxMagnitude auto
Float[] property LowMagickaMaxMagnitude auto
Float[] property LowLightMaxMagnitude auto
Float[] property UndetectedMaxMagnitude auto
;Imagespace modifiers menu options
Int[] iLowStatImagespaceModifiersList
Int[] iLowStatPercentage
Int[] iMaxMagnitude
ImagespaceModifier[] availableList

Bool property menuInitialized auto

;;;;;;;;;;;;;;;;;
;;SKY UI EVENTS;;
;;;;;;;;;;;;;;;;;

Event OnConfigInit()
	Pages = new string[5]
	Pages[0] = "Audio Options"
    Pages[1] = "Health Options"
    Pages[2] = "Stamina Options"
    Pages[3] = "Magicka Options"
	Pages[4] = "Light Options"
	;Pages[5] = "Stealth Options"

	ISModList = new ImagespaceModifier[128]
	ISModNameList = new String[128]
	LowHealthList = new ImagespaceModifier[128]
	LowStaminaList = new ImagespaceModifier[128]
	LowMagickaList = new ImagespaceModifier[128]
	LowLightList = new ImagespaceModifier[128]
	UndetectedList = new ImagespaceModifier[128]
	LowHealthPercentage = new Float[128]
	LowStaminaPercentage = new Float[128]
	LowMagickaPercentage = new Float[128]
	LowLightPercentage = new Float[128]
	;UndetectedPercentage = new Float[128]
	LowHealthMaxMagnitude = new Float[128]
	LowStaminaMaxMagnitude = new Float[128]
	LowMagickaMaxMagnitude = new Float[128]
	LowLightMaxMagnitude = new Float[128]
	UndetectedMaxMagnitude = new Float[128]

	iLowStatImagespaceModifiersList = new Int[128]
	iLowStatPercentage = new Int[128]
	iMaxMagnitude = new Int[128]

	menuInitialized = true
	Maint()
EndEvent

Event OnPageReset(string page)
    int flags
	SetCursorFillMode(LEFT_TO_RIGHT)

	If (page == "Audio Options")
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Health", 0)
		AddEmptyOption()
		iAudioMedHealthPercent = AddSliderOption("Slow heartbeat", AudioMedHealthPercent, "{2}", 0)
		iAudioLowHealthPercent = AddSliderOption("Fast heartbeat", AudioLowHealthPercent, "{2}", 0)
		AddHeaderOption("Stamina", 0)
		AddEmptyOption()
		iAudioCombatLowStaminaPercent = AddSliderOption("Heavy breath in combat", CombatLowStaminaPercent.GetValue(), "{2}", 0)
		AddEmptyOption()
		iAudioRunningMedStaminaPercent = AddSliderOption("Faster breath while running", RunningMedStaminaPercent.GetValue(), "{2}", 0)
		iAudioRunningLowStaminaPercent = AddSliderOption("Fastest breath while running", RunningLowStaminaPercent.GetValue(), "{2}", 0)
	ElseIf (page == "Health Options")
		PopulatePage(LowHealthList, LowHealthPercentage, LowHealthMaxMagnitude)
	ElseIf (page == "Stamina Options")
		PopulatePage(LowStaminaList, LowStaminaPercentage, LowStaminaMaxMagnitude)
	ElseIf (page == "Magicka Options")
		PopulatePage(LowMagickaList, LowMagickaPercentage, LowMagickaMaxMagnitude)
	ElseIf (page == "Light Options")
		PopulatePage(LowLightList, LowLightPercentage, LowLightMaxMagnitude)
	ElseIf (page == "Stealth Options")
		PopulateDetectionPage(UndetectedList, UndetectedMaxMagnitude)
	EndIf
EndEvent

Event OnOptionHighlight(int option)
	If (CurrentPage == "Audio Options")
		If (option == iAudioMedHealthPercent)
			SetInfoText("When health drops bellow this value, you will hear a slow heartbeat.")
		ElseIf (option == iAudioLowHealthPercent)
			SetInfoText("When health drops bellow this value, you will hear a fast heartbeat.")
		ElseIf (option == iAudioCombatLowStaminaPercent)
			SetInfoText("When stamina drops bellow this value in combat, you will hear a heavy breath. Can be hard to hear.")
		ElseIf (option == iAudioRunningMedStaminaPercent)
			SetInfoText("When stamina drops bellow this value while running, you will hear heavy breathing. Volume is tied to the Voice audio option.")
		ElseIf (option == iAudioRunningLowStaminaPercent)
			SetInfoText("When stamina drops bellow this value while running, you will hear heavier breathing.")
		EndIf
	Else
		Int i = 0
		While (i < 128)
			If (ISModList[i] != None)
				If (option == iLowStatImagespaceModifiersList[i])
					SetInfoText("Select an Imagespace Modifier to apply for the current stat.")
					return
				ElseIf (option == iMaxMagnitude[i])
					SetInfoText("How strong do you want this effect to be at max strength.")
					return
				EndIf
			EndIf
			i += 1
		EndWhile
		i = 0
		While (i < 128)
			If (ISModList[i] != None)
				If (option == iLowStatPercentage[i])
					SetInfoText("The selected modifier will start applying when bellow this stat percentage.")
					return
				EndIf
			EndIf
			i += 1
		EndWhile
	EndIf
EndEvent

Event OnOptionSliderOpen(int option)
	SetSliderDialogRange(0.0, 1.0)
	SetSliderDialogInterval(0.01)
	If (CurrentPage == "Audio Options")
		If (option == iAudioMedHealthPercent)
			SetSliderDialogStartValue(AudioMedHealthPercent)
			SetSliderDialogDefaultValue(0.2)
		ElseIf (option == iAudioLowHealthPercent)
			SetSliderDialogStartValue(AudioLowHealthPercent)
			SetSliderDialogDefaultValue(0.1)
		ElseIf (option == iAudioCombatLowStaminaPercent)
			SetSliderDialogStartValue(CombatLowStaminaPercent.GetValue())
			SetSliderDialogDefaultValue(0.33)
		ElseIf (option == iAudioRunningMedStaminaPercent)
			SetSliderDialogStartValue(RunningMedStaminaPercent.GetValue())
			SetSliderDialogDefaultValue(0.65)
		ElseIf (option == iAudioRunningLowStaminaPercent)
			SetSliderDialogStartValue(RunningLowStaminaPercent.GetValue())
			SetSliderDialogDefaultValue(0.35)
		EndIf
	ElseIf (CurrentPage == "Health Options")
		OnOptionSliderOpenPercent(option, LowHealthPercentage, LowHealthMaxMagnitude)
	ElseIf (CurrentPage == "Stamina Options")
		OnOptionSliderOpenPercent(option, LowStaminaPercentage, LowStaminaMaxMagnitude)
	ElseIf (CurrentPage == "Magicka Options")
		OnOptionSliderOpenPercent(option, LowMagickaPercentage, LowMagickaMaxMagnitude)
	ElseIf (CurrentPage == "Light Options")
		OnOptionSliderOpenPercent(option, LowLightPercentage, LowLightMaxMagnitude)
	ElseIf (CurrentPage == "Stealth Options")
		OnOptionSliderOpenMagnitude(option, UndetectedMaxMagnitude)
	EndIf
EndEvent

Event OnOptionSliderAccept(int option, float value)
	If (CurrentPage == "Audio Options")
		If (option == iAudioMedHealthPercent)
			AudioMedHealthPercent = value
			Game.SetGameSettingFloat("fPlayerHealthHeartbeatSlow", value)
		ElseIf (option == iAudioLowHealthPercent)
			AudioLowHealthPercent = value
			Game.SetGameSettingFloat("fPlayerHealthHeartbeatFast", value)
		ElseIf (option == iAudioCombatLowStaminaPercent)
			CombatLowStaminaPercent.SetValue(value)
		ElseIf (option == iAudioRunningMedStaminaPercent)
			RunningMedStaminaPercent.SetValue(value)
		ElseIf (option == iAudioRunningLowStaminaPercent)
			RunningLowStaminaPercent.SetValue(value)
		EndIf
	ElseIf (CurrentPage == "Health Options")
		OnOptionSliderAcceptPercent(option, value, LowHealthPercentage, LowHealthMaxMagnitude, BRWLowHealthSpell)
	ElseIf (CurrentPage == "Stamina Options")
		OnOptionSliderAcceptPercent(option, value, LowStaminaPercentage, LowStaminaMaxMagnitude, BRWLowStaminaSpell)
	ElseIf (CurrentPage == "Magicka Options")
		OnOptionSliderAcceptPercent(option, value, LowMagickaPercentage, LowMagickaMaxMagnitude, BRWLowMagickaSpell)
	ElseIf (CurrentPage == "Light Options")
		OnOptionSliderAcceptPercent(option, value, LowLightPercentage, LowLightMaxMagnitude, BRWLowLightSpell)
	ElseIf (CurrentPage == "Stealth Options")
		OnOptionSliderAcceptMagnitude(option, value, UndetectedMaxMagnitude)
	EndIf
	ForcePageReset()
EndEvent

Event OnOptionMenuOpen(int option)
	SetMenuDialogDefaultIndex(0)
	If (CurrentPage == "Health Options")
		OnOptionMenuOpenFunction(option, LowHealthList)
	ElseIf (CurrentPage == "Stamina Options")
		OnOptionMenuOpenFunction(option, LowStaminaList)
	ElseIf (CurrentPage == "Magicka Options")
		OnOptionMenuOpenFunction(option, LowMagickaList)
	ElseIf (CurrentPage == "Light Options")
		OnOptionMenuOpenFunction(option, LowLightList)
	ElseIf (CurrentPage == "Stealth Options")
		OnOptionMenuOpenFunction(option, UndetectedList)
	EndIf
EndEvent

Event OnOptionMenuAccept(int option, int index)
	If (CurrentPage == "Health Options")
		OnOptionMenuAcceptFunction(option, index, LowHealthList, BRWLowHealthSpell)
	ElseIf (CurrentPage == "Stamina Options")
		OnOptionMenuAcceptFunction(option, index, LowStaminaList, BRWLowStaminaSpell)
	ElseIf (CurrentPage == "Magicka Options")
		OnOptionMenuAcceptFunction(option, index, LowMagickaList, BRWLowMagickaSpell)
	ElseIf (CurrentPage == "Light Options")
		OnOptionMenuAcceptFunction(option, index, LowLightList, BRWLowLightSpell)
	ElseIf (CurrentPage == "Stealth Options")
		OnOptionMenuAcceptFunction(option, index, UndetectedList, BRWUndetectedSpell)
	EndIf
	ForcePageReset()
EndEvent

;;;;;;;;;;;;;;;;;
;;SKY UI EVENTS;;
;;;;;;;;;;;;;;;;;

Function PopulatePage(ImagespaceModifier[] list, Float[] percentageList, Float[] magnitude)
	Int i = 0
	While (i < 128)
		If (ISModList[i] != None)
			Int selectedISModIndex
			If (list[i] == none)
				selectedISModIndex = -1
			Else
				selectedISModIndex = ISModList.Find(list[i])
			EndIf
			iLowStatImagespaceModifiersList[i] = AddMenuOption("Imagespace Modifier", GetModifiersNameAtIndex(selectedISModIndex), 0)
			AddEmptyOption()
			iLowStatPercentage[i] = AddSliderOption("Low Stat Percentage", percentageList[i], "{2}", 0)
			iMaxMagnitude[i] = AddSliderOption("Max Modifier Magnitude", magnitude[i], "{2}", 0)
		EndIf
		i += 1
	EndWhile
EndFunction

Function PopulateDetectionPage(ImagespaceModifier[] list, Float[] magnitude)
	Int i = 0
	While (i < 128)
		If (ISModList[i] != None)
			Int selectedISModIndex
			If (list[i] == none)
				selectedISModIndex = -1
			Else
				selectedISModIndex = ISModList.Find(list[i])
			EndIf
			iLowStatImagespaceModifiersList[i] = AddMenuOption("Imagespace Modifier", GetModifiersNameAtIndex(selectedISModIndex), 0)
			iMaxMagnitude[i] = AddSliderOption("Max Modifier Magnitude", magnitude[i], "{2}", 0)
		EndIf
		i += 1
	EndWhile
EndFunction

String Function GetModifiersNameAtIndex(Int index)
	If (index < 0)
		return "No isMod"
	Else
		return ISModNameList[index]
	EndIf
EndFunction

Function OnOptionSliderOpenPercent(int option, float[] LowStatPercentage, float[] MaxMagnitude)
	SetSliderDialogDefaultValue(0.0)
	Int i = 0
	While (i < 128)
		If (ISModList[i] != None)
			If (option == iLowStatPercentage[i])
				SetSliderDialogStartValue(LowStatPercentage[i])
				return
			ElseIf (option == iMaxMagnitude[i])
				SetSliderDialogStartValue(MaxMagnitude[i])
				return
			EndIf
		EndIf
		i += 1
	EndWhile
EndFunction

Function OnOptionSliderOpenMagnitude(int option, float[] MaxMagnitude)
	SetSliderDialogDefaultValue(0.0)
	Int i = 0
	While (i < 128)
		If (ISModList[i] != None)
			If (option == iMaxMagnitude[i])
				SetSliderDialogStartValue(MaxMagnitude[i])
				return
			EndIf
		EndIf
		i += 1
	EndWhile
EndFunction

Function OnOptionSliderAcceptPercent(int option, float value, float[] LowStatPercentage, float[] MaxMagnitude, spell mySpell)
	Int i = 0
	While (i < 128)
		If (ISModList[i] != None)
			If (option == iLowStatPercentage[i])
				LowStatPercentage[i] = value
				PlayerRef.RemoveSpell(mySpell)
				PlayerRef.AddSpell(mySpell, false)
				return
			ElseIf (option == iMaxMagnitude[i])
				PlayerRef.RemoveSpell(mySpell)
				PlayerRef.AddSpell(mySpell, false)
				MaxMagnitude[i] = value
				return
			EndIf
		EndIf
		i += 1
	EndWhile
EndFunction

Function OnOptionSliderAcceptMagnitude(int option, float value, float[] MaxMagnitude)
	Int i = 0
	While (i < 128)
		If (ISModList[i] != None)
			If (option == iMaxMagnitude[i])
				MaxMagnitude[i] = value
				return
			EndIf
		EndIf
		i += 1
	EndWhile
EndFunction

Function OnOptionMenuOpenFunction(int option, ImagespaceModifier[] list)
	Int i = 0
	availableList = new ImagespaceModifier[128]	;We donn't want to apply the same filter twice,  make forms in list not availble to select
	Int availableListSize = 0
	;Add all forms to the temp list
	While (i < 128)
		If (ISModList[i] != None)
			availableList[i] = ISModList[i]
			availableListSize += 1
		EndIf
		i += 1
	EndWhile

	;Find the menu option that this applies to
	i = 0
	int optionIndex
	bool break = false
	While (!break && i < 128)
		If (option == iLowStatImagespaceModifiersList[i])
			optionIndex = i
			break = true
		EndIf
		i += 1
	EndWhile

	;Remove already applied forms from the temp list, Don't remove the selected option
	i = 0
	While (i < 128)
		int t = availableList.Find(list[i])
		If (t >= 0 && availableList[t] != list[optionIndex])
			availableList[t] = None
			;Don't subtract list size, positions in the array dont change
		EndIf
		i += 1
	EndWhile

	;We need to fill in the gaps in the array
	i = 0
	While (i < availableListSize)
		If (availableList[i] == none)
			Int s = i
			break = false
			While (!break && s < 128)
				If (availableList[s] != none)
					availableList[i] = availableList[s]
					availableList[s] = none
					break = true
				EndIf
				s += 1
			EndWhile
		EndIf
		i += 1
	EndWhile

	;Set start index to curently selected option
	If (list[optionIndex] == none)
		SetMenuDialogStartIndex(0)
	Else
		SetMenuDialogStartIndex(availableList.Find(list[optionIndex]) + 1)
	EndIf

	;Make the temp list the available options
	String[] nameArray = new String[128]
	nameArray[0] = "No isMod"	;The first option will always be none
	i = 0		;Cycle through each index in availableList.
	int s = 1	;Tracks the name array index size
	While (i < availableListSize)
		ImagespaceModifier t = availableList[i]
		If (t != none)
			nameArray[s] = GetModifiersNameAtIndex(ISModList.Find(t))
			s += 1
		EndIf
		i += 1
	EndWhile
	SetMenuDialogOptions(nameArray)
EndFunction

Function OnOptionMenuAcceptFunction(int option, int index, ImagespaceModifier[] list, Spell effectSpell)
	;Find the menu option that this applies to
	int i = 0
	int optionIndex
	bool break = false
	While (!break && i < 128)
		If (option == iLowStatImagespaceModifiersList[i])
			optionIndex = i
			break = true
		EndIf
		i += 1
	EndWhile
	;Find the Imagespace Modifier that matches the index

	;Add/remove the isMod to the list and reset the spell
	If (index == 0)
		list[optionIndex] = None
		PlayerRef.RemoveSpell(effectSpell)
		i = 0
		break = false
		while (!break && i < 128)
			If (list[i] != None)
				PlayerRef.AddSpell(effectSpell, false)
				break = true
			EndIf
			i += 1
		EndWhile
	Else
		index -= 1
		list[optionIndex] = availableList[index]
		PlayerRef.RemoveSpell(effectSpell)
		PlayerRef.AddSpell(effectSpell, false)
	EndIf
EndFunction

Function Maint()
	Game.SetGameSettingFloat("fPlayerHealthHeartbeatSlow", AudioMedHealthPercent)
	Game.SetGameSettingFloat("fPlayerHealthHeartbeatFast", AudioLowHealthPercent)
EndFunction