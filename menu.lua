local menu={}

function menu:init()
    
    self.options={
        difficulty={
            options={"idiot","easy","normal","hard"},
        },
        speed={
            options={"turtle","slow","normal","fast"},
        }
    }
    self.menu={
        x=conf.gW/2,
        y=-100,
        items={
            "start game",
            "",
            "difficulty: "..self.options.difficulty.options[options.difficulty],
            "speed: "..self.options.speed.options[options.speed],
            ""
        }
    }

    self.oImg=lg.newImage("assets/outline.png")

    self.fruitImg=lg.newImage("assets/fruit.png")
    self.fruitQuads={}
    for x=0,self.fruitImg:getWidth()/8 - 1 do
        local quad=love.graphics.newQuad(x*8,0,8,8,self.fruitImg:getWidth(),self.fruitImg:getHeight())
        table.insert(self.fruitQuads,quad)
    end
    self.fruitKinds=#self.fruitQuads

    
end

function menu:refresh()
    self.menu.items={
        "start game",
        "",
        "difficulty: "..self.options.difficulty.options[options.difficulty],
        "speed: "..self.options.speed.options[options.speed],
        ""
    }
end

function menu:enter()
    timer.clear()

    self.disp={img=lg.newCanvas(conf.gW,conf.gH),x=conf.gW/2,y=conf.gH/2,w=0,h=0,r=-2,timer=timer.new()}
    self.frozen=true
    self.disp.timer:tween(0.7,self.disp,{r=0,h=1,w=1},"out-elastic",function()
        self.frozen=false
        --local y=self.menu.y
        --self.menu.y=-100
        self.disp.timer:tween(0.7,self.menu,{y=46},"out-cubic")
        timer.tween(1,self.title,{y=20},"in-bounce")
    end)

    self.select=1

    self.selBounce=0
    self.bIng=false

    self.title={img=lg.newImage("assets/title.png"),x=conf.gW/2,y=-18,w=88,h=18}

    self.fruit={}
    timer.every(0.2,function()
        local d={-1,1}
        table.insert(self.fruit,{x=love.math.random(0,conf.gW),y=-8,vy=50,dir=d[math.random(1,2)],id=math.random(1,self.fruitKinds)})
    end)

    self.time=0
end

function menu:bounce()
    self.selBounce=0
    timer.tween(0.1,self,{selBounce=-2},"out-cubic")
end

function menu:update(dt)
    self.disp.timer:update(dt)
    if not self.frozen then
        self.time=self.time+dt
        timer.update(dt)

        local rmv={}

        for k,v in ipairs(self.fruit) do
            v.y=v.y+v.vy*dt

            if v.y>conf.gH+8 then
                table.insert(rmv,k)
            end
        end

        for i=#rmv,1,-1 do
            table.remove(self.fruit,rmv[i])
        end

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
            self:bounce()
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
            self:bounce()
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

local function sprint(t,x,y,a,r,ox,oy)
    local cr,cg,cb,ca=lg.getColor()
    lg.setColor(0,0,0,a)
    cprint(t,x+(ox or 1),y+(oy or 1),r)
    lg.setColor(cr,cg,cb,ca)
    cprint(t,x,y,r)
end

local text="hey there! thanks for playing my game! i hope you enjoy it. shoutout to razertg! you know whats funny about scrolling text like this? its that you can say pretty much whatever you want on these. such as youve been trolled or your mom. please dont ask why the heck i made this at the bottom, i just thought it would look cool. if you enjoyed this game please leave a comment on the itch.io page and rate it too! well... i dont know what else you say... just start the game already im getting impatient and i can only write so much!!! who cares im starting it over.   "

function menu:draw()
    lg.setCanvas(self.disp.img)
        lg.clear(color("#0c8cd6ff"))

        for k,v in ipairs(self.fruit) do
            lg.draw(self.fruitImg,self.fruitQuads[v.id],v.x,v.y,love.timer.getTime()*v.dir*2,1,1,4,4)
        end

        lg.setColor(0,0,0,0.5)
            lg.rectangle("fill",18,0,conf.gW-30,conf.gH-14)
        lg.setColor(color("#482a37"))
            local w=16
            rrect(w,-1,conf.gW-w*2,conf.gH-w)
        lg.setColor(color("#9a5854"))
            local w=20
            rrect(w,-1,conf.gW-w*2,conf.gH-w)
        


        local m=self.menu
        for k,v in pairs(self.menu.items) do
            if self.select==k then
                lg.setColor(color("#fff3ee"))
                sprint(v,m.x,(m.y+(k-1)*font:getHeight())+self.selBounce,0.5,0,1,2)
            else
                lg.setColor(color("#ffd9b6ff"))
                sprint(v,m.x,m.y+(k-1)*font:getHeight(),0.5,0)
            end
            
        end

        lg.setColor(color("#fff3ee"))
        sprint("high score: 5260",conf.gW/2,100,0.5,0,1,1)

        lg.setColor(1,1,1,1)

        lg.draw(self.oImg,conf.gW/2,100-16,0,1,1,self.oImg:getWidth()/2,4)

        lg.draw(self.title.img,self.title.x,self.title.y,0,1,1,self.title.w/2,self.title.h/2)

        lg.setColor(0,0,0,0.5)
        lg.print(text,conf.gW-(self.time*70)%(font:getWidth(text)+conf.gW)+1,conf.gH-8)
        lg.setColor(color("#fff3ee"))
        lg.print(text,conf.gW-(self.time*70)%(font:getWidth(text)+conf.gW),conf.gH-9)

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