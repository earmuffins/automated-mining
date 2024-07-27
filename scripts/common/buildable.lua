--- Automated Mining: buildable.lua
--- @author earmuffs

local typeMaps = mjrequire "common/typeMaps"
local locale = mjrequire "common/locale"

local constructable = mjrequire "common/constructable"
local snapGroup = mjrequire "common/snapGroup"
local resource = mjrequire "common/resource"
local skill = mjrequire "common/skill"
local plan = mjrequire "common/plan"
local action = mjrequire "common/action"

local mod = {
    loadOrder = 10,
}

local clearObjectsAndTerrainSequence = {
    {
        constructableSequenceTypeIndex = constructable.sequenceTypes.clearObjects.index,
    },
    {
        constructableSequenceTypeIndex = constructable.sequenceTypes.clearTerrain.index
    },
    {
        constructableSequenceTypeIndex = constructable.sequenceTypes.clearObjects.index,
    },
    {
        constructableSequenceTypeIndex = constructable.sequenceTypes.bringResources.index,
    },
    {
        constructableSequenceTypeIndex = constructable.sequenceTypes.bringTools.index,
    },
    {
        constructableSequenceTypeIndex = constructable.sequenceTypes.moveComponents.index,
    },
}

function mod:onload(buildable)
    buildable:addBuildable("mine", {
        modelName = "mine",
        inProgressGameObjectTypeKey = "build_mine",
        finalGameObjectTypeKey = "mine",
        name = locale:get("buildable_mine"),
        plural = locale:get("buildable_mine_plural"),
        summary = locale:get("buildable_mine_summary"),
        classification = constructable.classifications.build.index,

        allowYTranslation = false,
        noBuildUnderWater = true,
        requiresSlopeCheck = true,
        allowBuildEvenWhenDark = true,
        
        skills = {
            required = skill.types.mining.index,
        },
    
        buildSequence = clearObjectsAndTerrainSequence,
    
        requiredResources = {
            {
                type = resource.types.rock.index,
                count = 12,
                afterAction = {
                    actionTypeIndex = action.types.patDown.index,
                }
            }
        },
    })
end

return mod