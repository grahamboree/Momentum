require "Elements/elementBase"

--[[ needs "radius" in pixels ]]--

ElementCircle = ElementBase:new();

-- remember this subclass for the editor
table.insert(ElementBase.elementClasses, ElementCircle);


function ElementCircle:draw()
  love.graphics.setColor(255,0,0);
  love.graphics.circle("fill", self.x, self.y, self.radius);
end

function ElementCircle:pointIsInside(x,y)
  local dx = x - self.x
  local dy = y - self.y
  return dx*dx+dy*dy <= self.radius*self.radius;
end

function ElementCircle:setDefaults()
  if not self.radius then self.radius = 30 end
end

    
