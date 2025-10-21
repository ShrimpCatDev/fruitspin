require("init")

function love.load()
    shove.createLayer("game")

end

function love.update(dt)
    input:update()
end 

function love.draw()
    shove.beginDraw()
        shove.beginLayer("game")

        shove.endLayer()
    shove.endDraw()
end