local bg={}

function bg:init()
    self.img=lg.newImage("assets/bg/test.png")
end

function bg:update(dt)

end

function bg:draw()
    lg.clear(color("#4ad1f3ff"))
end

return bg