Scriptname BRWLowLightLevelScript extends ActiveMagicEffect

BRWMCM property Manager auto
Actor property playerRef auto
ImagespaceModifier[] LowLightList
Float[] LowLightPercentage
Float[] LowLightMaxMagnitude
Int ListSize = 0

Event OnEffectStart(Actor akTarget, Actor akCaster)
	LowLightList = new ImagespaceModifier[128]
	LowLightPercentage = new Float[128]
	LowLightMaxMagnitude = new Float[128]
	int i
	While (i < 128)
		If (Manager.LowLightList[i] != None)
			LowLightList[ListSize] = Manager.LowLightList[i]
			LowLightPercentage[ListSize] = Manager.LowLightPercentage[i]
			LowLightMaxMagnitude[ListSize] = Manager.LowLightMaxMagnitude[i]
			ListSize += 1
		EndIf
		i += 1
	EndWhile
	If (ListSize > 0)
    	RegisterForSingleUpdate(1)
	EndIf
EndEvent

Event OnUpdate()
	int i = 0
	While (i < ListSize)
		LowLightList[i].PopTo(LowLightList[i], LowLightMaxMagnitude[i]-((playerRef.GetLightLevel()/150)*(1/LowLightPercentage[i])))
		i += 1
	EndWhile
    RegisterForSingleUpdate(1)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	int i = 0
	While (i < ListSize)
		LowLightList[i].Remove()
		i += 1
	EndWhile
EndEvent