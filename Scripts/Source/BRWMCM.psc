scriptname BRWMCM extends SKI_ConfigBase

globalvariable property CombatLowStaminaPercent auto
globalvariable property RunningMedStaminaPercent auto
globalvariable property RunningLowStaminaPercent auto
globalvariable property LowMagickaPercent auto
spell property LowMagickaSpell auto
Actor property playerRef auto


bool healthEnabled = true
float medHealthPercent = 0.6
float lowHealthPercent = 0.3
float property defaultMedHealthPercent = 0.2 autoReadOnly
float property defaultLowHealthPercent = 0.1 autoReadOnly

bool staminaEnabled = true
float localCombatLowStaminaPercent = 0.33
float localRunningMedStaminaPercent = 0.65
float localRunningLowStaminaPercent = 0.35
float property defaultCombatLowStaminaPercent = 0.33 autoReadOnly
float property defaultRunningMedStaminaPercent = 0.65 autoReadOnly
float property defaultRunningLowStaminaPercent = 0.35 autoReadOnly

bool magickaEnabled = true
float localLowMagickaPercent = 0.65


int ihealthEnabled
int imedHealthPercent
int ilowHealthPercent

int istaminaEnabled
int iCombatLowStaminaPercent
int iRunningMedStaminaPercent
int iRunningLowStaminaPercent

int imagickaEnabled
int iLowMagickaPercent

event OnConfigInit()
	Pages = new string[1]
	Pages[0] = "Options"
	Maintenance()
    playerRef.AddSpell(LowMagickaSpell, false)
endEvent

Event OnPageReset(string page)
    int flags
    SetCursorFillMode(TOP_TO_BOTTOM)
    
    If(healthEnabled)
        flags = OPTION_FLAG_NONE
    Else
        flags = OPTION_FLAG_DISABLED
    EndIf
    AddHeaderOption("Health", 0)
    ihealthEnabled = AddToggleOption("Enabled", healthEnabled, 0)
    imedHealthPercent = AddSliderOption("Medium Health Percentage", medHealthPercent, "", flags)
    ilowHealthPercent = AddSliderOption("Low Health Percentage", lowHealthPercent, "", flags)

    If(staminaEnabled)
        flags = OPTION_FLAG_NONE
    Else
        flags = OPTION_FLAG_DISABLED
    EndIf
    AddHeaderOption("Stamina", 0)
    istaminaEnabled = AddToggleOption("Enabled", staminaEnabled, 0)
    iCombatLowStaminaPercent = AddSliderOption("Low Stamina Percent In Combat", localCombatLowStaminaPercent, "", flags)
    iRunningMedStaminaPercent = AddSliderOption("Medium Stamina Percent While Running", localRunningMedStaminaPercent, "", flags)
    iRunningLowStaminaPercent = AddSliderOption("Low Stamina Percent While Running", localRunningLowStaminaPercent, "", flags)

    If(magickaEnabled)
        flags = OPTION_FLAG_NONE
    Else
        flags = OPTION_FLAG_DISABLED
    EndIf
    AddHeaderOption("Magicka", 0)
    imagickaEnabled = AddToggleOption("Enabled", magickaEnabled, 0)
    iLowMagickaPercent = AddSliderOption("Low Magicka Percent", localLowMagickaPercent, "", flags)
EndEvent

Event OnOptionHighlight(int option)
    If(option == ihealthEnabled)
        SetInfoText("Enable/Disable earlier low health warnings. Skyrim's default values are 0.2 and 0.1")
    ElseIf(option == imedHealthPercent)
        SetInfoText("When health drops bellow this value, you will hear a slow heartbeat")
    ElseIf(option == ilowHealthPercent)
        SetInfoText("When health drops bellow this value, you will hear a fast heartbeat")
    ElseIf(option == istaminaEnabled)
        SetInfoText("Enable/Disable earlier low stamina warnings. Skyrim's default values are 0.65 and 0.35")
    ElseIf(option == iCombatLowStaminaPercent)
        SetInfoText("While in combat and performing a block or power attack, if stamina is bellow this value you will hear heavy breating")
    ElseIf(option == iRunningMedStaminaPercent)
        SetInfoText("While running, if stamina drops bellow this value you will hear slightly heavier breathing. It can be hard to notice.")
    ElseIf(option == iRunningLowStaminaPercent)
        SetInfoText("While running, if stamina drops bellow this value you will hear heavier breathing.")
    ElseIf(option == imagickaEnabled)
        SetInfoText("Enable/Disable earlier low magicka warning. There is no equivalent in the base game.")
    ElseIf(option == iLowMagickaPercent)
        SetInfoText("When magicka drops bellow this value, the world will lose color. At zero mana, the world will be black and white.")
    EndIf
EndEvent

Event OnOptionSelect(int option)
    If(option == ihealthEnabled)
        healthEnabled = !healthEnabled
        SetToggleOptionValue(ihealthEnabled, healthEnabled, true)
        If(healthEnabled)
            SetOptionFlags(imedHealthPercent, OPTION_FLAG_NONE, true)
            SetOptionFlags(ilowHealthPercent, OPTION_FLAG_NONE, false)
            Game.SetGameSettingFloat("fPlayerHealthHeartbeatSlow", medHealthPercent)
            Game.SetGameSettingFloat("fPlayerHealthHeartbeatFast", lowHealthPercent)
        Else
            SetOptionFlags(imedHealthPercent, OPTION_FLAG_DISABLED, true)
            SetOptionFlags(ilowHealthPercent, OPTION_FLAG_DISABLED, false)
            Game.SetGameSettingFloat("fPlayerHealthHeartbeatSlow", defaultMedHealthPercent)
            Game.SetGameSettingFloat("fPlayerHealthHeartbeatFast", defaultLowHealthPercent)
        EndIf
    ElseIf(option == istaminaEnabled)
        staminaEnabled = !staminaEnabled
        SetToggleOptionValue(istaminaEnabled, staminaEnabled, true)
        If(staminaEnabled)
            SetOptionFlags(iCombatLowStaminaPercent, OPTION_FLAG_NONE, true)
            SetOptionFlags(iRunningMedStaminaPercent, OPTION_FLAG_NONE, true)
            SetOptionFlags(iRunningLowStaminaPercent, OPTION_FLAG_NONE, false)
            CombatLowStaminaPercent.SetValue(localCombatLowStaminaPercent)
            RunningMedStaminaPercent.SetValue(localRunningMedStaminaPercent)
            RunningLowStaminaPercent.SetValue(localRunningLowStaminaPercent)
        Else
            SetOptionFlags(iCombatLowStaminaPercent, OPTION_FLAG_DISABLED, true)
            SetOptionFlags(iRunningMedStaminaPercent, OPTION_FLAG_DISABLED, true)
            SetOptionFlags(iRunningLowStaminaPercent, OPTION_FLAG_DISABLED, false)
            CombatLowStaminaPercent.SetValue(defaultCombatLowStaminaPercent)
            RunningMedStaminaPercent.SetValue(defaultRunningMedStaminaPercent)
            RunningLowStaminaPercent.SetValue(defaultRunningLowStaminaPercent)
        EndIf
    ElseIf(option == imagickaEnabled)
        magickaEnabled = !magickaEnabled
        SetToggleOptionValue(imagickaEnabled, magickaEnabled, true)
        If(magickaEnabled)
            SetOptionFlags(iLowMagickaPercent, OPTION_FLAG_NONE, false)
            playerRef.AddSpell(LowMagickaSpell, false)
        Else
            SetOptionFlags(iLowMagickaPercent, OPTION_FLAG_DISABLED, false)
            playerRef.RemoveSpell(LowMagickaSpell)
        EndIf
    EndIf
EndEvent

Event OnOptionSliderOpen(int option)
    SetSliderDialogRange(0.00, 1.00)
    SetSliderDialogInterval(0.01)
    If(option == imedHealthPercent)
        SetSliderDialogStartValue(medHealthPercent)
        SetSliderDialogDefaultValue(defaultMedHealthPercent)
    ElseIf(option == ilowHealthPercent)
        SetSliderDialogStartValue(lowHealthPercent)
        SetSliderDialogDefaultValue(defaultLowHealthPercent)
    ElseIf(option == iCombatLowStaminaPercent)
        SetSliderDialogStartValue(localCombatLowStaminaPercent)
        SetSliderDialogDefaultValue(defaultCombatLowStaminaPercent)
    ElseIf(option == iRunningMedStaminaPercent)
        SetSliderDialogStartValue(localRunningMedStaminaPercent)
        SetSliderDialogDefaultValue(defaultRunningMedStaminaPercent)
    ElseIf(option == iRunningLowStaminaPercent)
        SetSliderDialogStartValue(localRunningLowStaminaPercent)
        SetSliderDialogDefaultValue(defaultRunningLowStaminaPercent)
    ElseIf(option == iLowMagickaPercent)
        SetSliderDialogStartValue(localLowMagickaPercent)
        SetSliderDialogDefaultValue(0.65)
    EndIf
EndEvent

Event OnOptionSliderAccept(int option, float value)
    SetSliderOptionValue(option, value, "", 0)
    If(option == imedHealthPercent)
        medHealthPercent = value
        Game.SetGameSettingFloat("fPlayerHealthHeartbeatSlow", value)
    ElseIf(option == ilowHealthPercent)
        lowHealthPercent = value
        Game.SetGameSettingFloat("fPlayerHealthHeartbeatFast", value)
    ElseIf(option == iCombatLowStaminaPercent)
        localCombatLowStaminaPercent = value
        CombatLowStaminaPercent.SetValue(value)
    ElseIf(option == iRunningMedStaminaPercent)
        localRunningMedStaminaPercent = value
        RunningMedStaminaPercent.SetValue(value)
    ElseIf(option == iRunningLowStaminaPercent)
        localRunningLowStaminaPercent = value
        RunningLowStaminaPercent.SetValue(value)
    ElseIf(option == iLowMagickaPercent)
        localLowMagickaPercent = value
        LowMagickaPercent.SetValue(value)
    EndIf
EndEvent

Event OnPlayerLoadGame()
    Maintenance()
EndEvent

Function Maintenance()
    Game.SetGameSettingFloat("fPlayerHealthHeartbeatSlow", medHealthPercent)
    Game.SetGameSettingFloat("fPlayerHealthHeartbeatFast", lowHealthPercent)
EndFunction