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

--entity states
--player
require 'src/states/entity/PlayerFallingState'
require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerJumpState'
require 'src/states/entity/PlayerWalkingState'
--slime
require 'src/states/entity/slime/SlimeIdleState'
require 'src/states/entity/slime/SlimeMovingState'
require 'src/states/entity/slime/SlimeChasingState'

--general
require 'src/Animation'
require 'src/Entity'
require 'src/GameObject'
require 'src/GameLevel'
--mouse control
require 'src/Mouse'
--levelMaker
require 'src/LevelMaker'
--tiles
require 'src/Tile'
require 'src/TileMap'
--mobs and characters
require 'src/Player'
require 'src/Slime'

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
    --mobs
    ['slimes'] = love.graphics.newImage('graphics/slimes.png'),
    ['recruit1'] = love.graphics.newImage('graphics/recruit1.png'),
    --plains and GameObjects
    ['plains'] = love.graphics.newImage('graphics/backgrounds.png'),
    ['tiles'] = love.graphics.newImage('graphics/tiles.png'),
    ['toppers'] = love.graphics.newImage('graphics/tile_tops.png'),
}

gFrames = {
    --characters & mobs
    ['player'] = GenerateQuads(gTextures['player'], 16, 20),
    ['slimes'] = GenerateQuads(gTextures['slimes'], 80, 48),
    ['recruit1'] = GenerateQuads(gTextures['recruit1'], 18, 32),
    --plains and GameObjects
    ['plains'] = GenerateQuads(gTextures['plains'], 256, 128),
    ['tiles'] = GenerateQuads(gTextures['tiles'], TILE_SIZE, TILE_SIZE),
    ['toppers'] = GenerateQuads(gTextures['toppers'], TILE_SIZE, TILE_SIZE)
}

--these needed to be added after gFrames is initialized because they refer to gFrames from within
gFrames['tilesets'] = GenerateTileSets(gFrames['tiles'], TILE_SET_WIDE, TILEL_SET_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)
gFrames['toppersets'] = GenerateTileSets(gFrames['toppers'], TOPPER_SET_WIDE, TOPPER_SET_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)

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

--game dependencies
PLAINS = #gFrames['plains']