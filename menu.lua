local menu={}

function menu:init()
    self.options={
        difficulty={
            options={"idiot","easy","normal","hard"},
            selected=3
        },
        speed={
            options={"turtle","slow","normal","fast"},
            selected=3
        }
    }
    self.menu={
        x=conf.gW/2,
        y=-100,
        items={
            "start game",
            "",
            "difficulty: "..self.options.difficulty.options[self.options.difficulty.selected],
            "speed: "..self.options.speed.options[self.options.speed.selected],
            ""
        }
    }
    
end

function menu:enter()
    self.disp={img=lg.newCanvas(conf.gW,conf.gH),x=conf.gW/2,y=conf.gH/2,w=0,h=0,r=-2,timer=timer.new()}
    self.frozen=true
    self.disp.timer:tween(0.7,self.disp,{r=0,h=1,w=1},"out-elastic",function()
        self.frozen=false
        --local y=self.menu.y
        --self.menu.y=-100
        self.disp.timer:tween(1,self.menu,{y=8},"out-elastic")
    end)

    self.select=1

    self.selBounce=-2
    self.bIng=false
end


function menu:update(dt)
    self.disp.timer:update(dt)
    if not self.frozen then
        if input:pressed("up") then
            self.select=self.select-1

            while self.menu.items[self.select]=="" do
                self.select=self.select-1
            end

            if self.select<1 then
                self.select=#self.menu.items
            end

            while self.menu.items[self.select]=="" do
                self.select=self.select-1
            end
        end
        if input:pressed("down") then
            self.select=self.select+1

            while self.menu.items[self.select]=="" do
                self.select=self.select+1
            end

            if self.select>#self.menu.items then
                self.select=1
            end

            while self.menu.items[self.select]=="" do
                self.select=self.select+1
            end
        end
        if input:pressed("select") then
            local sel=self.menu.items[self.select]
            if sel=="start game" then
                self.frozen=true
                self.disp.timer:tween(0.5,self.disp,{h=0},"in-bounce",function()
                    gs.switch(state["level"])
                end)
            end
        end
    end
end

local function sprint(t,x,y,a,r)
    local cr,cg,cb,ca=lg.getColor()
    lg.setColor(0,0,0,a)
    cprint(t,x+1,y+1,r)
    lg.setColor(cr,cg,cb,ca)
    cprint(t,x,y,r)
end

function menu:draw()
    lg.setCanvas(self.disp.img)
        lg.clear(0.5,0.5,0.5)
        local m=self.menu
        for k,v in pairs(self.menu.items) do
            if self.select==k then
                lg.setColor(color("#fff3ee"))
                sprint(v,m.x,(m.y+(k-1)*font:getHeight())+self.selBounce,0.5,0)
            else
                lg.setColor(color("#83c3d4"))
                sprint(v,m.x,m.y+(k-1)*font:getHeight(),0.5,0)
            end
            
        end
        lg.setColor(1,1,1,1)
    lg.setCanvas()
    shove.beginDraw()
        shove.beginLayer("game")
            lg.setColor(1,1,1,1)
            local w=conf.gW/2
            local h=conf.gH/2
            lg.draw(self.disp.img,self.disp.x,self.disp.y,self.disp.r,self.disp.w,self.disp.h,w,h)
        shove.endLayer()
    shove.endDraw()
end

return menu