--- Automated Mining: craftable.lua
--- @author earmuffs

local typeMaps = mjrequire "common/typeMaps"
local locale = mjrequire "common/locale"

local constructable = mjrequire "common/constructable"
local craftAreaGroup = mjrequire "common/craftAreaGroup"
local snapGroup = mjrequire "common/snapGroups/snapGroup"
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

            local temp = (res.options and res.options.template.verb) or locale:get("craftable_mine_template_mine")
            local name = (res.options and res.options.name) or locale:get("object_" .. res.objectKey)
            name = temp:gsub("{resource}", name)

            local outputArray = {}
            for o = 1, (res.options and res.options.count) or 1, 1 do
                table.insert(outputArray, gameObject.typeIndexMap[res.objectKey])
            end

            local actionSeq = (res.options and res.options.template and res.options.template.actionSequence) or actionSequence.types.mine.index
            local requiredSkill = (res.options and res.options.template and res.options.template.skill) or skill.types.mining.index
            local requiredTool = (res.options and res.options.template and res.options.template.tool) or tool.types.mine.index

            craftable:addCraftable("mine_" .. res.objectKey, {
                name = name,
                plural = name,
                summary = (res.options and res.options.summary) or locale:get("craftable_mine_summary"),
                iconGameObjectType = gameObject.typeIndexMap[res.objectKey],
                classification = constructable.classifications.craft.index,

                outputObjectInfo = {
                    objectTypesArray = outputArray
                },
        
                buildSequence = craftable:createStandardBuildSequence(actionSeq, requiredTool),
                inProgressBuildModel = "craftSimple",
                
                outputDisplayCount = (res.options and res.options.count) or nil,

                skills = {
                    required = requiredSkill,
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
                    requiredTool,
                },
                requiredCraftAreaGroups = {
                    craftAreaGroup.types.mine.index,
                },
            })

            mj:log("[Automated Mining] (craftable.lua:86) Created craftable resource: " .. res.objectKey)
        end

        local totalCount = #automatedMining.resourceQueue
        local presetCount = automatedMining.presetCount
        local customCount = totalCount - presetCount
        mj:log("[Automated Mining] (craftable.lua:92) Craftables created: " .. totalCount .. " (" .. presetCount .. " packaged / " .. customCount .. " custom)")
    end
end

return mod