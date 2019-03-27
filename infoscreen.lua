local composer = require( "composer" ) --This is a composer file so need to require composer module
local scene = composer.newScene()
local starFieldGenerator = require("starfieldgenerator") -- A module that will generate starFieldGenerator
local starGenerator -- Single instance of the starFieldGenerator
local pushingText = require("pushingtext") -- Pushes text on the start screen, very dramatic


function scene:create( event )
	local group = self.view
	starGenerator =  starFieldGenerator.new(10,group,20)
	backButton = display.newImage("backButton.png",display.contentCenterX,display.contentCenterY+300)
	
	local invadersText =  pushingText.new( "Instructions",display.contentCenterX,display.contentCenterY-400,"InvaderCandyFont", 70,group )
    invadersText:setColor( 1, 1, 1 )
    invadersText:Pushtext()
	
	local infoText =  pushingText.new ("The aim of the game is to shoot all the",display.contentCenterX,display.contentCenterY-200,"", 40,group)
	local infoText2 =  pushingText.new("aliens, destroying all of the alien fleet will",display.contentCenterX,display.contentCenterY-150,"", 40,group)
	local infoText3 =  pushingText.new("progress you to the next level. You can",display.contentCenterX,display.contentCenterY-100,"", 40,group)
	local infoText4 =  pushingText.new("move left or right by tapping the onscreen",display.contentCenterX,display.contentCenterY-50,"", 40,group)
	local infoText5 =  pushingText.new(" arrow keys and tap anywhere to shoot.",display.contentCenterX,display.contentCenterY-0,"", 40,group)
	local infoText6 =  pushingText.new(" GOODLUCK! ",display.contentCenterX,display.contentCenterY+100,"", 40,group)
	
	group:insert(backButton)
end


function scene:show(event)
	local phase = event.phase
    local previousScene = composer.getSceneName( "previous" )
	if(previousScene~=nil) then

		composer.removeScene(previousScene)
	end
   if ( phase == "did" ) then
   backButton:addEventListener("tap",backHome)
   Runtime:addEventListener("enterFrame", starGenerator)
   end

end

function scene:hide( event )
		local phase = event.phase
		if ( phase == "will" ) then
    		backButton:removeEventListener("tap",backHome)
			Runtime:removeEventListener("enterFrame", starGenerator)
		end
end

function backHome()
composer.gotoScene("start")
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
return scene