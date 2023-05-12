--- Automated Mining: gameObject.lua
--- @author earmuffs

local typeMaps = mjrequire "common/typeMaps"
local locale = mjrequire "common/locale"
local snapGroup = mjrequire "common/snapGroup"
local craftAreaGroup = mjrequire "common/craftAreaGroup"
local pathFinding = mjrequire "common/pathFinding"
local mjm = mjrequire "common/mjm"
local vec3 = mjm.vec3

local mod = {
    loadOrder = 1,
}

function mod:onload(gameObject)

	local automatedMining = mjrequire "automatedMining/automatedMining"
	automatedMining.gameObject = gameObject
	gameObject.automatedMining = automatedMining

	gameObject:addGameObject("mine", {
		name = locale:get("object_mine"),
		plural = locale:get("object_mine_plural"),
		modelName = "mine",
		scale = 1.0,
		isCraftArea = true,
		ignoreBuildRay = true,
		craftAreaGroupTypeIndex = craftAreaGroup.types.mine.index,
		hasPhysics = true,
		isBuiltObject = true,
		isPathFindingCollider = true,
		preventGrassAndSnow = true,
		disallowAnyCollisionsOnPlacement = true,
		iconOverrideIconModelName = "icon_mine_2",
		sapienLookAtOffset = vec3(0.0,mj:mToP(0.5),0.0),
		markerPositions = {
			{ 
				worldOffset = vec3(0.0, mj:mToP(0.8), 0.0)
			}
		},
	})

	gameObject:addGameObject("build_mine", {
		modelName = "mine",
		scale = 1.0,
		hasPhysics = true,
		isInProgressBuildObject = true,
		disallowAnyCollisionsOnPlacement = true,
		preventGrassAndSnow = true,
		ignoreBuildRay = true,
		iconOverrideIconModelName = "icon_mine_2",
		objectViewCameraOffsetFunction = function(object)
			return vec3(0.0,0.5,1.0)
		end,
		markerPositions = {
			{ 
				worldOffset = vec3(0.0, mj:mToP(0.8), 0.0)
			}
		}
	})
end

return mod