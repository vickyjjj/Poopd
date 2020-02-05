 --main
display.setStatusBar( display.HiddenStatusBar )
local storyboard = require "storyboard"
local json = require "json"
parse = require "mod_parse" 
parse:init({ 
  appId = "IiNiJKE7AtSZF07l0d15v0SMjq47GJ6UQubsadEX", 
  apiKey = "gZBU8aO0tyKbd1TJiwz7hdp6NLknBx5DMkHP55Fa"
})

--save table to file
function saveTable(t, filename)
	local path = system.pathForFile(filename , system.DocumentsDirectory)
	local file = io.open(path, "w")
	if file then
		local contents = json.encode(t)
		file:write(contents)
		io.close(file)
		return true
	else
		return false
	end
end

--load in the table from file
function loadTable(filename)
	local path = system.pathForFile(filename, system.DocumentsDirectory)
	local contents = ""
	local myTable = {}
	local file = io.open(path, "r")
	if file then
		local contents = file:read("*a")
		myTable = json.decode(contents)
		io.close(file)
		return myTable
	end
	return nil
end

storyboard.state = {}
storyboard.state.finScore = 0
storyboard.state.prevHiScore = 0
myGameSettings = loadTable("mygamesettings.json")

--set data in the game from file
function setData()
	if myGameSettings ~= nil then
		storyboard.state.hiScore = myGameSettings.hiScore
		storyboard.state.level = myGameSettings.level
		storyboard.state.np = myGameSettings.np
	else
		myGameSettings = {}
		storyboard.state.hiScore = 0
		storyboard.state.level = "Let it rain poop"
		storyboard.state.np = false
	end
end

--global things

selSound = audio.loadSound("select.wav")
cam = audio.loadSound("cam.wav")

function playAud(type)
	audio.play(type)
end

function backToMenu(event)
	if event.phase == "began" then
		audio.play(selSound)
		storyboard.gotoScene("start", "fade", 100)
	end
end

setData()
parse:appOpened()

storyboard.gotoScene( "start" )