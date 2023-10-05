--libraries
Class = require 'lib/class'
push = require 'lib/push'
gamera = require 'lib/gamera'
Timer = require 'lib/knife.timer'
mp = require 'mp'

--own code
require 'src/constants'
require 'src/StateMachine'
require 'src/Util'

--game states
require 'src/states/BaseState'
require 'src/states/game/BeginGameState'
require 'src/states/game/StartState'
require 'src/states/game/BeginPlayState'
require 'src/states/game/PlayState'
require 'src/states/game/PauseState'
require 'src/states/game/InstructionState'
require 'src/states/game/SettingState'

--general
require 'src/Animation'
require 'src/Entity'
require 'src/GameObject'
--mouse control
require 'src/Mouse'
--levelMaker
require 'src/LevelMaker'
--tiles
require 'src/Tile'
require 'src/TileMap'
--mobs and characters
require 'src/Player'

gSounds = {
    ['selection'] = love.audio.newSource('sounds/selection.wav', 'static'),
    ['turn'] = love.audio.newSource('sounds/turn.mp3', 'static'),
    ['pickup'] = love.audio.newSource('sounds/pickup.wav', 'static'),
    ['powerup-reveal'] = love.audio.newSource('sounds/powerup-reveal.wav', 'static'),
    ['empty-block'] = love.audio.newSource('sounds/empty-block.wav', 'static'),
    --footsteps
    ['ice-foot'] = love.audio.newSource('sounds/ice_footstep.wav', 'static'),

    ['music'] = love.audio.newSource('sounds/music3.mp3', 'stream'),
    ['story1'] = love.audio.newSource('sounds/plot1.wav', 'stream')
}

gTextures = {
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['setting'] = love.graphics.newImage('graphics/setting.png'),
    ['logo'] = love.graphics.newImage('graphics/logo22.png'),
    ['player'] = love.graphics.newImage('graphics/blue_alien(player).png'),

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
MOUSE = true
ZOOM = 1
MOUSE_ZOOM = false