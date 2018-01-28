require "Elements/elementBase"
vec2 = require "vector2d"

--[[ needs "radius" in pixels ]]--

ElementCircle = ElementBase:new();

-- remember this subclass for the editor
table.insert(ElementBase.elementClasses, ElementCircle);



function ElementCircle:draw()
  self:setDrawColor();
  love.graphics.circle("fill", self.x, self.y, self.radius);
  
  if (self.text) then
    love.graphics.setColor(0,255,255);
    love.graphics.printf(self.text, self.x -self.radius, self.y, 2*self.radius, "center");
  end
  
end

function ElementCircle:pointIsInside(x,y)
  self:setDefaults();
  local dx = x - self.x
  local dy = y - self.y
  return dx*dx+dy*dy <= self.radius*self.radius;
end

function ElementCircle:setDefaults()
  if not self.radius then self.radius = 30 end
  if not self.text then self.text = "circ" end
  if not self.color then self.color = { r = 255, g = 0, b = 0 } end
end

function ElementCircle:modifyBoid(i, boidData, addIfPossible)
  self:setDefaults()
  local deltaX = boidData.positions[i][1] - self.x
  local deltaY = boidData.positions[i][2] - self.y

  local len2 = vec2.len2(deltaX, deltaY)

  local range2 = self.radius * self.radius

  if len2 < range2 then
    local boidVX = boidData.velocities[i][1]
    local boidVY = boidData.velocities[i][2]

    local x, y = vec2.mirror(boidVX, boidVY, deltaX, deltaY)
    boidData.velocities[i][1] = x
    boidData.velocities[i][2] = y

    local normDeltaX, normDeltaY = vec2.normalize(deltaX, deltaY)
    normDeltaX = normDeltaX * self.radius
    normDeltaY = normDeltaY * self.radius


    boidData.positions[i][1] = self.x + normDeltaX * 1.1
    boidData.positions[i][2] = self.y + normDeltaY * 1.1

  end
end