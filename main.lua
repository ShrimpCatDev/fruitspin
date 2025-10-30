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

    options={difficulty=3,speed=3,music=true,sfx=true}

    local fontImg=love.image.newImageData("assets/font.png")
    font=love.graphics.newImageFont(fontImg,"abcdefghijklmnopqrstuvwxyz1234567890!:.| ",1)
    lg.setFont(font)

    timer=require("lib.hump.timer")

    gs=require("lib.hump.gamestate")
    gs.registerEvents()

    state={
        ["level"] = require("level"),
        ["menu"] = require("menu")
    }
    
    math.randomseed(love.math.random(0,845261654))
    rotate=require("lib.rotate")

    local lutEffect=love.graphics.newShader("shaders/lut.glsl")
    pal=lg.newImage("assets/lut.png")
    pal:setFilter("nearest","nearest")
    lutEffect:send("lut",pal)

    shove.addGlobalEffect(lutEffect)
    shove.createLayer("game")

    gs.switch(state["menu"])

    

end

function love.update(dt)
    input:update()
end 

function love.draw()
    
end

function love.keypressed(k)

end