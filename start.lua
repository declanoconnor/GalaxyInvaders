local composer = require( "composer" ) --This is a composer file so need to require composer module
local scene = composer.newScene()

local infoButton
local startButton -- Self explanatory
local pushingText = require("pushingtext") -- Pushes text on the start screen, very dramatic
local starFieldGenerator = require("starfieldgenerator") -- A module that will generate starFieldGenerator
local starGenerator -- Single instance of the starFieldGenerator

function scene:create( event )

	local group = self.view
	starGenerator =  starFieldGenerator.new(10,group,20)
	
	startButton = display.newImage("new_game_btn.png",display.contentCenterX,display.contentCenterY+80)
    group:insert(startButton)
	
	infoButton = display.newImage("instructionsButton.png",display.contentCenterX,display.contentCenterY+180)
    group:insert(infoButton)
	
	optionsButton = display.newImage("options.png",display.contentCenterX,display.contentCenterY+280)
    group:insert(optionsButton)
	
    local invadersText =  pushingText.new( "Galaxy war",display.contentCenterX,display.contentCenterY-200,"InvaderCandyFont", 70,group )
    invadersText:setColor( 1, 1, 1 )
    invadersText:Pushtext()
	
	local invadersText =  pushingText.new( "Declan O'Connor - IT Lua Project 2017 © Alpha Build 2.3",display.contentCenterX,display.contentCenterY+540,"", 25,group)
	
end

function scene:show(event)
	local phase = event.phase
    local previousScene = composer.getSceneName( "previous" )
	if(previousScene~=nil) then
		composer.removeScene(previousScene)
	end
	
	if ( phase == "did" ) then
	startButton:addEventListener("tap",startGame)
	infoButton:addEventListener("tap",startInfo)
	optionsButton:addEventListener("tap",startOptions)
	Runtime:addEventListener("enterFrame", starGenerator)
	end
end

function scene:hide( event )
		local phase = event.phase
		if ( phase == "will" ) then
    		startButton:removeEventListener("tap",startGame)
			infoButton:removeEventListener("tap",startInfo)
			optionsButton:removeEventListener("tap",startOptions)
			Runtime:removeEventListener("enterFrame", starGenerator)
			end
end

function startGame()
composer.gotoScene("gamelevel")
end

function startInfo()
composer.gotoScene("infoscreen")
end

function startOptions()
composer.gotoScene("optionscreen")
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
return scene