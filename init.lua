conf=require 'config'

gs=require "lib.hump.gamestate"
gs.registerEvents()

shove=require 'lib.shove'
baton=require 'lib.baton'
color=require 'lib.hex2color'
require 'lib.func'

input=baton.new(conf.input)

shove.setResolution(conf.gW,conf.gH,{fitMethod=conf.fit,scalingFilter=conf.textureFilter,renderMode=conf.render})
shove.setWindowMode(conf.wW,conf.wH,{resizable=true,vsync=conf.vsync})