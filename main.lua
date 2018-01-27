vec2 = require "vector2d"
boids = require "boids"

-- game config
config = {
	width = 1600,
	height = 900
}

-- intialization
function love.load()
  -- ZeroBrane debugging requirement
  if arg[#arg] == "-debug" then require("mobdebug").start() end
	
  -- Disable window decorations
  love.window.setMode(config.width, config.height, {centered=true, borderless=true, msaa=8})
  
  -- Really start
  boids.init()
end

function love.update(dt)
  boids.update(dt)
end

function love.draw()
  boids.draw()
end
