--Load everything
function love.load()
  local ico = love.image.newImageData("M/Graphics/window_icon.png")
  love.window.setIcon(ico)

  -- RESOURCES --
  Gamestate = require("C.gamestate")      --Gamestate jazz
  Strings   = require("M.Text.strings") 	--String data for messages, etc
  Display   = require("C.display")		    --Object; SBox; Button; PicButton; IBox; Menu; [update, clicks, text, all, clear, getActiveButton]
  Sounds    = require("C.sounds")			    --SFX; Mus; Song; Fanfare; [update, stopSounds, clear]
  Util      = require("C.utilities")      --[alreadyInTable, getIndex]
  Objects   = require("C.objects")	   	  --Camera; Item; Platform; Ground
  Sprites   = require("C.sprites")        --AnimSprite; [update]
  require("C.entities") 			       	    --Entity; Player; Enemy
  require("C.text") 				        	    --TextBox; CharacterBox
  require("C.flags")                      --Flags
  require("C.world")                      --Level
  require("C.tilesheets")                 --TileSprite; TSheet
  require("C.map")                        --Tile; Map
  -- END --

  -- STATES --
  Splash    = require("S.splashS")        --Splash screen
  MS        = require("S.menuS")          --Menu screen
  Game      = require("S.gameS")          --State for games
  MR        = require("S.MusicRoomS")     --Music room
  -- END --

  --switch states
  Gamestate.registerEvents()
  Gamestate.switch(Splash)
end
