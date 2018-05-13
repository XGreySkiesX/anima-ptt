--Load everything
function love.load()
  local ico = love.image.newImageData("M/Graphics/window_icon.png")
  love.window.setIcon(ico)

  -- RESOURCES --
  Gamestate = require("C.gamestate")
  Strings   = require("M.Text.strings") 	--string data for messages, etc
  Display   = require("C.display")		--Object; SBox; Button; PicButton; IBox; Menu; [update, clicks, text, all, clear, getActiveButton]
  Sounds    = require("C.sounds")			--SFX; Mus; Song; Fanfare; [update, stopSounds, clear]
  Util      = require("C.utilities")			--[alreadyInTable, getIndex]
  Objects   = require("C.objects") 		--Camera; Item; Platform; Ground
  require("C.entities") 				--Entity; Player; Enemy
  require("C.text") 					--TextBox; CharacterBox
  require("C.flags") 					--Flags
  require("C.world")					--Level
  require("C.tilesheets")				--TileSprite; TSheet
  require("C.map")					--Tile; Map
  -- END --

  -- STATES --
  Game      = require("S.gameS")
  MS        = require("S.menuS")
  MR        = require("S.MusicRoomS")
  Splash    = require("S.splashS")
  -- END --

  --switch states
  Gamestate.registerEvents()
  Gamestate.switch(Splash)
end
