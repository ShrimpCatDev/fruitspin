local lvl={}

local function fallBlocks(map)
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

local function rmvBlocks(map)
    for y=1,#map do
        for x=1,#map[y] do
            local oTile=map[y][x]
            if oTile~=0 then
                --y >:3
                local num=0

                local yy = y

                while yy<#map and map[yy+1][x]==oTile do
                    yy=yy+1
                    num=num+1
                end

                if num>1 then
                    for i=y,yy do
                        lvl:addScore(lvl.blockScore[map[i][x]])
                        local xxx=lvl.screen.x-lvl.screen.w/2
                        local yyy=lvl.screen.y-lvl.screen.y/2
                        
                        lvl.particles.new(xxx+((x-1)*8),yyy+((yy-2)*8),math.random(-10,10),-math.random(120,10),0,240,1,
                        function(x1,y1,lt,data)
                            lg.draw(lvl.fruitImg,lvl.fruitQuads[data.tile],x1+4,y1+4,-lt*8,1,1,4,4)
                        end,
                        function() end,
                        {tile=map[i][x]})
                    end

                    for i=y,yy do
                        map[i][x]=0
                    end

                    lvl.sfx.match:play()

                    return
                end
            end

            local oTile=map[y][x]
            if oTile~=0 then
                --x >:3
                local num=0

                local xx = x

                while xx<#map[y] and map[y][xx+1]==oTile do
                    xx=xx+1
                    num=num+1
                end

                if num>1 then
                    for i=x,xx do
                        lvl:addScore(lvl.blockScore[map[y][i]])
                        local xxx=lvl.screen.x-lvl.screen.w/2
                        local yyy=lvl.screen.y-lvl.screen.y/2
                        
                        lvl.particles.new(xxx+((i-1)*8),yyy+((y-2)*8),math.random(-10,10),-math.random(120,10),0,240,1,
                        function(x1,y1,lt,data)
                            lg.draw(lvl.fruitImg,lvl.fruitQuads[data.tile],x1+4,y1+4,-lt*8,1,1,4,4)
                        end,
                        function() end,
                        {tile=map[y][i]})
                    end

                    for i=x,xx do
                        map[y][i]=0
                    end

                    lvl.sfx.match:play()

                    return
                end
            end
        end
    end
end

local function checkBlockFall(map)
    for y=#map,1,-1 do
        for x=1,#map[y] do
            if (map[y][x]~=0 and y<#map) and (map[y+1] and map[y+1][x]==0) then
                return true
            end
        end
    end
    return false
end

local function getBrickNumber(map)
    local num=0
    for y=1,#map do
        for x=1,#map[y] do
            if map[y][x]~=0 then
                num=num+1
            end
        end
    end
    return num
end

function lvl:init()
    self.particles=require("lib.particles")

    self.deg=math.rad(90)
    self.screen={img=lg.newCanvas(80,80),x=conf.gW/2,y=conf.gH/2,w=80,h=80,r=0,canRotate=true}

    self.patternRotate=1
    self.bricks={lg.newImage("assets/brick1.png"),lg.newImage("assets/brick2.png")}
    self.fruitImg=lg.newImage("assets/fruit.png")
    self.fruitQuads={}
    for x=0,self.fruitImg:getWidth()/8 - 1 do
        local quad=love.graphics.newQuad(x*8,0,8,8,self.fruitImg:getWidth(),self.fruitImg:getHeight())
        table.insert(self.fruitQuads,quad)
    end
    self.fruitKinds=#self.fruitQuads

    self.sfx={
        rotate=ripple.newSound(love.audio.newSource('assets/sfx/rotate.wav', 'static')),
        match=ripple.newSound(love.audio.newSource('assets/sfx/match.wav', 'static'))
    }

    self.music={
        temp=ripple.newSound(love.audio.newSource('assets/music/temp.ogg', 'stream'),{loop=true,volume=1}),
    }
end

local function rrect(x,y,w,h)
    lg.rectangle("fill",x+1,y,w-2,h)
    lg.rectangle("fill",x,y+1,w,h-2)
end

function lvl:newBlock(x,kind)
    table.insert(self.fall,{x=x,y=-8,kind=kind})
end

lvl.blockScore={10,10,10,10,10,10}

function lvl:addScore(s)
    self.score=self.score+s
    if self.stat.cr then
        self.stat.cr=false
        timer.tween(0.1,self.stat,{tr=0.2},"out-cubic",function()
            timer.tween(0.1,self.stat,{tr=0},"in-cubic",function()
                self.stat.cr=true
            end)
        end)
   end
end

function lvl:enter()
    self.stat={tr=0,cr=true}
    self.score=0
    self.fall={}
    self.fallSpeed=20

    self.particles.clear()
    self.next={img=lg.newCanvas(28,12),x=conf.gW/2,y=6,w=28,h=10,arrow=lg.newImage("assets/arrow.png")}

    self.bg=require("bgs/bg1")
    self.bg:init()

    self.time=0
    self.maxTime=0.4
    self.map=generateMap(10,10,0)
    
    --[[self.map[1][1]=4
    self.map[2][1]=5
    self.map[3][1]=5
    self.map[4][1]=5
    self.map[5][1]=6]]
    --[[for x=1,10 do
        for y=1,10 do
            if math.random(0,1)==1 then
                self.map[y][x]=math.random(1,self.fruitKinds)
            end
        end
    end]]
    self.music.temp:play()

    self.nextFruit={1,6,3}
    
end

function lvl:rotateBoard(dir)
    if self.screen.canRotate then
        self.sfx.rotate:play()
        self.screen.canRotate=false
        self.screen.r=1.5708*dir
        timer.tween(0.15,self.screen,{r=0},"out-cubic",function()
            self.screen.canRotate=true
        end)
    end
end

function lvl:update(dt)

    local rmv={}

    --[[for k,b in ipairs(self.fall) do
        b.y=b.y+self.fallSpeed*dt
        local ty=math.floor((b.y)/8)-2
        if ty>0 and ((ty+1<=10 and self.map[ty+1][b.x]~=0) or ty==10) and self.map[ty][b.x]==0 then
            self.map[ty][b.x]=b.kind
            table.insert(rmv,k)
        end
        
    end

    for i=#rmv,1,-1 do
        table.remove(self.fall,rmv[i])
    end]]

    self.particles.update(dt)
    timer.update(dt)
    self.bg:update(dt)

    if input:pressed("rotateRight") and self.screen.canRotate then
        self.map=rotate.rotate(self.map,1)
        self.patternRotate=self.patternRotate+1
        self:rotateBoard(-1)
    end
    if input:pressed("rotateLeft") and self.screen.canRotate then
        self.map=rotate.rotate(self.map,3)
        self.patternRotate=self.patternRotate-1
        self:rotateBoard(1)
    end

    if input:pressed("fall") then
        self.prevTime=self.maxTime
        self.maxTime=self.maxTime*0.5
    end

    if input:released("fall") then
        self.maxTime=self.prevTime
    end

    if self.patternRotate<0 then
        self.patternRotate=1
    elseif self.patternRotate>1 then
        self.patternRotate=0
    end

    self.time=self.time+dt

    if self.time>=self.maxTime then
        local spawn=false
        if not checkBlockFall(self.map) then
            rmvBlocks(self.map)
            spawn=true
            
        end

        fallBlocks(self.map)

        if spawn then
            if not checkBlockFall(self.map) then
                local x=math.random(1,10)
                while self.map[1][x]~=0 do
                    x=math.random(1,10)
                end
                table.insert(self.nextFruit,1,math.random(1,self.fruitKinds))
                table.remove(self.nextFruit,4)
                self.map[1][x]=self.nextFruit[2]
            end
        end
        
        self.time=0
    end
end

local function sprint(t,x,y,a,r)
    lg.setColor(0,0,0,a)
    cprint(t,x+1,y+1,r)
    lg.setColor(1,1,1,1)
    cprint(t,x,y,r)
end

function lvl:draw()
    self.bg:cDraw()

    lg.setCanvas(self.next.img)

        lg.setColor(color("#fdb193"))
        rrect(0,1,self.next.w,self.next.h)
        lg.setColor(color("#fff3ee"))
        rrect(0,0,self.next.w,self.next.h)
        lg.setColor(1,1,1,1)

        for k,v in pairs(self.nextFruit) do
            lg.draw(self.fruitImg,self.fruitQuads[v],(k-1)*9+1,1)
        end

        lg.setColor(1,1,1,1)

    lg.setCanvas(self.screen.img)
        for x=0,9 do
            for y=0,9 do
                if (x+y)%2==self.patternRotate then
                    lg.draw(self.bricks[1],x*8,y*8)
                else
                    lg.draw(self.bricks[2],x*8,y*8)
                end
            end
        end
        for y,v in ipairs(self.map) do
            for x,j in ipairs(v) do
                if j~=0 then
                    lg.draw(self.fruitImg,self.fruitQuads[j],(x-1)*8,(y-1)*8)
                end
            end
        end
        
    lg.setCanvas()

    shove.beginDraw()
        shove.beginLayer("game")

            self.bg:draw()

            local s=self.screen

            lg.setColor(0,0,0,0.55)
            lg.rectangle("fill",s.x-4-(s.w/2)+2,0,s.w+7,s.h+s.y-(s.w/2)+5)
            lg.setColor(color("#482a37"))
            lg.rectangle("fill",s.x-4-(s.w/2),0,s.w+8,s.h+s.y-(s.w/2)+3)
            lg.rectangle("fill",s.x-4-(s.w/2)+1,0,s.w+6,s.h+s.y-(s.w/2)+4)
            lg.setColor(color("#9a5854"))
            lg.rectangle("fill",s.x-(s.w/2),0,s.w,s.h+s.y-(s.w/2))

            lg.setColor(1,1,1,1)
            
            lg.draw(self.next.img,self.next.x,self.next.y,0,1,1,self.next.w/2,0)
            lg.draw(self.next.arrow,self.next.x-2,self.next.y+12)

            lg.draw(s.img,s.x,s.y,s.r,1,1,s.w/2,s.h/2)

            for k,b in ipairs(self.fall) do
                lg.draw(self.fruitImg,self.fruitQuads[b.kind],(b.x-1)*8 + self.screen.x-self.screen.w/2,b.y)

                local yy=math.floor((b.y+8)/8)
                --lg.rectangle("fill",(b.x-1)*8 + self.screen.x-self.screen.w/2,yy*8,8,8)
            end

            self.particles.draw()

            

            sprint("score: "..self.score,80,conf.gH-10,0.7,self.stat.tr)

            --sprint(getBrickNumber(self.map),0,0)
        shove.endLayer()
    shove.endDraw()
end

return lvl