planetling = {}

function planetling:new()
  local object = {
    mass = 10;
		radius = 1;
		xpos = 1;
		ypos = 1;
		xvel = 0;
		yvel = 0;
    grabbed = 1;
    isBig = true;
  }
  setmetatable(object, { __index = planetling })
  return object
end

function planetling:new(mass, radius, xpos, ypos)
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
  setmetatable(object, { __index = planetling })
  return object
end

function planetling:update(dt)
  self:setClosestPlanet()
  local dist;
  local grav;
  
  dist = math.atan2((planets[self.grabbed].xpos - self.xpos), (planets[self.grabbed].ypos - self.ypos));
  grav = (gravity * self.mass) / (math.pow((math.abs(self.xpos) + math.abs(planets[self.grabbed].xpos)), 2) + math.pow((math.abs(self.ypos) + math.abs(planets[self.grabbed].ypos)), 2));
  
  self.xvel = self.xvel + math.sin(dist) * grav;
  self.yvel = self.yvel + math.cos(dist) * grav;
  
  self.xpos = self.xpos + self.xvel * dt;
  self.ypos = self.ypos + self.yvel * dt;
  
end

function planetling:setClosestPlanet()
  local distFrom1, distFrom2, distFrom3, min;
  distFrom1 = math.dist(planets[1].xpos, planets[1].ypos, self.xpos, self.ypos);
  distFrom2 = math.dist(planets[2].xpos, planets[2].ypos, self.xpos, self.ypos);
  distFrom3 = math.dist(planets[3].xpos, planets[3].ypos, self.xpos, self.ypos);
  min = math.min(distFrom1, distFrom2, distFrom3)
  if (min == distFrom1) then self.grabbed = 1; end
  if (min == distFrom2) then self.grabbed = 2; end
  if (min == distFrom3) then self.grabbed = 3; end   
end

function planetling:draw()
  yae.graphics.setColor(255, 255, 255) 
  yae.graphics.circle("fill", self.xpos, self.ypos, self.radius, 18)
end
