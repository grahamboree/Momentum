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

	local range2 = self.radius * self.radius

	if len2 < range2 then
		local scaler = 1 - (len2 / range2)
		scaler = scaler * boidconf.maxForce

		local force = seek(i, self.x, self.y)
		forceY, forceX = vec2.normalize(force[1], force[2])

		local velLength = vec2.len(boidData.velocities[i][1], boidData.velocities[i][2]) 
		local normVelX = boidData.velocities[i][1] / velLength
		local normVelY = boidData.velocities[i][2] / velLength

		local len = math.sqrt(len2)

		if vec2.angleTo(normVelX, normVelY, deltaX / len, deltaY / len) < 0 then
			--forceY = -forceY
		end

		addIfPossible({forceX, forceY}, scaler)
	end
end
