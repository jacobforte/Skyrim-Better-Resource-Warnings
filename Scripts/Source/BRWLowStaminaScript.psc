Scriptname BRWLowStaminaScript extends ActiveMagicEffect

BRWMCM property Manager auto
Actor property playerRef auto
ImagespaceModifier[] LowStaminaList
Float[] LowStaminaPercentage
Float[] LowStaminaMaxMagnitude
Int ListSize = 0

Event OnEffectStart(Actor akTarget, Actor akCaster)
	LowStaminaList = new ImagespaceModifier[128]
	LowStaminaPercentage = new Float[128]
	LowStaminaMaxMagnitude = new Float[128]
	int i
	While (i < 128)
		If (Manager.LowStaminaList[i] != None)
			LowStaminaList[ListSize] = Manager.LowStaminaList[i]
			LowStaminaPercentage[ListSize] = Manager.LowStaminaPercentage[i]
			LowStaminaMaxMagnitude[ListSize] = Manager.LowStaminaMaxMagnitude[i]
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
		LowStaminaList[i].PopTo(LowStaminaList[i], LowStaminaMaxMagnitude[i]-(playerRef.GetActorValuePercentage("Stamina")*(1/LowStaminaPercentage[i])))
		i += 1
	EndWhile
    RegisterForSingleUpdate(1)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	int i = 0
	While (i < ListSize)
		LowStaminaList[i].Remove()
		i += 1
	EndWhile
EndEvent