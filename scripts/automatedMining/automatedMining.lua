--- Automated Mining: automatedMining.lua
--- @author earmuffs

local typeMaps = mjrequire "common/typeMaps"
local locale = mjrequire "common/locale"

local resource = mjrequire "common/resource"

local mod = {
    resourceQueue = {},
    presetCount = 0,
}


local isAddingPresets = false

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
        if mod.gameObject.typeIndexMap[objectKey] then

            local alreadyExists = false
            for _, r in ipairs(mod.resourceQueue) do
                if r.objectKey == objectKey then
                    alreadyExists = true
                    break
                end
            end

            if not alreadyExists then
                mj:log("[Automated Mining] (automatedMining.lua:36) Queued craftable resource: " .. objectKey)

                if isAddingPresets then mod.presetCount = mod.presetCount + 1 end

                table.insert(mod.resourceQueue, {
                    objectKey = objectKey,
                    options = options,
                })
            else
                mj:log("[Automated Mining] (automatedMining.lua:42) Craftable resource already exists: " .. objectKey)
            end
        else
            mj:log("[Automated Mining] (automatedMining.lua:45) The resource type for '" .. objectKey .. "' does not exist. Skipping this object.")
        end
    else
        mj:log("[Automated Mining] (automatedMining.lua:48) No objectKey parameter was detected. Please visit automatedMine.lua for usage.")
    end
end


--- Adds preset resources to mines.
--  Runs when Automated Mining inits craftable.lua.
function mod:load(gameObject_)
    isAddingPresets = true

    
    if false then -- Enable this to view the example in-game

        -- Stone Pickaxe Example
        mod:addMineResource("stonePickaxe", {

            -- You can override this to change the recipe's display.
            template = "Build a {resource}",

            -- You can override this to change the gameObject's display name in the recipe.
            name = "Suspicious Stone Pickaxe",

            -- Unlike craftables, gameObjects don't have a summary, so we can add one.
            summary = "A good pick will last you a lifetime. Unfortunately, this one will break on you very quickly.",

            -- The cost in branches to craft this resource. This is 1 by default.
            cost = 5,
        })

    end


    -- Preset templates available:
    --   craftable_mine_template_mine     (default)
    --   craftable_mine_template_extract


    -- Add clay
    mod:addMineResource("clay", {
        template = locale:get("craftable_mine_template_extract"),
        cost = 3,
    })


    -- Add sands
    for _, sand in ipairs({"sand", "redSand", "riverSand"}) do
        mod:addMineResource(sand, {
            template = locale:get("craftable_mine_template_extract"),
            cost = 3,
        })
    end


    -- Add dirts
    mod:addMineResource("poorDirt", {
        template = locale:get("craftable_mine_template_extract"),
        cost = 2,
    })
    mod:addMineResource("dirt", {
        template = locale:get("craftable_mine_template_extract"),
        cost = 3,
    })
    mod:addMineResource("richDirt", {
        template = locale:get("craftable_mine_template_extract"),
        cost = 5,
    })


    -- Add rocks
    local rock = mjrequire "common/rock"
    for i, rockType in ipairs(rock.validTypes) do
        mod:addMineResource(rockType.objectTypeKey)
    end
    mod:addMineResource("flint", {
        cost = 2,
    })


    -- Add ores
    mod:addMineResource("copperOre", {
        cost = 4,
    })
    mod:addMineResource("tinOre", {
        cost = 4,
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