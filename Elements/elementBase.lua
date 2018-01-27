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
    self:setDefaults();
    return obj;
  end
  
  function ElementBase:draw()
    print "No draw method for element!";
  end
  
  function ElementBase:pointIsInside(x,y)
    return false
  end
  
  
  function ElementBase:setDefaults() end
  