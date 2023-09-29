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
    --love.mouse.setCursor(cursorImage)

    -- Draw the custom cursor at the current mouse position
    Mousex, Mousey = love.mouse.getPosition()
    Mousewidth = 32
    Mouseheight = 32

    --love.mouse.setVisible(false)

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true,
        canvas = false
    })

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['begin-game'] = function() return BeginGameState() end,
        ['play'] = function() return PlayState() end,
        ['pause'] = function() return PauseState() end,
        ['instructions'] = function() return InstructionState() end,
        ['setting'] = function() return SettingState() end
    }
    gStateMachine:change('start')

    gSounds['music']:setLooping(true)
    gSounds['music']:play()

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
        gSounds['music']:play()
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
    --love.graphics.draw(Cursor, Mousex, Mousey)
end