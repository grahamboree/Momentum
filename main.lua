vec2 = require "vector2d"

states = {
  boids = require "boids",
  startScreen = require "startScreen",
  elementEditor =require "elementEditor",
}

-- game config
config = {
	width = 1600,
	height = 900,
  showWindowChrome = false,
}


mainState = states.boids;
--mainState = states.startScreen;
--mainState = states.elementEditor;

-- intialization
function love.load()
  -- ZeroBrane debugging requirement
  if arg[#arg] == "-debug" then require("mobdebug").start() end
	
  -- Set up window 
  love.window.setMode(config.width, config.height, {centered=true, borderless=not config.showWindowChrome, msaa=8})
  
  -- Really start
  if mainState.enter then mainState.enter() end
end

function love.update(dt)
  if mainState.update then mainState.update(dt) end
end

function love.draw()
  mainState.draw()
end

function love.mousereleased(...)
  if (mainState.mousereleased) then mainState.mousereleased(args) end
end



function setMainState(state)
  if mainState and mainState.exit then mainState.exit() end
  mainState = state;
  _notifyMainStateEnter();
end

function _notifyMainStateEnter()
  if mainState.enter then mainState.enter(config, states) end
end
