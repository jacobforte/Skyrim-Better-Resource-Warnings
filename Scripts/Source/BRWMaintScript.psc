ScriptName BRWMaintScript extends ReferenceAlias

Actor property playerRef auto
Spell property BRWUndetectedSpell auto
BRWMCM MCMQuest

Event OnInit()
	MCMQuest = Quest.GetQuest("BRWMainQuest") As BRWMCM
EndEvent

Event OnPLayerLoadGame()
	MCMQuest.Maint()
EndEvent