local composer = require( "composer" ) --This is a composer file so need to require composer module
local scene = composer.newScene()
local splashscreen
local timer = 0

function scene:create( event )
	local grp = self.view
	local w = display.viewableContentWidth+ 10
	local h = display.viewableContentHeight+ 130
	splashscreen = display.newImageRect("splash.png", w,h)
	splashscreen.x = display.viewableContentWidth/2
	splashscreen.y = display.viewableContentHeight/2
	grp:insert (splashscreen)
end

function scene:show(event)

	local function toMenu()
	local options = {
		effect = "fade",
		time = 2000
	}
	composer.gotoScene("start", options)
	end
timer.performWithDelay(4000,toMenu)
end

function scene:hide( event )
		print("exit")
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
return scene