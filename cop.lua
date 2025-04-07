cop = {}

function cop:load()
    local player = require('player')
    self.collider = World:newBSGRectangleCollider(780, 360, 26, 37, 8)
    self.collider:setFixedRotation(true)
    self.x = 780
    self.y = 360
    self.startX = 780
    self.startY = 360
    self.dir = VECTOR(-1, 0)
    self.maxhp = 10
    self.speed = 100
    self.hp = self.maxhp
    self.spritesheet = love.graphics.newImage('sprites/cop.png')
    self.grid = Anim8.newGrid( 30, 25, self.spritesheet:getWidth(), self.spritesheet:getHeight() )

    self.animations = {}
    self.animations.right = Anim8.newAnimation( self.grid('1-4', 1), 0.3 )
    self.animations.left = Anim8.newAnimation( self.grid('5-2', 3), 0.3 )
    self.anim = self.animations.left

    self.grounded = true
end

function cop:update(dt)
    local copMove = false
    local cx, cy = self.collider:getLinearVelocity() -- Get the current velocity of cop
    self.collider:setLinearVelocity(cx, cy)

    local px, py = player.collider:getPosition()
    local ex, ey = self.collider:getPosition()

    wallCheck = World:queryCircleArea(ex, ey, 18, {'wall'})
    if #wallCheck > 0 then
        self.collider:applyLinearImpulse(cx, -100)
    end

    function copMovement(dt)
        self.dir = VECTOR(px - ex, py - ey):normalized() * self.speed

        self.collider:setX(self.collider:getX() + self.dir.x * dt)
        self.collider:setY(self.collider:getY() + self.dir.y * dt)

        if self.dir.x >= 0 then
            self.anim = self.animations.right
        else
            self.anim = self.animations.left
        end

        copMove = true
    end

    copMovement(dt)
    cx = self.speed

    if cop.collider:enter('BladeBeam') then
        cop.hp = cop.hp - 1
        sounds.cophit:play()
    end

    if copMove == false then
        self.anim:gotoFrame(1)
    end

    self.anim:update(dt)
    self.x = self.collider:getX()
    self.y = self.collider:getY()
end

function cop:draw()
    self.anim:draw(self.spritesheet, self.x, self.y, nil, 1.5, nil, 8, 10)
end
