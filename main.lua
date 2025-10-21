require("init")
lg=love.graphics

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
    math.randomseed(love.math.random(0,845261654))
    rotate=require("lib.rotate")
    shove.createLayer("game")
    map=generateMap(10,10,0)

    img=lg.newImage("assets/fruit.png")
    quads={}
    for x=0,img:getWidth()/8 - 1 do
        local quad=love.graphics.newQuad(x*8,0,8,8,img:getWidth(),img:getHeight())
        table.insert(quads,quad)
    end
    map[1][1]=1
    map[1][10]=2
    map[10][10]=3

    for x=1,10 do
        for y=1,10 do
            if math.random(0,10)==1 then
                map[y][x]=math.random(1,3)
            end
        end
    end

    time=0
end

function fallBlocks()
    for y=#map,1,-1 do
        for x=1,#map[y] do
            if y+1<=#map and map[y+1][x]==0 then
                local tile=map[y][x]
                map[y][x]=0
                map[y+1][x]=tile
            end
        end
    end
end

function love.update(dt)
    input:update()

    time=time+dt

    if time>=0.2 then
        fallBlocks()
        time=0
    end
end 

function love.draw()
    shove.beginDraw()
        shove.beginLayer("game")
            lg.setColor(0.4,0.4,0.4)
            lg.rectangle("fill",0,0,80,80)
            lg.setColor(1,1,1,1)
            for y,v in ipairs(map) do
                for x,j in ipairs(v) do
                    if j~=0 then
                        lg.draw(img,quads[j],(x-1)*8,(y-1)*8)
                    end
                end
            end
        shove.endLayer()
    shove.endDraw()
end

function love.keypressed(k)
    if k=="right" then
        map=rotate.rotate(map,1)
    end
    if k=="left" then
        map=rotate.rotate(map,3)
    end
end