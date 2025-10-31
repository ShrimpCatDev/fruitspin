local conf = {}

conf.gW = 160
conf.gH = 128

conf.wW = conf.gW*5
conf.wH = conf.gH*5

conf.textureFilter = "nearest"
conf.fit = "aspect"
conf.render="layer"
conf.vsync=true

conf.input={
    controls={
        rotateLeft={"key:left","key:a"},
        rotateRight={"key:right","key:d"},
        fall={"key:down","key:s"},
        up={"key:up","key:w"},
        down={"key:down","key:s"},
        select={"key:return","key:space","key:z"},
        pause={"key:escape"}
    },
    pairs={

    },
    joystick = love.joystick.getJoysticks()[1],
}

return conf