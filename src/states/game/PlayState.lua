PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.camX = 0
    self.camY = 0
    self.level = LevelMaker.generate(100, 10)
    self.tileMap = self.level.tileMap
    self.background = math.random(PLAINS)
    self.backgroundX = 0

    self.gravityOn = true
    self.gravityAmount = 6

    self.player = Player({
        x = 0, y = 0,
        width = 16, height =  20,
        stateMachine = StateMachine {
            ['idle'] = function() return PlayerIdleState(self.player) end,
            ['walking'] = function() return PlayerWalkingState(self.player) end,
            ['jump'] = function() return PlayerJumpState(self.player, self.gravityAmount) end,
            ['falling'] = function() return PlayerFallingState(self.player, self.gravityAmount) end
        },
        map = self.tileMap,
        level = self.level
    })
end

function PlayState:update(dt)
    Timer.update(dt)

    --remove any nils from pickups, etc
    self.level:clear()

    --update player and level
    self.player:update(dt)
    self.level:update(dt)
    self:updateCamera()

    --constrain player X no matter which state
    if self.player.x <= 0 then
        self.player.x = 0
    elseif self.player.x > TILE_SIZE * self.tileMap.width - self.player.width then
        self.player.x = TILE_SIZE * self.tileMap.width - self.player.width
    end
end

function PlayState:updateCamera()
    --clamp movement of the camera 's X between 0 and the map bounds - VIRTUAL_WIDTH
    self.camX = math.max(0,
        math.min(TILE_SIZE * self.tileMap.width - VIRTUAL_WIDTH,
        self.player.x - (VIRTUAL_WIDTH / 2 - 8)))

    --adjust the background X to move a third the rate of camera for parallax
    self.backgroundX = (self.camX / 3) % VIRTUAL_WIDTH--this is looping point logic
end

function PlayState:render()
    love.graphics.push()
    love.graphics.draw(gTextures['plains'], gFrames['plains'][self.background], math.floor(-self.backgroundX), 0)
    love.graphics.draw(gTextures['plains'], gFrames['plains'][self.background], math.floor(-self.backgroundX),
        gTextures['plains']:getHeight() / 3 * 2, 0, 1, -1)
    love.graphics.draw(gTextures['plains'], gFrames['plains'][self.background], math.floor(-self.backgroundX + 256), 0)
    love.graphics.draw(gTextures['plains'], gFrames['plains'][self.background], math.floor(-self.backgroundX + 256),
        gTextures['plains']:getHeight() / 3 * 2, 0, 1, -1)
    
    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))
    
    self.level:render()

    self.player:render()
    love.graphics.pop()
    
    -- render score
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(tostring(self.player.score), 5, 5)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(tostring(self.player.score), 4, 4)
end

--[[
    Add a series of enemies  to the level randomly
]]
function PlayState:spawnEnemies()
    --spawn snails in the level
    for x = 1, self.tileMap.width do
        
        local groundFound = false

        for y = 1, self.tileMap.height do
            if not groundFound then
                if self.tileMap.tiles[y][x].id == TILE_ID_GROUND then
                    groundFound = true

                    --random chance, 1 in 20(this is for slimes)
                    if math.random(20) == 1 then
                        
                        local slime--this is declaration in advance
                        slime = Slime {
                            texture = 'slimes',
                            x = (x - 1) * TILE_SIZE,
                            y = (y - 2) * TILE_SIZE + 2,
                            width = 16,
                            height = 16,
                            stateMachine = StateMachine {
                                ['idle'] = function () return SlimeIdleState(self.tileMap, self.player, slime) end,
                                ['moving'] = function() return SlimeMovingState(self.tilelMap, self.player, slime) end,
                                ['chasing'] = function() return SlimeChasingState(self.tileMap, self.player, slime) end
                            }
                        }
                        slime:changeState('idle', {
                            wait = math.random(5)
                        })

                        table.insert(self.level.entities, slime)
                    end
                end
            end
        end
    end
end