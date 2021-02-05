-- name: SlaveTurtle_startup
-- version: 1.0
-- author: Joey Balardeta

-- pastebin get byiir7p9 startup

-- grab and run script
if fs.exists("Main") then
    shell.run("delete", "Main")
end
--shell.run("pastebin", "get", "DeUP6Kmc", "Main")
shell.run("copy", "/disk/Main", "Main")
shell.run("Main")