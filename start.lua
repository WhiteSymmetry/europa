local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local ui = require "scripts.lib.ui"
local radlib = require "scripts.lib.radlib"
local _ = require "scripts.lib.underscore"

local countries = require "countries"
countries = _.shuffle( countries )

---------------------------------------------------------------------------------
-- BEGINNING OF VARIABLE DECLARATIONS
---------------------------------------------------------------------------------
local START_X = 500
local START_Y = 1700

local screen = nil
local imgEuropeMap = nil
local imgCurrentCountry = nil
local txtCurrentCountry = nil
local txtTimeDisplay = nil
local timeSpent = 0

local gameTimer = nil
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

local renderCountryImage = function( country )
  local img = display.newImageRect( "images/" .. country.image, country.width, country.height )
  img.x = START_X
  img.y = START_Y
  img.country = country

  return img
end

local renderCountryText = function( country )
  local txt = display.newText( country.name, START_X, START_Y + 200, native.systemFont, 120 )
  txt.x = txt.x - txt.width/2

  return txt
end

local clockTick = function( event )
  timeSpent = timeSpent + 1
  txtTimeDisplay.text = string.format( "%03d", timeSpent )
end

function scene:createScene( event )
  screen = self.view

  imgEuropeMap = renderEuropeMap()
  screen:insert( imgEuropeMap )

  txtTimeDisplay = renderTimer()
  screen:insert( txtTimeDisplay )

  currentCountry = countries[1]
  imgCurrentCountry = renderCountryImage( currentCountry )
  screen:insert( imgCurrentCountry )

  txtCurrentCountry = renderCountryText( currentCountry )
  screen:insert( txtCurrentCountry )

  gameTimer = timer.performWithDelay( 1000, clockTick, 0 )
end

function scene:enterScene( event )
  timer.resume( gameTimer )
end

function scene:exitScene( event )
  timer.pause( gameTimer )
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


