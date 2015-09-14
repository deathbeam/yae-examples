require "planet"
require "planetling"

SCREEN_WIDTH = yae.window.getWidth()
SCREEN_HEIGHT = yae.window.getHeight()

-- Run once on load
function yae.load()
  planets = {};
  
  gravity = 80000;
  
  pause = false;

  planets[1] = planet:new(700000, 70, (SCREEN_WIDTH/2), (SCREEN_HEIGHT/2) - 100)
  planets[2] = planet:new(500000, 50, (SCREEN_WIDTH/2) + 150, (SCREEN_HEIGHT/2) - 60)
  planets[3] = planet:new(500000, 50, (SCREEN_WIDTH/2) - 200, (SCREEN_HEIGHT/2) + 140)  
      
  -- Each planet has a vaguely random mass and position. They will move away from each other naturally. 
  for i = 4, 35 do
    planets[i] = planetling:new(math.random(10)*20, 2+math.random(4), 600+math.random(50), 300+math.random(100))
  end
  for i = 35, 200 do
    planets[i] = planetling:new(math.random(10)*20, 2+math.random(4), 100 + math.random(100), 600 + math.random(200))
  end
end

-- dist between in 2d land
function math.dist(ax, az, bx, bz) 
  return math.sqrt((bx - ax)*(bx - ax) + (bz - az)*(bz - az));
end

function yae.draw()
  -- Draw BG
  yae.graphics.setColor(0, 0, 0) -- Cornflower Blue
  yae.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
  
  -- Draw planets and blobs
  yae.graphics.setColor(0, 0, 0)
  for i = 1, #planets do
    planets[i]:draw()
  end
  
  -- Return the colour back to normal
  yae.graphics.setColor(255, 255, 255)
end

function yae.update(dt)
  if not pause then    
    for i = 1, #planets do
      planets[i]:update(dt)
    end
  end
end

function yae.keypressed(key)
  if key == 'p' then
    pause = not pause;
  end
end