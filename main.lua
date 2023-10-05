--Music: https://soundcloud.com/dreamscapeee/oneheart-x-reidenshi-snowfall
--Art pack: https://opengameart.org/content/kenney-16x16
--I have also modified and created additional content

love.graphics.setDefaultFilter('nearest', 'nearest')
require 'src/Dependencies'

function love.load()
    love.graphics.setFont(gFonts['medium'])
    love.window.setTitle('Intergalactic Odyssey')

    local cursorImage = love.mouse.newCursor("graphics/cursor.png")
    Cursor = love.graphics.newImage("graphics/cursor.png")
    love.mouse.setCursor(cursorImage)

    -- Draw the custom cursor at the current mouse position
    Mousewidth = 32
    Mouseheight = 32

    love.mouse.setVisible(false)

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true,
        canvas = false
    })

    gStateMachine = StateMachine {
        ['begin-game'] = function() return BeginGameState() end,
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['begin-play'] = function() return BeginPlayState() end,
        ['pause'] = function() return PauseState() end,
        ['instructions'] = function() return InstructionState() end,
        ['setting'] = function() return SettingState() end
    }
    gStateMachine:change('begin-game')

    if gStateMachine:getCurrentStateName() ~= 'begin-game' then
        gSounds['music']:setLooping(true)
        gSounds['music']:play()
    end

    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'p' then
        if gStateMachine:getCurrentStateName() ~= 'start' then
            gStateMachine:change('pause',{
                state = gStateMachine:getCurrentStateName()
            })
        end
    end

    love.keyboard.keysPressed[key] = true
end

-- function love.wheelmoved(x, y)
--     -- Increase or decrease the ZOOM factor based on the mouse wheel movement
--     if y > 0 then
--       ZOOM = ZOOM + 0.1
--     elseif y < 0 then
--       ZOOM = ZOOM - 0.1
--     end
-- end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

-- function love.mousemoved(x, y, dx, dy, istouch)
--     -- Update the cursor's position here based on user input
--     -- For example, you can set the cursor's position to the mouse coordinates:
--     love.mouse.setPosition(x, y)
-- end

function love.update(dt)
    if not MUSIC then
        gSounds['music']:stop()
    else
        if gStateMachine:getCurrentStateName() ~= 'begin-game' then
            gSounds['music']:play()
        end
    end

    gStateMachine:update(dt)
    Mouse:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    local mouseX, mouseY = love.mouse.getPosition()

    push:start()
    if ZOOM == 1 then
        gStateMachine:render()
    else
        -- push:start()
        -- love.graphics.scale(ZOOM)
        -- if not MOUSE_ZOOM then
        --     MOUSEX, MOUSEY = push:toGame(love.mouse.getPosition())
        -- end
        -- MOUSE_ZOOM = true
        -- love.graphics.translate(-MOUSEX / (2 * ZOOM), -MOUSEY / (2 * ZOOM))
        -- gStateMachine:render()
        -- love.graphics.scale(1 / ZOOM)
        -- -- MOUSE_ZOOM = false
        -- push:finish()
    end
    push:finish()
    
    if MOUSE then
        love.graphics.draw(Cursor, mouseX, mouseY)
    end
end