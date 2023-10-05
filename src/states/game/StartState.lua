local positions = {}

StartState = Class{__includes = BaseState}

function StartState:init()
    --current selected menu
    self.currentMenuItem = 1

    self.menu = {
        "Play",
        "Instructions",
        "Settings",
        "Achievements",
        "Exit"
    }

    -- Define your colors
    self.colors = {
        [1] = {217/255, 87/255, 99/255, 1},
        [2] = {95/255, 205/255, 228/255, 1},
        [3] = {251/255, 242/255, 54/255, 1},
        [4] = {118/255, 66/255, 138/255, 1},
        [5] = {153/255, 229/255, 80/255, 1},
        [6] = {223/255, 113/255, 38/255, 1}
    }

    -- Define the letters and their spacing for "Intergalactic"
    self.letter1Table = {
        { letter = 'I', x = 0 },
        { letter = 'n', x = 8 },
        { letter = 't', x = 16 },
        { letter = 'e', x = 24 },
        { letter = 'r', x = 32 },
        { letter = 'g', x = 40 },
        { letter = 'a', x = 48 },
        { letter = 'l', x = 56 },
        { letter = 'a', x = 64 },
        { letter = 'c', x = 72 },
        { letter = 't', x = 80 },
        { letter = 'i', x = 88 },
        { letter = 'c', x = 96 },
    }
    
    -- Define the letters and their spacing for "Odyssey"
    self.letter2Table = {
        { letter = 'O', x = 0 },
        { letter = 'd', x = 8 },
        { letter = 'y', x = 16 },
        { letter = 's', x = 24 },
        { letter = 's', x = 32 },
        { letter = 'e', x = 40 },
        { letter = 'y', x = 48 }
    }

    self.colorTimer = Timer.every(0.075, function ()
        
        self.colors[0] = self.colors[6]

        for i = 6, 1, -1 do
            self.colors[i] = self.colors[i - 1]
        end
    end)

    self.transitionAlpha = 0

    self.pauseInput = false
end

function StartState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if self.pauseInput == false then
        --change menu selection
        if love.keyboard.wasPressed('up') then
            self.currentMenuItem = math.max(1, self.currentMenuItem - 1)
            gSounds['selection']:play()
        elseif love.keyboard.wasPressed('down') then
            self.currentMenuItem = math.min(#self.menu, self.currentMenuItem + 1)
            gSounds['selection']:play()
        end

        -- switch to another state via one of the menu options
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            if self.currentMenuItem == 1 then      
                -- handle "Play" menu option
                -- tween, using Timer, the transition rect's alpha to 1, then
                -- transition to the BeginGame state after the animation is over
                Timer.tween(1, {
                    [self] = {transitionAlpha = 1}
                }):finish(function()
                    gStateMachine:change('begin-play', {
                        level = 1
                    })

                    --self.colorTimer:remove()
                end)
            elseif self.currentMenuItem == 2 then
                Timer.tween(1, {
                    [self] = {transitionAlpha = 1}
                }):finish(function ()
                    gStateMachine:change('instructions', {
                        transitionAlpha = self.transitionAlpha
                    })

                    self.colorTimer:remove()
                end)
            elseif self.currentMenuItem == 3 then
                Timer.tween(1, {
                    [self] = {transitionAlpha = 1}
                }):finish(function ()
                    gStateMachine:change('setting')

                    self.colorTimer:remove()
                end)

            elseif self.currentMenuItem == #self.menu then
                love.event.quit()
            end

            --turn off input during transition
            self.pauseInput = true
        end

        --this for mouse logic of checking things
        -- check if the mouse is inside any of the menu options
        for i, option in ipairs(self.menu) do
            local optionX = VIRTUAL_WIDTH / 2 - gFonts['medium']:getWidth(option) / 2
            local optionY = 16 + 12 + (i - 1) * 16

            local mouseX, mouseY = push:toGame(love.mouse.getPosition())

            if mouseX and mouseY then
                if mouseX >= optionX and mouseX <= optionX + gFonts['medium']:getWidth(option) and
                mouseY >= optionY and mouseY <= optionY + gFonts['medium']:getHeight() then
                    self.currentMenuItemMouse = i
                    break
                else
                    self.currentMenuItemMouse = 0
                end
            end
        end

        -- switch to another state via mouse click
        if love.mouse.isDown(1) then
            if self.currentMenuItemMouse == 1 then
                -- handle "Play" menu option
                -- tween, using Timer, the transition rect's alpha to 1, then
                -- transition to the BeginGame state after the animation is over
                Timer.tween(1, {
                    [self] = {transitionAlpha = 1}
                }):finish(function()
                    gStateMachine:change('begin-play', {
                        level = 1
                    })

                    --self.colorTimer:remove()
                end)
            elseif self.currentMenuItemMouse == 2 then
                -- handle "Instructions" menu option
                Timer.tween(1, {
                    [self] = {transitionAlpha = 1}
                }):finish(function ()
                    gStateMachine:change('instructions', {
                        transitionAlpha = self.transitionAlpha
                    })

                    self.colorTimer:remove()
                end)
            elseif self.currentMenuItemMouse == 3 then
                -- handle "Settings" menu option
                Timer.tween(1, {
                    [self] = {transitionAlpha = 1}
                }):finish(function ()
                    gStateMachine:change('setting')

                    self.colorTimer:remove()
                end)
            elseif self.currentMenuItemMouse == 4 then
                -- handle "Achievements" menu option
            elseif self.currentMenuItemMouse == 5 then
                -- handle "Exit" menu option
                love.event.quit()
            end

            self.pauseInput = true
        end
    end
    --update our timer, which will be used for our fade transition
    Timer.update(dt)

    -- if self.currentMenuItem == 1 or self.currentMenuItemMouse == 1 then
    --     self.colorTimer:remove()
    -- end
end

function StartState:render()
    love.graphics.draw(gTextures['background'], 16, 0)
    
    -- keep the background and tiles a little darker than normal
    love.graphics.setColor(1/255, 1/255, 1/255, 128/255)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    
    self:drawMatch3Text(-60)
    self:drawOptions(12)

    love.graphics.setColor(1, 1, 1, 1)

    -- draw our transition rect; is normally fully transparent, unless we're moving to a new state
    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    --additional utilities
    love.graphics.setColor(1, 1, 1, 1 - self.transitionAlpha)
    love.graphics.draw(gTextures['setting'], 16, 0)
    love.graphics.setColor(1, 1, 1, 1)
end

--[[
    Draw the centered Intergalactic Odyssey text with background rect, placed along the Y
    axis as needed, relative to the center.
]]
function StartState:drawMatch3Text(y)
    
    -- -- draw semi-transparent rect behind Intergalactic Odyssey
    -- love.graphics.setColor(1, 1, 1, 128/255)
    -- love.graphics.rectangle('fill', 48, 0, 169, 16, 6)

    -- draw Intergalactic Odyssey text shadows
    love.graphics.setFont(gFonts['medium'])

    -- self:drawEditShadow("Intergalactic", -64 + 32 ,VIRTUAL_HEIGHT / 2 + y)
    -- print Intergalactic letters in their corresponding current colors
    for i = 1, #self.letter1Table do
        love.graphics.setColor(self.colors[(i - 1) % 6 + 1])
        love.graphics.printf(self.letter1Table[i].letter, self.letter1Table[i].x - 108 + 32, VIRTUAL_HEIGHT / 2 + y,
            VIRTUAL_WIDTH, 'center')
    end

    self:drawEditShadow("Odyssey", -64 + 32 + 92 ,VIRTUAL_HEIGHT / 2 + y)
    -- print Odyssey letters in their corresponding current colors
    for i = 1, #self.letter2Table do
        love.graphics.setColor(self.colors[(i - 1) % 6 + 1])
        love.graphics.printf(self.letter2Table[i].letter, self.letter2Table[i].x + 36, VIRTUAL_HEIGHT / 2 + y,
            VIRTUAL_WIDTH, 'center')
    end
end

--[[
    Draws menu text over semi-transparent rectangles
]]
function StartState:drawOptions(y)
    -- draw menu options
    love.graphics.setFont(gFonts['medium'])

    for i, option in ipairs(self.menu) do
        -- draw option text shadow
        self:drawTextShadow(option, 16 + y + (i - 1) * 16)

        -- set color based on current menu item
        if self.currentMenuItem == i then
            love.graphics.setColor(99/255, 155/255, 1, 1)
        else
            love.graphics.setColor(48/255, 96/255, 130/255, 1)
        end

        -- draw option text
        love.graphics.printf(option, 0, 16 + y + (i - 1) * 16, VIRTUAL_WIDTH, 'center')
    end
end

--[[
    Helper function for drawing just text backgrounds; draws several layers of the same text, in
    black, over top of one another for a thicker shadow.
]]
function StartState:drawTextShadow(text, y)
    love.graphics.setColor(34/255, 32/255, 52/255, 1)
    love.graphics.printf(text, 2, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 0, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 2, VIRTUAL_WIDTH, 'center')
end

function StartState:drawEditShadow(text, x, y)
    love.graphics.setColor(34/255, 32/255, 52/255, 1)
    love.graphics.printf(text, x + 2, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, x + 1, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, x, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, x + 1, y + 2, VIRTUAL_WIDTH, 'center')
end


