# Automated Mining

Introduces mines, a workstation for renewable resources.

Join the [Discord Thread](https://discord.com/channels/982162184366862336/1054746343517732915)!

## Features
- `v0.0.6` Added stone blocks
- `v0.0.5` Added new ores, flint, and new stone types
- `v0.0.4` Added clay, sand, and dirt excavation
- `v0.0.4` Created QOL wrapper (with mod compatibility support, see below)

## Known Bugs
- `v0.0.6` Fixed recipes that didn't use the correct skills
- `v0.0.5` Fixed game crashing when multi-selecting mines
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
