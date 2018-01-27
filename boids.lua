NUM_BOIDS = 10000
boidconf = {
	maxSpeed = 300,
	maxForce = 100,
	neighborRadius = 100,
}

velocities = {}
positions = {}

local function init()
	for i = 1, NUM_BOIDS do
		velocities[i] = {love.math.random() * 100, love.math.random() * 100}
		positions[i] = {love.math.random(config.width), love.math.random(config.height)}
	end
end

local function draw()
	-- draw all the things
	for i = 1, NUM_BOIDS do
		love.graphics.setColor(255, 255, 255)
		love.graphics.circle("fill", positions[i][1], positions[i][2], 2, 5)
	end
end

local function steer()
end	

local function update(dt)
	steer()

	-- move all the things
	for i = 1, NUM_BOIDS do
		positions[i][1] = positions[i][1] + velocities[i][1] * dt
		positions[i][2] = positions[i][2] + velocities[i][2] * dt

		if positions[i][1] > config.width then
			positions[i][1] = 0
		end

		if positions[i][2] > config.height then
			positions[i][2] = 0
		end
	end
end

-- returns the other boids near the boid with index i
local function neighbors(i)
	-- TODO
	return positions
end

return {
	draw = draw,
	init = init,
	update = update
}
