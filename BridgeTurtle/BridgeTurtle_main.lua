-- name: BridgeTurtle_main
-- version: 1.0
-- author: Joey Balardeta

-- pastebin get V5EKmFdu main

-- variables

local materialSlot = 1 -- initial material slot
local outOfBlocks = false


-- refuel turtle, checks all slots
function refuel()
    for i = 1, 16, 1 do
        turtle.select(i)
        local data = turtle.getItemDetail()
        if data then
            if data.name == "minecraft:coal" or data.name == "minecraft:coal_block" or data.name == "minecraft:charcoal" then
                turtle.refuel()
            end
        end
    end

    print("Fuel Level: " .. turtle.getFuelLevel())
end



function findMaterial()
    local stacks = 0
    for i = 1, 16, 1 do
        turtle.select(i)
        local data = turtle.getItemDetail()

        if data then
            stacks = stacks + 1
            materialSlot = i
        end
    end
    turtle.select(materialSlot)

    if stacks == 0 then
        outOfBlocks = true
    end
end


function bridge()
    print("How many blocks to bridge? (integer)")
    dist = read()
    dist = tonumber(dist)
    if dist < 1 then
        dist = 10
    elseif dist > 499 then
        dist = 10
    end


    print("Creating bridge for " .. dist .. " blocks.")

    for i = 1, dist, 1 do
        turtle.forward()
        local bool = turtle.placeDown()
        if not bool then
            findMaterial()
            turtle.placeDown()
        end

        if outOfBlocks then
            return
        end
    end
end


function main()
    refuel() 
    bridge()

    turtle.back()
    turtle.back()
    turtle.back()


end




main()