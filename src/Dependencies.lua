--libraries
Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

--own code
require 'src/constants'
require 'src/StateMachine'
require 'src/Util'

--game states
require 'src/states/BaseState'
require 'src/states/game/StartState'
require 'src/states/game/BeginGameState'
require 'src/states/game/PlayState'
require 'src/states/game/PauseState'
require 'src/states/game/InstructionState'
require 'src/states/game/SettingState'

--general
require 'src/Animation'
require 'src/Entity'
require 'src/GameObject'

gSounds = {
    ['selection'] = love.audio.newSource('sounds/selection.wav', 'static'),
    ['turn'] = love.audio.newSource('sounds/turn.mp3', 'static'),

    ['music'] = love.audio.newSource('sounds/music3.mp3', 'stream')
}

gTextures = {
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['slimes'] = love.graphics.newImage('graphics/slimes.png')
}

gFrames = {
    ['slimes'] = GenerateQuads(gTextures['slimes'], 80, 48)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 4),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['title'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 32),
    ['instructions'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 10)
}

--other functionalities including music
MUSIC = true