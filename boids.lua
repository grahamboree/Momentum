vec2 = require "vector2d"
require "utils"

NUM_BOIDS = 5000
boidconf = {
	maxSpeed = 200,
	maxForce = 3000,
	neighborRadius = 30,
	sepWeight = 0,
	aliWeight = 0,
	cohWeight = 0,

	startVelDirVariance = 0.001,
	startVelMagVariance = 20,
	wanderVariance = 0,
	jitter = 1,

	emissionRate = 20
}

active = {}
accelerations = {}
velocities = {}
positions = {}
neighbors = {}
modifiedThisUpdate = {}

boidData = {
	active = active,
	accelerations = accelerations,
	velocities = velocities,
	positions = positions,
	neighbors = neighbors,
	modifiedThisUpdate = modifiedThisUpdate
}

currentboid = 0

activeElements = {}

local function init()
	for i = 1, NUM_BOIDS do
		active[i] = false
		accelerations[i] = {0, 0}
		velocities[i] = {0, 0}
		positions[i] = {0, 0}

		modifiedThisUpdate[i] = false
		
		neighbors[i] = {}
		for j = 1, NUM_BOIDS do
			neighbors[i][j] = false
		end
	end
end

local function draw()
	love.graphics.setColor(255, 225, 141)

	-- draw all the things
	for i = 1, NUM_BOIDS do
		if active[i] then
			love.graphics.circle("fill", positions[i][1], positions[i][2], 3, 5)
		end
	end
end

local function updateNeighbors()
	local sqNR = boidconf.neighborRadius * boidconf.neighborRadius
	for i = 1, NUM_BOIDS do
		if active[i] then
			for j = 1, NUM_BOIDS do
				local dx = positions[i][1] - positions[j][1]
				local dy = positions[i][2] - positions[j][2]

				local isNeighbor = active[j] and vec2.len2(dx, dy) <= sqNR

				neighbors[i][j] = isNeighbor
				neighbors[j][i] = isNeighbor
			end
		end
	end
end

function steerToVelocity(i, desiredX, desiredY)
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

function seek(i, x, y)
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
	local numNeighbors = 0

	for j = 1, NUM_BOIDS do
		if i ~= j and neighbors[i][j] then
			numNeighbors = numNeighbors + 1
			sumX = sumX + velocities[j][1]
			sumY = sumY + velocities[j][2]
		end
	end

	if numNeighbors == 0 then
		return {0, 0}
	end

	-- average the velocity
	sumX = sumX / numNeighbors
	sumY = sumY / numNeighbors

	return steerToVelocity(i, sumX, sumY)
end

local function steer(i)
	local maxF2 = boidconf.maxForce * boidconf.maxForce

	local forceLeft2 = maxF2
	local result = {0, 0}

	local addIfPossible = function(force, scaler)
		force[1] = force[1] * scaler
		force[2] = force[2] * scaler

		if forceLeft2 > 0 then
			local clampedForce = clampVec2(force, forceLeft2)
			forceLeft2 = forceLeft2 - vec2.len2(clampedForce[1], clampedForce[2])

			result[1] = result[1] + clampedForce[1]
			result[2] = result[2] + clampedForce[2]
		end
	end

	for e, element in pairs(activeElements) do
		element:modifyBoid(i, boidData, addIfPossible)
	end

	local posX = positions[i][1]
	local posY = positions[i][2]
	local velX = velocities[i][1]
	local velY = velocities[i][2]

	--local phi = boidconf.wanderVariance * normNoise(posX * 10, posY * 10)

	local noise = normNoise(posX * 0.001 + i, posY * 0.001 + i)
	-- noise = love.math.random() * 2 - 1

	local phi = boidconf.wanderVariance * noise
	velX, velY = vec2.rotate(phi, velX, velY)
	velocities[i][1] = velX
	velocities[i][2] = velY

	--addIfPossible(alignment(i), boidconf.aliWeight)
	--addIfPossible(separation(i), boidconf.sepWeight)
	--addIfPossible(cohesion(i), boidconf.cohWeight)

	return result
end

local function update(dt)
	--updateNeighbors()

	local spawnedThisFrame = 0
	for i = 1, NUM_BOIDS do
		if not active[i] then
			active[i] = true

			local posX, posY = vec2.randomDirection(30, 30)
			positions[i][1] = posX + 50
			positions[i][2] = posY + 50

			local velX = 1.41421356237 -- sqrt(2)
			local velY = 1.41421356237
			velX, velY = vec2.mul(boidconf.maxSpeed, velX, velY)

			local phi = boidconf.startVelDirVariance * normNoise(posX, posY)
			velX, velY = vec2.rotate(phi, velX, velY)

			velocities[i][1] = velX
			velocities[i][2] = velY

			spawnedThisFrame = spawnedThisFrame + 1

			if spawnedThisFrame >= boidconf.emissionRate then
				break
			end
		end
	end

  for e, element in pairs(activeElements) do
		element:preModifyAllBoids(e, boidData)
	end

	for i = 1, NUM_BOIDS do
		if active[i] then
			accelerations[i] = steer(i)

			-- damping
			--velocities[i][1] = velocities[i][1] * .999
			--velocities[i][2] = velocities[i][2] * .999

			-- update velocity with acceleration
			velocities[i][1] = velocities[i][1] + accelerations[i][1] * dt
			velocities[i][2] = velocities[i][2] + accelerations[i][2] * dt

			-- update position with velocity
			positions[i][1] = positions[i][1] + velocities[i][1] * dt
			positions[i][2] = positions[i][2] + velocities[i][2] * dt

			-- only apply jitter if we haven't been modified by an object this frame.
			if not modifiedThisUpdate[i] then
				local posX = positions[i][1]
				local posY = positions[i][2]

				local jitterNoise = normNoise(posX * 0.001 + i, posY * 0.001 + i) * 2 * 3.14159

				local jitterX, jitterY = vec2.rotate(jitterNoise, 0, 1)
				jitterX, jitterY = vec2.mul(boidconf.jitter, jitterX, jitterY)

				positions[i][1] = positions[i][1] + jitterX
				positions[i][2] = positions[i][2] + jitterY
			end

			active[i] = positions[i][1] <= config.width and positions[i][1] >= 0
				and positions[i][2] <= config.height and positions[i][2] >= 0
		end
		modifiedThisUpdate[i] = false
	end
end

return {
	draw = draw,
	enter = init,
	update = update
}
