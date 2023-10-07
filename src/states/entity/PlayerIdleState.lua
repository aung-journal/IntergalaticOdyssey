PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(player)
    self.player = player

    self.animation = Animation {
        --no need to worry as this is the same as green alien
        frames = {1},
        interval = 1
    }

    self.player.currentAnimation = self.animation
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        
        self.player:changeState('walking')
    end
    --not elseif because we want to make changing to jump state and walk state available simultaneously

    if love.keyboard.wasPressed('space') then
        self.player:changeState('jump')
    end

    --check if we have collided with any entities and die if so
    for k, entity in pairs(self.player.level.entities) do
        if entity:collides(self.player) then
            gSounds['death']:play()
            gStateMachine:change('start')
        end
    end
end