--[[
    GD50
    Super Mario Bros. Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Helper functions for writing Match-3.
]]

--[[
    Given an "atlas" (a texture with multiple sprites), as well as a
    width and a height for the tiles therein, split the texture into
    all of the quads by simply dividing it evenly.
]]
function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

--[[
    Utility function for slicing tables, a la Python.

    https://stackoverflow.com/questions/24821045/does-lua-have-something-like-pythons-slice
]]
function table.slice(tbl, first, last, step)
    local sliced = {}
  
    for i = first or 1, last or #tbl, step or 1 do
      sliced[#sliced+1] = tbl[i]
    end
  
    return sliced
end


--[[
    Divides quads we've generated via slicing our tile sheet into separate tile sets.
]]
function GenerateTileSets(quads, setsX, setsY, sizeX, sizeY)
    local tilesets = {}
    local tableCounter = 0
    local sheetWidth = setsX * sizeX
    local sheetHeight = setsY * sizeY

    -- for each tile set on the X and Y
    for tilesetY = 1, setsY do
        for tilesetX = 1, setsX do
            
            -- tileset table
            table.insert(tilesets, {})
            tableCounter = tableCounter + 1

            for y = sizeY * (tilesetY - 1) + 1, sizeY * (tilesetY - 1) + 1 + sizeY do
                for x = sizeX * (tilesetX - 1) + 1, sizeX * (tilesetX - 1) + 1 + sizeX do
                    table.insert(tilesets[tableCounter], quads[sheetWidth * (y - 1) + x])
                end
            end
        end
    end

    return tilesets
end

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

--game code functionalities for setting

function MouseCollides(object)
    return not (object.x > Mousex + Mousewidth or Mousex > object.x + object.width or
    object.y > Mousey + Mouseheight or Mousey > object.y + object.height)
end

--This is for gSounds['music'] volume changing
function increaseVolume()
    local currentVolume = gSounds['music']:getVolume()
    local newVolume = math.min(currentVolume + 0.1, 1.0) -- Increase volume by 10%
    gSounds['music']:setVolume(newVolume)
end

function decreaseVolume()
    local currentVolume = gSounds['music']:getVolume()
    local newVolume = math.max(currentVolume - 0.1, 0.0) -- Decrease volume by 10%
    gSounds['music']:setVolume(newVolume)
end

function drawTick(x1, y1, x2, y2, x3, y3)
    -- Set the line width and color for the tick
    love.graphics.setLineWidth(5)

    -- Draw the tick using lines
    love.graphics.line(x1, y1, x2, y2)
    love.graphics.line(x2, y2, x3, y3)

    -- Reset the line width
    love.graphics.setLineWidth(1)
end

--[[
    Helper function for drawing just text backgrounds; draws several layers of the same text, in
    black, over top of one another for a thicker shadow.
]]
function drawTextShadow(text, y)
    love.graphics.setColor(34/255, 32/255, 52/255, 1)
    love.graphics.printf(text, 2, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 0, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 2, VIRTUAL_WIDTH, 'center')
end

function drawEditShadow(text, x, y, textWidth, mode)
    love.graphics.setColor(34/255, 32/255, 52/255, 1)
    love.graphics.printf(text, x + 2, y + 1, textWidth, mode)
    love.graphics.printf(text, x + 1, y + 1, textWidth, mode)
    love.graphics.printf(text, x, y + 1, textWidth, mode)
    love.graphics.printf(text, x + 1, y + 2, textWidth, mode)
end