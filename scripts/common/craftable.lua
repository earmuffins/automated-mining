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

local rock = mjrequire "common/rock"

local mod = {
    loadOrder = 1,
}

function mod:onload(craftable)

    local super_load = craftable.load
    craftable.load = function(craftable_, gameObject, flora)
        super_load(craftable_, gameObject, flora)

        for i, rockType in ipairs(rock.validTypes) do

            local modelName = rockType.objectTypeKey
            if rockType.objectTypeKey == "rock" then
                modelName = modelName .. "1"
            end

            craftable:addCraftable("mine_" .. rockType.objectTypeKey, {
                name = locale:get("craftable_" .. rockType.objectTypeKey),
                plural = locale:get("craftable_" .. rockType.objectTypeKey .. "_plural"),
                summary = locale:get("craftable_" .. rockType.objectTypeKey .. "_summary"),
                iconGameObjectType = gameObject.typeIndexMap[rockType.objectTypeKey],
                classification = constructable.classifications.craft.index,

                addGameObjectInfo = {
                    resourceTypeIndex = resource.types.rock.index,
                    modelName = modelName,
                },
        
                buildSequence = craftable:createStandardBuildSequence(actionSequence.types.mine.index, tool.types.mine.index),
                inProgressBuildModel = "craftSimple",
                
                skills = {
                    required = skill.types.mining.index,
                },
                requiredResources = {
                    {
                        type = resource.types.branch.index,
                        count = 1,
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
        end
    end
end

return mod