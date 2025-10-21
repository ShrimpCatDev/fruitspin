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
    map[2][1]=1
    map[3][1]=1
    map[4][1]=1


    --[[for x=1,10 do
        for y=1,10 do
            if math.random(0,10)==1 then
                map[y][x]=math.random(1,3)
            end
        end
    end]]

    --[[for i=1,3 do
        for j=1,3 do
            local x,y=math.random(1,10),math.random(1,10)
            if map[y][x]==0 then
                map[y][x]=i
            end
        end
    end]]

    time=0
end

function fallBlocks()
    for y=#map,1,-1 do
        for x=1,#map[y] do
            if y+1<=#map and map[y+1][x]==0 then
                local tile=map[y][x]
                map[y][x]=0
                map[y+1][x]=tile

                local oTile=map[y+1][x]
            end
        end
    end
end

function rmvBlocks()
    for y=#map,1,-1 do
        for x=1,#map[y] do
            local oTile=map[y][x]
            if oTile~=0 then

                --y <;3
                local num=1

                local yy = y

                while yy<#map and map[yy+1][x]==oTile do
                    yy=yy+1
                    num=num+1
                end

                if num>2 then
                    for i=y-1,y+num-1 do
                        map[i][x]=0
                    end
                end
                
                --x >:3zx
                local num=1

                local xx = x

                while xx<#map[y] and map[y][xx+1]==oTile do
                    xx=xx+1
                    num=num+1
                end

                if num>2 then
                    for i=x-1,x+num-1 do
                        map[y][i]=0
                    end
                end
            end
        end
    end
end

function checkBlockFall()
    for y=#map,1,-1 do
        for x=1,#map[y] do
            if (map[y][x]~=0 and y<#map) and (map[y+1] and map[y+1][x]==0) then
                return true
            end
        end
    end
    return false
end

function love.update(dt)
    input:update()

    time=time+dt

    if time>=0.4 then
        if not checkBlockFall() then
            rmvBlocks()
            map[1][math.random(1,10)]=math.random(1,3)
        end
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
    lg.print(tostring(checkBlockFall()))
end

function love.keypressed(k)
    if k=="right" then
        map=rotate.rotate(map,1)
    end
    if k=="left" then
        map=rotate.rotate(map,3)
    end
end