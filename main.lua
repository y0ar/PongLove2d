-- Constants
local maxHeight = love.graphics.getHeight()
local maxWidth = love.graphics.getWidth()
local gameFont = love.graphics.newFont(50)
local point = 1

-- Player
local player = {}
player.x = 25
player.y = 100
player.speed = 5
player.height = 75
player.width = 20
player.score = {}
player.score.value = 0
player.score.x = (maxWidth / 2) - 75
player.score.y = 20

-- Opponent
local opponent = {}
opponent.x = maxWidth - player.x - player.width
opponent.y = (maxHeight - player.y) / 2
opponent.speed = player.speed
opponent.height = player.height
opponent.width = player.width
opponent.score = {}
opponent.score.value = 0
opponent.score.x = (maxWidth + 75) / 2
opponent.score.y = player.score.y
local goUp = false
local goDown = false

-- Ball
local ball = {}
local ballSpeed = -5
ball.radius = 10
ball.x = (maxWidth + ball.radius) / 2
ball.y = (maxHeight + ball.radius) / 2
ball.speed = {}
ball.speed.x = 0
ball.speed.y = 0

function love.load()
    ball.speed.x = ballSpeed
    goUp = true; -- Set an initial direction
end

function love.update()
    -- Player movement
    if love.keyboard.isDown("up") and player.y > 0 then
        player.y = player.y - player.speed
    end
    if love.keyboard.isDown("down") and player.y < maxHeight - player.height then
        player.y = player.y + player.speed
    end

    -- Opponent movement
    MoveOpponent()

    -- Ball movement
    ball.x = ball.x + ball.speed.x
    ball.y = ball.y + ball.speed.y

    -- Collision with player
    if ball.x == player.x + player.width and ball.y >= player.y and ball.y <= player.y + player.height then
        -- Collision with player while moving
        if love.keyboard.isDown("up") then
            ball.speed.y = -player.speed
        end
        if love.keyboard.isDown("down") then
            ball.speed.y = player.speed
        end

        -- No collision on the X axis since the player can only move up and down
        ball.speed.x = -ballSpeed
    end

    -- Collision with opponent
    if ball.x + ball.radius == opponent.x and ball.y >= opponent.y and ball.y <= opponent.y + opponent.height then
        ball.speed.x = ballSpeed
    end

    -- Collision of ball with walls
    -- Top wall
    if ball.y == 0 + ball.radius then
        ball.speed.y = -ballSpeed
    end
    -- Bottom wall
    if ball.y == maxHeight - ball.radius then
        ball.speed.y = ballSpeed
    end
    -- Left wall
    if ball.x == 0 + ball.radius then
        ball.speed.x = -ballSpeed
        opponent.score.value = opponent.score.value + point
    end
    -- Right wall
    if ball.x == maxWidth - ball.radius then
        ball.speed.x = ballSpeed
        player.score.value = player.score.value + point
    end
end

function love.draw()
    -- Player
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
    love.graphics.rectangle("fill", opponent.x, opponent.y, opponent.width, opponent.height)
    
    -- Ball
    love.graphics.circle("fill", ball.x, ball.y, ball.radius)

    -- Separator
    love.graphics.rectangle("fill", maxWidth / 2, 0, 1, maxHeight)

    -- Score
    love.graphics.print(tostring(player.score.value), player.score.x, player.score.y)
    love.graphics.print(tostring(opponent.score.value), opponent.score.x, opponent.score.y)
    love.graphics.setFont(gameFont)
end

function MoveOpponent()
    if opponent.y == 0 then
        goUp = false
        goDown = true
    elseif opponent.y == maxHeight - opponent.height then
        goUp = true
        goDown = false
    end

    if (goUp) then
        opponent.y = opponent.y - opponent.speed
    end
    if (goDown) then
        opponent.y = opponent.y + opponent.speed
    end
end
