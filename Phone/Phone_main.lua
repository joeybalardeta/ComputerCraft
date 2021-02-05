-- name: DoorOpener_phone
-- version: 1.0
-- author: Joey Balardeta

-- pastebin get auBhNrqa startup

rednet.open("back")

while true do
    command = read()
    if command == "open vault" then
        rednet.send(4, "open sesame")
        event, id, message, distance = os.pullEvent("rednet_message")
        if id == 4 then
            print(message)
        end
    elseif command == "sample text" then
        print("Something cool")
    else
        print("Error! Command not recognized!")
    end
end