
--setup Gamestates
Gamestate= require("Codes.Scripts.gamestate")

-- Game States --
Splash=require("Codes.States.splashS")
MenuScreen=require("Codes.States.menuS")
Game=require("Codes.States.gameS")
MR=require("Codes.States.MusicRoomS")
-- END --

-- Scripts --
Sounds=require("Codes.Scripts.sounds")
Display=require("Codes.Scripts.display")
Entities=require("Codes.Scripts.entities")
Text=require("Codes.Scripts.text")
Collide=require("Codes.Scripts.collisions")
Util=require("Codes.Scripts.utilities")
-- END --

--Switch to splash
function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(Splash)
end
