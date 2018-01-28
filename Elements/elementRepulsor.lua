require "Elements/elementCircle"
vec2 = require "vector2d"

--[[ needs "radius" in pixels ]]--

ElementRepulsor = ElementCircle:new();

-- remember this subclass for the editor
ElementBase.elementClasses.ElementRepulsor = ElementRepulsor

function ElementRepulsor:setDefaults()
  if not self.radius then self.radius = 100 end
  if not self.text then self.text = "rep" end
  if not self.color then self.color = { r = 35, g = 35, b = 35 } end
end

function ElementRepulsor:modifyBoid(i, boidData, addIfPossible)
	self:setDefaults()
	local deltaX = self.x - boidData.positions[i][1]
	local deltaY = self.y - boidData.positions[i][2]

	local len2 = vec2.len2(deltaX, deltaY)

	local radius2 = self.radius * self.radius

	if len2 < radius2 then
		local scaler = (1 - (len2 / radius2)) * boidconf.maxForce

		--[[
		local vx = deltaY * boidconf.maxSpeed
		local vy = -deltaX * boidconf.maxSpeed

		forceX, forceY = vec2.normalize(unpack(steerToVelocity(i, vx, vy)))
		--forceX, forceY = vec2.normalize(unpack(seek(i, self.x, self.y)))
		local len = math.sqrt(len2)

		if vec2.dot(boidData.velocities[i][1], boidData.velocities[i][2], deltaX, deltaY) > 0 then
			addIfPossible({-forceX, -forceY}, scaler)
		end
		]]

		local velX = boidData.velocities[i][1]
		local velY = boidData.velocities[i][2]

		-- tangent to the velocity
		local tanX = velY
		local tanY = -velX

		local phi = -config.gravityWellStrenth * (1-(len2 / radius2))
		if vec2.dot(deltaX, deltaY, tanX, tanY) > 0 then
			phi = phi * -1
		end

		-- rotate the velocity
		local newX, newY = vec2.rotate(phi, velX, velY)
		boidData.velocities[i][1] = newX
		boidData.velocities[i][2] = newY
	end
end
