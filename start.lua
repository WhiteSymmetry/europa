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
local txtScoreDisplay = nil
local timeSpent = 0
local score = 0

local gameTimer = nil
---------------------------------------------------------------------------------
-- END OF VARIABLE DECLARATIONS
---------------------------------------------------------------------------------


---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
local onTouchCountry = nil
local renderCountryImage = nil
local renderCountryText = nil

local isWithinTargetPosition = function( t )
  if ( math.abs(t.country.targetPosition.x - t.x) < t.country.targetPosition.dx ) and
    ( math.abs(t.country.targetPosition.y - t.y) < t.country.targetPosition.dy ) then
    return true
  else
    return false
  end
end

local moveToTargetPosition = function( t )
  transition.to( t, {time = 300, x = t.country.targetPosition.x, y = t.country.targetPosition.y} )
end

local moveToStartPosition = function( t )
  transition.to( t, {time = 300, x = START_X, y = START_Y} )
end

local calculateScore = function( timeSpent )
  if timeSpent > 60 then
    return 100
  else
    return 100 + 10*(60 - timeSpent)
  end
end

local renderScore = function( score )
  local txt = display.newText( "Your Score: " .. score, display.contentWidth/2, 1600, native.systemFont, 120 )
  txt.x = txt.x - txt.width/2

  return txt
end

local goBackToMainMenu = function( event )
  storyboard.gotoScene( "menu", "fade", 5000 )
end

local doEndOfGame = function()
  timer.cancel( gameTimer )
  txtCurrentCountry:removeSelf()
  txtTimeDisplay:removeSelf()

  score = calculateScore( timeSpent )
  txtScoreDisplay = renderScore( score )
  screen:insert( txtScoreDisplay )

  imgEuropeMap:addEventListener( "touch", goBackToMainMenu )
end

local showNextCountry = function()
  table.remove( countries, 1 )
  if #countries > 0 then
    currentCountry = countries[1]
    imgCurrentCountry:removeEventListener( "touch", onTouchCountry )
    txtCurrentCountry:removeSelf()
    imgCurrentCountry = renderCountryImage( currentCountry )
    screen:insert( imgCurrentCountry )
    txtCurrentCountry = renderCountryText( currentCountry )
    screen:insert( txtCurrentCountry )
  else
    doEndOfGame()
  end
end

onTouchCountry = function( event )
  local t = event.target
  local phase = event.phase

  if "began" == phase then
    t.isFocus = true
    t.x0 = event.x - t.x
    t.y0 = event.y - t.y
  elseif t.isFocus then
    if "moved" == phase then
      t.x = event.x - t.x0
      t.y = event.y - t.y0
      print("x = " .. t.x .. ", y = " .. t.y)
    elseif "ended" == phase or "cancelled" == phase then
      t.isFocus = false
      if isWithinTargetPosition( t ) then
        moveToTargetPosition( t )
        showNextCountry()
      else
        moveToStartPosition( t )
      end
    end
  end
end

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

renderCountryImage = function( country )
  local img = display.newImageRect( "images/" .. country.image, country.width, country.height )
  img.x = START_X
  img.y = START_Y
  img.country = country
  img:addEventListener( "touch", onTouchCountry )

  return img
end

renderCountryText = function( country )
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


