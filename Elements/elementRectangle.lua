require "Elements/elementBase"

--[[ needs "width" "height" in pixels
     "x" and "y" are centered
 ]]--


ElementRectangle = ElementBase:new();

-- remember this subclass for the editor
table.insert(ElementBase.elementClasses, ElementRectangle);


function ElementRectangle:draw()
  love.graphics.setColor(0,0,255);
  love.graphics.rectangle("fill", self.x - self.width/2, self.y -self.height/2, self.width, self.height);
end

function ElementRectangle:pointIsInside(x,y)
  local dx = x - self.x
  local dy = y - self.y
  
  if (dx < -self.width/2) then return false end
  if (dx > self.width/2) then return false end
  if (dy < -self.height/2) then return false end
  if (dy > self.height/2) then return false end
  
  return true;
end

function ElementRectangle:setDefaults()
  if not self.width then self.width = 30 end
  if not self.height then self.height = 60 end
end

    