-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 144

--game functionalities
--tiles
TILE_SIZE = 16

--width and height of screen in tiles
SCREEN_TILE_WIDTH = VIRTUAL_WIDTH / TILE_SIZE
SCREEN_TILE_HEIGHT = VIRTUAL_HEIGHT / TILE_SIZE

--camera scrolling speeed
CAMERA_SPEED = 100

--speed of scrolling background
BACKGROUND_SCROLL_SPEED = 10

--number of tiles in each tile set
TILE_SET_WIDTH = 5
TILE_SET_HEIGHT = 4

--number of tile sets in sheet
TILE_SET_WIDE = 6
TILEL_SET_TALL = 10

--total number of topper and tile sets
TOPPER_SET_WIDE = 6
TOPPER_SET_TALL = 18

--player walking speed
PLAYER_WALK_SPEED = 60

--slime movement speed
SLIME_MOVE_SPEED = 10

--
-- tile IDs
--
TILE_ID_EMPTY = 5
TILE_ID_GROUND = 3

--table of tiles that should trigger a collision
COLLIDABLE_TILES = {
    TILE_ID_GROUND
}

--
--game object IDs
--
BUSH_IDS = {
    1,2,5,6,7
}

COIN_IDs = {
    1, 2, 3
}

CRATES = {
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
}

GEMS = {
    1, 2, 3, 4, 5, 6, 7, 8
}

JUMP_BLOCKS = {}

for i = 1, 30 do
    table.insert(JUMP_BLOCKS, i)
end
