-- name: MasterTurtle_main
-- version: 1.0
-- author: Joey Balardeta

-- pastebin get rtgPWh4f main


-- variables
local powerOn = false
local activeTurtles = 0
local maxTurtles = 0
local lanesMined = 0
local turtleSlot = 0
local mineMode = ""
-- local monitor = peripheral.find("monitor")


-- functions
function deploy(numTurtles)
    while turtle.detectUp() do
        local bool, data = turtle.inspectUp()
        if data then
            if data.name == "computercraft:turtle_normal" then
                os.sleep(0.5)
            end
        end
    end

    for i = 1, numTurtles, 1 do
        for j = 1, 16, 1 do
            turtle.select(j)
            local data = turtle.getItemDetail()
    
            if data then
                if data.name == "computercraft:turtle_normal" then
                    turtleSlot = j
                end
            end
        end
        turtle.select(turtleSlot)
        turtle.placeUp()
        peripheral.call("top", "turnOn")
        activeTurtles = activeTurtles + 1
        os.sleep(2)
    end


end


function mineLastTurtle()
    for i = 60, 0, -1 do
        print("Waiting for brothers: " .. i .. " seconds left.")
        os.sleep(1)
    end
    turtle.digUp()
    print("Done!")
end


-- main loop
print("Auto Turtle Mining OS v1.0")
print("---------------------------")


while true do
    maxTurtles = 0
    
    command = read()
    if command == "deploy" then
        for i = 1, 16, 1 do
            maxTurtles = maxTurtles + turtle.getItemCount(i)
        end
        print("Mining mode? (single, continous)")
        mineMode = read()
        print("Number of Turtles to deploy? (max " .. maxTurtles ..")")
        local n = read()
        if tonumber(n) > maxTurtles then
            n = 1
        end
        deploy(n)
    end

    if mineMode == "single" then
        if turtle.detectUp() then
            local bool, data = turtle.inspectUp()
            if data.name == "computercraft:turtle_normal" then
                mineLastTurtle()
            end
        end
    elseif mineMode == "continuous"
        if turtle.detectUp() then
            local bool, data = turtle.inspectUp()
            if data.name == "computercraft:turtle_normal" then
                local turtle = peripheral.wrap("top")
                turtle.shutdown()
                os.sleep(1)
                turtle.turnOn()
                os.sleep(10)
            end
        end
    end
end