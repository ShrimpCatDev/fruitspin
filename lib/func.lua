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

function rrect(x,y,w,h)
    lg.rectangle("fill",x+1,y,w-2,h)
    lg.rectangle("fill",x,y+1,w,h-2)
end

function cprint(text,x,y,r)
    lg.print(text,x,y,r or 0,1,1,font:getWidth(text)/2,font:getHeight()/2)
end