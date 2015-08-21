with yae
  debug = true

  -- Timers
  canShoot = true
  canShootTimerMax = 0.3
  canShootTimer = canShootTimerMax
  createEnemyTimerMax = 0.4
  createEnemyTimer = createEnemyTimerMax

  -- Player Object
  player = { x: 200, y: 710, speed: 150, img: nil }
  isAlive = true
  score  = 0

  -- Entity Storage
  bullets = {}  -- Array of current bullets being drawn and updated.
  enemies = {}  -- Array of current enemies on screen.

  -- Collision Detection
  checkCollision = (x1, y1, w1, h1, x2, y2, w2, h2) ->
    x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1

  -- Import Locals
  import random from math
  import remove from table

  -- Load Images
  playerImg = .graphics.newImage 'plane.png'
  enemyImg = .graphics.newImage 'enemy.png'
  bulletImg = .graphics.newImage 'bullet.png'

  -- Width & Height Storage
  windowWidth, windowHeight = .window.getWidth!, .window.getHeight!
  playerWidth, playerHeight = playerImg\getWidth!, playerImg\getHeight!
  enemyWidth, enemyHeight = enemyImg\getWidth!, enemyImg\getHeight!
  bulletWidth, bulletHeight = bulletImg\getWidth!, bulletImg\getHeight!

  enemySpawnWidth = enemyWidth * 0.5  -- So our enemies don't spawn too far off the screen.

  -- Updating
  .update = (dt) ->
    dt *= 1000
    if .keyboard.isDown 'escape' then .system.quit!

    -- Time out how far apart our shots can be.
    canShootTimer -= dt
    canShoot = true unless canShootTimer >= 0

    -- Time out enemy creation.
    createEnemyTimer -= dt
    unless createEnemyTimer >= 0
      createEnemyTimer = createEnemyTimerMax

      -- Create an enemy.
      randomNumber = random enemySpawnWidth, windowWidth - enemySpawnWidth
      newEnemy = { x: randomNumber, y: -10, img: enemyImg }
      enemies[#enemies + 1] = newEnemy

    -- Update the positions of bullets.
    for i = 1, #bullets
      bullet = bullets[i]
      if bullet
        bullet.y -= (250 * dt)

        -- Remove bullets when they pass off the screen.
        remove bullets, i unless bullet.y >= 0

    -- Update the position of enemies.
    for i = 1, #enemies
      enemy = enemies[i]
      if enemy
        enemy.y += (200 * dt)

        -- Remove enemies when they pass off the screen.
        unless enemy.y <= 850
          remove enemies, i

          -- Reduce score for each missed plane.
          score -= 1
          isAlive = false unless score >= 0

    -- Run our collision detection. Since there will be fewer enemies on screen
    -- than bullets, we'll loop them first. Also, we need to see if the enemies
    -- hit our player.
    for i = 1, #enemies
      enemy = enemies[i]
      for j = 1, #bullets
        bullet = bullets[j]
        if (enemy and bullet) and checkCollision enemy.x, enemy.y, enemyWidth, enemyHeight, bullet.x, bullet.y, bulletWidth, bulletHeight
          remove bullets, j
          remove enemies, i
          score += 1

      if isAlive and (enemy and player) and checkCollision enemy.x, enemy.y, enemyWidth, enemyHeight, player.x, player.y, playerWidth, playerHeight
        remove enemies, i
        isAlive = false

    if isAlive
      if .keyboard.isDown 'left', 'a'
        -- Binds us to the map.
        player.x -= player.speed * dt unless player.x <= 0
      elseif .keyboard.isDown 'right', 'd'
        player.x += player.speed * dt unless player.x >= (windowWidth - playerWidth)

      if canShoot and .keyboard.isDown 'space', 'rctrl', 'lctrl'
        -- Create some bullets.
        newBullet = { x: player.x + playerWidth * 0.5, y: player.y, img: bulletImg }
        bullets[#bullets + 1] = newBullet
        canShoot = false
        canShootTimer = canShootTimerMax
    elseif .keyboard.isDown 'r'
      -- Remove all our bullets and enemies from screen.
      bullets = {}
      enemies = {}

      -- Reset timers.
      canShootTimer = canShootTimerMax
      createEnemyTimer = createEnemyTimerMax

      -- Move player back to default position.
      player.x = 50
      player.y = 710

      -- Reset our gate state.
      score = 0
      isAlive = true

  -- Drawing
  .draw = ->
    for i = 1, #bullets
      bullet = bullets[i]
      .graphics.draw bulletImg, bullet.x, bullet.y

    for i = 1, #enemies
      enemy = enemies[i]
      .graphics.draw enemyImg, enemy.x, enemy.y

    .graphics.setColor 255, 255, 255
    .graphics.print "SCORE: #{score}", 375, 10

    if isAlive
      .graphics.draw playerImg, player.x, player.y
    else
      .graphics.print "Press 'R' to restart.", windowWidth * 0.5 - 50, windowHeight * 0.5 - 10

    if debug
      fps = .timer.getFPS!
      delta = .timer.getDelta!
      .graphics.print "Current FPS: #{fps}", 9, 10
      .graphics.print "Current Delta: #{delta}s", 9, 28
