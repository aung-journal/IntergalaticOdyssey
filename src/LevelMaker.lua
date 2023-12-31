LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entites = {}
    local objects = {}

    local tileID = TILE_ID_GROUND

    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    for x = 1, height do
        table.insert(tiles, {})
    end

    for x = 1, width do
        local tileID = TILE_ID_EMPTY

        --lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y], Tile(x, y, tileID, nil, tileset, topperset))
        end

        --chance to be emptiness(chasm)
        if math.random(7) == 1 then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))  
            end
        else
            tileID = TILE_ID_GROUND

            --height at which we would spawn a potential jump block
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper  or nil, tileset, topperset))
            end

            --chance to generate a pillar
            if math.random(8) == 1 then
                blockHeight = 2

                --chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,

                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end

                --pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            --chance to generate bushes
            -- elseif math.random(8) == 1 then
            --     table.insert(objects,
            --         GameObject {
            --             texture = 'bushes',
            --             x = (x - 1) * TILE_SIZE,
            --             y = (6 - 1) * TILE_SIZE,
            --             width = 16,
            --             height = 16,
            --             frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
            --             collidable = false
            --         })
            -- end

            -- --chance to spawn a block
            -- if math.random(10) == 1 then
            --     table.insert(objects,
            --         --jump block
            --         GameObject {
            --             texture = 'jump-blocks',
            --             x = (x - 1) * TILE_SIZE,
            --             y = (blockHeight - 1) * TILE_SIZE,
            --             width = 16,
            --             height = 16,

            --             --make it a random variant
            --             frame = math.random(#JUMP_BLOCKS),
            --             collidable = true,
            --             hit = false,
            --             solid = true,

            --             --collision function takes itself
            --             onCollide = function (obj)
                            
            --                 --spawn a gem if we haven't already hit

            --                 if not obj.hit then
                                
            --                     -- chance to spawn gem, not guaranteed

            --                     local gem = GameObject {
            --                         texture = 'gems',
            --                         x = (x - 1) * TILE_SIZE,
            --                         y = (blockHeight - 1) * TILE_SIZE - 4,
            --                         width = 16,
            --                         height = 16,
            --                         frame = math.random(#GEMS),
            --                         collidable = true,
            --                         consumable = true,
            --                         solid = false,

            --                         --gem has its own function to add player's score
                                    
            --                         onConsume = function (player, object)
                                        
            --                             gSounds['pickup']:play()
            --                             player.score = player.score + 1
            --                         end

            --                     }
            --                     --make the gem move up from the block and play a sound

            --                     Timer.tween(0.1, {
            --                         [gem] = {y = (blockHeight - 2)}
            --                     })
            --                     gSounds['powerup-revel']:play()

            --                     table.insert(objects, gem)
            --                 end

            --                 obj.hit = true

            --                 gSounds['empty-block']:play()
            --             end
            --         }
            --     )
            -- end
            end
        end
    end

    local map = TileMap(width, height)
    map.tiles = tiles

    return GameLevel(entites, objects, map)
end