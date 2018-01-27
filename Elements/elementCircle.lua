require "Elements/elementBase"

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

    
