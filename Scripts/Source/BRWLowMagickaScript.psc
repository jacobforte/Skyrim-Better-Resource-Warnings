Scriptname BRWLowMagickaScript extends ActiveMagicEffect  

BRWMCM property Manager auto
Actor property playerRef auto
ImagespaceModifier[] LowMagickaList
Float[] LowMagickaPercentage
Float[] LowMagickaMaxMagnitude
Int ListSize = 0

Event OnEffectStart(Actor akTarget, Actor akCaster)
	LowMagickaList = new ImagespaceModifier[128]
	LowMagickaPercentage = new Float[128]
	LowMagickaMaxMagnitude = new Float[128]
	int i
	While (i < 128)
		If (Manager.LowMagickaList[i] != None)
			LowMagickaList[ListSize] = Manager.LowMagickaList[i]
			LowMagickaPercentage[ListSize] = Manager.LowMagickaPercentage[i]
			LowMagickaMaxMagnitude[ListSize] = Manager.LowMagickaMaxMagnitude[i]
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
		float playerMagicka = playerRef.GetActorValuePercentage("Magicka")
		If (playerMagicka < 0)
			playerMagicka = 0
		EndIf

		LowMagickaList[i].PopTo(LowMagickaList[i], LowMagickaMaxMagnitude[i]-(playerMagicka*(1/LowMagickaPercentage[i])))
		i += 1
	EndWhile
    RegisterForSingleUpdate(1)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	int i = 0
	While (i < ListSize)
		LowMagickaList[i].Remove()
		i += 1
	EndWhile
EndEvent