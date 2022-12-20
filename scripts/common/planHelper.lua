--- Automated Mining: planHelper.lua
--- @author earmuffs

local gameObject = mjrequire "common/gameObject"
local plan = mjrequire "common/plan"

local mod = {
    loadOrder = 10,
}

function mod:onload(planHelper)
    function planHelper:availablePlansForMines(objectInfos, tribeID)

        local queuedPlanInfos = planHelper:getQueuedPlanInfos(objectInfos, tribeID, false)

        local craftPlanInfo = {
            planTypeIndex = plan.types.craft.index,
        }
        local hash = planHelper:getPlanHash(craftPlanInfo)
        local availablePlanCounts = {
            [hash] = #objectInfos
        }
    
        planHelper:addPlanExtraInfo(craftPlanInfo, queuedPlanInfos, availablePlanCounts)

        local plans = {
            craftPlanInfo,
        }
        

        local clonePlanInfo = planHelper:getClonePlanInfo(objectInfos, tribeID)
        table.insert(plans, clonePlanInfo)
        
        --local deconstructionPlanInfo = planHelper:getDeconstructionPlanInfo(objectInfos, tribeID, false)
        --table.insert(plans, deconstructionPlanInfo)
        
        return plans
    end

    planHelper.availablePlansFunctionsByObjectType[gameObject.types.mine.index] = planHelper.availablePlansForMines
end

return mod