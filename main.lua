config = {
  width = 1600,
  height = 900
}

NUM_BOIDS = 100

velocities = {}
positions = {}

function love.load()
  love.window.setMode(config.width, config.height, {centered=true, borderless=true, msaa=8})

  for i = 1, NUM_BOIDS do
    velocities[i] = {love.math.random() * 100, love.math.random() * 100}
    positions[i] = {love.math.random(config.width), love.math.random(config.height)}
  end
end

function love.update(dt)
  for i = 1, NUM_BOIDS do
    positions[i][1] = positions[i][1] + velocities[i][1] * dt
    positions[i][2] = positions[i][2] + velocities[i][2] * dt
  end
end

function love.draw()
  for i = 1, NUM_BOIDS do
    drawBoid(positions[i][1], positions[i][2])
  end
end

function drawBoid(x, y)
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("fill", x, y, 2, 5)
end
