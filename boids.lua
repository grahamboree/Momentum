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

local function steerToVelocity(i, desiredX, desiredY)
	--[[
	local forceX = desiredX - velocities[i][1]
	local forceY = desiredY - velocities[i][2]

	local forceLen = vec2.len(forceX, forceY)

	local magnitude = forceLen / vec2.len(desiredX, desiredY)
	magnitude = clamp01(magnitude) * boidconf.maxForce

	return {
		(forceX / forceLen) * magnitude,
		(forceY / forceLen) * magnitude
	}
	]]

	return {
		desiredX - velocities[i][1],
		desiredY - velocities[i][2]
	}
end

local function seek(i, x, y)
	-- delta position
	local desiredX = x - positions[i][1]
	local desiredY = y - positions[i][2]

	local distanceToTarget = vec2.len(desiredX, desiredY)

	-- delta position w/max force length
	desiredX = (desiredX / distanceToTarget) * boidconf.maxSpeed
	desiredY = (desiredY / distanceToTarget) * boidconf.maxSpeed

	return steerToVelocity(i, desiredX, desiredY)
end

local function separation(i)
	local steerX = 0
	local steerY = 0
	local numNeighbors = 0

	for j = 1, NUM_BOIDS do
		if i ~= j and neighbors[i][j] then
			numNeighbors = numNeighbors + 1

			-- vector from the neighbor to the current boid
			local toX, toY = positions[i][1] - positions[j][1], positions[i][2] - positions[j][2]

			-- normalize the vector
			local len = vec2.len(toX, toY)
			local normX, normY = toX/len, toY/len

			-- less force the closer the neighbor
			local scaler = 1 / len

			-- accumulate the force
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

local function cohesion(i)
	local centroidX = 0
	local centroidY = 0
	local numNeighbors = 0

	for j = 1, NUM_BOIDS do
		if i ~= j and neighbors[i][j] then
			numNeighbors = numNeighbors + 1

			centroidX = centroidX + positions[j][1]
			centroidY = centroidY + positions[j][2]
		end
	end

	if numNeighbors == 0 then
		return {0, 0}
	end

	return seek(i, centroidX / numNeighbors, centroidY / numNeighbors)
end

local function alignment(i)
	local sumX, sumY = 0, 0
	local hasNeighbors = false

	for i = 1, NUM_BOIDS do
		if i ~= j and neighbors[i][j] then
			hasNeighbors = true
			sumX = sumX + velocities[j][1]
			sumY = sumY + velocities[j][2]
		end
	end

	if not hasNeighbors then
		return {0, 0}
	end

	local len = vec2.len(sumX, sumY)
	return {
		(sumX / len) * boidconf.maxSpeed - velocities[i][1],
		(sumY / len) * boidconf.maxSpeed - velocities[i][2]
	}
end

local function update(dt)
	updateNeighbors()

	for i = 1, NUM_BOIDS do
		-- steer
		local sep = separation(i)
		local coh = cohesion(i)
		local ali = alignment(i)

		accelerations[i] = {
			sep[1] + coh[1] + ali[1],
			sep[2] + coh[2] + ali[2]
		}

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
