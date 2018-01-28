
-- ordered list of levels to play
--  filename is level name in UI

--require "Levels/stringLevels"
levelList = 
{
    "level1",
    "level2",
    "level3",
    "level4",
    "level5",
  }

local textX = 400;
local width = 400;
local textY = 300;
local buttonMargin = 10;
local buttonFrame = 10;
local yDelta = 100;

local buttons = {}

local function enter()
  local y = textY
  for i, name in pairs(levelList) do
    local button = ElementRectangle:new { x=textX, y=y, width=width, height= yDelta-buttonMargin, color = {r=255,g=255,b=0 }, text=name };
    buttons[i] = button;
    y = y + yDelta
  end

end


local function draw()
  
  local y = textY;
  for i, button in pairs(buttons) do
    button:draw()
  end
  
end

local function mousereleased()
  for i, button in pairs(buttons) do
    if (button:pointIsInside(love.mouse.getX(), love.mouse.getY())) then
      levelToLoad = button.text
        setMainState(states.playLevel);
    end
  end
  
end


return { enter = enter,
  draw = draw,
  mousereleased = mousereleased};