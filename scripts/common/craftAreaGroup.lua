--- Automated Mining: craftAreaGroup.lua
--- @author earmuffs

local typeMaps = mjrequire "common/typeMaps"

local mod = {
    loadOrder = 1,
}

function mod:onload(craftAreaGroup)
    typeMaps:insert("craftAreaGroup", craftAreaGroup.types, {
        key = "mine",
    })
end

return mod