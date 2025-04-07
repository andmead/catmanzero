-- shift + alt + k to open game
WF = require 'libraries/windfield' --library for physics
Camera = require 'libraries/camera'
Anim8 = require 'libraries/anim8' --library for character animation
STI = require 'libraries/sti' --library to help in using Tiled
VECTOR = require 'libraries/hump.vector' --library for vectors/timers/generally helpful utilities
TIMER = require 'libraries/hump.timer'
SIGNAL = require 'libraries/hump.signal'
Game = require 'states/game'
require('player')
require('cop')

function love.load() --loads the game
    World = WF.newWorld(0, 0, true) --space where physics objects exist arg1 x grav arg2 y grav arg3 sleep(optional)
    World:setGravity(0, 3000)

    love.graphics.setDefaultFilter('nearest', 'nearest')
    Cam = Camera() --generates camera object storing it within cam
    love.window.setMode(1280, 720, highdpi)
    Screen = love.window.getDPIScale()
    GameMap = STI('background6.lua')

    player:load()
    cop:load()
    World:addCollisionClass('player')
    player.collider:setCollisionClass('player')
    World:addCollisionClass('cop')
    cop.collider:setCollisionClass('cop')
    World:addCollisionClass('wall')
    World:addCollisionClass('BladeBeam', {ignores = {'wall'}})
    World:addCollisionClass('projectile', {ignores = {'wall'}})

    game = Game()

    sounds = {}
    sounds.music = love.audio.newSource('sounds/bgm_action_3.mp3', 'stream')
    sounds.music:setLooping(true)
    sounds.sword = love.audio.newSource('sounds/swordsound.wav', 'static')
    sounds.cophit = love.audio.newSource('sounds/cophit.wav', 'static')
    sounds.copdie = love.audio.newSource('sounds/copdie.wav', 'static')
    sounds.playerhit = love.audio.newSource('sounds/playerhit.mp3', 'static')

    controls = '"a" = left, "d" = right, "space" = jump, "left click" = shoot'
    start = 'Press "Enter" to Start Game'
    replay = 'Press "Enter" to Restart Game'
    youLose = 'Game Over'
    youWin = 'You Win!'

    GameWalls = {}
    if GameMap.layers['Walls'] then
        for i, obj in pairs(GameMap.layers['Walls'].objects) do
            local wall = World:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            wall:setCollisionClass('wall')
            table.insert(GameWalls, wall)
        end
    end
    sounds.music:play()
end

function love.update(dt) --updates the current pixels
    if game.state.menu then
        if love.keyboard.isDown('return') then
            game.state.menu = false
            game.state.running = true
        end
    end
    if game.state.running then
        player:update(dt)
        cop:update(dt)
        World:update(dt)
        Cam:lookAt(player.x, player.y)

        local w = love.graphics.getWidth()
        local h = love.graphics.getHeight()
        if Cam.x < w/2 then --stops the camera from showing the black background when you go too far left
            Cam.x = w/2
        end
        if Cam.y < h/2 then --stops the camera from showing the black background when you go too far up
            Cam.y = h/2
        end
        local mapW = GameMap.width * GameMap.tilewidth
        local mapH = GameMap.height * GameMap.tileheight
        if Cam.x > (mapW - w/2) then --stops on right border
            Cam.x = (mapW - w/2)
        end
        if Cam.y > (mapH - h/2) then --stops on bottom border
            Cam.y = (mapH - h/2)
        end
        updateBladeBeams(dt)

        if player.hp <= 0 or cop.hp <= 0 then
            game.state.running = false
            game.state.ended = true
        end
    end
    if game.state.ended then
        if love.keyboard.isDown('return') then
            game.state.ended = false
            love.event.quit('restart')
        end
    end
end

function DrawBladeBeams()
    for _, beam in ipairs(player.bladeBeams) do
        local bx, by = beam.collider:getPosition()
        beam.anim:draw(player.slash.spritesheet, bx, by, nil, 0.6, 0.6, 50, 50)
    end
end

function love.draw() --draws the image to the screen 
    if game.state.menu then
        love.graphics.print(controls, (love.graphics.getWidth() * 0.2), 200, nil, 2, 2)
        love.graphics.print(start, (love.graphics.getWidth() * 0.35), 500, nil, 2, 2)
    end
    if game.state.running then
        love.graphics.push()
        Cam:attach()
        love.graphics.scale(1.5, 2) --scaling the resolution
        love.graphics.translate(0, -190)
            GameMap:drawLayer(GameMap.layers['Background'])
            GameMap:drawLayer(GameMap.layers['railing'])
            GameMap:drawLayer(GameMap.layers['boxes'])
            GameMap:drawLayer(GameMap.layers['lamp posts'])
            GameMap:drawLayer(GameMap.layers['fencing'])
            GameMap:drawLayer(GameMap.layers['crates'])

            player:draw()
            cop:draw()

        --World:draw() --for debug
        DrawBladeBeams()
        love.graphics.pop()
        Cam:detach()
        love.graphics.print(player.hp, 20, 50, nil, 3, 3) --player hp
        love.graphics.print('Player', 20, 20, nil, 2, 2)
        love.graphics.print(cop.hp, 1220, 50, nil, 3, 3) --cop hp
        love.graphics.print('Cop', 1210, 20, nil, 2, 2)
    end
    if game.state.ended then
        love.graphics.print(replay, (love.graphics.getWidth() * 0.35), 500, nil, 2, 2)
        if player.hp <= 0 then
            love.graphics.print(youLose, (love.graphics.getWidth() * 0.455), 200, nil, 2, 2)
        elseif cop.hp <= 0 then
            love.graphics.print(youWin, (love.graphics.getWidth() * 0.455), 200, nil, 2, 2)
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end