--instructions
local physics = require "physics"
physics.start()
local widget = require "widget"
local storyboard = require "storyboard"
local json = require "json"
local scene = storyboard.newScene()

--make characters and background
function scene:createScene(event)
	local screenGroup = self.view
	local radioGroup = display.newGroup()

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

	instr = display.newImage("instructions.png")
	instr.x = display.contentWidth / 2
	instr.y = display.contentHeight / 2
	screenGroup:insert(instr)

	radio1 = widget.newSwitch
	{
		x = display.contentWidth * 0.77,
		y = display.contentHeight * 0.62,
		style = "radio",
		id = "Radio1",
		initialSwitchState = true,
		onPress = onSwitchPress
	}
	radioGroup:insert(radio1)
	screenGroup:insert(radio1)

	radio2 = widget.newSwitch
	{
		x = display.contentWidth * 0.77,
		y = display.contentHeight * 0.72,
		style = "radio",
		id = "Radio2",
		initialSwitchState = false,
		onPress = onSwitchPress
	}
	radioGroup:insert(radio2)
	screenGroup:insert(radio2)

	if storyboard.state.np == true then
		radio1:setState({isOn = false})
		radio2:setState({isOn = true})
	end
end

function onSwitchPress(event)
	playAud(selSound)
    switch = event.target
    if event.target.id == "Radio1" then
    	storyboard.state.np = false
    else
    	storyboard.state.np = true
    end
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