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
        y=8,
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
    self.select=1
end

function menu:update(dt)
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
            gs.switch(state["level"])
        end
    end
end

local function sprint(t,x,y,a,r)
    lg.setColor(0,0,0,a)
    cprint(t,x+1,y+1,r)
    lg.setColor(1,1,1,1)
    cprint(t,x,y,r)
end

function menu:draw()
    shove.beginDraw()
        shove.beginLayer("game")
            local m=self.menu
            for k,v in pairs(self.menu.items) do
                if self.select==k then
                    lg.setColor(color("#fff3ee"))
                else
                    lg.setColor(color("#83c3d4"))
                end
                cprint(v,m.x,m.y+(k-1)*font:getHeight(),0)
            end
        shove.endLayer()
    shove.endDraw()
end

return menu