
states = {
  startScreen = require "startScreen",
  elementEditor =require "elementEditor",
}

-- game config
config = {
	width = 1600,
	height = 900,
  showWindowChrome = false,

  vortexStrength = 0.05,
  repulsorStrength = 0.05
}

--mainState = states.startScreen;
mainState = states.elementEditor;

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
  love.graphics.clear(20,20,20, 255)
  mainState.draw()
end

function love.mousereleased(...)
  if (mainState.mousereleased) then mainState.mousereleased(...) end
end

function love.mousepressed(...)
  if (mainState.mousepressed) then mainState.mousepressed(...) end
end

function love.textinput(text)
  if (mainState.textinput) then mainState.textinput(text) end
end

function love.keypressed(...)
  if (mainState.keypressed) then mainState.textinput(...) end
end

function setMainState(state)
  if mainState and mainState.exit then mainState.exit() end
  mainState = state;
  _notifyMainStateEnter();
end

function _notifyMainStateEnter()
  if mainState.enter then mainState.enter(config, states) end
end
