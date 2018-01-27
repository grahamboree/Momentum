vec2 = require "vector2d"
boids = require "boids"

-- game config
config = {
	width = 1600,
	height = 900,
  showWindowChrome = false,
}

mainState = boids;


-- intialization
function love.load()
  -- ZeroBrane debugging requirement
  if arg[#arg] == "-debug" then require("mobdebug").start() end
	
  -- Set up window 
  love.window.setMode(config.width, config.height, {centered=true, borderless=not config.showWindowChrome, msaa=8})
  
  -- Really start
  mainState.enter()
end

function love.update(dt)
  mainState.update(dt)
end

function love.draw()
  mainState.draw()
end

function setMainState(state)
  if mainState then mainState.exit() end
  mainState = state;
  mainState.enter();
end
