--restart
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

	shotButton = display.newImage("camera.png")
	shotButton.x = display.contentWidth * 0.8
	shotButton.y = display.contentHeight * 0.85
	screenGroup:insert(shotButton)

	restartButton = display.newImage("restartbutton.png")
	restartButton.x = display.contentWidth / 2
	restartButton.y = display.contentHeight * 0.75
	restartButton.xScale = 0.8
	restartButton.yScale = 0.8
	screenGroup:insert(restartButton)

	menuButton = display.newImage("menubutton.png")
	menuButton.x = display.contentWidth * 0.5
	menuButton.y = display.contentHeight * 0.9
	menuButton.xScale = 0.7
	menuButton.yScale = 0.7
	screenGroup:insert(menuButton)

	scoreButton = display.newImage("score.png")
	scoreButton.x = display.contentWidth * 0.3
	scoreButton.y = display.contentHeight * 0.3
	screenGroup:insert(scoreButton)

	hiButton = display.newImage("high.png")
	hiButton.x = display.contentWidth * 0.3
	hiButton.y = display.contentHeight * 0.4
	screenGroup:insert(hiButton)

	levelLabel = display.newImage("level.png")
	levelLabel.x = display.contentWidth * 0.3
	levelLabel.y = display.contentHeight * 0.5
	screenGroup:insert(levelLabel)

	highScore = display.newText(storyboard.state.hiScore, display.contentWidth * 0.6, display.contentHeight * 0.4, native.systemFontBold, 30)
	highScore:setFillColor(0, 0, 100)
	screenGroup:insert(highScore)

	recentScore = display.newText(storyboard.state.finScore, display.contentWidth * 0.6, display.contentHeight * 0.3, native.systemFontBold, 30)
	recentScore:setFillColor(0, 0, 100)
	screenGroup:insert(recentScore)

	levelScore = display.newText(storyboard.state.level, display.contentWidth * 0.6, display.contentHeight * 0.5, native.systemFontBold, 30)
	levelScore:setFillColor(0, 0, 100)
	screenGroup:insert(levelScore)

	if storyboard.state.finScore > storyboard.state.prevHiScore then
		new1 = display.newText("NEW HI SCORE!", display.contentWidth * 0.3, display.contentHeight * 0.15, native.systemFontBold, 40)
		new1:setFillColor(0, 0, 100)		
		screenGroup:insert(new1)
	end

	seagullOp = {width = 100, height = 55, numFrames = 2}
	seagullImgSht = graphics.newImageSheet("seagull.png", seagullOp)
	seagullSeqData = {name = "there", start = 0, count = 2, frames = {1, 2}, time = 500, loopcount = 0}
	
	seagull1 = display.newSprite(seagullImgSht, seagullSeqData)
	seagull1.x = display.contentWidth * 0.8
	seagull1.y = display.contentHeight * 0.2
	seagull1.speed = math.random (4, 8)
	seagull1.xScale = 1.5
	seagull1.yScale = 1.5
	seagull1:play()
	physics.addBody(seagull1, "static", {density = .1, bounce = .1, friction = .1})
	screenGroup:insert(seagull1)

	playerOp = {width = 54, height = 60, numFrames = 10}
	playerImgSht = graphics.newImageSheet("player.png", playerOp)
	playerSeqData = {name = "there", start = 1, count = 10, frames = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, time = 500, loopcount = 0}
	player = display.newSprite(playerImgSht, playerSeqData)
	player.x = display.contentWidth * 0.2
	player.y = display.contentHeight * 0.8
	player.collided = false
	player.isVisible = true
	player:play()
	physics.addBody(player, "static", {density = .1, bounce = .1, friction = .05})
	screenGroup:insert(player)

	if storyboard.state.hiScore > 2500 then
		storyboard.state.level = "YOUUUU"
	elseif storyboard.state.hiScore > 2250 then
		storyboard.state.level = "Legendary dodger"
	elseif storyboard.state.hiScore > 2000 then
		storyboard.state.level = "Poop allergies"
	elseif storyboard.state.hiScore > 1750 then
		storyboard.state.level = "Seagull whisperer"
	elseif storyboard.state.hiScore > 1500 then
		storyboard.state.level = "Poop repellant"
	elseif storyboard.state.hiScore > 1250 then
		storyboard.state.level = "Soldier of clean"
	elseif storyboard.state.hiScore > 1000 then
		storyboard.state.level = "Tamed the birds"
	elseif storyboard.state.hiScore > 750 then
		storyboard.state.level = "Full body workout"
	elseif storyboard.state.hiScore > 500 then
		storyboard.state.level = "Defying seagulls"
	elseif storyboard.state.hiScore > 250 then
		storyboard.state.level = "Good moves"
	elseif storyboard.state.hiScore > 100 then
		storyboard.state.level = "Poop magnet"
	else
		storyboard.state.level = "Let it rain poop"
	end

end

--go to the game
local function tryAgain(event)
	if event.phase == "began" then
		playAud(selSound)
		storyboard.gotoScene("game", "fade", 100)
	end
end

local function captureShot(event)
	if event.phase == "began" then
		playAud(cam)
		obj = display.captureScreen(true)
		obj:removeSelf()
		native.showAlert("Success!", "A screencap of your stats has been saved for sharing :)", {"OK"})
	end
end

local function toMenu(event)
	if event.phase == "began" then
		playAud(selSound)
		storyboard.gotoScene("start")
	end
end

function scene:enterScene(event)
	myGameSettings.hiScore = storyboard.state.hiScore
	myGameSettings.level = storyboard.state.level
	saveTable(myGameSettings, "mygamesettings.json")

	storyboard.purgeScene("game")
	restartButton:addEventListener("touch", tryAgain)
	shotButton:addEventListener("touch", captureShot)
	menuButton:addEventListener("touch", toMenu)
end

function scene:exitScene(event)
	restartButton:removeEventListener("touch", tryAgain)
	menuButton:removeEventListener("touch", toMenu)
	shotButton:removeEventListener("touch", captureShot)
end

function scene:destroyScene(event)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene