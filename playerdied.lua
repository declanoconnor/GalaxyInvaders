local composer = require("composer")
local scene = composer.newScene()
local starFieldGenerator = require("starfieldgenerator")
local pushingText = require("pushingtext")
local backButton
local starGenerator

function scene:create( event )
    local group = self.view
    starGenerator =  starFieldGenerator.new(200,group,5)
    local   invadersText =  pushingText.new("GAME OVER", display.contentCenterX, display.contentCenterY-200,"", 20,group )
    invadersText:setColor( 1, 1, 1 )
    invadersText:Pushtext()
	
    backButton = display.newImage("backButton.png",display.contentCenterX, display.contentCenterY)
    group:insert(backButton)
 end
 
function scene:show(event)
    local phase = event.phase
    composer.removeScene("gamelevel")
    if ( phase == "did" ) then
      backButton:addEventListener("tap",goBack)
      Runtime:addEventListener ( "enterFrame", starGenerator)
    end
end

function scene:hide(event)
    local phase = event.phase
    if ( phase == "will" ) then
        Runtime:removeEventListener("enterFrame", starGenerator)
        backButton:removeEventListener("tap",goBack)
    end
end
 
function goBack()
    composer.gotoScene("start")
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
 
return scene