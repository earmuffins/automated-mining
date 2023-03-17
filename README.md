# Automated Mining

Introduces mines, a workstation for renewable resources.

Join the [Discord Thread](https://discord.com/channels/982162184366862336/1054746343517732915)!

## Done
- Added clay, sand, and dirt excavation
- Created wrapper to add Mine recipes from resources (mod compatibility support)

## Planned
- Better game balance
- Improve workstation appearance

## Known Bugs
- Ladder and mineshaft disappear once Mine is constructed

## Mod Support
Adding your own resources is recommended in your craftable.lua shadow:
```lua
function mod:onload(craftable)
    local super_load = craftable.load
    craftable.load = function(craftable_, gameObject, flora)
        super_load(craftable_, gameObject, flora)

        local am = gameObject.automatedMining
        if am then
            am:addMineResource("mithrilOre", {
                name = "Mithril Ore",
                summary = "Usually only obtainable by raiding dwarven foundries or befriending old hobbits.",
            })
        end

        -- Do your thing down here
    end
end
```
