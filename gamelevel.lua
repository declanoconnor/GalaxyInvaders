local composer = require("composer")
local scene = composer.newScene()

local starFieldGenerator = require("starfieldgenerator")
local pushingText = require("pushingtext")
local physics = require("physics")
local gameData = require( "gamedata" )
physics.start()
local backgroundRect
local starGenerator
local player
local playerHeight = 125
local playerWidth = 94
local invaderSize = 80 -- The width and height of the sprites image
local changeDirection = false
local leftBounds = 30
local rightBounds = display.contentWidth - 30
local invaderHalfWidth = 16
local invaders = {} -- Table that holds all the invaders
local invaderSpeed = 5
local playerBullets = {} -- Table that holds the players Bullets
local canFireBullet = true
local invadersWhoCanFire = {} -- Table that holds the invaders that are able to fire bullets
local invaderBullets = {}
local numberOfLives = 3
local playerIsInvincible = false
local rowOfInvadersWhoCanFire = 5
local invaderTimer
local gameIsOver = false;
local drawDebugButtons = {}  -- move player in simulator
local enableBulletFireTimer
heart3 = nil
heart2 = nil
heart1 = nil
gameHasPlayed = true
score = 100000
local duration = 2000000
local fps = 1


function scene:create( event )
        local group = self.view
    	 starGenerator =  starFieldGenerator.new(50,group,9)
     	 setupPlayer()
     	 setupInvaders()
     	 drawDebugButtons()
		 drawLives()
		 
		 highscoreText = display.newText( "Score:", display.contentCenterX-80, 10, "", 30 )
		 group:insert(highscoreText)
		 
		 scoreText = display.newText( "", display.contentCenterX+50, 10, "", 30 )
		 group:insert(scoreText)
		 showScore( scoreText, score, duration, fps )
		 
		 backButton = display.newImage("homeButton.png",30,10)
		 group:insert(backButton)
end

function scene:show( event )
	local phase = event.phase
	  local previousScene = composer.getSceneName( "previous" )
      composer.removeScene(previousScene)
	   local group = self.view
	   if ( phase == "did" ) then
	    backButton:addEventListener("tap",backHome)
	    Runtime:addEventListener("enterFrame", gameLoop)
     	Runtime:addEventListener("enterFrame", starGenerator)
		Runtime:addEventListener("tap", firePlayerBullet)
		Runtime:addEventListener( "collision", onCollision )
		invaderFireTimer = timer.performWithDelay(3000, fireInvaderBullet,-1)
		Runtime:addEventListener("enterFrame", updateText)
	   end
end

function scene:hide( event )
	local phase = event.phase
    local group = self.view
    if ( phase == "will" ) then
	    backButton:removeEventListener("tap",backHome)
       	Runtime:removeEventListener("enterFrame", starGenerator)
       	Runtime:removeEventListener("tap", firePlayerBullet)
       	Runtime:removeEventListener("enterFrame", gameLoop)
       	Runtime:removeEventListener( "collision", onCollision )
       	timer.cancel(invaderFireTimer)
		Runtime:removeEventListener("enterFrame",updateText)
    end
end

local function lerp( v0, v1, t )
    return v0 + t * (v1 - v0)
end

function showScore( target, value, duration, fps )
    if value == 0 then
        return
    end
    local newScore = 0
    local passes = duration / fps
    local increment = lerp( 0, value, 1/passes )
 
    local count = 0
     function updateText()
        if count < passes then
            newScore = newScore + increment
            target.text = string.format( "%07d", newScore )
            count = count + 1
        else
            target.text = string.format( "%07d", value )
        end
    end	
end

function setupPlayer()
	local options = { width = playerWidth,height = playerHeight,numFrames = 2}
	local playerSheet = graphics.newImageSheet( "player.png", options )
	local sequenceData = {
  	 {  start=1, count=2, time=500,   loopCount=0 }
	}
	player = display.newSprite( playerSheet, sequenceData )
	player.name = "player"
	player.x=display.contentCenterX- playerWidth /2 
	player.y = display.contentHeight - playerHeight - 10
	player:play()
	scene.view:insert(player)
	local physicsData = (require "shapedefs").physicsData(1.0)
	physics.addBody( player, physicsData:get("ship"))
	player.gravityScale = 0
end

function drawDebugButtons() --move keys for player
	local function movePlayer(event)
		if(event.target.name == "left") then
			  player.x = player.x -15
		elseif(event.target.name == "right") then
			player.x = player.x+15
		end
	end
		
	local left = display.newImage( "Larrow.png", 90, 700)
	left.name = "left"
    scene.view:insert(left)
	
	local right = display.newImage( "Rarrow.png", display.contentWidth-90, 700)
	right.name = "right"
	scene.view:insert(right)
	
    left:addEventListener("tap", movePlayer)
    right:addEventListener("tap", movePlayer)
end

function drawLives() --lives
	heart1 = display.newImage("heart.png", 720, 10)
	heart1.name = "heart1"
    scene.view:insert(heart1)
	
	heart2 = display.newImage("heart.png", 680, 10)
	heart2.name = "heart2"
    scene.view:insert(heart2)
	
	heart3 = display.newImage("heart.png", 640, 10)
	heart3.name = "heart3"
    scene.view:insert(heart3)
end

function backHome() --Back to menu
composer.gotoScene("start")
end

function firePlayerBullet()
	if(canFireBullet == true)then
		local tempBullet = display.newImage("laser.png", player.x, player.y - playerHeight/ 2)
		tempBullet.name = "playerBullet"
		scene.view:insert(tempBullet)
		physics.addBody(tempBullet, "dynamic" )
    	tempBullet.gravityScale = 0
    	tempBullet.isBullet = true
    	tempBullet.isSensor = true
		tempBullet:setLinearVelocity( 0,-300)
		table.insert(playerBullets,tempBullet)
		local laserSound = audio.loadSound( "laser.wav" )
		local laserChannel = audio.play( laserSound )
		audio.dispose(laserChannel)
		canFireBullet = false

	else
		return
	end
	local function enableBulletFire()
		canFireBullet = true
	end
	timer.performWithDelay(500,enableBulletFire,1)
end

function checkPlayerBulletsOutOfBounds()
	if(#playerBullets > 0)then
		for i=#playerBullets,1,-1 do
 			if(playerBullets[i].y < 0) then
 				playerBullets[i]:removeSelf()
 				playerBullets[i] = nil
 				table.remove(playerBullets,i)
 			end
 		end
	end
end

function gameLoop()
    checkPlayerBulletsOutOfBounds()
	moveInvaders()
	checkInvaderBulletsOutOfBounds()
end

function setupInvaders() -- manages the amount and pos of invaders
	local xPositionStart =display.contentCenterX - invaderHalfWidth - (gameData.invaderNum *(invaderSize + 10)) --starting position
	local numberOfInvaders = gameData.invaderNum * 2 + 1 --level progression
	for i = 1, gameData.rowsOfInvaders do
		for j = 1, numberOfInvaders do
			local tempInvader = display.newImage("invader1.png",xPositionStart + ((invaderSize+10)*(j-1)), i * 46 )
			tempInvader.name = "invader"
			if(i== gameData.rowsOfInvaders)then
				table.insert(invadersWhoCanFire,tempInvader)
			end
			
		physics.addBody(tempInvader, "dynamic" )
   		tempInvader.gravityScale = 0
		tempInvader.isSensor = true

		scene.view:insert(tempInvader)
		table.insert(invaders,tempInvader)
		end
	end
end

function moveInvaders()  --Looping through invaders changing there Xpos by value stored in invader speed, left & right bounds sees if invader out of bounds
    local changeDirection = false
	for i=1, #invaders do
      	invaders[i].x = invaders[i].x + invaderSpeed 
     	if(invaders[i].x > rightBounds - invaderHalfWidth or invaders[i].x < leftBounds + invaderHalfWidth) then 
          	changeDirection = true;
     	end
	 end
    if(changeDirection == true)then
        invaderSpeed = invaderSpeed*-1
        for j = 1, #invaders do
            invaders[j].y = invaders[j].y+ 46
        end
        changeDirection = false;
    end 
end

function onCollision( event ) -- Collision for invaders
	local function removeInvaderAndPlayerBullet(event)
    local params = event.source.params
	local invaderIndex = table.indexOf(invaders,params.theInvader)
	local invadersPerRow = gameData.invaderNum *2+2 
    if(invaderIndex > invadersPerRow) then
		 table.insert(invadersWhoCanFire, invaders[invaderIndex - invadersPerRow])
    end
	 params.theInvader.isVisible = false
     physics.removeBody(params.theInvader)
     table.remove(invadersWhoCanFire,table.indexOf(invadersWhoCanFire,params.theInvader))
	  
	if(table.indexOf(playerBullets,params.thePlayerBullet)~=nil)then
	  physics.removeBody(params.thePlayerBullet)
	  table.remove(playerBullets,table.indexOf(playerBullets,params.thePlayerBullet))
	  display.remove(params.thePlayerBullet)
	  params.thePlayerBullet = nil
	end
      end
	  --delay is neccessary for collision detection
      if ( event.phase == "began" ) then 
			if(event.object1.name == "invader" and event.object2.name == "playerBullet")then
				local tm = timer.performWithDelay(10, removeInvaderAndPlayerBullet,1)
				tm.params = {theInvader = event.object1, thePlayerBullet = event.object2}
			end
			
   	  if(event.object1.name == "playerBullet" and event.object2.name == "invader") then
			local tm = timer.performWithDelay(10, removeInvaderAndPlayerBullet,1)
			tm.params = {theInvader = event.object2, thePlayerBullet = event.object1}
   	  end
   	  
   	    if(event.object1.name == "player" and event.object2.name == "invaderBullet") then
  	  	table.remove(invaderBullets,table.indexOf(invaderBullets,event.object2))
  	  	event.object2:removeSelf()
  	  	event.object2 = nil
  	  	if(playerIsInvincible == false) then
			killPlayer()
  	  	end
  	  	return
  	  end
  	  
  	   if(event.object1.name == "invaderBullet" and event.object2.name == "player") then
  	  	table.remove(invaderBullets,table.indexOf(invaderBullets,event.object1))
  	  	event.object1:removeSelf()
  	  	event.object1 = nil
  	  	if(playerIsInvincible == false) then
			killPlayer()
  	  	end
		return
  	   end
  	   
  	   if(event.object1.name == "player" and event.object2.name == "invader") then
				numberOfLives = 0
				killPlayer()
  	    end
		
  	     if(event.object1.name == "invader" and event.object2.name == "player") then
				numberOfLives = 0
				killPlayer()
  	    end
  	 end
end	

function fireInvaderBullet()
    if(#invadersWhoCanFire >0) then
        local randomIndex = math.random(#invadersWhoCanFire)
        local randomInvader = invadersWhoCanFire[randomIndex]
        local tempInvaderBullet = display.newImage("invlaser.png", randomInvader.x , randomInvader.y + invaderSize/2)
        tempInvaderBullet.name = "invaderBullet"
        scene.view:insert(tempInvaderBullet)
        physics.addBody(tempInvaderBullet, "dynamic" )
        tempInvaderBullet.gravityScale = 0
        tempInvaderBullet.isBullet = true
        tempInvaderBullet.isSensor = true
        tempInvaderBullet:setLinearVelocity( 0,400)
        table.insert(invaderBullets, tempInvaderBullet)
    else
        levelComplete()
    end  
end

function checkInvaderBulletsOutOfBounds() 
	if (#invaderBullets > 0) then
		for i=#invaderBullets,1,-1 do
			if(invaderBullets[i].y > display.contentHeight) then
				invaderBullets[i]:removeSelf()
				invaderBullets[i] = nil
				table.remove(invaderBullets,i)
			end
		end
	end
end

function killPlayer()
	numberOfLives = numberOfLives- 1;
  	 if (numberOfLives == 2) then
	 heart3:removeSelf()
	 deathsound1()
	 end
	 if (numberOfLives == 1) then
	 heart2:removeSelf()
	 deathsound1()
	 end
	  if (numberOfLives == 0) then
	 heart1:removeSelf()
	 deathsound1()
	 end
	 if(numberOfLives <= 0) then
         gameData.invaderNum  = 1
         composer.gotoScene("playerdied")		
	  else
	     playerIsInvincible = true
         spawnNewPlayer()
  	end
end

function deathsound1() --called deathsound but its really a 'being hit' sound
	 local deathSound = audio.loadSound( "explode.wav" )
	 local deathChannel = audio.play( deathSound )
	 audio.dispose(deathChannel)
end

function spawnNewPlayer() --lives
	local numberOfTimesToFadePlayer = 5
	local numberOfTimesPlayerHasFaded = 0
	local function fadePlayer()
        player.alpha = 0;
        transition.to( player, {time=400, alpha=1,  })
        numberOfTimesPlayerHasFaded = numberOfTimesPlayerHasFaded + 1

    if(numberOfTimesPlayerHasFaded == numberOfTimesToFadePlayer) then
  		playerIsInvincible = false
  	end	
  end	
	fadePlayer()
    timer.performWithDelay(400, fadePlayer,numberOfTimesToFadePlayer)
end


local function onAccelerate( event )
	player.x = display.contentCenterX + (display.contentCenterX * (event.xGravity*2))
end
	
function levelComplete()
     gameData.invaderNum  = gameData.invaderNum  + 1
     if(gameData.invaderNum  <= gameData.maxLevels) then
	 	composer.gotoScene("gameover")
	 else
	    gameData.invaderNum  = 1
	 	composer.gotoScene("playerdied")
		
     end
end

system.setAccelerometerInterval( 60 ) --times per second
Runtime:addEventListener ("accelerometer", onAccelerate)
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene