
local function enter(config, states)

end


local function draw()
  love.graphics.print("Click to start!", 400, 300);
end

local function mousereleased()
  setMainState(states.boids);
end


return { draw = draw,
  mousereleased = mousereleased};