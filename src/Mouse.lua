Mouse = Class{}

function Mouse:init()
    self.transitionAlpha = 1
end

function Mouse:update(dt)
    local mouseX, mouseY = push:toGame(love.mouse.getPosition())

    if mouseY > VIRTUAL_HEIGHT then
        MOUSE  = false
    end

    if mouseX and mouseY then
        --this is for setting
        if gStateMachine:getCurrentStateName() ~= 'start' then
            if gStateMachine:getCurrentStateName() == 'play' then
                if MouseCollidesXY(16, 0, 16, 16, mouseX, mouseY) and love.mouse.isDown(1) then
                    gStateMachine:change('setting', {
                        state = gStateMachine:getCurrentStateName()
                    })
                end
            elseif gStateMachine:getCurrentStateName() == 'instructions' then
                if MouseCollidesXY(32, 0, 16, 16, mouseX, mouseY) and love.mouse.isDown(1) then
                    gStateMachine:change('setting', {
                        state = gStateMachine:getCurrentStateName()
                    })
                end
            -- elseif gStateMachine:getCurrentStateName() == 'setting' then
            --     if MouseCollidesXY(VIRTUAL_WIDTH / 2 + 8, VIRTUAL_HEIGHT / 6, 80, 65, mouseX, mouseY) then
            --         MUSIC = true
            --     end
            end
        else--this is start state only
            if MouseCollidesXY(16, 0, 16, 16, mouseX, mouseY) and love.mouse.isDown(1) then
                gStateMachine:change('setting', {
                    state = gStateMachine:getCurrentStateName()
                })
            end
        end
    end

    --this is for pause State
end