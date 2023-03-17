--- Automated Mining: inspectCraftPanel.lua
--- @author earmuffs

local gameObject = mjrequire "common/gameObject"
local constructable = mjrequire "common/constructable"
local resource = mjrequire "common/resource"

local automatedMining = mjrequire "automatedMining/automatedMining"

local mod = {
    loadOrder = 50,
}

function mod:onload(inspectCraftPanel)
    local super_load = inspectCraftPanel.load
    inspectCraftPanel.load = function(inspectCraftPanel_, serinspectUI_, inspectObjectUI_, world_, parentContainerView)
        inspectCraftPanel.itemLists[gameObject.typeIndexMap.mine] = {}

        -- Load an item for each resource in the queue
        for i, res in ipairs(automatedMining.resourceQueue) do
            table.insert(inspectCraftPanel.itemLists[gameObject.typeIndexMap.mine], 1, constructable.types["mine_" .. res.objectKey].index)
        end

        mj:log("[Automated Mining] (inspectCraftPanel.lua:24) Crafting panel objects loaded.")

        super_load(inspectCraftPanel_, serinspectUI_, inspectObjectUI_, world_, parentContainerView)
    end
end

return mod
