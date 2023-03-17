--- Automated Mining: craftable.lua
--- @author earmuffs

local typeMaps = mjrequire "common/typeMaps"
local locale = mjrequire "common/locale"

local constructable = mjrequire "common/constructable"
local craftAreaGroup = mjrequire "common/craftAreaGroup"
local snapGroup = mjrequire "common/snapGroup"
local resource = mjrequire "common/resource"
local skill = mjrequire "common/skill"
local tool = mjrequire "common/tool"
local action = mjrequire "common/action"
local actionSequence = mjrequire "common/actionSequence"

local automatedMining = mjrequire "automatedMining/automatedMining"

local mod = {
    loadOrder = 50,
}

function mod:onload(craftable)

    local super_load = craftable.load
    craftable.load = function(craftable_, gameObject, flora)
        super_load(craftable_, gameObject, flora)

        -- Load packaged mine resources
        automatedMining:load(gameObject)

        mj:log("[Automated Mining] (craftable.lua:31) Creating craftables...")

        -- Add each resource in the resourceQueue to the Mine crafting area
        for i, res in ipairs(automatedMining.resourceQueue) do

            local temp = (res.options and res.options.template) or locale:get("craftable_mine_template_mine")
            local name = (res.options and res.options.name) or locale:get("object_" .. res.objectKey)
            name = temp:gsub("{resource}", name)

            craftable:addCraftable("mine_" .. res.objectKey, {
                name = name,
                plural = name,
                summary = (res.options and res.options.summary) or locale:get("craftable_mine_summary"),
                iconGameObjectType = gameObject.typeIndexMap[res.objectKey],
                classification = constructable.classifications.craft.index,

                outputObjectInfo = {
                    objectTypesArray = {
                        gameObject.typeIndexMap[res.objectKey]
                    }
                },
        
                buildSequence = craftable:createStandardBuildSequence(actionSequence.types.mine.index, tool.types.mine.index),
                inProgressBuildModel = "craftSimple",
                
                skills = {
                    required = skill.types.mining.index,
                },
                requiredResources = {
                    {
                        type = resource.types.branch.index,
                        count = (res.options and res.options.cost) or 1,
                        afterAction = {
                            actionTypeIndex = action.types.pickup.index,
                            duration = 1.0,
                        }
                    },
                },
                requiredTools = {
                    tool.types.mine.index,
                },
                requiredCraftAreaGroups = {
                    craftAreaGroup.types.mine.index,
                },
            })

            mj:log("[Automated Mining] (craftable.lua:77) Created craftable resource: " .. res.objectKey)
        end

        local totalCount = #automatedMining.resourceQueue
        local presetCount = automatedMining.presetCount
        local customCount = totalCount - presetCount
        mj:log("[Automated Mining] (craftable.lua:80) Craftables created: " .. totalCount .. " (" .. presetCount .. " packaged / " .. customCount .. " custom)")
    end
end

return mod