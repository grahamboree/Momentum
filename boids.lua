vec2 = require "vector2d"

NUM_BOIDS = 2000
boidconf = {
	maxSpeed = 50,
	maxForce = 3000,
	neighborRadius = 30,
}

accelerations = {}
velocities = {}
positions = {}
neighbors = {}

function normRand()
	return love.math.random() * 2 - 1
end

local function init()
	for i = 1, NUM_BOIDS do
		accelerations[i] = {0, 0}
		velocities[i] = {0, 0} -- {normRand() * boidconf.maxSpeed, normRand() * boidconf.maxSpeed}
		positions[i] = {love.math.random(config.width), love.math.random(config.height)}
		
		neighbors[i] = {}
		for j = 1, NUM_BOIDS do
			neighbors[i][j] = false
		end
	end
end

local function draw()
	-- draw all the things
	for i = 1, NUM_BOIDS do
		love.graphics.setColor(255, 255, 255)
		love.graphics.circle("fill", positions[i][1], positions[i][2], 2, 5)
	end
end

local function updateNeighbors()
	local sqNR = boidconf.neighborRadius * boidconf.neighborRadius
	for i = 1, NUM_BOIDS do
		for j = 1, NUM_BOIDS do
			local dx = positions[i][1] - positions[j][1]
			local dy = positions[i][2] - positions[j][2]

			local isNeighbor = vec2.len2(dx, dy) <= sqNR

			neighbors[i][j] = isNeighbor
			neighbors[j][i] = isNeighbor
		end
	end
end

local function separation(i)
	local steerX = 0
	local steerY = 0
	local numNeighbors = 0

	for j = 1, NUM_BOIDS do
		if i ~= j and neighbors[i][j] then
			numNeighbors = numNeighbors + 1

			-- compute separation
			local toX, toY = vec2.sub(positions[i][1], positions[i][2], positions[j][1], positions[j][2])

			local len = vec2.len(toX, toY)
			local normX, normY = toX/len, toY/len

			local scaler = 1 / len

			steerX = steerX + normX * scaler
			steerY = steerY + normY * scaler
		end
	end

	if numNeighbors == 0 then
		return {0, 0}
	end

	return {
		(steerX / numNeighbors) * boidconf.maxForce,
		(steerY / numNeighbors) * boidconf.maxForce
	}
end

local function alignment()
end

local function cohesion()
end

local function steer()
	for i = 1, NUM_BOIDS do
		accelerations[i] = separation(i)
	end
end

local function update(dt)
	updateNeighbors()
	steer()

	for i = 1, NUM_BOIDS do
		-- damping
		accelerations[i][1] = accelerations[i][1] * .9
		accelerations[i][2] = accelerations[i][2] * .9
		velocities[i][1] = velocities[i][1] * .9
		velocities[i][2] = velocities[i][2] * .9

		-- update velocity with acceleration
		velocities[i][1] = velocities[i][1] + accelerations[i][1] * dt
		velocities[i][2] = velocities[i][2] + accelerations[i][2] * dt

		-- update position with velocity
		positions[i][1] = positions[i][1] + velocities[i][1] * dt
		positions[i][2] = positions[i][2] + velocities[i][2] * dt

		-- wrap horizontal
		if positions[i][1] > config.width then
			positions[i][1] = 0
		elseif positions[i][1] < 0 then
			positions[i][1] = config.width - 1
		end

		-- wrap vertical
		if positions[i][2] > config.height then
			positions[i][2] = 0
		elseif positions[i][2] < 0 then
			positions[i][2] = config.height - 1
		end
	end
end


return {
	draw = draw,
	enter = init,
	update = update
}
