require "audio"

--[[ 

An element knows:
  "x"  "y" position
  how to draw itself
  whether or not a given point is "inside" it (to handle mouse dragging)
  
Later, an element may need to know:
  how a firefly at position p should react to it
  
Since the basic functions in ElementBase don't do anything, this base class is rather pointless.  But they are here to remind me what to implement for each element....   
  
]]--
  
ElementBase = {};
ElementBase.elementClasses = {};

function ElementBase:new(obj)
  obj = obj or {}   -- create object if user does not provide one
  setmetatable(obj, self);
  self.__index = self;
  self.boidsUpdatedThisFrame = 0
  return obj;
end

function ElementBase:draw()
  self:setDefaults();
  print "No draw method for element!";
end

function ElementBase:AllowWin()
  return true
end


function ElementBase:pointIsInside(x,y)
  self:setDefaults();
  return false
end

function ElementBase:setDrawColor()
  self:setDefaults();
  love.graphics.setColor(self.color.r, self.color.g, self.color.b);
end

function ElementBase:setDefaults() end

function ElementBase:modifyBoid(i, boidData, addIfPossible) end
  
function ElementBase:preModifyAllBoids(e, boidData) 
  if not self.currentSound then
    self.currentSound = love.audio.newSource(loop(e % 6))
    self.currentSound:setLooping(true)
    self.currentSound:play()
    self.currentSound:setVolume(0)

  else
    self.currentSound:setVolume(clamp01(self.boidsUpdatedThisFrame / 100))
    self.boidsUpdatedThisFrame = 0
  end
end
