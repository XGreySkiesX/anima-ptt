--Music Room--
local MusicRoom={}

--okay, this place would be better off called the test room. Anyways
--this is where all teh NAUGHTY scriptsies go
-- I joke
-- This is just where I try out stuff
-- It was originally for testing music, and for displaying music stats, but now it's just... A lab.
-- Anywho
--stop all sounds and do the enemy scriptsy
function MusicRoom:enter()
Txter.prep(1,"You are awesome :))",.2,0,"txt4","spc4",12,{255,255,255},{100,100,100},love.graphics.getWidth(),100)
Trem.stopBGM("all")
--Trem.playMus(1,"MR","Media/Audio/Music/Musicroom.mp3",0,"end")
end

--so you can get outta the place
function MusicRoom:keypressed(kek)
  if kek=="k" then
    Txter.initiate()
  end
  Txter.advance(kek)
  M.MenuKeys(kek)
end

-- For the typewriter thing
function MusicRoom:update(dt)
  --Trem.Loop("MR")
  Txter.tUpd(1,dt)
end

--and of course we're gonna need a visual
function MusicRoom:draw()
  M.MenuDraw()
  Txter.printT(1)
  Txter.printadv(1)
end


return MusicRoom
