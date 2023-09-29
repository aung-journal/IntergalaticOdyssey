BeginGameState = Class{__includes = BaseState}

function BeginGameState:init()

    --set our transition to be full
    self.transitionAlpha = 1
end

function BeginGameState:enter(def)
    self.level = def.level

    Timer.tween(1, {
        [self] = {transitionAlpha = 0}
    })
    :finish(function ()
        gStateMachine:change('play')
    end)
end

function BeginGameState:update(dt)
    Timer.update(dt)
end

function BeginGameState:render()
    love.graphics.draw(gTextures['background'], 16, 0)
end