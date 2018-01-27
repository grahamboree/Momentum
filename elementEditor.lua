require "Elements/elementCircle"
require "Elements/elementRectangle"

local sidebar_guys = {};
local sidebar_width = 1/16.0;


local function enter()
  sidebar_guys = {}; -- rebuild sidebar
  
  local num_classes = #ElementBase.elementClasses;
  if (num_classes <= 0) then return end
  
  local delta_y = love.graphics.getHeight() / (1+num_classes);
  local y = delta_y/2;
  local x = love.graphics.getWidth() * sidebar_width / 2;
  
  for k, class in pairs(ElementBase.elementClasses) do
    local e = class:new {x = x, y = y}
    table.insert(sidebar_guys, e);
    y = y + delta_y;
  end
  
  
end



local function draw()
  
  love.graphics.setColor(50,50,50);
  love.graphics.rectangle("fill", 0,0, love.graphics.getWidth() * sidebar_width, love.graphics.getHeight());
  
  for k, template in pairs(sidebar_guys) do
    template:draw()
  end
  
end



return {
  draw = draw,
  enter = enter,
  
  };