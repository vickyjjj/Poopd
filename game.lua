--game
local physics = require "physics"
physics.start()
local storyboard = require ("storyboard")
local scene = storyboard.newScene()
local coin = audio.loadSound("pickup.wav")
local deadSound = audio.loadSound("death.wav")
local powerup = audio.loadSound("powerup.wav")
local hatuse = audio.loadSound("hatuse.wav")
local backgroundMusic = audio.loadStream("musicclip.mp3")

--make background and characters
function scene:createScene(event)

	local screenGroup = self.view

	points = 0

	scoreTimer = timer.performWithDelay(100, pointsUpdate, 0)

	background1 = display.newImage("schoolBack.jpg", true)
	background1.x = display.contentWidth * 2.55
	background1.y = display.contentHeight / 2
	background1.speed = 7
	background1.isVisible = false
	screenGroup:insert(background1)

	background2 = display.newImage("schoolBack.jpg", true)
	background2.x = display.contentWidth * 7.40
	background2.y = display.contentHeight / 2
	background2.speed = 7
	background2.isVisible = false
	screenGroup:insert(background2)

	background3 = display.newImage("beach.png", true)
	background3.x = display.contentWidth 
	background3.y = display.contentHeight / 5
	background3.yScale = 0.8
	background3.speed = 7
	background3.isVisible = false
	screenGroup:insert(background3)

	background4 = display.newImage("beach.png", true)
	background4.x = display.contentWidth * 3
	background4.y = display.contentHeight / 5
	background4.yScale = 0.8
	background4.speed = 7
	background4.isVisible = false
	screenGroup:insert(background4)

	cloud = display.newImage("cloud.png")
	cloud.x = display.contentWidth * -0.3
	cloud.y = display.contentHeight * 0.4
	cloud.speed = math.random(1, 2)
	cloud.element = "left"
	cloud.xScale = 0.5
	cloud.yScale = 0.5
	cloud.isVisible = false
	screenGroup:insert(cloud)

	cloud2 = display.newImage("cloud.png")
	cloud2.x = display.contentWidth * 1.3
	cloud2.y = display.contentHeight * 0.2
	cloud2.speed = math.random(1, 2)
	cloud2.element = "right"
	cloud2.xScale = 0.5
	cloud2.yScale = 0.5
	cloud2.isVisible = false
	screenGroup:insert(cloud2)

	seagullOp = {width = 100, height = 55, numFrames = 2}
	seagullImgSht = graphics.newImageSheet("seagull.png", seagullOp)
	seagullSeqData = {name = "there", start = 0, count = 2, frames = {1, 2}, time = 500, loopcount = 0}

	seagull1 = display.newSprite(seagullImgSht, seagullSeqData)
	seagull1.x = display.contentWidth * 0.1
	seagull1.y = display.contentHeight * 0.1
	seagull1.speed = math.random (4, 8)
	seagull1:play()
	physics.addBody(seagull1, "static", {density = .1, bounce = .1, friction = .1})
	screenGroup:insert(seagull1)

	seagull2 = display.newSprite(seagullImgSht, seagullSeqData)
	seagull2.x = display.contentWidth * 0.9
	seagull2.y = display.contentHeight * 0.1
	seagull2.speed = math.random (4, 8)
	seagull2:play()
	physics.addBody(seagull2, "static", {density = .1, bounce = .1, friction = .1})
	screenGroup:insert(seagull2)

	seagull3 = display.newSprite(seagullImgSht, seagullSeqData)
	seagull3.x = display.contentWidth * 0.5
	seagull3.y = display.contentHeight * 0.1
	seagull3.speed = math.random (4, 8)
	seagull3:play()
	physics.addBody(seagull3, "static", {density = .1, bounce = .1, friction = .1})
	screenGroup:insert(seagull3)

	playerOp = {width = 54, height = 60, numFrames = 10}
	playerImgSht = graphics.newImageSheet("player.png", playerOp)
	playerSeqData = {name = "there", start = 1, count = 10, frames = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, time = 500, loopcount = 0}
	player = display.newSprite(playerImgSht, playerSeqData)
	player.x = display.contentWidth * 0.2
	player.y = display.contentHeight * 0.6
	player.collided = false
	player.isVisible = true
	player:play()
	physics.addBody(player, "static", {density = .1})
	screenGroup:insert(player)

	deadPlayerOp = {width = 60, height = 60, numFrames = 6}
	deadPlayerImgSht = graphics.newImageSheet("died.png", deadPlayerOp)
	deadPlayerSeqData = {name = "there", start = 1, count = 6, frames = {1, 2, 3, 4, 5, 6}, time = 1100, loopcount = 1}
	deadPlayer = display.newSprite(deadPlayerImgSht, deadPlayerSeqData)
	deadPlayer.x = display.contentWidth * 2
	deadPlayer.y = display.contentHeight * 0.7
	screenGroup:insert(deadPlayer)

	floor = display.newImage("floor.png")
	floor.x = display.contentWidth
	floor.y = display.contentHeight * 0.9
	physics.addBody(floor, "static", {friction = .3})
	screenGroup:insert(floor)

	poop1 = display.newImage("poop.png")
	poop1.x = seagull1.x
	poop1.y = seagull1.y
	poop1.label = 1
	poop1.speed = math.random(4, 8)
	poop1.element = "bad"
	physics.addBody(poop1, "static", {bounce = .1})
	screenGroup:insert(poop1)

	poop2 = display.newImage("poop.png")
	poop2.x = seagull2.x
	poop2.y = seagull2.y
	poop2.label = 2
	poop2.speed = math.random(4, 8)
	poop2.element = "bad"
	physics.addBody(poop2, "static", {bounce = .1})
	screenGroup:insert(poop2)

	poop3 = display.newImage("poop.png")
	poop3.x = seagull3.x
	poop3.y = seagull3.y
	poop3.label = 3
	poop3.speed = math.random(4, 8)
	poop3.element = "bad"
	physics.addBody(poop3, "static", {bounce = .1})
	screenGroup:insert(poop3)

	gPoop = display.newImage("good.png")
	gPoop.x = seagull3.x + 5
	gPoop.y = seagull3.y
	gPoop.label = 3
	gPoop.speed = math.random(4, 8)
	gPoop.element = "gold"
	physics.addBody(gPoop, "static", {bounce = .1})
	screenGroup:insert(gPoop)

	hat = display.newImage("tophat.png")
	hat.x = display.contentWidth * 0.5
	hat.y = display.contentHeight * -3
	hat.element = "hold"
	hat.lives = 3
	hat.isActive = false
	hat.speed = math.random(4, 8)
	physics.addBody(hat, "static")
	screenGroup:insert(hat)

	score = display.newText("0", display.contentWidth * 0.9, display.contentHeight * 0.9, native.systemFontBold, 40)
	score:setFillColor(0, 0, 100)
	screenGroup:insert(score)

	hatLives = display.newText("3", display.contentWidth * 0.9, display.contentHeight * 0.1, native.systemFontBold, 40)
	hatLives:setFillColor(100, 0, 0)
	hatLives.isVisible = false
	screenGroup:insert(hatLives)

end

--move the clouds
local function scroll(self)
	if self.element == "left" then
		if self.x > display.contentWidth * 1.3 then
			self.x = display.contentWidth * -0.3
			self.y = math.random(display.contentHeight * 0.1, display.contentHeight * 0.5)
		else
			self.x = self.x + self.speed
		end
	elseif self.element == "right" then
		if self.x < display.contentWidth * -0.3 then
			self.x = display.contentWidth * 1.3
			self.y = math.random(display.contentHeight * 0.1, display.contentHeight * 0.5)
		else
			self.x = self.x - self.speed
		end
	end
end

--move school background
local function scrollWorld1(self)
	if self.x < - display.viewableContentWidth * 2.6 then
		self.x = display.viewableContentWidth * 7
	else
		self.x = self.x - self.speed 
	end
	movePlayer()
end

--move beach background
local function scrollWorld2(self)
	if self.x < - display.viewableContentWidth * 1.1 then
		self.x = display.viewableContentWidth * 2.4
	else
		self.x = self.x - self.speed 
	end
	movePlayer()
end

--move the seagulls
local function scrollGulls(self)
	if self.x > display.contentWidth * 1.2 then
		self.x = display.contentWidth * -0.2
		self.y = display.contentHeight * 0.1
	else
		self.x = self.x + self.speed
	end
end

function movePlayer()
	if player.y > display.contentHeight * 1.1 and player.collided == false then
		player.collided = true
		player.bodyType = "static"
		playerHit()
	elseif player.x > display.contentWidth * 1.1 then
		player.x = display.contentWidth * -0.05
		player.y = display.contentHeight * 0.75
	elseif player.x < display.contentWidth * -0.1 then
		player.x = display.contentWidth * 1.05
		player.y = display.contentHeight * 0.75
	end
end

--move hat item
local function moveHat(self)
	if hat.isActive == false and self.y > display.contentHeight then
		self.y = display.contentHeight * -3
		self.x = math.random(display.contentWidth * 0.1, display.contentWidth * 0.9)
		self.speed = math.random(4, 8)
	elseif hat.isActive == true then
		hat.x = player.x
		hat.y = display.contentHeight * 0.68
	else
		self.y = self.y + self.speed
	end
end

--move poops
local function moveFallObj(self)
	if self.y > display.contentHeight * 0.73 then
		self.bodyType = "static"
		self.isVisible = true
		if points > 2000 then
			self.speed = math.random(16, 18)
		elseif points > 1500 then
			self.speed = math.random(14, 16)
		elseif points > 1000 then
			self.speed = math.random(12, 14)
		elseif points > 700 then
			self.speed = math.random(9, 11)
		elseif points > 350 then
			self.speed = math.random(6, 8)
		else
			self.speed = math.random(3, 5)
		end
		if self.label == 1 then
			self.x = seagull1.x
			self.y = seagull1.y
		elseif self.label == 2 then
			self.x = seagull2.x
			self.y = seagull2.y
		else
			self.x = seagull3.x
			self.y = seagull3.y
		end
	else
		self.y = self.y + self.speed
	end
end

--make player physics body dynamic
local function playerReady()
	player.bodyType = "dynamic"
end

--move player right
local function activatePlayerRight(self)
	self:applyForce(5, 0, self.x, self.y)
end

--move player left
local function activatePlayerLeft(self)
	self:applyForce(-5, 0, self.x, self.y)
end

--gather screen touch event information
local function touchScreen(event)
	if event.phase == "began" then
		if event.x < display.contentWidth / 2 then
			player.enterFrame = activatePlayerLeft
			Runtime:addEventListener("enterFrame", player)
		else
			player.enterFrame = activatePlayerRight
			Runtime:addEventListener("enterFrame", player)
		end
	elseif event.phase == "ended" then
		Runtime:removeEventListener("enterFrame", player)
	end
end

--add points by 1
function pointsUpdate()
	points = points + 1
	score.text = string.format("%d", points)
end

--keep track of hat lives
local function hatUpdate()
	playAud(hatuse)
	hat.lives = hat.lives - 1
	hatLives.text = string.format("%d", hat.lives)
end

--go to restart 
function gameOver()
	deadPlayer:pause()
	storyboard.gotoScene("restart", "fade", 800)
end

--compare and set hi score
function scoreCheck()
	storyboard.state.prevHiScore = storyboard.state.hiScore
	if points > storyboard.state.hiScore then
		storyboard.state.hiScore = points
	end
end

--player collision results
function playerHit()
	scoreCheck()
	storyboard.state.finScore = points
	player.isVisible = false
	deadPlayer.x = player.x
	deadPlayer.y = player.y
	deadPlayer:play()
	playAud(deadSound)
	timer.pause(scoreTimer)
	timer.performWithDelay(1000, gameOver, 1)
end

--activate/deactivate hat powers
local function activateHat()
	playAud(powerup)
	hat.lives = 3
	hatLives.text = string.format("%d", hat.lives)
	hatLives.isVisible = true
	hat.isActive = true
end

local function deactivateHat()
	hat.x = display.contentWidth * -0.5
	hat.y = display.contentHeight * -5
	hatLives.isVisible = false
	hat.isActive = false
end

--detect collision information
local function onCollision(event)
	if event.phase == "began" and event.object2.element == "bad" then
		if hat.isActive then
			hatUpdate()
			if hat.lives < 1 then
				deactivateHat()
			end
		elseif player.collided == false then
			player.collided = true
			player.bodyType = "static"
			playerHit()
		end
	elseif event.phase == "began" and event.object2.element == "gold" then
		if player.collided == false then
			playAud(coin)
			points = points + 25
		end
	elseif event.phase == "began" and event.object2.element == "hold" then
		if player.collided == false and hat.isActive == false then
			activateHat()
		end
	end
end

function scene:enterScene(event)
	storyboard.purgeScene("start")
	storyboard.purgeScene("restart")

	backgroundMusicChannel = audio.play(backgroundMusic, {channel = 1, loops = -1, fadein = 1000})

	playerIntro = transition.to(player, {time = 100, x = display.contentWidth * 0.2, onComplete = playerReady})

	Runtime:addEventListener("touch", touchScreen)
	Runtime:addEventListener("collision", onCollision)

	seagull1.enterFrame = scrollGulls
	Runtime:addEventListener("enterFrame", seagull1)
	seagull2.enterFrame = scrollGulls
	Runtime:addEventListener("enterFrame", seagull2)
	seagull3.enterFrame = scrollGulls
	Runtime:addEventListener("enterFrame", seagull3)

	poop1.enterFrame = moveFallObj
	Runtime:addEventListener("enterFrame", poop1)
	poop2.enterFrame = moveFallObj
	Runtime:addEventListener("enterFrame", poop2)
	poop3.enterFrame = moveFallObj
	Runtime:addEventListener("enterFrame", poop3)
	gPoop.enterFrame = moveFallObj
	Runtime:addEventListener("enterFrame", gPoop)
	hat.enterFrame = moveHat
	Runtime:addEventListener("enterFrame", hat)

	if storyboard.state.np then
		background1.isVisible = true
		background2.isVisible = true
		background1.enterFrame = scrollWorld1
		Runtime:addEventListener("enterFrame", background1)
		background2.enterFrame = scrollWorld1
		Runtime:addEventListener("enterFrame", background2)
	else
		cloud.isVisible = true
		cloud2.isVisible = true
		background3.isVisible = true
		background4.isVisible = true
		background3.enterFrame = scrollWorld2
		Runtime:addEventListener("enterFrame", background3)
		background4.enterFrame = scrollWorld2
		Runtime:addEventListener("enterFrame", background4)
		cloud.enterFrame = scroll
		Runtime:addEventListener("enterFrame", cloud)
		cloud2.enterFrame = scroll
		Runtime:addEventListener("enterFrame", cloud2)
	end
end

function scene:exitScene(event)
	Runtime:removeEventListener("touch", touchScreen)
	Runtime:removeEventListener("collision", onCollision)
	Runtime:removeEventListener("enterFrame", seagull1)
	Runtime:removeEventListener("enterFrame", seagull2)
	Runtime:removeEventListener("enterFrame", seagull3)
	Runtime:removeEventListener("enterFrame", poop1)
	Runtime:removeEventListener("enterFrame", poop2)
	Runtime:removeEventListener("enterFrame", poop3)
	Runtime:removeEventListener("enterFrame", gPoop)
	Runtime:removeEventListener("enterFrame", hat)
	audio.stop(1)
end

function scene:destroyScene(event)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene