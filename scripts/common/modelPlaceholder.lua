--- Automated Mining: modelPlaceholder.lua
--- @author earmuffs

local gameObject = mjrequire "common/gameObject"
local model = mjrequire "common/model"
local resource = mjrequire "common/resource"

local mod = {
    loadOrder = 1,
}

function mod:onload(modelPlaceholder)
    local super_initRemaps = modelPlaceholder.initRemaps
    modelPlaceholder.initRemaps = function()
		super_initRemaps()

		modelPlaceholder:addModel("mine", {
			{
				multiKeyBase = "rock",
				multiCount = 12,
				defaultModelName = "rock1",
				resourceTypeIndex = resource.types.rock.index,
				offsetToWalkableHeight = true,
				rotateToWalkableRotation = true,
			},
			{
				key = "mine_hole",
				defaultModelName = "mine_hole",
				offsetToWalkableHeight = true,
				rotateToWalkableRotation = true,
			},
			{
				key = "mine_ladder",
				defaultModelName = "mine_ladder",
			},
			{
				key = "rock_store",
				offsetToStorageBoxWalkableHeight = true,
			},
			{
				key = "branch_store",
				offsetToStorageBoxWalkableHeight = true,
			},
		})
    end
end

return mod