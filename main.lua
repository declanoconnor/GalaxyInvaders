--display.setStatusBar(display.HiddenStatusBar) --Here Incase I dont want it

display.setDefault( "anchorX", 0.5) --Anchor points
display.setDefault( "anchorY", 0.5)

background = display.newImageRect( "background.png", 960, 1710) --background image ofcourse
background:setFillColor( 0.1, 0.6, 0.7) -- tints background 
background.x = display.contentCenterX
background.y = display.contentCenterY

math.randomseed( os.time() ) --Random Gen


local gameData = require( "gamedata" ) --Require function adds module to package.load 
gameData.invaderNum = 1 --What level the game is on
gameData.maxLevels = 3 -- amount of levels (for future progression)
gameData.rowsOfInvaders = 3 -- how many rows of aliens
local composer = require ("composer")
--gameHasPlayed = false

--My splash Screen which works but breaks the game for an unsolvable reason!!

--[[
local options =
{
effect = "fade",
time = 2000,

}
composer.gotoScene("splash",options) -- Go to homepage basically
]]--

composer.gotoScene("start")