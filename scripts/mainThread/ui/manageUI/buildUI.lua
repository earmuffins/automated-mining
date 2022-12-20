--- Automated Mining: buildUI.lua
--- @author earmuffs

local constructable = mjrequire "common/constructable"

local mod = {
    loadOrder = 30,
}

function mod:onload(buildUI)
    local super_createItemList = buildUI.createItemList
    buildUI.createItemList = function()
        super_createItemList()
        
        table.insert(buildUI.itemList, constructable.types.mine.index)
    end
end

return mod