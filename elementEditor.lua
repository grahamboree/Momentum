require "Elements/elementCircle"

local sidebar_guys = {};

local function enter()
  sidebar_guys = {}; -- rebuild sidebar
  
  local num_classes = #ElementBase.elementClasses;
  if (num_classes <= 0) then return end
  
  local delta_y = love.graphics.getHeight() / (1+num_classes);
  local y = delta_y/2;
  local x = love.graphics.getWidth() / 6;
  
  for k, class in pairs(ElementBase.elementClasses) do
    local e = class:new {x = x, y = y}
    table.insert(sidebar_guys, e);
  end
  
  
end



local function draw()
  for k, template in pairs(sidebar_guys) do
    template:draw()
  end
  
end



return {
  draw = draw,
  enter = enter,
  
  };