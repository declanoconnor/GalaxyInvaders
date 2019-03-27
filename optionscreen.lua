local composer = require( "composer" ) --This is a composer file so need to require composer module
local scene = composer.newScene()
local starFieldGenerator = require("starfieldgenerator") -- A module that will generate starFieldGenerator
local starGenerator -- Single instance of the starFieldGenerator
local pushingText = require("pushingtext") -- Pushes text on the start screen, very dramatic
soundOn = false
underlineX = -100


function scene:create( event )
	local group = self.view
	starGenerator =  starFieldGenerator.new(10,group,20)
	
	local invadersText =  pushingText.new( "Options",display.contentCenterX,display.contentCenterY-350,"InvaderCandyFont", 70,group )
		invadersText:setColor( 1, 1, 1 )
		invadersText:Pushtext()	
	
	local musicText =  pushingText.new ("TOGGLE MUSIC",display.contentCenterX,display.contentCenterY-150,"", 30,group)
	musicButton = display.newImage("playmusic.png",display.contentCenterX,display.contentCenterY-100)
	group:insert(musicButton)
	
	underline = display.newRect(display.contentCenterX+underlineX,display.contentCenterY+130,65,6)
	group:insert(underline)
	
	--local stopMusicText =  pushingText.new ("Stop Music",display.contentCenterX+120,display.contentCenterY-100,"", 40,group)
	--stopmusicButton = display.newImage("stopmusic.png",display.contentCenterX+270,display.contentCenterY-100)
	--group:insert(stopmusicButton)
	
--difficulty level	
	local difficultyText =  pushingText.new ("SELECT DIFFICULTY:",display.contentCenterX,display.contentCenterY,"", 30,group)
	difficultyButton = display.newImage("difficulty.png",display.contentCenterX+100,display.contentCenterY+80)
	group:insert(difficultyButton)
	
	difficultyButton2 = display.newImage("difficulty2.png",display.contentCenterX,display.contentCenterY+80)
	group:insert(difficultyButton2)
	
	difficultyButton3 = display.newImage("difficulty3.png",display.contentCenterX-100,display.contentCenterY+80)
	group:insert(difficultyButton3)
	
	backButton = display.newImage("backButton.png",display.contentCenterX,display.contentCenterY+400)
	group:insert(backButton)

--if (gameHasPlayed == true) then

--Select colours
	local tintText1 =  pushingText.new ("SELECT BACKGROUND COLOUR:",display.contentCenterX,display.contentCenterY+200,"", 30,group)
	tintButton = display.newImage("colourblue.png",display.contentCenterX+150,display.contentCenterY+270)
	group:insert(tintButton)
	
	tintButton2 = display.newImage("colourred.png",display.contentCenterX+50,display.contentCenterY+270)
	group:insert(tintButton2)
	
	tintButton3 = display.newImage("colourgreen.png",display.contentCenterX-50,display.contentCenterY+270)
	group:insert(tintButton3)
	
	tintButton4 = display.newImage("colourpurple.png",display.contentCenterX-150,display.contentCenterY+270)
	group:insert(tintButton4)
--end

end

function scene:show(event)
	local phase = event.phase
    local previousScene = composer.getSceneName( "previous" )
	if(previousScene~=nil) then

		composer.removeScene(previousScene)
	end
   if ( phase == "did" ) then
   difficultyButton:addEventListener("tap",setHard)
   difficultyButton2:addEventListener("tap",setMedium)
   difficultyButton3:addEventListener("tap",setEasy)
   tintButton:addEventListener("tap",tintbackground)
   tintButton2:addEventListener("tap",tintbackground2)
   tintButton3:addEventListener("tap",tintbackground3)
   tintButton4:addEventListener("tap",tintbackground4)
   musicButton:addEventListener("tap",playMusic)
   backButton:addEventListener("tap",backHome)
   Runtime:addEventListener("enterFrame", starGenerator)
   end

end

function scene:hide( event )
		local phase = event.phase
		if ( phase == "will" ) then
			difficultyButton:removeEventListener("tap",setHard)
			difficultyButton2:removeEventListener("tap",setMedium)
			difficultyButton3:removeEventListener("tap",setEasy)
			tintButton:removeEventListener("tap",tintbackground)
			tintButton2:removeEventListener("tap",tintbackground2)
			tintButton3:removeEventListener("tap",tintbackground3)
			tintButton4:removeEventListener("tap",tintbackground4)
			musicButton:removeEventListener("tap",playMusic)
    		backButton:removeEventListener("tap",backHome)
			Runtime:removeEventListener("enterFrame", starGenerator)
		end
end

function backHome()
composer.gotoScene("start")
end

--Difficulty functions
function setHard()
underlineX = 100
--numberOfLives = 1
end

function setMedium()
underlineX = 0
--numberOfLives = 2
end

function setEasy()
underlineX = -100
--numberOfLives = 3
end


function playMusic()
		if (soundOn == false) then
			bSound = audio.loadSound( "bmusic.mp3" )
			bChannel = audio.play( bSound, {loops=-1} )
			soundOn = true
		else
			audio.stop()
		end
end		

--select colours
function tintbackground()
background:setFillColor( 0.1, 0.6, 0.7)
end

function tintbackground2()
background:setFillColor( 0.7, 0.1, 0.1)
end

function tintbackground3()
background:setFillColor( 0.1, 0.7, 0.1)
end

function tintbackground4()
background:setFillColor( 0.8, 0.1, 0.8)
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
return scene