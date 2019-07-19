Scriptname BRWUndetectedScript extends ActiveMagicEffect

BRWMCM property Manager auto
Actor property playerRef auto
ImagespaceModifier[] UndetectedList
Int ListSize = 0

Event OnEffectStart(Actor akTarget, Actor akCaster)
	int i
	While (i < 128)
		If (Manager.UndetectedList[i] != None)
			UndetectedList[ListSize] = Manager.UndetectedList[i]
			UndetectedList[ListSize].PopTo(UndetectedList[ListSize], Manager.UndetectedMaxMagnitude[i])
			ListSize += 1
		EndIf
		i += 1
	EndWhile
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	int i = 0
	While (i < ListSize)
		UndetectedList[i].Remove()
		i += 1
	EndWhile
EndEvent