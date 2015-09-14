planet = {}

function planet:new(mass, radius, xpos, ypos)
  local object = {
    mass = mass;
    radius = radius;
    xpos = xpos;
    ypos = ypos;
    xvel = 0;
    yvel = 0;
    grabbed = 1;
    isBig = true;
  }
  setmetatable(object, { __index = planet })
  return object
end

function planet:update(dt)
  -- Update big planet
end

function planet:draw()
  yae.graphics.setColor(100,149,237) 
  yae.graphics.circle("fill", self.xpos, self.ypos, self.radius, 18)
end
