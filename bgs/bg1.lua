local bg={}

function bg:init()
    self.img=lg.newImage("assets/bg/test.png")
    self.shipImg=lg.newImage("assets/bg/ship.png")
    self.duckImg=lg.newImage("assets/bg/duck.png")

    self.shader=lg.newShader("shaders/wave.glsl")
    self.shader:send("freq",16)
    self.shader:send("amp",0.05)
    self.shader:send("speed",2)

    self.canvas=lg.newCanvas(160,64)
end

function bg:update(dt)
    self.shader:send("time",love.timer.getTime())
end

function bg:cDraw()
    lg.setCanvas(self.canvas)
        lg.clear(color("#357bd8"))
        lg.draw(self.img,0,math.cos(love.timer.getTime()*3) + 4)

        local t=love.timer.getTime()
        lg.draw(self.shipImg,160-((t*16)%176),16+math.cos(t*3 +2)*3)
        
    lg.setCanvas()
end

function bg:draw()
    lg.draw(self.canvas)

    lg.setColor(0.5,0.5,1)
    lg.setShader(self.shader)
        lg.draw(self.canvas,0,conf.gH,0,1,-1)
    lg.setShader()

    lg.setColor(1,1,1,1)
    lg.draw(self.duckImg,16,100+math.cos(love.timer.getTime()*3 +2))
end

return bg