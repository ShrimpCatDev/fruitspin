local intro={}

local shrimp={img=lg.newImage("assets/intro/shrimpcat.png")}
local title={img=lg.newImage("assets/intro/shrimpTitle.png")}
local introCanvas=lg.newCanvas(conf.gW,conf.gH)
local gI={w=1,h=1}


function intro:enter()
    
    shove.removeGlobalEffect(lutEffect)
    gI={w=1,h=1}
    timer.clear()

    shrimp.w=shrimp.img:getWidth()
    shrimp.h=shrimp.img:getHeight()

    shrimp.cw=math.floor(shrimp.w/2)
    shrimp.ch=math.floor(shrimp.h/2)

    shrimp.x=(conf.gW/2)
    shrimp.y=(conf.gH/2)

    shrimp.scale={x=0,y=0}
    shrimp.r=180

    title.x=(conf.gW/2)
    title.y=(conf.gH/2)+16

    title.scale={x=1,y=0}

    title.w,title.h=title.img:getWidth(),title.img:getHeight()

        timer.after(0.5,function()

        timer.tween(0.6,shrimp.scale,{x=1},"out-elastic")
        timer.tween(1.2,shrimp.scale,{y=1},"out-elastic")
        timer.tween(1.5,shrimp,{r=0},"out-elastic")

        timer.after(1.5,function()
            timer.tween(0.9,title.scale,{y=1},"out-elastic")
            timer.tween(0.2,title.scale,{x=1.5},"out-quad")
            timer.tween(1.2,shrimp,{y=(conf.gH/2)-10},"out-elastic")
            timer.after(0.1,function()
                timer.tween(0.1,title.scale,{x=1},"out-quad")
            end)
            timer.after(2,function()
                timer.tween(0.5,gI,{h=0},"in-bounce")
                timer.after(0.6,function()
                    gs.switch(state["menu"])
                end)
            end)
        end)

    end)
    
end

function intro:update(dt)
    timer.update(dt)
end

local function drawLogo(osx,osy)
    lg.push()
    lg.translate(osx,osy)
    lg.draw(shrimp.img,shrimp.x,shrimp.y,math.rad(shrimp.r),shrimp.scale.x,shrimp.scale.y,shrimp.cw,shrimp.ch)
    lg.draw(title.img,title.x,title.y,0,title.scale.x,title.scale.y,title.w/2,title.h)
    lg.pop()
end

local function drawScreen()
    love.graphics.setColor(color("#0099db"))
    love.graphics.rectangle("fill",0,0,conf.gW,conf.gH)
    love.graphics.setColor(color("#124e89"))
    for x=0,conf.gW-1 do
        for y=0,conf.gH-1 do
            if ((x+y+(love.timer.getTime()*32))/2)%16>8 then
                love.graphics.points(x+0.5,y+0.5)
            end
        end
    end

    lg.setColor(0,0,0,1)
    drawLogo(1,1)
    lg.setColor(1,1,1,1)
    drawLogo(0,0)
end

function intro:draw()
    lg.setCanvas(introCanvas)
        drawScreen()
    lg.setCanvas()
    shove.beginDraw()
        lg.draw(introCanvas,conf.gW/2,conf.gH/2,0,gI.w,gI.h,introCanvas:getWidth()/2,introCanvas:getHeight()/2)
    shove.endDraw()
end

function intro:leave()

end

return intro