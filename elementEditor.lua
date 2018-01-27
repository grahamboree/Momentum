require "Elements/elementCircle"
require "Elements/elementRectangle"

require "DataDumper"

local sidebar_guys = {};
local placed_guys = {};
local sidebar_width = 1/16.0;


local function randomPlace(template)

  local s = DataDumper(template);
  local copy_func = loadstring(s);
  local copy =copy_func();
  copy.x = copy.x + 400;
  table.insert(placed_guys, copy);

end

local function enter()
  love.keyboard.setKeyRepeat(true)

  
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
    
    randomPlace(e);
  end
end

local function exit()
      love.keyboard.setKeyRepeat(false)
end


local utf8 = require("utf8")
 
 
local text = "default"
local function textinput(t)
    text = text .. t
end
 
local function keypressed(key)
    if key == "backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(text, -1)
 
        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            text = string.sub(text, 1, byteoffset - 1)
        end
    end
end

local draggedGuy = nil;
local function startDrag(x,y,drag_me)
  draggedGuy = drag_me
  dragOffset = { dx = drag_me.x - x, dy = drag_me.y -y };
end


local function getHitElement(x,y,element_list)
  for k, element in pairs(element_list) do
    if (element:pointIsInside(x,y)) then return element end
  end
  return nil;
end

local function mousepressed(x,y)
  local placed = getHitElement(x,y,placed_guys);
  if (placed) then startDrag(x,y,placed) end
  
  local template = getHitElement(x,y,sidebar_guys);
  if (template) then
    local dude = randomPlace(template);
  end
end

local function updateDrag()
  if (draggedGuy) then
    draggedGuy.x = love.mouse.getX() + dragOffset.dx;
    draggedGuy.y = love.mouse.getY() +dragOffset.dy;
  end
  
end


local function mousereleased(x,y)
  updateDrag()
  draggedGuy = nil;

end




local function update()
  updateDrag();  
end


    


local function draw()
  
  -- draw sidebar box
  love.graphics.setColor(50,50,50);
  love.graphics.rectangle("fill", 0,0, love.graphics.getWidth() * sidebar_width, love.graphics.getHeight());
  
  -- draw sidebar contents
  for k, template in pairs(sidebar_guys) do
    template:draw()
  end
  
  -- draw the placed elements
  for k, template in pairs(placed_guys) do
    template:draw()
  end
  
  love.graphics.printf(text, 0, 0, love.graphics.getWidth())

end



return {
  draw = draw,
  enter = enter,
  exit = exit,
  update = update,
  --keypressed = keypressed,  -- not doing filenames for the moment
  --textinput = textinput,
  mousepressed = mousepressed,
  mousereleased = mousereleased,
  };