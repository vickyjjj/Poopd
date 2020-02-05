--credits + information
local physics = require "physics"
physics.start()
local storyboard = require ("storyboard")
local scene = storyboard.newScene()

--make characters and background
function scene:createScene(event)
	local screenGroup = self.view

	background = display.newImage("background.png")
	background.x = display.contentWidth / 2
	background.y = display.contentHeight / 2
	screenGroup:insert(background)

	menuButton = display.newImage("menubutton.png")
	menuButton.x = display.contentWidth * 0.5
	menuButton.y = display.contentHeight * 0.9
	menuButton.xScale = 0.8
	menuButton.yScale = 0.8
	screenGroup:insert(menuButton)

	cred = display.newImage("credits.png")
	cred.x = display.contentWidth / 2
	cred.y = display.contentHeight * 0.4
	screenGroup:insert(cred)
end

function scene:enterScene(event)
	storyboard.purgeScene("start")
	
	menuButton:addEventListener("touch", backToMenu)
end

function scene:exitScene(event)
	menuButton:removeEventListener("touch", backToMenu)
end

function scene:destroyScene(event)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene