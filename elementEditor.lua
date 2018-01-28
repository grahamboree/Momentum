require "Elements/elementCircle"
require "Elements/elementRectangle"
require "Elements/elementRepulsor"
require "Elements/elementCWVortex"
require "Elements/elementCCWVortex"

require "utils"
require "DataDumper"

local tserialize = (require "tserialize").tserialize

boids = require "boids"

local sidebar_guys = {};
local placed_guys = {};
local sidebar_width = 1/16.0;
local buttons = {};

local level_filename = "editorLevel.lua"

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
  
  local num_classes = tablelength(ElementBase.elementClasses);
  if (num_classes <= 0) then return end
  
  local delta_y = love.graphics.getHeight() / (1+num_classes);
  local y = delta_y/2;
  local x = love.graphics.getWidth() * sidebar_width / 2;
  local button_y = y / 2;
  
  buttons = {
    ElementCircle:new { radius=30, y = button_y, x = x/2, text = "SAVE" },
    ElementCircle:new { radius=30, y = button_y, x = 3*x/2, text = "LOAD" },
    };
  
  for k, class in pairs(ElementBase.elementClasses) do
    local e = class:new {x = x, y = y}
    table.insert(sidebar_guys, e);
    y = y + delta_y;
    
    randomPlace(e);
  end
  
  activeElements = placed_guys
  boids.enter()
end

local function exit()
      love.keyboard.setKeyRepeat(false)
end


local utf8 = require("utf8")
 
 
text = "default"
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

  local button_pressed = getHitElement(x,y,buttons);
  if (button_pressed) then
    if (button_pressed.text == "SAVE") then 
      local s = tserialize(placed_guys)
      love.filesystem.write(level_filename, s);
    end
    if (button_pressed.text == "LOAD") then
      local s = love.filesystem.read(level_filename);
      local copy_func = loadstring(s);
      local copy =copy_func();
      
      
      for k,guy in pairs(copy) do
        local class = ElementBase.elementClasses[guy.class];
        setmetatable(guy, class);
      end
      
      placed_guys = copy;
      activeElements = placed_guys
    end
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

local function update(dt)
  updateDrag();  
  boids.update(dt)
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
  
  -- draw the buttons
  for k, button in pairs(buttons) do
    button:draw()
  end
  
  love.graphics.printf(text, 0, 0, love.graphics.getWidth())

  boids.draw()
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