--- Automated Mining: automatedMining.lua
--- @author earmuffs

local typeMaps = mjrequire "common/typeMaps"
local locale = mjrequire "common/locale"

local resource = mjrequire "common/resource"
local skill = mjrequire "common/skill"
local tool = mjrequire "common/tool"
local actionSequence = mjrequire "common/actionSequence"

local mod = {
    resourceQueue = {},
    presetCount = 0,
}


local isAddingPresets = false


local mineTemplate = {
    verb = locale:get("craftable_mine_template_mine"),
    actionSequence = actionSequence.types.mine.index,
    tool = tool.types.mine.index,
    skill = skill.types.mining.index,
}

local extractTemplate = {
    verb = locale:get("craftable_mine_template_extract"),
    actionSequence = actionSequence.types.mine.index,
    tool = tool.types.mine.index,
    skill = skill.types.digging.index,
}

local chiselSoftTemplate = {
    verb = locale:get("craftable_mine_template_cut"),
    actionSequence = actionSequence.types.chiselStone.index,
    tool = tool.types.softChiselling.index,
    skill = skill.types.chiselStone.index,
}

local chiselHardTemplate = {
    verb = locale:get("craftable_mine_template_cut"),
    actionSequence = actionSequence.types.chiselStone.index,
    tool = tool.types.hardChiselling.index,
    skill = skill.types.chiselStone.index,
}


--- Add resources to mines with one simple function call.
--  See the load function below for examples.
--
--  objectKey:   (Required) The key of the item's gameObject. Example: stonePickaxe.
--  options {
--      template:  (Optional) By default, this value is "Mine [resource]". Change it to alter how this recipe will be displayed.
--      name:      (Optional) Overrides the name of the item.
--      summary:   (Optional) Gives a summary of the item in the crafting menu.
--      cost:      (Optional) The number of branches required to craft this item.
--  }
function mod:addMineResource(objectKey, options)
    if objectKey then
        if mod.gameObject.types[objectKey] then

            local alreadyExists = false
            for _, r in ipairs(mod.resourceQueue) do
                if r.objectKey == objectKey then
                    alreadyExists = true
                    break
                end
            end

            if not alreadyExists then
                
                if isAddingPresets then mod.presetCount = mod.presetCount + 1 end

                if not options then options = {} end
                if not options.template then options.template = mineTemplate end

                table.insert(mod.resourceQueue, 1, {
                    objectKey = objectKey,
                    options = options,
                })

                mj:log("[Automated Mining] (automatedMining.lua:84) Queued craftable resource: " .. objectKey)
            else
                mj:log("[Automated Mining] (automatedMining.lua:86) Craftable resource already exists: " .. objectKey)
            end
        else
            mj:log("[Automated Mining] (automatedMining.lua:89) The gameObject for '" .. objectKey .. "' does not exist. Skipping this resource.")
        end
    else
        mj:log("[Automated Mining] (automatedMining.lua:92) No objectKey parameter was detected. Please visit automatedMine.lua for usage.")
    end
end


--- Adds preset resources to mines.
--  Runs when Automated Mining inits craftable.lua.
function mod:load(gameObject_)
    isAddingPresets = true

    
    if false then -- Enable this to view the example in-game

        -- Stone Pickaxe Example
        mod:addMineResource("stonePickaxe", {

            -- You can override this to change the recipe's type. This is mineTemplate by default.
            template = extractTemplate,

            -- You can override this to change the gameObject's display name in the recipe.
            name = "Suspicious Stone Pickaxe",

            -- Unlike craftables, gameObjects don't have a summary, so we can add one.
            summary = "A good pick will last you a lifetime. Unfortunately, this one will break on you very quickly.",

            -- The number of resources this recipe will produce. This is 1 by default.
            count = 2,

            -- The cost in branches to craft this resource. This is 1 by default.
            cost = 5,
        })

    end


    -- Add ores
    mod:addMineResource("copperOre", {
        cost = 4,
    })
    mod:addMineResource("tinOre", {
        cost = 4,
    })


    -- Add flint
    mod:addMineResource("flint", {
        count = 2,
        cost = 3,
    })


    -- Add rocks and blocks
    local rock = mjrequire "common/rock"
    for i, rockType in ipairs(rock.validTypes) do

        -- Rocks
        mod:addMineResource(rockType.objectTypeKey)

        -- Stone blocks
        if rockType.stoneBlockTypeKey then
            mod:addMineResource(rockType.stoneBlockTypeKey, {
                template = rockType.isSoftRock and chiselSoftTemplate or chiselHardTemplate,
                cost = 2,
            })
        end
    end

    
    -- Add dirts
    mod:addMineResource("poorDirt", {
        template = extractTemplate,
        cost = 2,
    })
    mod:addMineResource("dirt", {
        template = extractTemplate,
        cost = 3,
    })
    mod:addMineResource("richDirt", {
        template = extractTemplate,
        cost = 5,
    })


    -- Add sands
    for _, sand in ipairs({"sand", "redSand", "riverSand"}) do
        mod:addMineResource(sand, {
            template = extractTemplate,
            cost = 3,
        })
    end

    
    -- Add clay
    mod:addMineResource("clay", {
        template = extractTemplate,
        cost = 3,
    })


    -- Built-in support for Coal Mod by niCoke
    local coal = resource.types["coal"]
    if coal then
        mod:addMineResource(coal.key, {
            name = "Coal",
            summary = "Used as fuel in torches, campfires, and kilns.",
        })
    end

    
    isAddingPresets = false
end

return mod