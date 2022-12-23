--- Automated Mining: inspectCraftPanel.lua
--- @author earmuffs

local gameObject = mjrequire "common/gameObject"
local constructable = mjrequire "common/constructable"

local rock = mjrequire "common/rock"

local mod = {
    loadOrder = 30,
}

function mod:onload(inspectCraftPanel)
    local super_load = inspectCraftPanel.load
    inspectCraftPanel.load = function(inspectCraftPanel_, serinspectUI_, inspectObjectUI_, world_, parentContainerView)
        inspectCraftPanel.itemLists[gameObject.typeIndexMap.mine] = {}

        for i, rockType in ipairs(rock.validTypes) do
            table.insert(inspectCraftPanel.itemLists[gameObject.typeIndexMap.mine], 1, constructable.types["mine_" .. rockType.objectTypeKey].index)
        end

        table.insert(inspectCraftPanel.itemLists[gameObject.typeIndexMap.mine], 1, constructable.types["mine_coal"].index)

        super_load(inspectCraftPanel_, serinspectUI_, inspectObjectUI_, world_, parentContainerView)
    end
end

return mod
