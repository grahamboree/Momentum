require "Elements/elementCircle"

--[[ needs "radius" in pixels ]]--

ElementGravityWell = ElementCircle:new();

-- remember this subclass for the editor
table.insert(ElementBase.elementClasses, ElementGravityWell);


function ElementGravityWell:setDefaults()
  if not self.radius then self.radius = 30 end
  if not self.text then self.text = "grav" end
  if not self.color then self.color = { r = 35, g = 35, b = 35 } end
end


