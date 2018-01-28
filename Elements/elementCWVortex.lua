require "Elements/elementCircle"
vec2 = require "vector2d"

--[[ needs "radius" in pixels ]]--

ElementCWVortex = ElementCircle:new();

-- remember this subclass for the editor
ElementBase.elementClasses.ElementCWVortex = ElementCWVortex;

function ElementCWVortex:setDefaults()
  if not self.radius then self.radius = 100 end
  if not self.text then self.text = "CW vortex" end
  if not self.color then self.color = { r = 35, g = 35, b = 35 } end
  self.class = "ElementCWVortex"
end

function ElementCWVortex:modifyBoid(i, boidData, addIfPossible)
	self:setDefaults()

	local deltaX = self.x - boidData.positions[i][1]
	local deltaY = self.y - boidData.positions[i][2]

	local len2 = vec2.len2(deltaX, deltaY)
	local radius2 = self.radius * self.radius

	if len2 < radius2 then
		local velX = boidData.velocities[i][1]
		local velY = boidData.velocities[i][2]

		-- tangent to the velocity
		local tanX = velY
		local tanY = -velX

		local phi = config.vortexStrength * (1-(len2 / radius2))

		-- rotate the velocity
		local newX, newY = vec2.rotate(phi, velX, velY)
		boidData.velocities[i][1] = newX
		boidData.velocities[i][2] = newY

		boidData.modifiedThisUpdate[i] = true
		self.boidsUpdatedThisFrame = self.boidsUpdatedThisFrame + 1
	end
end
