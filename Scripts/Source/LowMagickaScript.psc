Scriptname LowMagickaScript extends ActiveMagicEffect  

ImageSpaceModifier Property BRWLowMagicka auto
Actor Property playerRef auto
Globalvariable property LowMagickaPercent auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    RegisterForSingleUpdate(1)
EndEvent

Event OnUpdate()
    ;What value can we multiply BRWLowMagicka by to get the player's magicka percentage on a scale of 0 to 1 instead of 0 to LowMagickaPercent
    ;Multiply the percentage of magica by our magnitude to get the percentage of magicka remaining less than LowMagickaPercent on a scale from 0 to 1
    BRWLowMagicka.PopTo(BRWLowMagicka, 1-(playerRef.GetActorValuePercentage("Magicka")*(1/LowMagickaPercent.GetValue())))
    RegisterForSingleUpdate(1)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    BRWLowMagicka.Remove()
EndEvent