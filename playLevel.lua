require "elementEditor"

local function enter()
  
  states.elementEditor.enter()
  
  -- load level
  
  --local s = levels[levelToLoad]
  --local func = loadstring(s)
  --local guys =func()
  local unclassed = require("Levels/" .. levelToLoad)
  applyClassesAndSet( unclassed )
  
    
  foo = activeElements

    for k, template in pairs(unclassed) do
    template:draw()
    end
  
  -- reset boids
  states.boids.enter()
  
end


local function draw()
  -- draw the placed elements
  for k, template in pairs(activeElements) do
    template:draw()
  end
  
  boids.draw()
  
  love.graphics.print("R to restart     ESC to exit puzzle", 10, love.graphics.getHeight() - 100)
end


local function update(dt)
  boids.update(dt)
end

local function keypressed(key)
    if key == "r" then
        setMainState(states.playLevel);
    end
    
    if key == "escape" then
      setMainState(states.levelList);
      end
end


return { enter = enter,
  draw = draw,
  update=update,
  keypressed=keypressed};