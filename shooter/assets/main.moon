debug = true

-- Timers
-- We declare these here so we don't have to edit them multiple places
canShoot = true
canShootTimerMax = 0.2 
canShootTimer = canShootTimerMax
createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax

-- Player Object
player = { x: 200, y: 710, speed: 150, img: nil }
isAlive = true
score  = 0

-- Image Storage
bulletImg = nil
enemyImg = nil

-- Entity Storage
bullets = {} -- array of current bullets being drawn and updated
enemies = {} -- array of current enemies on screen

-- Collision detection
checkCollision = (x1, y1, w1, h1, x2, y2, w2, h2) ->
  x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1

-- Load images on loading screen
player.img = non.graphics.newImage 'plane.png'
enemyImg = non.graphics.newImage 'enemy.png'
bulletImg = non.graphics.newImage 'bullet.png'

-- Updating
non.update = (dt) ->
  dt = dt * 1000
  if non.keyboard.isDown 'escape'
    non.system.quit!

  -- Time out how far apart our shots can be.
  canShootTimer = canShootTimer - dt
  if canShootTimer < 0 then canShoot = true

  -- Time out enemy creation
  createEnemyTimer = createEnemyTimer - dt
  if createEnemyTimer < 0
    createEnemyTimer = createEnemyTimerMax

    -- Create an enemy
    randomNumber = math.random 10, non.window.getWidth! - 10
    newEnemy = { x: randomNumber, y: -10, img: enemyImg }
    table.insert enemies, newEnemy

  -- update the positions of bullets
  for i, bullet in ipairs bullets
    bullet.y = bullet.y - (250 * dt)

    -- remove bullets when they pass off the screen
    if bullet.y < 0 then table.remove bullets, i

  -- update the positions of enemies
  for i, enemy in ipairs(enemies) do
    enemy.y = enemy.y + (200 * dt)

    -- remove enemies when they pass off the screen
    if enemy.y > 850 then table.remove enemies, i

  -- run our collision detection
  -- Since there will be fewer enemies on screen than bullets we'll loop them first
  -- Also, we need to see if the enemies hit our player
  for i, enemy in ipairs enemies
    for j, bullet in ipairs bullets
      if checkCollision(enemy.x, enemy.y, enemy.img\getWidth!, enemy.img\getHeight!, bullet.x, bullet.y, bullet.img\getWidth!, bullet.img\getHeight!)
        table.remove bullets, j
        table.remove enemies, i
        score = score + 1

    if checkCollision(enemy.x, enemy.y, enemy.img\getWidth!, enemy.img\getHeight!, player.x, player.y, player.img\getWidth!, player.img\getHeight!) and isAlive
      table.remove(enemies, i)
      isAlive = falsey

  if non.keyboard.isDown 'left','a'
    -- binds us to the map 
    if player.x > 0
      player.x -= player.speed * dt
  elseif non.keyboard.isDown 'right','d'
    if player.x < (non.window.getWidth! - player.img\getWidth!)
      player.x += player.speed * dt

  if non.keyboard.isDown('space', 'rctrl', 'lctrl') and canShoot
    -- Create some bullets
    newBullet = { x: player.x + player.img\getWidth! / 2, y: player.y, img: bulletImg }
    table.insert bullets, newBullet
    canShoot = false
    canShootTimer = canShootTimerMax

  if not isAlive and non.keyboard.isDown 'r'
    -- remove all our bullets and enemies from screen
    bullets = {}
    enemies = {}

    -- reset timers
    canShootTimer = canShootTimerMax
    createEnemyTimer = createEnemyTimerMax

    -- move player back to default position
    player.x = 50
    player.y = 710

    -- reset our game state
    score = 0
    isAlive = true

-- Drawing
non.draw = ->
  for i, bullet in ipairs bullets
    non.graphics.draw bullet.img, bullet.x, bullet.y

  for i, enemy in ipairs enemies
    non.graphics.draw enemy.img, enemy.x, enemy.y

  non.graphics.setColor 255, 255, 255
  non.graphics.print "SCORE: " .. tostring(score), 400, 10

  if isAlive
    non.graphics.draw player.img, player.x, player.y
  else
    non.graphics.print "Press 'R' to restart", non.window.getWidth! / 2 - 50, non.window.getHeight! / 2 - 10

  if debug then
    fps = tostring non.timer.getFPS!
    delta = tostring non.timer.getDelta!
    non.graphics.print "Current FPS: "..fps, 9, 10
    non.graphics.print "Current Delta: "..delta.." s", 9, 28
