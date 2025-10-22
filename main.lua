require("init")
lg=love.graphics
lm=love.math
la=love.audio

function generateMap(w,h,val)
    local temp={}
    for y=1,h do
        table.insert(temp,{})
        for x=1,w do
            table.insert(temp[y],val)
        end
    end
    return temp
end

function love.load()

    gs=require("lib.hump.gamestate")
    gs.registerEvents()

    state={
        ["level"] = require("level")
    }
    
    math.randomseed(love.math.random(0,845261654))
    rotate=require("lib.rotate")
    shove.createLayer("game")

    gs.switch(state["level"])

end

function love.update(dt)
    input:update()
end 

function love.draw()
    
end

function love.keypressed(k)
    if k=="right" then
        map=rotate.rotate(map,1)
    end
    if k=="left" then
        map=rotate.rotate(map,3)
    end
end