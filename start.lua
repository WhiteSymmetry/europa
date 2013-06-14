local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local ui = require "scripts.lib.ui"
local radlib = require "scripts.lib.radlib"

---------------------------------------------------------------------------------
-- BEGINNING OF VARIABLE DECLARATIONS
---------------------------------------------------------------------------------
local screen = nil
local imgEuropeMap = nil
local txtTimeDisplay = nil
local timeSpent = 0
---------------------------------------------------------------------------------
-- END OF VARIABLE DECLARATIONS
---------------------------------------------------------------------------------


---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
local renderEuropeMap = function()
  local map = display.newImageRect( "images/europe.png", 1372, 1395 )
  map.x = display.contentWidth/2
  map.y = display.contentHeight/2 - 280

  return map
end

local renderTimer = function()
  local t = display.newText( '000', 1000, 1600, native.systemFont, 240 )
  t:setTextColor( 180, 180, 100 )

  return t
end

function scene:createScene( event )
  screen = self.view

  imgEuropeMap = renderEuropeMap()
  screen:insert( imgEuropeMap )

  txtTimeDisplay = renderTimer()
  screen:insert( txtTimeDisplay )
end

function scene:enterScene( event )
  print("Start loaded...")

  storyboard.removeAll()
end

function scene:exitScene( event )
  -- stop timers, sound, etc.
end

function scene:destroyScene( event )
  -- free up resources here
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )
---------------------------------------------------------------------------------

return scene


