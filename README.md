# ComputerCraft Turtle Scripts

## Phone Scripts
### main.lua
Scripts for all phone functions, interfacing with rednet, etc.

## Master Turtle Scripts
### startup.lua
Starts the main script on bootup
### main.lua
Auto Turtle Mining OS, can send commands to deploy turtles to the mine.

## Slave Turtle Scripts
### startup.lua
Rips main script from disk drive on boot, automatically starts the main script.
### main.lua
Goes into the mine and proceeds right until it finds an unmined z-lane, mines 100 blocks forward and returns to master turtle.

## Bridge Turtle Scripts
## main.lua
Creates a bridge with any blocks given for a specified length based on user input.

## Door Turtle Scripts
### reciever.lua
Recieves rednet messages from phones, sends redstone pulse on open vault message.