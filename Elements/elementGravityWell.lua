require "Elements/elementCircle"
vec2 = require "vector2d"

--[[ needs "radius" in pixels ]]--

ElementGravityWell = ElementCircle:new();

-- remember this subclass for the editor
ElementBase.elementClasses.ElementGravityWell = ElementGravityWell;


function ElementGravityWell:setDefaults()
  if not self.radius then self.radius = 100 end
  if not self.text then self.text = "grav" end
  if not self.color then self.color = { r = 35, g = 35, b = 35 } end
  self.class = "ElementGravityWell"
end

function ElementGravityWell:modifyBoid(i, boidData, addIfPossible)
  
	self:setDefaults()
	local deltaX = self.x - boidData.positions[i][1]
	local deltaY = self.y - boidData.positions[i][2]

	local len2 = vec2.len2(deltaX, deltaY)
	local radius2 = self.radius * self.radius

	if len2 < radius2 then
		local scaler = (len2 / radius2) * boidconf.maxForce
		local forceX, forceY = vec2.normalize(unpack(seek(i, self.x, self.y)))
		addIfPossible({forceY, -forceX}, scaler)
	end
end
