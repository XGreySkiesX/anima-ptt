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
  Sounds.stopSounds()
  Text.clear()
  Display.clear()
  local box1=TextBox:new{string="You are awesome :)",fetchcode="box1",h=100,c={100,100,255,150},y=love.graphics.getHeight(),tc={255,255,255,255},delay=0.3,asrc="Media/Audio/Sound/adv3.wav"}
  local box2=TextBox:new{string="Test second box...",fetchcode="box2",h=100,c={100,100,255,150},y=love.graphics.getHeight(),tc={255,255,255,255},delay=0.3,asrc="Media/Audio/Sound/adv3.wav"}
  local box3=CharacterBox:new{string="Here is an example character text box~",fetchcode="charbox1",h=100,c={100,100,255,150},y=love.graphics.getHeight(),tc={255,255,255,255},delay=0.1,ts=25,ssrc="Media/Audio/Sound/Text/spc4.wav",tsrc="Media/Audio/Sound/Text/txt4.wav",asrc="Media/Audio/Sound/adv3.wav",vol=0.2}
  MRM=Menu:new({text="Menu",x=0,y=0,w=100,h=30,hidden=true},{{"mrm1","Continue",function() MRM:hide() end},{"mrm2","Exit",function() Gamestate.switch(MenuScreen) end}})
  but=mrm1
end

--so you can get outta the place
function MusicRoom:keypressed(k)
  if k=="k" then
    Text.initiate()
  end
  if k=="a" then
    Text.advance()
  end
  if k=="escape" then
    if MRM.hidden then
      MRM:show()
      mrm1.hover=true
      but=mrm1
    else
      MRM:hide()
    end
  end
  if k=="up" and not MRM.hidden then
    mrm1.hover=not mrm1.hover
    mrm2.hover=not mrm2.hover
    if but==mrm1 then
      but=mrm2
    else
      but=mrm1
    end
  end
  if k=="enter" and not MRM.hidden then
    but:setActive()
  end
end

-- For the typewriter thing
function MusicRoom:update(dt)
  if Text.getCurrentBox()~="none" then
    Text.getCurrentBox():setpaused(not MRM.hidden)
  end
  Text.update(dt)
  MRM:update()
end

function love.mousereleased(x,y,btn)
  if btn==1 then
    Display.clicks(x,y)
  end
end

--and of course we're gonna need a visual
function MusicRoom:draw()
  Text.draw()
  Display.all()
  love.graphics.setColor({255,255,255,255})
end


return MusicRoom
