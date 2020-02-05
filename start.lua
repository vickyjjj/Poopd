--start
local physics = require "physics"
physics.start()
local storyboard = require ("storyboard")
local json = require "json"
local scene = storyboard.newScene()

--make characters and background
function scene:createScene(event)
	local screenGroup = self.view

	background = display.newImage("background.png")
	background.x = display.contentWidth / 2
	background.y = display.contentHeight / 2
	screenGroup:insert(background)

	playerOp = {width = 54, height = 60, numFrames = 10}
	playerImgSht = graphics.newImageSheet("player.png", playerOp)
	playerSeqData = {name = "there", start = 1, count = 10, frames = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, time = 500, loopcount = 0}
	player = display.newSprite(playerImgSht, playerSeqData)
	player.x = display.contentWidth * 0.9
	player.y = display.contentHeight * 0.8
	player.collided = false
	player.element = "right"
	player.speed = math.random (4, 8)
	player:play()
	physics.addBody(player, "static", {density = .1, bounce = .1, friction = .05})
	screenGroup:insert(player)

	seagullOp = {width = 100, height = 55, numFrames = 2}
	seagullImgSht = graphics.newImageSheet("seagull.png", seagullOp)
	seagullSeqData = {name = "there", start = 0, count = 2, frames = {1, 2}, time = 500, loopcount = 0}
	seagull1 = display.newSprite(seagullImgSht, seagullSeqData)
	seagull1.x = display.contentWidth * 0.1
	seagull1.y = display.contentHeight * 0.8
	seagull1.element = "left"
	seagull1.speed = math.random (4, 8)
	seagull1:play()
	physics.addBody(seagull1, "static", {density = .1, bounce = .1, friction = .1})
	screenGroup:insert(seagull1)

	cloud = display.newImage("cloud.png")
	cloud.x = display.contentWidth * -0.3
	cloud.y = display.contentHeight * 0.6
	cloud.speed = math.random(1, 2)
	cloud.element = "left"
	cloud.xScale = math.random(5, 15) / 10
	cloud.yScale = math.random(5, 15) / 10
	screenGroup:insert(cloud)

	cloud2 = display.newImage("cloud.png")
	cloud2.x = display.contentWidth * 1.3
	cloud2.y = display.contentHeight * 0.2
	cloud2.speed = math.random(1, 2)
	cloud2.element = "right"
	cloud2.xScale = math.random(5, 15) / 10
	cloud2.yScale = math.random(5, 15) / 10
	screenGroup:insert(cloud2)

	playButton = display.newImage("playbutton.png")
	playButton.x = display.contentWidth * 0.5
	playButton.y = display.contentHeight * 0.15
	screenGroup:insert(playButton)

	instrButton = display.newImage("instrbutton.png")
	instrButton.x = display.contentWidth * 0.5
	instrButton.y =  display.contentHeight * 0.35
	instrButton.xScale = 1.2
	instrButton.yScale = 1.2
	screenGroup:insert(instrButton)

	credButton = display.newImage("creditsbutton.png")
	credButton.x = display.contentWidth * 0.5
	credButton.y = display.contentHeight * 0.55
	credButton.xScale = 0.7
	credButton.yScale = 0.7
	screenGroup:insert(credButton)

	recButton = display.newImage("recent.png")
	recButton.x = display.contentWidth * 0.4
	recButton.y = display.contentHeight * 0.7
	screenGroup:insert(recButton)

	hiButton = display.newImage("high.png")
	hiButton.x = display.contentWidth * 0.4
	hiButton.y = display.contentHeight * 0.8
	screenGroup:insert(hiButton)

	levelLabel = display.newImage("level.png")
	levelLabel.x = display.contentWidth * 0.4
	levelLabel.y = display.contentHeight * 0.9
	screenGroup:insert(levelLabel)

	highScore = display.newText(storyboard.state.hiScore, display.contentWidth * 0.7, display.contentHeight * 0.8, native.systemFontBold, 30)
	highScore:setFillColor(0, 0, 100)
	screenGroup:insert(highScore)

	recentScore = display.newText(storyboard.state.finScore, display.contentWidth * 0.7, display.contentHeight * 0.7, native.systemFontBold, 30)
	recentScore:setFillColor(0, 0, 100)
	screenGroup:insert(recentScore)

	levelScore = display.newText(storyboard.state.level, display.contentWidth * 0.7, display.contentHeight * 0.9, native.systemFontBold, 30)
	levelScore:setFillColor(0, 0, 100)
	screenGroup:insert(levelScore)
end

--go to the game
local function startGame(event)
	if event.phase == "began" then
		playAud(selSound)
		storyboard.gotoScene("game", "fade", 300)
	end
end

--go to the instructions
local function toInstruction(event)
	if event.phase == "began" then
		playAud(selSound)
		storyboard.gotoScene("instructions", "fade", 100)
	end
end

--move the clouds, player and seagull
local function scroll(self)
	if self.element == "left" then
		if self.x > display.contentWidth * 1.3 then
			self.x = display.contentWidth * -0.3
			self.y = math.random(display.contentHeight * 0.1, display.contentHeight)
		else
			self.x = self.x + self.speed
		end
	elseif self.element == "right" then
		if self.x < display.contentWidth * -0.3 then
			self.x = display.contentWidth * 1.3
			self.y = math.random(display.contentHeight * 0.1, display.contentHeight)
		else
			self.x = self.x - self.speed
		end
	end
end

--go to the extra information
local function toCredit(event)
	if event.phase == "began" then
		playAud(selSound)
		storyboard.gotoScene("creds", "fade", 100)
	end 
end

function scene:enterScene(event)
	playButton:addEventListener("touch", startGame)
	instrButton:addEventListener("touch", toInstruction)
	credButton:addEventListener("touch", toCredit)

	cloud.enterFrame = scroll
	Runtime:addEventListener("enterFrame", cloud)
	cloud2.enterFrame = scroll
	Runtime:addEventListener("enterFrame", cloud2)

	storyboard.purgeScene("restart")
	storyboard.purgeScene("instructions")
	storyboard.purgeScene("creds")

	seagull1.enterFrame = scroll
	Runtime:addEventListener("enterFrame", seagull1)
	player.enterFrame = scroll
	Runtime:addEventListener("enterFrame", player)
end

function scene:exitScene(event)
	Runtime:removeEventListener("enterFrame", seagull1)
	Runtime:removeEventListener("enterFrame", player)
	playButton:removeEventListener("touch", startGame)
	instrButton:removeEventListener("touch", toInstruction)
	credButton:removeEventListener("touch", toCredit)
end

function scene:destroyScene(event)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene