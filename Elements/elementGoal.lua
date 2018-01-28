require "Elements/elementRectangle"
vec2 = require "vector2d"


ElementGoal = ElementRectangle:new();

-- remember this subclass for the editor
ElementBase.elementClasses.ElementGoal = ElementGoal;


function ElementGoal:setDefaults()
  if not self.width then self.width = 30 end
  if not self.height then self.height = 60 end
  if not self.fliesNeeded then self.fliesNeeded = 50 end
  if not self.text then self.text = "goal" end
  if not self.color then self.color = { r = 255, g = 255, b = 255 } end
  if not self.captured then self.captured = {} end
  if not self.numCaptured then self.numCaptured = 0 end
  
  self.class = "ElementGoal"
end

function ElementGoal:preModifyAllBoids(boidData) 
	self:setDefaults()
  
  -- uncapture dead boids
  for i,ignore in ipairs(self.captured) do
    if not boidData.active[i] then
      self.captured[i] = false
      self.numCaptured = self.numCaptured - 1
    end
  end
  
  
  -- capture new boids
  for i = 1, NUM_BOIDS do
    if (self.numCaptured >= self.fliesNeeded) then break end
    
		if boidData.active[i] and not self.captured[i] then
      local boidX = boidData.positions[i][1]
      local boidY = boidData.positions[i][2]
  
      if self:pointIsInside(boidX, boidY) then
        self.numCaptured = self.numCaptured + 1;
        self.captured[i] = true;
        print(i .. " at " .. boidX .. "x" .. boidY)
        
      end
    end
  end
  
  self.text = self.numCaptured .. "/" .. self.fliesNeeded;
  self.happy = (self.numCaptured >= self.fliesNeeded)
  print("tot = " .. self.numCaptured)
end
  

function ElementGoal:modifyBoid(i, boidData, addIfPossible)
  self:setDefaults()

  if self.captured[i] then 

    local xMin = self.x - self.width / 2
    local xMax = self.x + self.width / 2
    local yMin = self.y - self.height / 2
    local yMax = self.y + self.height / 2
    

    local boidX = boidData.positions[i][1]
    local boidY = boidData.positions[i][2]
    local boidVX = boidData.velocities[i][1]
    local boidVY = boidData.velocities[i][2]

    if (boidVX ~= boidVX) then print("xNaN before!") end


    if (boidX < xMin) then
      boidX = xMin
      boidVX = - boidVX * .9
    end

    if (boidX > xMax) then
      boidX = xMax
      boidVX = - boidVX
    end
    
    if (boidY < yMin) then
      boidY = yMin
      boidVY = - boidVY * .9
    end
    
    if (boidY > yMax) then
      boidY = yMax
      boidVY = - boidVY
    end

    if (boidVX ~= boidVX) then print("xNaN after!") end

    boidData.positions[i][1] = boidX
    boidData.positions[i][2] = boidY

    boidData.velocities[i][1] = boidVX
    boidData.velocities[i][2] = boidVY
  end
end
