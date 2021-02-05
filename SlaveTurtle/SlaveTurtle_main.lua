-- name: SlaveTurtle_main
-- version: 1.5
-- author: Joey Balardeta

-- pastebin get DeUP6Kmc main


-----------------------------------------------------------------------------------------------------------------
-- variables
local xOrig, yOrig, zOrig = 0, 63, 0
local x, y, z = 0, 63, 0
local botNumber = 0
local items = 0
local fuel = 0
local facingDir = "West"
notFoundLane = true

local unwantedBlocks = {"minecraft:dirt", "minecraft:gravel", "minecraft:cobblestone", "minecraft:flint", "minecraft:granite", "minecraft:basalt", "minecraft:stone",
                        "chisel:marble2", "chisel:limestone2"}

local valuableBlocks = {"minecraft:coal_ore", "minecraft:diamond_ore", "minecraft:gold_ore", "minecraft:iron_ore", "minecraft:emerald_ore", "minecraft:lapis_ore", "minecraft:redstone_ore", "minecraft:andesite"}

local valuableItems = {}

-----------------------------------------------------------------------------------------------------------------
-- functions

-- set bot number from master computer
function setBotNumber(n)
    botNumber = n
end

-- move bot forward
function forward()
    local success, error = turtle.forward()

    while not success do
        turtle.dig()
        success, error = turtle.forward()
    end

    if facingDir == "North" then
        z = z + 1
        return
    end
    if facingDir == "East" then
        x = x + 1
        return
    end
    if facingDir == "South" then
        z = z - 1
        return
    end
    if facingDir == "West" then
        x = x - 1
        return
    end
end

-- turn bot left
function left()
    turtle.turnLeft()
    if facingDir == "North" then
        facingDir = "West"
        return
    end
    if facingDir == "East" then
        facingDir = "North"
        return
    end
    if facingDir == "South" then
        facingDir = "East"
        return
    end
    if facingDir == "West" then
        facingDir = "South"
        return
    end
end

-- turn bot right
function right()
    turtle.turnRight()
    if facingDir == "North" then
        facingDir = "East"
        return
    end
    if facingDir == "East" then
        facingDir = "South"
        return
    end
    if facingDir == "South" then
        facingDir = "West"
        return
    end
    if facingDir == "West" then
        facingDir = "North"
        return
    end
end

-- refuel turtle, checks all slots
function refuel()
    for i = 1, 16, 1 do
        turtle.select(i)
        local data = turtle.getItemDetail()
        if data then
            if data.name == "minecraft:coal" or data.name == "minecraft:coal_block" then
                turtle.refuel()
            end
        end
    end
end

-- mine to y = 11
function toMines()
    forward()
    forward()
    forward()

    for i = y, 12, -1 do
    
        if turtle.detectDown() then
            local bool, data = turtle.inspectDown()
            if data.name == "computercraft:turtle_normal" then
                os.sleep(2)
            end
        end
        turtle.digDown()
        turtle.down()
        y = y - 1
    end
end

-- return to the surface
function toSurface()
    for i = 12, yOrig, 1 do
    
        local success, error = turtle.up()

        while not success do
            if turtle.detectUp() then
                local bool, data = turtle.inspectUp()
                if data.name == "computercraft:turtle_normal" then
                    os.sleep(2)
                end
            end
            turtle.digUp()
            success, error = turtle.up()
        end
        y = y + 1
    end

    dropUnwantedItems()

    print("Location: " .. x .. " " .. y .. " " .. z)
    

    if x < xOrig+5 then
        right()
        for i = x, xOrig+5, 1 do
            forward()
        end
        right()

    elseif x > xOrig+5 then
        left()
        for i = x, xOrig+7, -1 do
            forward()
        end
        left()
    else
        right()
        right()
    end
    print("Location: " .. x .. " " .. y .. " " .. z)

    for i = z, zOrig+1, -1 do
        forward()
    end

    emptyToChest()
    right()

    for i = x, xOrig+1, -1 do
        forward()
    end
end

-- mine a 1x2 
function mine(n)
    if turtle.detectDown() then
        local bool, data = turtle.inspectDown()
        for i = 1, table.getn(valuableBlocks), 1 do
            if data.name == valuableBlocks[i] then
                turtle.digDown()
            end
        end
    end
    for i = 1, n, 1 do
        if turtle.detect() then
            local bool, data = turtle.inspect()
            if data.name == "computercraft:turtle_normal" then
                os.sleep(2)
            end
            turtle.dig()
            
        end

        forward()

        if turtle.detectUp() then
            turtle.digUp()
        end
    end

    if not (fuel > (x + z + yOrig - y)*2) or (items == 16) then
        if (fuel > (x + z + yOrig - y)*2) then
            print("Out of fuel! Returning to surface.")
        end

        if (items == 16) then
            print("Inventory full! Returning to surface.")
        end

        return
    end
end

function mineBlock(l, w)
    for i = 1, w, 1 do
        mine(l-1)

        if i ~= w and math.fmod(i, 2) == 1 then
            right()
            mine(1)
            right()
        end

        if i ~= w and math.fmod(i, 2) == 0 then
            left()
            mine(1)
            left()
        end
        dropUnwantedItems()
    end
end

-- drop items in unwanted items list
function dropUnwantedItems()
    items = 0
    for i = 1, 16, 1 do
        turtle.select(i)
        local data = turtle.getItemDetail()

        if data then
            items = items + 1
            for i = 1, table.getn(unwantedBlocks), 1 do
                if data.name == unwantedBlocks[i] then
                    items = items - 1
                    turtle.drop()
                end
            end
        end
    end
end


function emptyToChest()
    for i = 1, 16, 1 do
        turtle.select(i)
        turtle.dropDown()
    end
end

-----------------------------------------------------------------------------------------------------------------
-- main function

function main()
    -------------------------------------------------------------------------------------------------------------
    -- starting commands
    notFoundLane = true

    -- take coal block from chest on side of turtle
    if turtle.getFuelLevel() < 800 then
        turtle.suck(1)
    end

    refuel()
    fuel = turtle.getFuelLevel()
    print("Fuel Level: " .. tostring(fuel))



    -- function calls
    right()
    toMines()
    while notFoundLane do
        if turtle.detect() then
            local bool, data = turtle.inspect()
            if data.name == "computercraft:turtle_normal" then
            else
                notFoundLane = false
            end
        end
        if notFoundLane then
            right()
            mine(1)
            left()
        end
    end
    mine(100)
    toSurface()
end


main()