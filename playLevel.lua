require "elementEditor"
require "audio"

musicIndex = 1

local function enter()
  
  states.elementEditor.enter()
  
  local unclassed = require("Levels/" .. levelToLoad)
  applyClassesAndSet( unclassed )
  
  -- reset boids
  states.boids.enter()
  
  -- choose some music!
  sounds.music.level1:stop()
	sounds.music.level2:stop()
	sounds.music.level3:stop()
  
  sounds.music["level" .. musicIndex]:play()
  
  musicIndex = musicIndex + 1
  if (musicIndex > 3) then musicIndex = 1 end

  
end


local function weWon()
  -- see how many goal elements are happy
  for k, element in pairs(activeElements)do
    if (not element:AllowWin()) then
      return false
    end
    
  end
  
  return true
end


local function draw()
  -- draw the placed elements
  for k, template in pairs(activeElements) do
    template:draw()
  end
  
  boids.draw()
  
  local y = love.graphics.getHeight() - 100;
  love.graphics.print("R to restart     ESC to exit puzzle", 10, y )
  
  if (weWon()) then
    
    love.graphics.print("YOU WIN!", 600, y)
  
  end
  
end



local function update(dt)
  boids.update(dt)
  updateDrag()
end

local function keypressed(key)
    if key == "r" then
        setMainState(states.playLevel);
    end
    
    if key == "escape" then
      setMainState(states.levelList);
      end
end

local function mousereleased(x,y)
  updateDrag()
  draggedGuy = nil;
end

local function mousepressed(x,y)
  local placed = getHitElement(x,y,activeElements);
  if (placed and not placed.playerCantDrag) then 
    startDrag(x,y,placed) 
  end
  
  
end

return { enter = enter,
  draw = draw,
  update=update,
  keypressed=keypressed,
  mousereleased=mousereleased,
  mousepressed=mousepressed};