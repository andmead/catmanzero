player = {}

function player:load()
    local cop = require('cop')
    self.x = 0
    self.y = 463
    self.vector = VECTOR.new(self.x, self.y)
    self.maxhp = 3
    self.hp = self.maxhp
    self.speed = 200
    self.collider = World:newBSGRectangleCollider(0, 463, 25, 33, 8)
    self.collider:setFixedRotation(true)
    self.spritesheet = love.graphics.newImage('sprites/player.png')
    self.grid = Anim8.newGrid( 32, 23, self.spritesheet:getWidth(), self.spritesheet:getHeight() )

    self.animations = {}
    self.animations.moveRight = Anim8.newAnimation( self.grid('1-4', 1), 0.3 )
    self.animations.moveLeft = Anim8.newAnimation( self.grid('4-1', 4), 0.3 )
    self.animations.attackRight = Anim8.newAnimation( self.grid('1-4', 2), 0.15 )
    self.animations.attackLeft = Anim8.newAnimation( self.grid('4-1', 6), 0.15 )
    self.anim = self.animations.moveRight

    self.slash = {}
    self.slash.spritesheet = love.graphics.newImage('sprites/slashes.png')
    self.slash.grid = Anim8.newGrid( 120, 90, self.slash.spritesheet:getWidth(), self.slash.spritesheet:getHeight() )
    self.slash.right = Anim8.newAnimation(self.slash.grid('1-6', 1), 0.1)
    self.slash.anim = self.slash.right
    self.bladeBeams = {}
end

function shootBladeBeam(direction)
    if #player.bladeBeams > 0 then
        for _, beam in ipairs(player.bladeBeams) do
            beam.collider:destroy()
        end
        player.bladeBeams = {}
    end
    local offset = 15
    local spawnX = player.x + math.cos(direction) * offset
    local spawnY = player.y
    Beam = {
        collider = World:newCircleCollider(spawnX, spawnY, 20),
        anim = player.slash.anim,
    }
    Beam.collider:setCollisionClass('BladeBeam')
    Beam.collider:setGravityScale(0)

    local speed = 600
    Beam.collider:setLinearVelocity(math.cos(direction) * speed, 0)
    table.insert(player.bladeBeams, Beam)
end

function player:update(dt)
    local isMoving = false --flag to check if player is moving to use idle animation
    local vx, vy = self.collider:getLinearVelocity() -- Get the current velocity of player

    if love.keyboard.isDown('d') then
        vx = self.speed
        self.anim = self.animations.moveRight
        isMoving = true
    end

    if love.keyboard.isDown('a') then
        vx = self.speed * -1
        self.anim = self.animations.moveLeft
        isMoving = true
    end

    if love.keyboard.isDown('space') then --jumping logic
        local px, py = self.collider:getPosition()
        px = px + 10
        local colliders = World:queryCircleArea(px, py, 18, {'wall'})
        if #colliders > 0 then
            vy = self.speed * -3
            isMoving = true
        end
    end
    
    function updateBladeBeams(dt)
        for i = #player.bladeBeams, 1, -1 do
            local beam = player.bladeBeams[i]
            beam.anim:update(dt)
        end
    end

    if love.mouse.isDown('1') then
        if self.anim == self.animations.moveRight then
            self.anim = self.animations.attackRight
            shootBladeBeam(0)
        elseif self.anim == self.animations.moveLeft then
            self.anim = self.animations.attackLeft
            shootBladeBeam(math.pi)
        end
        isMoving = true
        sounds.sword:play()
    end

    if isMoving == false then
        self.anim:gotoFrame(1)
    end

    if self.collider:enter('cop') then
        self.hp = self.hp - 1
        sounds.playerhit:play()
    end

    self.x = self.collider:getX()
    self.y = self.collider:getY()
    self.anim:update(dt)
    self.collider:setLinearVelocity(vx, vy)
end

function player:draw()
    self.anim:draw(self.spritesheet, self.x, self.y, nil, 1.5, nil, 8, 10) --8 and 10 are for cam offset half of character's pixel l&w
end