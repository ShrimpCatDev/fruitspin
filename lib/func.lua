function clamp(x, min, max)
    return math.max(min, math.min(x, max))
end

function lerpDt(a, b, t,dt)
    return a + (b - a) * (t*dt)
end

function lerp(a, b, t,dt)
    return a + (b - a) * t
end

function collision(x1,y1,x2,y2,w1,h1,w2,h2)
    return x1<x2+w2 and x2<x1+w1 and y1<y2+h2 and y2<y1+h1 
end

local rr=love.graphics.rectangle

function rect(f,x,y,w,h)
    if f=="fill" then
        rr(f,x,y,w,h)
    else
        rr(f,x+.5,y+.5,w,h)
    end
end

function cprint(text,x,y,r)
    lg.print(text,x-font:getWidth(text)/2,y-font:getHeight()/2,r or 0)
end