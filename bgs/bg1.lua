local bg={}

function bg:init()
    self.img=lg.newImage("assets/bg/test.png")
    self.shader=lg.newShader("shaders/wave.glsl")
    self.shader:send("freq",16)
    self.shader:send("amp",0.05)
    self.shader:send("speed",2)
end

function bg:update(dt)
    self.shader:send("time",love.timer.getTime())
end

function bg:draw()
    lg.clear(color("#4ad1f3ff"))
    lg.draw(self.img)

    lg.setColor(0.5,0.5,1)
    lg.setShader(self.shader)
        lg.draw(self.img,0,conf.gH,0,1,-1)
    lg.setShader()

    lg.setColor(1,1,1,1)
end

return bg