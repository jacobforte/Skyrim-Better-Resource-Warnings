Scriptname BRWLowHealthScript extends ActiveMagicEffect

BRWMCM property Manager auto
Actor property playerRef auto
ImagespaceModifier[] LowHealthList
Float[] LowHealthPercentage
Float[] LowHealthMaxMagnitude
Int ListSize = 0

Event OnEffectStart(Actor akTarget, Actor akCaster)
	LowHealthList = new ImagespaceModifier[128]
	LowHealthPercentage = new Float[128]
	LowHealthMaxMagnitude = new Float[128]
	int i
	While (i < 128)
		If (Manager.LowHealthList[i] != None)
			LowHealthList[ListSize] = Manager.LowHealthList[i]
			LowHealthPercentage[ListSize] = Manager.LowHealthPercentage[i]
			LowHealthMaxMagnitude[ListSize] = Manager.LowHealthMaxMagnitude[i]
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
		LowHealthList[i].PopTo(LowHealthList[i], LowHealthMaxMagnitude[i]-(playerRef.GetActorValuePercentage("Health")*(1/LowHealthPercentage[i])))
		i += 1
	EndWhile
    RegisterForSingleUpdate(1)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	int i = 0
	While (i < ListSize)
		LowHealthList[i].Remove()
		i += 1
	EndWhile
EndEvent