--setup Gamestates
Gamestate= require("C.gamestate")

-- Game States --
Splash=require("S.splashS")
MenuScreen=require("S.menuS")
Game=require("S.gameS")
MR=require("S.MusicRoomS")
-- END --

-- Scripts --
Sounds=require("C.sounds")
Display=require("C.display")
Text=require("C.text")
Obj=require("C.obj")
Util=require("C.utilities")
-- END --

--Switch to splash
function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(Splash)
end