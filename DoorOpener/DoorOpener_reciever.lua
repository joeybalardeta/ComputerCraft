-- name: DoorOpener_reciever
-- version: 1.0
-- author: Joey Balardeta

-- pastebin get C6TntymN startup

rednet.open("right")

while true do
    event, id, message, distance = os.pullEvent("rednet_message")
    if (id == 2 or id == 3) and message == "open sesame" then
        rednet.send(id, "[DoorTurtle]: Opening/closing door")
        redstone.setOutput("front", true)
        os.sleep(0.1)
        redstone.setOutput("front", false)
    end
end