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
    for y=#map,1,-1 do
        for x=1,#map[y] do
            local oTile=map[y][x]
            if oTile~=0 then
                --y <;3
                local num=0

                local yy = y

                while yy<#map and map[yy+1][x]==oTile do
                    yy=yy+1
                    num=num+1
                end

                if num>1 then
                    for i=y-1,yy do
                        map[i][x]=0
                    end
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
                        map[y][i]=0
                    end
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

function lvl:init()
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
end

function lvl:enter()
    self.bg=require("bgs/bg1")
    self.bg:init()

    self.time=0
    self.map=generateMap(10,10,0)

    --[[self.map[1][1]=3
    self.map[5][1]=1
    self.map[2][1]=1
    self.map[3][1]=1
    self.map[4][1]=3
    self.map[1][2]=2
    self.map[1][3]=2
    self.map[1][4]=2
    self.map[1][5]=4]]

    for x=1,10 do
        for y=1,10 do
            if math.random(0,10)==1 then
                self.map[y][x]=math.random(1,4)
            end
        end
    end
end

function lvl:rotateBoard(dir)
    if self.screen.canRotate then
        self.screen.canRotate=false
        self.screen.r=1.5708*dir
        timer.tween(0.15,self.screen,{r=0},"out-cubic",function()
            self.screen.canRotate=true
        end)
    end
end

function lvl:update(dt)
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
    if self.patternRotate<0 then
        self.patternRotate=1
    elseif self.patternRotate>1 then
        self.patternRotate=0
    end

    self.time=self.time+dt

    if self.time>=0.15 then
        if not checkBlockFall(self.map) then
            rmvBlocks(self.map)
            self.map[1][math.random(1,10)]=math.random(1,4)
        end
        fallBlocks(self.map)
        
        self.time=0
    end
end

function lvl:draw()
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

            lg.setColor(color("#482a37"))
            lg.rectangle("fill",s.x-4-(s.w/2),0,s.w+8,s.h+s.y-(s.w/2)+3)
            lg.rectangle("fill",s.x-4-(s.w/2)+1,0,s.w+6,s.h+s.y-(s.w/2)+4)
            lg.setColor(color("#9a5854"))
            lg.rectangle("fill",s.x-(s.w/2),0,s.w,s.h+s.y-(s.w/2))

            lg.setColor(1,1,1,1)
            lg.draw(s.img,s.x,s.y,s.r,1,1,s.w/2,s.h/2)

        shove.endLayer()
    shove.endDraw()
end

return lvl