vec2 = require "vector2d"
boids = require "boids"

-- game config
config = {
	width = 1600,
	height = 900
}

-- intialization
function love.load()
	love.window.setMode(config.width, config.height, {centered=true, borderless=true, msaa=8})
  boids.init()
end

function love.update(dt)
  boids.update(dt)
end

function love.draw()
  boids.draw()
end
